%include "init.inc"

PAGE_DIR        equ 0x100000
PAGE_TAB_KERNEL equ 0x101000
PAGE_TAB_USER   equ 0x102000
PAGE_TAB_LOW    equ 0x103000

[org 0x90000]
[bits 16]
start:
  cld
  mov ax, cs
  mov ds, ax
  xor ax, ax
  mov ss, ax

  xor eax, eax
  lea eax, [tss]
  add eax, 0x90000
  mov [descriptor4 + 2], ax
  shr eax, 16
  mov [descriptor4 + 4], al
  mov [descriptor4 + 7], ah

  cli
  lgdt [gdtr]

  mov eax, cr0
  or eax, 0x00000001
  mov cr0, eax

  jmp $ + 2
  nop
  nop
  jmp dword SysCodeSelector:PM_Start

[bits 32]

PM_Start:
  mov bx, SysDataSelector
  mov ds, bx
  mov es, bx
  mov fs, bx
  mov gs, bx
  mov ss, bx
  lea esp, [PM_Start]

  ; copy kernel onto 0x200000
  mov esi, 0x80000
  mov edi, 0x200000
  mov cx, 512 * NumKernelSector
kernel_copy:
  mov al, byte [ds:esi]
  mov byte [es:edi], al
  inc esi
  inc edi
  dec cx
  jnz kernel_copy

  ; initialize PAGE_DIR
  mov edi, PAGE_DIR
  mov eax, 0        ; not present
  mov ecx, 1024     ; # of pages
  cld
  rep stosd

  ; set PAGE_DIR[0]
  mov edi, PAGE_DIR
  mov eax, PAGE_TAB_LOW
  or eax, 0x01
  mov [es:edi], eax

  ; set PAGE_DIR[0x200] for 0x80000000
  mov edi, PAGE_DIR + 0x200 * 4
  mov eax, PAGE_TAB_USER
  or eax, 0x07      ; user-mode
  mov [es:edi], eax

  ; set PAGE_DIR[0x300] for 0xC0000000
  mov edi, PAGE_DIR + 0x300 * 4
  mov eax, PAGE_TAB_KERNEL
  or eax, 0x01      ; kernel-mode
  mov [es:edi], eax

  ; initialize PAGE_TAB_KERNEL for 0x101000-0x101FFF
  mov edi, PAGE_TAB_KERNEL
  mov eax, 0        ; not present
  mov ecx, 1024     ; # of pages
  cld
  rep stosd

  ; set PAGE_TAB_KERNEL[0]
  mov edi, PAGE_TAB_KERNEL
  mov eax, 0x200000
  or eax, 1         ; kernel-mode
  mov [es:edi], eax

  ; set PAGE_TAB_KERNEL[1]
  mov edi, PAGE_TAB_KERNEL + 0x001 * 4
  mov eax, 0x201000
  or eax, 1         ; kernel-mode
  mov [es:edi], eax

  ; set PAGE_TAB_KERNEL[2] for IDT
  mov edi, PAGE_TAB_KERNEL + 0x002 * 4
  mov eax, 0x202000
  or eax, 1         ; kernel-mode
  mov [es:edi], eax

  ; initialize PAGE_TAB_USER for 0x102000-0x102FFF
  mov edi, PAGE_TAB_USER
  mov eax, 0        ; not present
  mov ecx, 1024     ; # of pages
  cld
  rep stosd

  ; set PAGE_TAB_USER[0]
  mov edi, PAGE_TAB_USER
  mov eax, 0x300000
  or eax, 7         ; user-mode
  mov [es:edi], eax

  ; set PAGE_TAB_USER[1]
  mov edi, PAGE_TAB_USER + 0x001 * 4
  mov eax, 0x301000
  or eax, 7         ; user-mode
  mov [es:edi], eax

  ; set PAGE_TAB_USER[2]
  mov edi, PAGE_TAB_USER + 0x002 * 4
  mov eax, 0x302000
  or eax, 7         ; user-mode
  mov [es:edi], eax

  ; set PAGE_TAB_USER[3]
  mov edi, PAGE_TAB_USER + 0x003 * 4
  mov eax, 0x303000
  or eax, 7         ; user-mode
  mov [es:edi], eax

  ; set PAGE_TAB_USER[4]
  mov edi, PAGE_TAB_USER + 0x004 * 4
  mov eax, 0x304000
  or eax, 7         ; user-mode
  mov [es:edi], eax

  ; initialize PAGE_TAB_LOW for 0-0xFFFFF
  mov edi, PAGE_TAB_LOW
  mov eax, 0x0000
  or eax, 1         ; kernel-mode
  mov cx, 256       ; initialize quarter
page_low_loop:
  mov [es:edi], eax
  add eax, 0x1000
  add edi, 4
  dec cx
  jnz page_low_loop

  mov eax, PAGE_DIR
  mov cr3, eax
  mov eax, cr0
  or eax, 0x80000000
  mov cr0, eax

  lea eax, [tss]
  mov [TSS_WHERE], eax
  mov esp, 0xc0001fff

  jmp 0xC0000000 ; jump to kernel.bin

gdtr:
  dw gdt_end - gdt
  dd gdt

gdt:
  dd 0, 0
  dd 0x0000FFFF, 0x00CF9A00 ; SysCodeSelector
  dd 0x0000FFFF, 0x00CF9200 ; SysDataSelector
  dd 0x8000FFFF, 0x0040920B ; VideoSelector

descriptor4:                ; TSSSelector
  dw 104  ; limit 0-15
  dw 0    ; base 0-15
  db 0    ; base 16-23
  db 0x89 ; P=1, DPL=0, Type=9
  db 0    ; G, AVL, Limit 16-19
  db 0    ; base 24-31

  dd 0x0000FFFF, 0x00FCFA00 ; UserCodeSelector
  dd 0x0000FFFF, 0x00FCF200 ; UserDataSelector
gdt_end:

tss:
  dw 0, 0 ; backlink to a previous task
tss_esp0:
  dd 0xc0001fff           ; esp0
  dw SysDataSelector, 0   ; ss0
  dd 0                    ; esp1
  dw 0, 0                 ; ss1
  dd 0                    ; esp2
  dw 0, 0                 ; ss2
  dd 0x100000             ; cr3
tss_eip:
  dd 0, 0                 ; eip, eflags
  dd 0, 0, 0, 0           ; eax, ecx, edx, ebx
tss_esp:
  dd 0, 0, 0, 0           ; esp, ebp, esi, edi
  dw 0, 0                 ; es
  dw 0, 0                 ; cs
  dw UserDataSelector, 0  ; ss
  dw 0, 0                 ; ds
  dw 0, 0                 ; fs
  dw 0, 0                 ; gs
  dw 0, 0                 ; ldt
  dw 0, 0                 ; T bit for debug, IO permit bitmap

times 1024 - ($ - $$) db 0
