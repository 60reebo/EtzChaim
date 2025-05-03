# Makefile for EtzChaim
LIB = EtzChaim
AGDA = agda
AGDAFLAGS = --library=$(LIB) --library=standard-library-2.2

# Layers in dependency order
DOMAIN := $(shell find src/Hishtalshelut/Domain/Worlds -name "*.agda")
STATE  := $(shell find src/Hishtalshelut/State/Worlds -name "*.agda")
RULES  := $(shell find src/Hishtalshelut/Rules/Worlds -type f -name "*.agda" | grep -v "Test\.agda")
ENGINE  := $(shell find src/Hishtalshelut/Engine/Worlds -name "*.agda")
RUNTIME := $(shell find src/Hishtalshelut/Runtime/Worlds -name "*.agda")

.PHONY: all check html clean test safe-check coverage contraction igulimYosher geometry sims-all

all: check

check:
	@echo "Compiling Agda files..."
	@for f in $(DOMAIN) $(STATE) $(RULES) $(ENGINE) $(RUNTIME); do \
		$(AGDA) $(AGDAFLAGS) --compile $$f; \
	done

html:
	@echo "Generating HTML..."
	@for f in $(DOMAIN) $(STATE) $(RULES) $(ENGINE) $(RUNTIME); do \
		$(AGDA) $(AGDAFLAGS) --html $$f; \
	done

clean:
	rm -rf MAlonzo _build *.agdai *.agdac* temp-*

test: check
	runhaskell test/MainSpec.hs

safe-check:
	@echo "Compiling Agda files in safe mode..."
	@for f in $(DOMAIN) $(STATE) $(RULES) $(ENGINE) $(RUNTIME); do \
		$(AGDA) $(AGDAFLAGS) --safe --compile $$f; \
	done

coverage:
	@echo "Running tests and generating coverage report..."
	@stack test --coverage
	@stack hpc markup --destdir coverage

# Build individual scenario binaries
contraction:
	ghc --make -i./src src/MainContraction.hs -o MainContraction --no-main

igulimYosher:
	ghc --make -i./src src/MainIgulimYosher.hs -o MainIgulimYosher --no-main

geometry:
	ghc --make -i./src src/MainGeometry.hs -o MainGeometry --no-main

# Run all three scenarios in sequence
sims-all: igulimYosher contraction geometry
	@echo "\n=== Running All Scenarios ==="
	./MainIgulimYosher
	./MainContraction
	./MainGeometry
