!include ..\Makefile.inc

TARGET=01-01-boot.bin

all: $(OUTDIR)\$(TARGET)

run:
	$(PS) -file ..\deploy.ps1\
		-DD $(DD)\
		-Image $(OUTDIR)\01-01-boot.bin\
		-Device $(DEVICE)\
		-Vhd $(VHDX)\
		-VMName $(VMNAME)\

$(OUTDIR)\$(TARGET): boot.asm
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
	$(NASM) -f bin -o $@ $**

clean:
	@if exist $(OUTDIR)\$(TARGET) $(RM) $(OUTDIR)\$(TARGET)
