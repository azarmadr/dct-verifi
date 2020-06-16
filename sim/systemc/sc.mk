# Verilated -*- Makefile -*-
#
default: Vdct__ALL.a
#
# Constants...
PERL = perl
#VERILATOR_ROOT = /opt/verilator-3.656
#SYSTEMPERL = /opt/SystemPerl-1.282

# Switches...
VM_SP = 0
VM_SC = 1
VM_SP_OR_SC = 1
VM_PCLI = 0
VM_SC_TARGET_ARCH = linux64

# Vars...
VM_PREFIX = Vdct
VM_MODPREFIX = Vdct
VM_USER_CLASSES = \
		  #
VM_USER_DIR = \
	      #

CPPFLAGS += -I..
CPPFLAGS += -I.
CPPFLAGS += -I$(SYSTEMC)/include
CPPFLAGS += -I$(VERILATOR_ROOT)/include
CPPFLAGS += -I$(SYSTEMPERL)/src
# -DSYSTEMPERL


include Vdct_classes.mk
include $(VERILATOR_ROOT)/include/verilated.mk

# Local rules...

#SOURCES=../../tb_sc/sc_packet.cpp
#OBJECTS=$(SOURCES:.cpp=.o)

#all: $(OBJECTS)

%.o: ../../tb/%.cpp
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<


# Verilated -*- Makefile -*-

