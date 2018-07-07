times 63 dd 0 ; user-mode stack space
User1regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd 0x80000000             ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd 0x80000FFF             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User2regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd 0x80001000             ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd 0x80001FFF             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User3regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd 0x80002000             ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd 0x80002FFF             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User4regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd 0x80003000             ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd 0x80003FFF             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User5regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd 0x80004000             ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd 0x80004FFF             ; esp
  dw UserDataSelector, 0    ; ss
