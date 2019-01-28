segment .text

[global FloppyMotorOn]
[global FloppyMotorOff]
[global initializeDMA]
[global FloppyCode]
[global ResultPhase]
[global inb]
[global outb]

FloppyMotorOn:
  push edx
  push eax
  mov dx, 0x3f2
  mov al, 0x1c
  out dx, al
  pop eax
  pop edx
  ret

FloppyMotorOff:
  push edx
  push eax
  mov dx, 0x3f2
  xor al, al
  out dx, al
  pop eax
  pop edx
  ret

initializeDMA:
  push ebp
  mov ebp, esp
  push eax

  mov al, 0x14
  out 0x08, al
  mov al, 1
  out 0x0c, al
  mov al, 0x56
  out 0x0b, al
  mov al, 1
  out 0x0c, al

  mov eax, dword [ebp+0x0c]
  out 0x04, al
  mov al, ah
  out 0x04, al

  mov eax, dword [ebp+0x08]
  out 0x81, al

  mov al, 1
  out 0x0C, al
  mov al, 0xff
  out 0x05, al
  mov al, 1
  out 0x05, al
  mov al, 0x02
  out 0x0a, al
  mov al, 0x10
  out 0x08, al

  pop eax
  mov esp, ebp
  pop ebp
  ret

inb:
  push ebp
  mov ebp, esp
  push edx

  mov edx, dword [ebp + 0x08]
  in al, dx

  pop edx
  mov esp, ebp
  pop ebp
  ret

outb:
  push ebp
  mov ebp, esp
  push eax
  push edx

  mov eax, dword [ebp + 0x0c]
  mov edx, dword [ebp + 0x08]
  out dx, al

  pop edx
  pop eax
  mov esp, ebp
  pop ebp
  ret

ResultPhase:
  push edx
  mov dx, 0x3F5
  in al, dx
  pop edx
  ret
