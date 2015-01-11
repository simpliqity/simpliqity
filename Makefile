
OPENSCAD = openscad

OUTPUTS =           \
    box.dxf         \
    drawer.dxf      \
    shelves.dxf     \
    tower.dxf

all: $(OUTPUTS)

%.dxf : %.scad
	$(OPENSCAD) -o $@ $<

clean:
	rm -f $(OUTPUTS)

