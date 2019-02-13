%include "init.inc"

[extern printk]
[extern TimerHandler]
[extern schedule]
[extern KeyboardHandler]
[extern FloppyHandler]
[extern print_hex]
[extern IgnorableInterrupt]
[extern SystemCallEntry]
[extern H_isr_00]
[extern H_isr_01]
[extern H_isr_02]
[extern H_isr_03]
[extern H_isr_04]
[extern H_isr_05]
[extern H_isr_06]
[extern H_isr_07]
[extern H_isr_08]
[extern H_isr_09]
[extern H_isr_10]
[extern H_isr_11]
[extern H_isr_12]
[extern H_isr_13]
[extern H_isr_14]
[extern H_isr_15]
[extern H_isr_17]

segment .text

[global LoadIDT]
[global EnablePIC]
[global isr_ignore]
[global isr_32_timer]
[global isr_33_keyboard]
[global isr_38_floppy]
[global isr_128_soft_int]
[global isr_00]
[global isr_01]
[global isr_02]
[global isr_03]
[global isr_04]
[global isr_05]
[global isr_06]
[global isr_07]
[global isr_08]
[global isr_09]
[global isr_10]
[global isr_11]
[global isr_12]
[global isr_13]
[global isr_14]
[global isr_15]
[global isr_17]

LoadIDT:
  push ebp
  mov ebp, esp
  lidt [idtr]
  pop ebp
  ret

EnablePIC:
  mov al, 0xBC
  out 0x21, al
  sti
  ret

isr_ignore:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov al, 0x20
  out 0x20, al

  lea eax, [IgnorableInterrupt]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_32_timer:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov al, 0x20
  out 0x20, al

  lea eax, [TimerHandler]
  call eax
  lea eax, [schedule]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_33_keyboard:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov al, 0x20
  out 0x20, al

  ; retrieve scan code to receive next interruption
  in al, 0x60

  push eax
  lea eax, [KeyboardHandler]
  call eax
  add esp, 4

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_38_floppy:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov al, 0x20
  out 0x20, al

  lea eax, [FloppyHandler]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_128_soft_int:
  push gs
  push fs
  push es
  push ds
  pushad

  push eax
  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  pop eax

  mov dword [thunk], SystemCallEntry
  call [thunk]

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

thunk: dd 0

isr_00:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_00]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_01:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_01]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_02:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_02]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_03:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_03]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_04:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_04]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_05:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_05]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_06:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_06]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_07:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_07]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_08:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_08]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_09:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_09]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_10:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_10]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_11:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_11]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_12:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_12]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_13:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_13]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_14:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_14]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_15:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_15]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

isr_17:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea eax, [H_isr_17]
  call eax

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

segment .data

idtr:
  dw 256 * 8
  dd IDT_BASE
