PARTITION_DIR = $(HOME)/public_html/trad/partitions
RELATIVE_DIR = `pwd | sed 's,.*/\([^/]*/[^/]*\),\1,'`
TARGET_DIR = $(PARTITION_DIR)/$(RELATIVE_DIR)

MIDI = $(ABC:.abc=1.mid)
PS = $(ABC:.abc=.ps)
PDF = $(ABC:.abc=.pdf)
HTML = $(ABC:.abc=.html)
AUFILE = $(ABC:.abc=.au)
AU = $(ALLMIDI_DIR)/$(AUFILE)
ALLMIDI = $(ABC:.abc=.mid)
ALLMIDI_DIR = all
ALLMIDI_TAR_GZ = $(ABC:.abc=.mid.tar.gz)
YAPS_SCALE=0.9

#TIMIDITY=timidity -c gravis.cfg
TIMIDITY=timidity

.SUFFIXES:  .ps .dvi .tex .abc .midi .mid .pdf

TARGETS = $(PS) $(PDF) $(MIDI) $(AU) $(HTML) $(ALLMIDI_DIR)/$(ALLMIDI)

world: $(TARGETS)

clean:
	rm -fr $(TARGETS) $(ALLMIDI_DIR) *.mid

# No longer recompile stuff since the tools may not be on the WWW server.
#install : $(TARGETS)
install :
	mkdir -p $(TARGET_DIR)
	cp $(ABC) $(ALLMIDI_DIR)/$(ALLMIDI) $(AU) $(HTML) $(PS) $(PDF) $(TARGET_DIR)
	tar cf - *.mid | gzip -9 -c > $(TARGET_DIR)/$(ALLMIDI).tar.gz

index: *.abc
	abc2mtex -i *.abc
	sort_in

play: $(MIDI)
#	$(TIMIDITY) -L /usr/local/lib/timidity/instruments -ig *.mid
	$(TIMIDITY) -ig *.mid

playall: $(ALLMIDI_DIR)/$(ALLMIDI)
	$(TIMIDITY) -ig $(ALLMIDI_DIR)/$(ALLMIDI)

%1.mid : %.abc Makefile
	-abc2midi $<
	#cat $**.mid > $@

%.mid : %.abc Makefile
	-abc2midi $<
	mv $*1.mid $*.mid

%.au : %.mid Makefile
	-$(TIMIDITY) -id -OrMU -s8 -o $@ $*.mid

%.ps : %.abc Makefile
	#abc2ps $* -x -n -p -O = -o
	yaps $< -s $(YAPS_SCALE)

%.pdf : %.ps
	ps2pdf $<

$(ALLMIDI_DIR):
	mkdir $(ALLMIDI_DIR)

$(ALLMIDI_DIR)/$(ABC): $(ABC) $(ALLMIDI_DIR)
	abccat $(ABC) > $@

%.html : %.abc
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(ABC)'">ABC</A></FONT></TD>' > $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(ALLMIDI)'">MIDI</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(PDF)'">PDF</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(PS)'">PS</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(AUFILE)'">AU</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(ALLMIDI_TAR_GZ)'">mid.tar.gz</A></FONT></TD>' >> $@

.abc.tex: Makefile
	abc2mtex -x -o $*.tex $*

.abc.dvi: Makefile
	abc2mtex -x -o $*.tex $*
	tex $*
	#musixflx $*
	tex $*

#.abc.ps:
#       abc2mtex -x -o $*.tex $*
#       tex $*
#       #musixflx $*
#       tex $*
#       dvips -o $*.ps $*.dvi

