!include ..\Makefile.inc

TARGET=05-03-boot.bin

OBJS=\
	$(OBJDIR)\boot.bin\
	$(OBJDIR)\kernel.bin\

all: $(OUTDIR)\$(TARGET)

run:
	$(PS) -file ..\deploy.ps1\
		-DD $(DD)\
		-Image $(OUTDIR)\$(TARGET)\
		-Device $(DEVICE)\
		-Vhd $(VHDX)\
		-VMName $(VMNAME)\

$(OUTDIR)\$(TARGET): $(OBJS)
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
	copy $(OBJDIR)\boot.bin + $(OBJDIR)\kernel.bin /b $@

.asm{$(OBJDIR)}.bin:
	@if not exist $(OBJDIR) mkdir $(OBJDIR)
	$(NASM) -f bin -o $@ $**

clean:
	@if exist $(OBJDIR) $(RD) $(OBJDIR)
	@if exist $(OUTDIR)\$(TARGET) $(RM) $(OUTDIR)\$(TARGET)
