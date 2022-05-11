SCOUR=poetry run scour
SCOUR_OPTS=--enable-viewboxing --enable-comment-stripping

INKSCAPE:=$(shell command -v inkscape)

SOURCE_SVG=$(wildcard src/assets/*.svg)
FINAL_SVG=$(addprefix assets/,$(notdir $(SOURCE_SVG)))
FINAL_PNG=$(patsubst %.svg,%.png,$(addprefix assets/,$(notdir $(SOURCE_SVG))))

assets: $(FINAL_SVG) $(FINAL_PNG)

plain: $(SOURCE_SVG)

$(FINAL_SVG): assets/%.svg: src/assets/%.svg
	$(SCOUR) $(SCOUR_OPTS) -i $? -o $@

$(FINAL_PNG): assets/%.png: src/assets/%.svg
ifndef INKSCAPE
	@echo "You need Inkscape installed to build these files"
	exit 1
endif
	$(INKSCAPE) --export-filename=$@ $?

$(SOURCE_SVG): src/assets/%.svg:
ifndef INKSCAPE
	@echo "You need Inkscape installed to build these files"
	exit 1
endif
	$(INKSCAPE) --export-plain-svg --export-type=svg --export-filename=$@ $@
