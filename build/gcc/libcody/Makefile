# Nathan's generic Makefile		-*- mode:Makefile -*-
# Copyright (C) 2019-2020 Nathan Sidwell, nathan@acm.org
# License: Apache v2.0

srcdir := ../../../gcc/libcody
prefix := /home/dashiel/Projects/IbisOS/compiler/output
exec_prefix := ${prefix}
bindir := ${exec_prefix}/bin
libdir := ${exec_prefix}/lib
includedir := ${prefix}/include
# Linker options
LDFLAGS := -static-libstdc++ -static-libgcc  -Wl,--no-undefined
LIBS := 

# We have to place the -I paths last, so that building will see -I paths to us
CXX := $(filter-out -I%,g++ -std=c++11)
AR := ar
RANLIB := ranlib
INSTALL := $(srcdir)/build-aux/install-sh

# C++ compiler options
CXXFLAGS := -g -O2  
CXXINC := $(filter -I%,g++ -std=c++11)
CXXOPTS := $(CXXFLAGS) 

ifneq (,yes)
CXXOPTS += -fno-exceptions -fno-rtti
endif

# Config
CXXOPTS += $(filter-out -DHAVE_CONFIG_H,-DHAVE_CONFIG_H) -include config.h

# Linker options
LDFLAGS := -static-libstdc++ -static-libgcc  -Wl,--no-undefined
LIBS := 

# Per-source & per-directory compile flags (warning: recursive)
SRC_CXXFLAGS = $(CXXFLAGS$(patsubst $(srcdir)%,%,$1)) \
	$(if $(filter-out $(srcdir)/,$1),\
	  $(call $0,$(dir $(patsubst %/,%,$1))))

ifneq ($(MAINTAINER),)
override MAINTAINER += $1
endif
ifeq (,yes)
MAINTAINER = $2
else
MAINTAINER = \# --enable-maintainer-mode to rebuild $1, or make MAINTAINER=touch
endif

vpath %.in $(srcdir)
vpath %.cc $(srcdir)

.SUFFIXES: .o .cc

%.o: %.cc
	@mkdir -p $(dir $@)
	$(CXX) $(strip $(CXXOPTS) $(call SRC_CXXFLAGS,$<) $(CXXINC)) \
	  -MMD -MP -MF ${@:.o=.d} -c -o $@ $<

all:: Makefile

mostlyclean::

clean:: Makefile

# FIXME: Delete
revision.stamp: $(srcdir)/.
	@revision=$$(git -C $(srcdir) rev-parse HEAD 2>/dev/null) ;\
	if test -n "$$revision" ;\
	then revision=git-$$revision ;\
	  if git -C $(srcdir) status --porcelain 2>/dev/null | grep -vq '^  ' ;\
	  then revision+=M ;\
	  fi ;\
	else revision=unknown ;\
	fi ;\
	echo $$revision > $@

revision: revision.stamp
	@cmp -s $< $@ || cp -f $< $@

mostlyclean::

clean:: mostlyclean
	rm -f revision.stamp revision

distclean:: clean
	rm -f config.log config.status

$(srcdir)/configure: $(srcdir)/configure.ac $(srcdir)/config.m4
	$(call MAINTAINER,$@,cd $(@D) && autoconf -W all,error)

$(srcdir)/config.h.in: $(srcdir)/configure.ac $(srcdir)/config.m4
	$(call MAINTAINER,$@,cd $(@D) && autoheader -f -W all,error)

config.h: config.status config.h.in
	./$< --header=$@
	touch $@

ifeq ($(filter %clean,$(MAKECMDGOALS)),)
Makefile: config.status Makefile.in
	./$< --file=$@
	touch $@
endif

config.status: $(srcdir)/configure $(srcdir)/config.h.in
	if test -x $@; then ./$@ -recheck; else $<  '--srcdir=../../../gcc/libcody' '--cache-file=./config.cache' '--prefix=/home/dashiel/Projects/IbisOS/compiler/output' '--disable-nls' '--without-headers' '--enable-languages=c,c++,lto' '--program-transform-name=s&^&i686-elf-&' '--disable-option-checking' '--build=x86_64-pc-linux-gnu' '--host=x86_64-pc-linux-gnu' '--target=i686-elf' 'build_alias=x86_64-pc-linux-gnu' 'host_alias=x86_64-pc-linux-gnu' 'target_alias=i686-elf' 'CXX=g++' 'CXXFLAGS=-g -O2  ' 'LDFLAGS=-static-libstdc++ -static-libgcc '; fi

mostlyclean::

clean:: mostlyclean
	rm -f $(shell find $(srcdir) -name '*~')

distclean:: clean
	rm -f config.h

maintainer-clean:: distclean
	rm -f $(srcdir)/config.h.in

.PHONY: all check clean distclean maintainer-clean mostlyclean

CXXFLAGS/ := -I$(srcdir)
LIBCODY.O := buffer.o client.o fatal.o netclient.o netserver.o \
	resolver.o packet.o server.o

all:: libcody.a

libcody.a: $(LIBCODY.O)
	$(AR) -cr $@ $^
	$(RANLIB) $@

mostlyclean::

clean:: mostlyclean
	rm -f $(LIBCODY.O) $(LIBCODY.O:.o=.d)
	rm -f libcody.a

CXXFLAGS/fatal.cc = -DSRCDIR='"$(srcdir)"'

fatal.o: Makefile revision

install::
	$(INSTALL) -d $(libdir) $(includedir)
	$(INSTALL) libcody.a $(libdir)
	$(INSTALL) $(srcdir)/cody.hh $(includedir)

ifeq ($(filter clean%,$(MAKECMDGOALS)),)
-include $(LIBCODY.O:.o=.d)
endif
