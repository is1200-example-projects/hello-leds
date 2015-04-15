CFLAGS		+= -ffreestanding -march=mips32r2 -msoft-float -Wa,-msoft-float
ASFLAGS		+= -msoft-float
LDFLAGS		+= -T p32mx320f128h.ld
#LDFLAGS		+= -nostdlib -static -nostartfiles -lgcc

PROGNAME	= outfile

ELFFILE		= $(PROGNAME).elf
HEXFILE		= $(PROGNAME).hex

TTYDEV		= /dev/ttyUSB0
TTYBAUD		= 115200
DEVICE		= 32MX320F128H

CFILES          = $(wildcard *.c)
ASFILES         = $(wildcard *.S)
OBJFILES        = $(CFILES:.c=.c.o)
OBJFILES        +=$(ASFILES:.S=.S.o)

.PHONY: all clean install envcheck

all: envcheck $(HEXFILE)

clean:
	$(RM) $(HEXFILE) $(ELFFILE) $(OBJFILES)

envcheck:
	@[ "$(TARGET)" = "mipsel-pic32-elf-" ] || (echo "Make sure you have sourced the cross compiling environment"; exit 1)

install:
	$(TARGET)avrdude -v -p $(DEVICE) -c stk500v2 -P "$(TTYDEV)" -b $(TTYBAUD) -U "flash:w:$(HEXFILE)"

$(ELFFILE): $(OBJFILES)
	$(CC) $(CFLAGS) -o $@ $(OBJFILES) $(LDFLAGS)

$(HEXFILE): $(ELFFILE)
	$(TARGET)bin2hex -a $(ELFFILE)

%.c.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.S.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<
