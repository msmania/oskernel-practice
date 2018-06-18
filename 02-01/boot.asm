[org 0]
[bits 16]
  jmp 0x07C0:start

start:
  mov ax, cs
  mov ds, ax
  mov es, ax

  mov ax, 0xB800
  mov es, ax
  mov dl, 0
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

  jmp 0x1000:000 ; jump to kernel.bin

msgBack db '.', 0x67

times 510 - ($ - $$) db 0
  dw 0xAA55
