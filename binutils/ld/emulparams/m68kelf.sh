SCRIPT_NAME=elf
OUTPUT_FORMAT="elf32-m68k"
NO_REL_RELOCS=yes
TEXT_START_ADDR=0x80000000
MAXPAGESIZE="CONSTANT (MAXPAGESIZE)"
COMMONPAGESIZE="CONSTANT (COMMONPAGESIZE)"
ARCH=m68k
MACHINE=
NOP=0x4e714e71
TEMPLATE_NAME=elf
EXTRA_EM_FILE=m68kelf
GENERATE_SHLIB_SCRIPT=yes
GENERATE_PIE_SCRIPT=yes
NO_SMALL_DATA=yes