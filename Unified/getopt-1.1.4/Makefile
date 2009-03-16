.SUFFIXES:

DESTDIR=
prefix=/usr/local
bindir=$(prefix)/bin
mandir=$(prefix)/man
man1dir=$(mandir)/man1
libdir=$(prefix)/lib
sharedir=$(prefix)/share
getoptdir=$(libdir)/getopt
localedir=$(sharedir)/locale

# Define this to 0 to use the getopt(3) routines in this package.
LIBCGETOPT=1

# Define this to 1 if you do not have the gettext routines
WITHOUT_GETTEXT=0

# For creating the archive
PACKAGE=getopt
VERSION=1.1.4
BASENAME=$(PACKAGE)-$(VERSION)
UNLIKELYNAME=a8vwjfd92

SHELL=/bin/sh

CC=gcc
LD=ld
RM=rm -f
INSTALL=install
MSGFMT=msgfmt

LANGUAGES = cs de es fr it ja nl pt_BR
MOFILES:=$(patsubst %,po/%.mo,$(LANGUAGES))

CPPFLAGS=-DLIBCGETOPT=$(LIBCGETOPT) -DWITH_GETTEXT=$(WITH_GETTEXT) -DLOCALEDIR=\"$(localedir)\" -DNOT_UTIL_LINUX
ifeq ($(LIBCGETOPT),0)
CPPFLAGS+=-I./gnu 
endif
WARNINGS=-Wall \
         -W -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual \
         -Wcast-align -Wmissing-declarations \
         -Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes \
         -Wnested-externs -Winline
OPTIMIZE=-O3 -fno-strength-reduce
CFLAGS=$(WARNINGS) $(OPTIMIZE)
LDFLAGS=

sources=getopt.c
ifeq ($(LIBCGETOPT),0)
sources+=gnu/getopt.c gnu/getopt1.c
endif

objects=$(sources:.c=.o)

binaries=getopt

.PHONY: all clean realclean 
all: $(binaries) all_po

clean: clean_po
	-$(RM) $(objects) $(binaries) 

getopt: $(objects)
	$(CC) $(LDFLAGS) -o $@ $(objects)

install: getopt install_po
	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir) $(DESTDIR)$(man1dir)
	$(INSTALL) -m 755 getopt $(DESTDIR)$(bindir)
	$(INSTALL) -m 644 getopt.1 $(DESTDIR)$(man1dir)

install_doc:
	$(INSTALL) -m 755 -d $(DESTDIR)$(getoptdir)
	$(INSTALL) -m 755 getopt-parse.bash getopt-parse.tcsh \
	                  getopt-test.bash getopt-test.tcsh \
	           $(DESTDIR)$(getoptdir)

ifeq ($(WITH_GETTEXT),1)
all_po: $(MOFILES)
install_po: all_po
	$(INSTALL) -m 755 -d $(DESTDIR)$(localedir)
	for lang in $(LANGUAGES) ; do \
	  dir=$(localedir)/$$lang/LC_MESSAGES; \
	  $(INSTALL) -m 755 -d $(DESTDIR)$$dir ;\
	  $(INSTALL) -m 644 po/$$lang.mo $(DESTDIR)$$dir/getopt.mo  ;\
	done
clean_po:
	$(RM) $(MOFILES)
else
all_po:
install_po:
clean_po:
endif

%.o: %.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $*.c -o $*.o

%.mo: %.po
	 $(MSGFMT) -o $@ $<

# You need GNU tar for this to work!
.PHONY: package
package: clean
	$(RM) -r $(UNLIKELYNAME)
	mkdir $(UNLIKELYNAME)
	ln -s .. $(UNLIKELYNAME)/$(BASENAME)
	cd $(UNLIKELYNAME) && tar cfvzp ../$(BASENAME).tar.gz --exclude='CVS' --exclude='*.tar.gz' --exclude=$(UNLIKELYNAME) $(BASENAME)/*
	$(RM) -r $(UNLIKELYNAME)
