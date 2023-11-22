# Makefile for Haskell project

# Compiler and flags
GHC = ghc
GHC_FLAGS = -Wall

# Source and binary directories
SRC_DIR = src
BIN_DIR = bin

# Main executable name
EXECUTABLE = mdtoc

DESTDIR = /usr/bin

# Source files
SRC_FILES = $(wildcard $(SRC_DIR)/*.hs)

# Targets
.PHONY: build clean

build: $(BIN_DIR) $(BIN_DIR)/$(EXECUTABLE)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/$(EXECUTABLE): $(SRC_FILES)
	$(GHC) $(GHC_FLAGS) -o $@ $^

clean:
	rm -rf $(BIN_DIR)
	rm $(INSTALLDIR)$(DESTDIR)/$(EXECUTABLE) || :

install: build
	cp $(BIN_DIR)/$(EXECUTABLE) $(INSTALLDIR)$(DESTDIR)
