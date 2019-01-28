%include "init.inc"

[org 0]
  jmp 07C0h:start

%include "a20.inc"

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

; Load 2 sectors of setup.bin from Drive#0(FDA):Head#0:Sector#2:Cylinder#0
; onto 9000:0000
read_setup:
  mov ax, 0x9000
  mov es, ax
  mov bx, 0
  mov ah, 2
  mov al, 2
  mov ch, 0
  mov cl, 2
  mov dh, 0
  mov dl, 0
  int 13h
  jc read_setup

; Load kernel from Drive#0(FDA):Head#0:Sector#4:Cylinder#0
; onto 8000:0000
read_kernel:
  mov ax, 0x8000
  mov es, ax
  mov bx, 0
  mov ah, 2
  mov al, NumKernelSector
  mov ch, 0
  mov cl, 4
  mov dh, 0
  mov dl, 0
  int 13h
  jc read_kernel

  mov dx, 0x3F2 ; turn off FDA motor
  xor al, al
  out dx, al

  cli

  call a20_try_loop

  ; ICW1: PIC initialization
  mov al, 0x11 ; IC4=1
  out 0x20, al
  dw  0x00eb, 0x00eb ; jmp $+2, jmp $+2
  out 0xA0, al
  dw  0x00eb, 0x00eb

  ; ICW2: remapping
  mov al, 0x20 ; IRQ# offset for master PIC
  out 0x21, al
  dw  0x00eb, 0x00eb
  mov al, 0x28 ; IRQ# offset for slave PIC
  out 0xA1, al
  dw  0x00eb, 0x00eb

  ; ICW3
  mov al, 0x04 ; Master PIC's IRQ#2 connects to slave
  out 0x21, al
  dw  0x00eb, 0x00eb
  mov al, 0x02 ; Slave PIC connects to master's IRQ#2
  out 0xA1, al
  dw  0x00eb, 0x00eb

  ; ICW4
  mov al, 0x01 ; uPM=1: 8086 mode
  out 0x21, al
  dw  0x00eb, 0x00eb
  out 0xA1, al
  dw  0x00eb, 0x00eb

  mov al, 0xFF ; Block all interruption for slave PIC
  out 0xA1, al
  dw  0x00eb, 0x00eb
  mov al, 0xFB ; Block all interruption for master PIC except IRQ#2
  out 0x21, al

  jmp 0x9000:0000

msgBack db '.', 0x67

times 510 - ($ - $$) db 0
  dw 0AA55h
