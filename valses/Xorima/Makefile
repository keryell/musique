# you may need to change these for your system
CFLAGS	= -g
MAKE	= make
CC	= acc
RM	= /bin/rm

TEX	= userguide music
ABC	= Xenglish Xjigs Xreels Xstrspys

all : Xorima.ps
#ABCFLAGS=-x

install: abc2mtex sort_in search
	$(RM) -f *.o

abc2mtex: index.o fields.o abc.o tex.o
	$(CC) $(CFLAGS) -o $@ index.o fields.o abc.o tex.o

sort_in: sort_in.o index.o
	$(CC) $(CFLAGS) -o $@ sort_in.o index.o

search: search.o index.o
	$(CC) $(CFLAGS) -o $@ search.o index.o

index: *.abc
	abc2mtex -i *.abc
	sort_in

abc: $(ABC:=.ps)

tidy:
	$(RM) -f *.o index abc2mtex.log music.tex userguide.toc transpose.abc
	$(RM) -f $(TEX:=.dvi) $(TEX:=.log) $(TEX:=.ps) $(TEX:=.aux)
	$(RM) -f $(ABC:=.tex) $(ABC:=.dvi) $(ABC:=.log) $(ABC:=.ps) $(ABC:=.aux)

clean: tidy
	$(RM) -f abc2mtex sort_in search

.SUFFIXES:  .ps .dvi .tex .abc

.abc.tex:
	abc2mtex $(ABCFLAGS) -o $*.tex $*

.abc.dvi:
	abc2mtex $(ABCFLAGS) -o $*.tex $*
	tex $*
	musixflx $*
	tex $*

.abc.ps:
	abc2mtex $(ABCFLAGS) -o $*.tex $*
	tex $*
	musixflx $*
	tex $*
	dvips -o $*.ps $*.dvi

.tex.dvi:
	tex $*
	musixflx $*
	tex $*

.tex.ps:
	tex $*
	dvips -o $*.ps $*.dvi

.dvi.ps:
	dvips -o $*.ps $*.dvi

