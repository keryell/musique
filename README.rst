========
Morceaux
========

Some traditional music I play or used to play, mainly in the
`Kazimodal <http://kazimodal.trad.org>`_ band.

The tunes are written in `ABC notation <https://en.wikipedia.org/wiki/ABC_notation>`_
`ABC notation standard v2.2 <https://abcnotation.com/wiki/abc:standard:v2.2>`_
and a ``Makefile``-based build system generates sheet music (PDF, PostScript),
MIDI files, audio and HTML catalogs.


Dance types
===========

The repository is organized by dance/tune type, each in its own
directory:

Breton dances
-------------

- ``andro`` -- an dro
- ``hanter-dro`` -- hanter-dro
- ``gavottes`` -- gavottes (glazik, montagne...)
- ``dans_fisel`` -- danse fisel
- ``dans_leon`` -- danse Leon
- ``kaz-a-barh`` -- kas-a-barz
- ``kost_ar_c_hoad`` -- kost ar c'hoad
- ``larides_6`` -- laridé 6 temps
- ``larides_8`` -- laridé 8 temps
- ``plin`` -- plinn
- ``rond_saint-vincent`` -- rond de Saint-Vincent
- ``cercles_circassiens`` -- cercle circassien

Bal folk / French dances
------------------------

- ``bourrees_2`` -- bourrées 2 temps
- ``bourrees_3`` -- bourrées 3 temps
- ``mazurka`` -- mazurka
- ``scottish`` -- scottish
- ``scottish_valse`` -- scottish-valse
- ``valses`` -- valses
- ``valse_5`` -- valse 5 temps

Other collections
-----------------

- ``divers`` -- miscellaneous tunes (galop nantais, cochinchine...)
- ``catholique`` -- religious music
- ``Neketa`` -- collection from Neketa band
- ``Skol_Al_Louarn`` -- collection from the Skol Al Louarn band from the
  Breton dance teaching association in Plouzané
- ``Passages`` -- transition/modulation pieces


Directory layout
================

Each tune lives in its own sub-directory containing:

- an ABC source file (e.g. ``tune.abc``)
- a local ``Makefile`` that sets ``ABC`` and ``HTML_TITLE`` then
  includes the top-level ``Makefile``::

    ABC = tune.abc
    HTML_TITLE = Tune Title
    include ../../Makefile

- generated files: PDF, PostScript, MIDI (one per voice), HTML
- an ``all/`` directory with a merged MIDI of all voices


Prerequisites
=============

The build system runs on Linux (tested on Debian). Required packages
and tools:

- `abcm2ps <https://github.com/leesavide/abcm2ps>`_ -- ABC to
  PostScript (with UTF-8 support)
- `abc2midi <https://github.com/sshlien/abcmidi>`_ -- ABC to MIDI
- `abccat <https://github.com/keryell/music_utils>`_ -- concatenate
  ABC files into a single multi-voice file
- ``abc2abc`` -- transpose and manipulate ABC files (part of abcmidi)
- ``ps2pdf`` (Ghostscript) -- PostScript to PDF
- ``timidity`` -- MIDI playback and audio rendering
- ``sox`` -- audio format conversion (for CD creation)

On Debian/Ubuntu most of these are available as packages::

  sudo apt install abcmidi abcm2ps timidity ghostscript sox


Usage
=====

All ``make`` commands are run from a tune's own directory.

Build everything (PDF, PS, MIDI, audio, HTML)::

  make world

Play each voice individually (ALSA / JACK)::

  make play      # ALSA backend
  make jplay     # JACK backend

Play the full merged tune::

  make playall   # ALSA
  make jplayall  # JACK

Transpose up or down by 2 semitones::

  make tune+2.pdf
  make tune-2.pdf

Generate a bass-clef (F-key) version::

  make tune-F.pdf

Deploy to the web partition directory::

  make install

Clean generated files::

  make clean


File format pipeline
====================

::

  ABC source (.abc)
   |
   +-- abcm2ps --> PostScript (.ps) --> ps2pdf --> PDF (.pdf)
   |
   +-- abc2midi --> MIDI per voice (.mid)
   |                   |
   |                   +-- timidity --> AU audio (.au)
   |                   +-- timidity --> WAV (.wav) --> sox --> CDR
   |
   +-- abccat --> merged MIDI (all/tune.mid)
   |
   +-- --> HTML catalog fragment (.html)

Transposition and bass-clef variants are derived from the ABC source
with ``abc2abc`` and ``sed``.


References
==========

- `ABC notation standard v2.2
  <https://abcnotation.com/wiki/abc:standard:v2.2>`_
- `abcmidi (abc2midi, abc2abc)
  <https://github.com/sshlien/abcmidi>`_
- `abcm2ps <https://github.com/leesavide/abcm2ps>`_
- `music_utils (abccat) <https://github.com/keryell/music_utils>`_
- `Kazimodal band <http://kazimodal.trad.org>`_
