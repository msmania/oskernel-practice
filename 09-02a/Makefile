include ../Makefile.inc

TARGET=09-02a

SRCS=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*.c)
OBJS=$(addprefix $(OBJDIR)/, $(notdir $(patsubst %.c,%.bin,$(SRCS:.asm=.bin))))

KERNEL_OBJS=\
	$(OBJDIR)/util.o\
	$(OBJDIR)/main.o\

all: $(OUTDIR)/$(TARGET)

clean:
	$(RM) $(KERNEL_OBJS) $(OUTDIR)/$(TARGET)

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(NASM) -f coff -o $@ $^
	objdump -D $@ >$@.disas

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	gcc $(CFLAGS) -o $@ $^
	objdump -D $@ >$@.disas

$(OUTDIR)/$(TARGET): $(KERNEL_OBJS)
	@[ -d $(OUTDIR) ] || mkdir -p $(OUTDIR)
	$(eval P=$(shell A="$^"; B=($$A); echo $${B[0]//.\o/\.p}))
	ld $(LDFLAGS) -o ${P} -Ttext 0x00 -Tdata 0x200 -e main $^
	objcopy $(OBJCOPY_FLAGS) ${P} $@
	ndisasm -b32 $@ >$(OBJDIR)/01.bin.disas