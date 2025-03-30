# The standard and extensions used here:
# https://en.wikipedia.org/wiki/ABC_notation
# https://abcnotation.com/wiki/abc:standard:v2.2
# https://abc.sourceforge.net/standard/abc2midi.txt


LISTE_MORCEAUX=larides_8/LE_laride_8/LE_laride_8.abc plin/LE_plin/LE_plin.abc bourrees_2/saut_terne/saut_terne.abc larides_6/Groill/larides_6.abc scottish/Groilh/groilh.abc hanter-dro/L_HanterDro/hanter-dro.abc rond_saint-vincent/anneaux_d_or/anneaux_d_or.abc mazurka/Escholiers/Escholiers.abc andro/L_Andro/andro.abc kost_ar_c_hoad/LE_kost_ar_c_hoad/kost.abc dans_leon/LA_dans_leon/LA_dans_leon.abc cercles_circassiens/LE_cercle/LE_cercle.abc gavottes/LA_gavotte/LA_gavotte.abc valses/Floating_from_Skerry/Floating_from_Skerry.abc divers/galop_nantais/galop_nantais.abc

LISTE_MORCEAUX_MID=$(shell echo $(LISTE_MORCEAUX) | sed 's,\([^/]*\.\)abc,all/\1mid,g')
LISTE_MORCEAUX_WAV=$(LISTE_MORCEAUX_MID:.mid=.wav)
LISTE_MORCEAUX_CDR=$(LISTE_MORCEAUX_MID:.mid=.cdr)


PARTITION_DIR = $(HOME)/public_html/trad/partitions
RELATIVE_DIR := $(shell pwd | sed 's,.*/\([^/]*/[^/]*\),\1,')
TARGET_DIR = $(PARTITION_DIR)/$(RELATIVE_DIR)
FESTIV_DIR = $(PARTITION_DIR)/festiv/$(RELATIVE_DIR)


MIDI = $(ABC:.abc=1.mid)
PS = $(ABC:.abc=.ps)
PST = $(ABC:.abc=+2.ps)
PDF = $(ABC:.abc=.pdf)
PDFT = $(ABC:.abc=+2.pdf)
PSF = $(ABC:.abc=-F.ps)
PDFF = $(ABC:.abc=-F.pdf)
HTML = $(ABC:.abc=.html)
AUFILE = $(ABC:.abc=.au)
AU = $(ALLMIDI_DIR)/$(AUFILE)
ALLMIDI = $(ABC:.abc=.mid)
ALLMIDI_DIR = all
ALLMIDI_TAR_GZ = $(ABC:.abc=.mid.tar.gz)

# Scale by 0.9, number pages, print the X: tune numbers
# Change this variable in local Makefile to tweak the scale factor:
ZOOM=0.9
YAPS_OPTIONS=-s $(ZOOM) -N -x

AB2AB	= abc2abc
#TIMIDITY=timidity -c gravis.cfg
TIMIDITY=timidity

TARGETS = $(PS) $(PDF) $(PST) $(PDFT) $(MIDI) $(AU) $(HTML) $(ALLMIDI_DIR)/$(ALLMIDI) $(PSF) $(PDFF)

world: $(TARGETS)

clean:
	rm -fr $(TARGETS) $(ALLMIDI_DIR) *.mid
	find . -name '*.wav' -exec rm '{}' \;
	find . -name '*.cdr' -exec rm '{}' \;

# No longer recompile stuff since the tools may not be on the WWW server.
#install : $(TARGETS)
# This rule is to be run in a specific tune directory, not at the top directory.
install :
	mkdir -p $(TARGET_DIR)
	cp -a $(ABC) $(ALLMIDI_DIR)/$(ALLMIDI) $(AU) $(HTML) $(PS) $(PDF) $(TARGET_DIR)
	tar cf - *.mid | gzip -9 -c > $(TARGET_DIR)/$(ALLMIDI).tar.gz
	echo
	echo See also git and Makefile in $(TARGET_DIR) !

festiv_install :
	mkdir -p $(FESTIV_DIR)
	cp -a $(PDF) $(PDFF) $(ALLMIDI_DIR)/$(ALLMIDI) $(FESTIV_DIR)

index: *.abc
	abc2mtex -i *.abc
	sort_in

# Play each part individually with ALSA backend
play: $(MIDI)
#	$(TIMIDITY) -L /usr/local/lib/timidity/instruments -ig *.mid
	$(TIMIDITY) -iat -Os *.mid

# Play each part individually with JACK backend
jplay: $(MIDI)
#	$(TIMIDITY) -L /usr/local/lib/timidity/instruments -ig *.mid
	$(TIMIDITY) -iat -OjS *.mid

# Play the full tune with ALSA backend
playall: $(ALLMIDI_DIR)/$(ALLMIDI)
	$(TIMIDITY) -iat -Os $(ALLMIDI_DIR)/$(ALLMIDI)

# Play the full tune with JACK backend
jplayall: $(ALLMIDI_DIR)/$(ALLMIDI)
	$(TIMIDITY) -iat -OjS $(ALLMIDI_DIR)/$(ALLMIDI)

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
	#abcm2ps -i -x $* -O =
	yaps $< $(YAPS_OPTIONS) || abcmidi-yaps $< $(YAPS_OPTIONS)

%.pdf : %.ps
	ps2pdf $<

$(ALLMIDI_DIR):
	mkdir $(ALLMIDI_DIR)

$(ALLMIDI_DIR)/$(ABC): $(ABC) $(ALLMIDI_DIR)
	abccat $(ABC) > $@

### transpositions...
T	= 2
%-$(T).abc: %.abc; $(AB2AB) $< -t -$(T) > $@
%+$(T).abc: %.abc; $(AB2AB) $< -t  $(T) > $@


### Typeset in bass (F) key :
%-F.abc : %.abc
	sed 's/^K:\(.*\)$$/K:\1 clef=bass octave=-2/' $< > $@


%.html : %.abc
	# Use the directory name as an HTML anchor
	echo '<TR ALIGN=CENTER VALIGN=CENTER>' > $@
	echo '<TD/>' >> $@
	echo '<TD NOWRAP id="'$(RELATIVE_DIR)'"><FONT COLOR="#000000">'"$(HTML_TITLE)"'</FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(ABC)'">ABC</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(ALLMIDI)'">MIDI</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(PDF)'">PDF</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(PS)'">PS</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(AUFILE)'">AU</A></FONT></TD>' >> $@
	echo '<TD><FONT COLOR="#000000"><A HREF="'$(RELATIVE_DIR)/$(ALLMIDI_TAR_GZ)'">mid.tar.gz</A></FONT></TD>' >> $@
	echo '</TR>' >> $@

%.abc: %.tex Makefile
	abc2mtex -x -o $*.tex $*

%.abc: %.dvi Makefile
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


%.cdr : %.wav
	sox $< $@

%.wav : %.mid
	timidity -s 44100 -OwS $<

cd: $(LISTE_MORCEAUX_CDR)

cdwrite:
	cdrecord -v -overburn -audio speed=1 dev=0,0,0 $(LISTE_MORCEAUX_CDR)

