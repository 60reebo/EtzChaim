{-# LANGUAGE OverloadedStrings #-}

module Engine.Scenarios.Stage4Logs where

import Data.Text (Text, pack)
import Engine.Types.CoreTypes (OlamId)

-- | Header lines for Stage 4
stage4Header :: [Text]
stage4Header =
  [ "# --- Stage 4: Emanation of AK and ABiYA Potential Layers (Combined Loop) ---"
  , "LOG \"Stage 4: Emanating the Hierarchical Scaffold (AK, Atzilut Partzufim, BYA Layers).\""
  ]

-- | Log start of a world (Olam)
logStartOuter :: Text -> Text
logStartOuter olam =
  "LOG \"==== Starting Emanation of Outer Layer: " <> olam <> " ====\""

-- | Log start of a partzuf (with formation space)
logStartPartzuf :: Text -> Text -> Text -> Text
logStartPartzuf partzuf olam space =
  "  == Starting Emanation of Partzuf: " <> partzuf <> " of " <> olam <> " in space: " <> space <> " =="

-- | Log start of a sefirah
logStartSefirah :: Text -> Text
logStartSefirah sef =
  "    -- Starting Sefirah " <> sef <> " --"

-- | Log completion of Igul step
logIgulCompleted :: Text
logIgulCompleted = "    -> Igul completed."

-- | Log completion of Yosher step
logYosherCompleted :: Text
logYosherCompleted = "    -> Yosher completed."

-- | Log creation of Igul component
logCreateIgul :: Text
logCreateIgul = "    -> Creating Igul (Nefesh)."

-- | Log creation of Yosher component
logCreateYosher :: Text
logCreateYosher = "    -> Creating Yosher (Naranchay in Tzelem)."

-- | Log attire success event
logAttireSuccess :: Text -> Text
logAttireSuccess identity = "      *** Attire succeeded for: " <> identity <> " ***"

-- | Log end of a sefirah
logEndSefirah :: Text -> Text
logEndSefirah sef =
  "    -- Ending Sefirah " <> sef <> " --"

-- | Log end of an outer layer (Olam)
logEndOuter :: Text -> Text
logEndOuter olam =
  "LOG \"==== Ending Emanation of Outer Layer: " <> olam <> " ====\""

-- | Log end of a Partzuf
logEndPartzuf :: Text -> Text -> Text
logEndPartzuf partzuf olam =
  "  == Ending Emanation of Partzuf: " <> partzuf <> " of " <> olam <> " =="

-- | Log attire broken event
logAttireBroken :: Text -> Text -> Text
logAttireBroken identity reason =
  "      *** Shevira detected in: " <> identity <> "! Reason: " <> reason <> " ***"

-- | Log checking Makif Yashar distancing
logCheckMakif :: Text -> Text -> Text
logCheckMakif partzuf olam =
  "      >> Checking Makif Yashar distancing for " <> partzuf <> " of " <> olam <> "."

-- | Log Makif Yashar remains attached
logMakifYasharAttached :: Text -> Text
logMakifYasharAttached olam =
  "        > End of process in " <> olam <> ". Makif Yashar remains attached."

-- | Log Makif Yashar distancing
logMakifYasharDistancing :: Int -> Text
logMakifYasharDistancing d =
  "        > Makif Yashar distancing. Calculated Distance: " <> pack (show d) <> "."

-- | Log define the emanation structure
logDefineStructure :: Text
logDefineStructure = "LOG \"Define the emanation structure: OLAM_PARTZUF_STRUCTURE = DEFINE_WORLD_PARTZUF_STRUCTURE()\""

-- | Log retrieval of olam order
logGetOlamOrder :: [OlamId] -> Text
logGetOlamOrder ord =
  "LOG \"OLAM_ORDER = " <> pack (show ord) <> "\""

-- | Log current formation space
logFormationSpace :: Text -> Text
logFormationSpace space =
  "LOG \"current_formation_space = " <> space <> "\""

-- | Log current source light
logSourceLight :: Text -> Text
logSourceLight light =
  "LOG \"current_source_light = " <> light <> "\""

-- | Log applied height limits for Atzilut
logAppliedHeightLimits :: Text -> Text
logAppliedHeightLimits olam =
  "    >> Applied " <> olam <> " height limits."

-- | Log breaking out of Olam loop after Assiah
logBreakOlam :: Text -> Text
logBreakOlam olam =
  "LOG \"==== Breaking out of Olam loop after " <> olam <> " ====\""

-- | Log new formation space after Makif distancing
logNewFormationSpace :: Text -> Text
logNewFormationSpace space =
  "        > New formation space: " <> space

-- | Log updated source light after Makif distancing
logUpdatedSourceLight :: Text -> Text
logUpdatedSourceLight light =
  "        > Updated source light: " <> light 