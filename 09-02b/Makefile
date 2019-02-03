include ../Makefile.inc

TARGET=09-02b

SRCS=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*.c)
OBJS=$(addprefix $(OBJDIR)/, $(notdir $(patsubst %.c,%.o,$(SRCS:.asm=.o))))

all: $(OUTDIR)/$(TARGET)

clean:
	$(RM) $(OBJS) $(OUTDIR)/$(TARGET)

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	$(NASM) -f coff -o $@ $^

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@[ -d $(OBJDIR) ] || mkdir -p $(OBJDIR)
	gcc $(CFLAGS) -o $@ $^

$(OUTDIR)/$(TARGET): $(OBJS)
	@[ -d $(OUTDIR) ] || mkdir -p $(OUTDIR)
	gcc $(LFLAGS) -o $@ $^