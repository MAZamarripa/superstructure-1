# A simple makefile for creating the Superstructure distribution files
VERSION    := $(shell git describe --tags --dirty)
PRODUCT    := Superstructure Formulation
PROD_SNAME := Superstructure
LICENSE    := LICENSE.md
PKG_DIR    := CCSI_$(PROD_SNAME)_$(VERSION)
PACKAGE    := $(PKG_DIR).zip

PAYLOAD := docs/*.pdf
           minlp \
           README.docx \
           README.txt \
           README.md \
           $(LICENSE)

# Get just the top part (not dirname) of each entry so cp -r does the right thing
PAYLOAD_TOPS := $(sort $(foreach v,$(PAYLOAD),$(shell echo $v | cut -d'/' -f1)))
# And the payload with the PKG_DIR prepended
PKG_PAYLOAD := $(addprefix $(PKG_DIR)/, $(PAYLOAD))

# OS detection & changes
UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
  MD5BIN=md5sum
endif
ifeq ($(UNAME), Darwin)
  MD5BIN=md5
endif
ifeq ($(UNAME), FreeBSD)
  MD5BIN=md5
endif

.PHONY: all clean

all: $(PACKAGE)

$(PACKAGE): $(PAYLOAD)
	@mkdir $(PKG_DIR)
	@cp -r $(PAYLOAD_TOPS) $(PKG_DIR)
	@zip -qXr $(PACKAGE) $(PKG_PAYLOAD)
	@$(MD5BIN) $(PACKAGE)
	@rm -rf $(PKG_DIR)

clean: 
	@rm -rf $(PACKAGE) $(PKG_DIR)
