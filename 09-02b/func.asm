[bits 32]

segment .data

  lucky db "Lucky number is %d", 0

segment .text

[global func]
[extern printf]

func:
  push ebp
  mov ebp, esp
  push dword 7
  push lucky
  call printf
  mov esp, ebp
  pop ebp
  ret
