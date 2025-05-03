# Makefile for EtzChaim
LIB = EtzChaim
AGDA = agda
AGDAFLAGS = --library=$(LIB) --library=standard-library-2.2

# Layers in dependency order
DOMAIN := $(shell find src/Hishtalshelut/Domain/Worlds -name "*.agda")
STATE  := $(shell find src/Hishtalshelut/State/Worlds -name "*.agda")
RULES  := $(shell find src/Hishtalshelut/Rules/Worlds -name "*.agda")
ENGINE  := $(shell find src/Hishtalshelut/Engine/Worlds -name "*.agda")
RUNTIME := $(shell find src/Hishtalshelut/Runtime/Worlds -name "*.agda")

.PHONY: all check html clean

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
