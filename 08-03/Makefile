include ../Makefile.inc

TARGET=08-03-boot.bin

SRCS=$(wildcard $(SRCDIR)/*.asm)
OBJS=$(addprefix $(OBJDIR)/, $(notdir $(SRCS:.asm=.bin)))

all: $(OUTDIR)/$(TARGET)

clean:
	$(RM) $(OBJS) $(OUTDIR)/$(TARGET)

run:
	$(QEMU)\
		$(QEMU_OPT)\
		-drive format=raw,file=$(OUTDIR)/$(TARGET)

$(OBJDIR)/%.bin: $(SRCDIR)/%.asm
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(NASM) -f bin -o $@ $^

$(OUTDIR)/$(TARGET): $(OBJS)
	@[ -d $(OUTDIR) ] || mkdir -p $(OUTDIR)
	cat $(OBJDIR)/boot.bin\
	    $(OBJDIR)/setup.bin\
	    $(OBJDIR)/kernel.bin\
	    $(OBJDIR)/user_program1.bin\
	    $(OBJDIR)/user_program2.bin\
	    $(OBJDIR)/user_program3.bin\
	    $(OBJDIR)/user_program4.bin\
	    $(OBJDIR)/user_program5.bin>$@
