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

; Load 2 sectors of setup.bin from Drive#80(HDD):Head#0:Sector#2:Cylinder#0
; onto 9000:0000
read:
  mov ax, 0x9000
  mov es, ax
  mov bx, 0
  mov ah, 2
  mov al, 2
  mov ch, 0
  mov cl, 2
  mov dh, 0
  mov dl, 0x80
  int 13h
  jc read

; Load 7 sectors of kernel.bin from Drive#80(HDD):Head#0:Sector#4:Cylinder#0
; onto 8000:0000
read_kernel:
  mov ax, 0x8000
  mov es, ax
  mov bx, 0
  mov ah, 2
  mov al, 7
  mov ch, 0
  mov cl, 4
  mov dh, 0
  mov dl, 0x80
  int 13h
  jc read_kernel

; Load 1 sector of user_program1.bin from Drive#80(HDD):Head#0:Sector#11:Cylinder#0
; onto 7000:0000
read_user1:
  mov ax, 0x7000
  mov es, ax
  mov bx, 0
  mov ah, 2
  mov al, 1
  mov ch, 0
  mov cl, 11
  mov dh, 0
  mov dl, 0x80
  int 13h
  jc read_user1

; Load 1 sector of user_program2.bin from Drive#80(HDD):Head#0:Sector#12:Cylinder#0
; onto 7000:0200
read_user2:
  mov ax, 0x7000
  mov es, ax
  mov bx, 0x200
  mov ah, 2
  mov al, 1
  mov ch, 0
  mov cl, 12
  mov dh, 0
  mov dl, 0x80
  int 13h
  jc read_user2

; Load 1 sector of user_program3.bin from Drive#80(HDD):Head#0:Sector#13:Cylinder#0
; onto 7000:0400
read_user3:
  mov ax, 0x7000
  mov es, ax
  mov bx, 0x400
  mov ah, 2
  mov al, 1
  mov ch, 0
  mov cl, 13
  mov dh, 0
  mov dl, 0x80
  int 13h
  jc read_user3

; Load 1 sector of user_program4.bin from Drive#80(HDD):Head#0:Sector#14:Cylinder#0
; onto 7000:0600
read_user4:
  mov ax, 0x7000
  mov es, ax
  mov bx, 0x600
  mov ah, 2
  mov al, 1
  mov ch, 0
  mov cl, 14
  mov dh, 0
  mov dl, 0x80
  int 13h
  jc read_user4

; Load 1 sector of user_program5.bin from Drive#80(HDD):Head#0:Sector#15:Cylinder#0
; onto 7000:0800
read_user5:
  mov ax, 0x7000
  mov es, ax
  mov bx, 0x800
  mov ah, 2
  mov al, 1
  mov ch, 0
  mov cl, 15
  mov dh, 0
  mov dl, 0x80
  int 13h
  jc read_user5

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
