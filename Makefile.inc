RM=rm
QEMU=qemu-system-i386
NASM=nasm
SHELL=/bin/bash

OUTDIR=../bin
OBJDIR=obj
SRCDIR=.

QEMU_OPT=\
	-cpu max\
	-smp 1\
	-m 2048\

CFLAGS=\
	-c\
	-O0\
	-Wall\
	-m32\
	-fno-stack-protector\
	-fno-pic\

LFLAGS=\
	-m32\

LDFLAGS=\
	-melf_i386\

OBJCOPY_FLAGS=\
	-R .comment\
	-R .note\
	-S\
	-O binary\
