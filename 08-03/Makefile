!include ..\Makefile.inc

TARGET=08-03-boot.bin

OBJS=\
	$(OBJDIR)\boot.bin\
	$(OBJDIR)\setup.bin\
	$(OBJDIR)\kernel.bin\
	$(OBJDIR)\user_program1.bin\
	$(OBJDIR)\user_program2.bin\
	$(OBJDIR)\user_program3.bin\
	$(OBJDIR)\user_program4.bin\
	$(OBJDIR)\user_program5.bin\

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
	copy /b $(OBJDIR)\boot.bin\
    + $(OBJDIR)\setup.bin\
    + $(OBJDIR)\kernel.bin\
    + $(OBJDIR)\user_program1.bin\
    + $(OBJDIR)\user_program2.bin\
    + $(OBJDIR)\user_program3.bin\
    + $(OBJDIR)\user_program4.bin\
    + $(OBJDIR)\user_program5.bin $@

.asm{$(OBJDIR)}.bin:
	@if not exist $(OBJDIR) mkdir $(OBJDIR)
	$(NASM) -f bin -o $@ $**

clean:
	@if exist $(OBJDIR) $(RD) $(OBJDIR)
	@if exist $(OUTDIR)\$(TARGET) $(RM) $(OUTDIR)\$(TARGET)
