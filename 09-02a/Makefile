include ../Makefile.inc

TARGET=09-03-boot.bin

SRCS=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*.c)
OBJS=$(addprefix $(OBJDIR)/, $(notdir $(patsubst %.c,%.bin,$(SRCS:.asm=.bin))))

all: $(OUTDIR)/$(TARGET)

clean:
	$(RM) $(OBJS) #$(OUTDIR)/$(TARGET)

$(OBJDIR)/%.bin: $(SRCDIR)/%.asm
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	echo $(NASM) -f bin -o $@ $^

$(OBJDIR)/%.bin: $(SRCDIR)/%.c
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(eval O=$(patsubst %.bin,%.o,$@))
	$(eval P=$(patsubst %.bin,%.p,$@))
	gcc $(CFLAGS) -o $(O) $^
	ld -melf_i386 -o $(P) -Ttext 0x00 -Tdata 0x200 -e main $(O)
	objcopy -R .note -R .comment -S -O binary $(P) $@

$(OUTDIR)/$(TARGET): $(OBJS)
	@[ -d $(OUTDIR) ] || mkdir -p $(OUTDIR)
