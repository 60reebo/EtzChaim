{ pkgs ? import <nixpkgs> {} }:

let
  agdaStdLib = pkgs.agdaPackages.standard-library;
  # Get the actual store path of the standard library
  agdaStdLibPath = agdaStdLib.outPath;
  # Construct the path to the .agda-lib file within the standard library derivation
  agdaStdLibLibFile = "${agdaStdLibPath}/lib/agda/standard-library.agda-lib";
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    agda
    agdaStdLib # Use the variable defined above
    ghc
    hlint
    shellcheck
    stylish-haskell
    pre-commit
  ];

  # Define AGDA_LIBRARY_PATH to point Nix Agda to the project and stdlib
  # Note: AGDA_DIR is deprecated/less common now
  shellHook = ''
    # Create a default libraries file if it doesn't exist
    mkdir -p ~/.agda
    touch ~/.agda/libraries

    # Add project library path (current directory)
    echo "${./EtzChaim.agda-lib}" > ~/.agda/libraries-project
    # Add standard library path
    echo "${agdaStdLibLibFile}" >> ~/.agda/libraries-project
    
    # Set the library path environment variable for Agda to use our generated file
    # Using a temporary file avoids modifying the user's global ~/.agda/libraries directly
    export AGDA_DIR=$HOME/.agda # Keep this for potential legacy compatibility
    export AGDA_LIBRARIES_FILE=$HOME/.agda/libraries-project
    
    echo "========= סביבת פיתוח חוזרת ========"
    echo "Agda, Agda stdlib (${agdaStdLibPath}), GHC, HLint זמינים."
    echo "Using AGDA_LIBRARIES_FILE: $AGDA_LIBRARIES_FILE"
    # Display contents for debugging
    echo "Contents of $AGDA_LIBRARIES_FILE:"
    cat $AGDA_LIBRARIES_FILE
  '';
} 