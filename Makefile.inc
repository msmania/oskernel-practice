RM=rm
QEMU=qemu-system-i386
NASM=nasm

OUTDIR=../bin
OBJDIR=obj
SRCDIR=.

QEMU_OPT=\
  -cpu max\
  -smp 1\
  -m 2048\
