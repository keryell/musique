PARTITION_DIR = $(HOME)/public_html/trad/partitions
TARGET_DIR = $(PARTITION_DIR)/`pwd | sed 's,.*/\([^/]*/[^/]*\),\1,'`

MIDI = $(ABC:.abc=.midi)
PS = $(ABC:.abc=.ps)
AU = $(ABC:.abc=.au)

YAPS_SCALE=0.9

#TIMIDITY=timidity -c gravis.cfg
TIMIDITY=timidity

.SUFFIXES:  .ps .dvi .tex .abc .midi


all: $(PS) $(MIDI) $(AU)

clean:
	rm -f $(PS) $(MIDI) $(AU)

# No longer recompile stuff since the tools may not be on the WWW server.
install :
	mkdir -p $(TARGET_DIR)
	cp $(ABC) $(AU) $(TARGET_DIR)
	#gzip -9 -c $(PS) > $(TARGET_DIR)/$(PS).gz
	cp $(PS) $(TARGET_DIR)

index: *.abc
	abc2mtex -i *.abc
	sort_in

joue: $(MIDI)
#	$(TIMIDITY) -L /usr/local/lib/timidity/instruments -ig *.mid
	$(TIMIDITY) -ig *.mid

.abc.tex: Makefile
	abc2mtex -x -o $*.tex $*

.abc.dvi: Makefile
	abc2mtex -x -o $*.tex $*
	tex $*
	#musixflx $*
	tex $*

%.midi : %.abc Makefile
	-abc2midi $<
	#cat $**.mid > $@

%.au : %.midi Makefile
	-$(TIMIDITY) -id -OrMU -s8 -o $@ $**.mid

%.ps : %.abc Makefile
	#abc2ps $* -x -n -p -O = -o
	yaps $< -s $(YAPS_SCALE)

#.abc.ps:
#       abc2mtex -x -o $*.tex $*
#       tex $*
#       #musixflx $*
#       tex $*
#       dvips -o $*.ps $*.dvi

