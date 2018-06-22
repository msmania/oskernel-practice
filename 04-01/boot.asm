%include "init.inc"

[org 0]
  jmp 07C0h:start

start:
  mov ax, cs
  mov ds, ax
  mov es, ax

  mov ax, 0xB800
  mov es, ax
  mov di, 0
  mov ax, word [msgBack]
  mov cx, 0x7FF

paint:
  mov word [es:di], ax
  add di, 2
  dec cx
  jnz paint

read:
  mov ax, 0x1000
  mov es, ax
  mov bx, 0
  mov ah, 2 ; into es:bx
  mov al, 1 ; load 1 sector
  mov ch, 0 ; cylinder #0
  mov cl, 2 ; from sector #2
  mov dh, 0 ; Head=0
  mov dl, 0x80 ; Drive0=Floppy, Drive80=HDD
  int 0x13

  jc read

  cli
  mov al, 0xFF ; all interruption
  out 0xA1, al ; are blocked

  lgdt [gdtr]

  mov eax, cr0
  or eax, 0x00000001
  mov cr0, eax
  jmp $ + 2
  nop
  nop

  mov bx, SysDataSelector
  mov ds, bx
  mov es, bx
  mov fs, bx
  mov gs, bx
  mov ss, bx

  jmp dword SysCodeSelector:0x10000

msgBack db '.', 0x67

gdtr:
  dw gdt_end - gdt
  dd gdt + 0x7C00

gdt:
  dd 0, 0
  dd 0x0000FFFF, 0x00CF9A00
  dd 0x0000FFFF, 0x00CF9200
  dd 0x8000FFFF, 0x0040920B

gdt_end:

times 510 - ($ - $$) db 0
  dw 0AA55h
