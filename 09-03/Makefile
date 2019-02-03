include ../Makefile.inc

TARGET=09-03-kernel.img

BOOT_OBJS=\
	$(OBJDIR)/boot.o\
	$(OBJDIR)/setup.o\

KERNEL_OBJS=\
	$(OBJDIR)/kernel.o\
	$(OBJDIR)/interrupt_asm.o\
	$(OBJDIR)/interrupt.o\
	$(OBJDIR)/process.o\
	$(OBJDIR)/floppy_asm.o\
	$(OBJDIR)/floppy.o\

USER_OBJS=\
	$(OBJDIR)/user_program1.o\
	$(OBJDIR)/user_program2.o\
	$(OBJDIR)/user_program3.o\
	$(OBJDIR)/user_program4.o\

MODULES=$(BOOT_OBJS:.o=.bin) $(OBJDIR)/kernel.bin $(USER_OBJS:.o=.bin)

all: $(OUTDIR)/$(TARGET)

clean:
	$(RM) $(KERNEL_OBJS) $(MODULES) $(OUTDIR)/$(TARGET)

run:
	$(QEMU)\
		$(QEMU_OPT)\
		-fda $(OUTDIR)/$(TARGET)

$(OBJDIR)/%_asm.o: $(SRCDIR)/%.asm
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(NASM) -f coff -o $@ $^

$(OBJDIR)/%.bin: $(SRCDIR)/%.asm
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(NASM) -f bin -o $@ $^

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	gcc $(CFLAGS) -o $@ $^

$(OBJDIR)/kernel.bin: $(KERNEL_OBJS)
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(eval P=$(OBJDIR)/kernel.p)
	ld $(LDFLAGS) -o $(P) -Ttext 0xC0000000 -Tdata 0xC0001800 -e start_kernel $^
	objcopy $(OBJCOPY_FLAGS) $(P) $@
	rm $(P)

$(OBJDIR)/%.bin: $(OBJDIR)/%.o $(OBJDIR)/print_string.o
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(eval P=$(shell A="$^"; B=($$A); echo $${B[0]//.\o/\.p}))
	$(eval ADDR=$(shell \
		if [[ "$^" == *user_program1* ]]; then \
			echo 0x80000000; \
		elif [[ "$^" == *user_program2* ]]; then \
			echo 0x80001000; \
		elif [[ "$^" == *user_program3* ]]; then \
			echo 0x80002000; \
		elif [[ "$^" == *user_program4* ]]; then \
			echo 0x80003000; \
		fi))
	ld $(LDFLAGS) -o ${P} -Ttext ${ADDR} -e main $^
	objcopy $(OBJCOPY_FLAGS) ${P} $@
	rm ${P}

$(OUTDIR)/$(TARGET): $(MODULES)
	@[ -d $(OUTDIR) ] || mkdir -p $(OUTDIR)
	cat $^ >$@
