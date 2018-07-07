A20_TEST_LOOPS    equ 32
A20_ENABLE_LOOPS  equ 255
A20_TEST_ADDR     equ 4 * 0x80

a20_try_loop:

a20_none:
  call a20_test
  jnz a20_done

a20_bios:
  mov ax, 0x2401
  pushfd
  int 0x15 ; INT 15 AX=2401 enables A20 through BIOS
  popfd
  call a20_test
  jnz a20_done

a20_kbc:
  call empty_8042
  call a20_test
  jnz a20_done

  mov al, 0xD1
  out 0x64, al
  call empty_8042

  mov al, 0xDF
  out 0x60, al
  call empty_8042

a20_kbc_wait:
  xor cx, cx

a20_kbc_wait_loop:
  call a20_test
  jnz a20_done
  loop a20_kbc_wait_loop

a20_fast:
  in al, 0x92
  or al, 0x02
  and al, 0xFE
  out 0x92, al

a20_fast_wait:
  xor cx, cx

a20_fast_wait_loop:
  call a20_test
  jnz a20_done
  loop a20_fast_wait_loop

  dec byte [a20_tries]
  jnz a20_try_loop

a20_die:
  hlt
  jmp a20_die

a20_tries db A20_ENABLE_LOOPS

a20_done:
  ret

a20_test:
  push cx
  push ax
  xor cx, cx
  mov fs, cx ; fs=0000
  dec cx
  mov gs, cx ; gs=ffff
  mov cx, A20_TEST_LOOPS
  mov ax, word [fs:A20_TEST_ADDR]
  push ax

a20_test_wait:
  inc ax
  mov word [fs:A20_TEST_ADDR], ax         ; set to 0000:A20_TEST_ADDR
  call delay
  cmp ax, word [gs:A20_TEST_ADDR + 0x10]  ; load from FFFF:A20_TEST_ADDR + 0x10
  loop a20_test_wait

  pop word [fs:A20_TEST_ADDR]
  pop ax
  pop cx
  ret

empty_8042:
  push ecx
  mov ecx, 100000

empty_8042_loop:
  dec ecx
  jz empty_8042_end_loop

  call delay

  in al, 0x64
  test al, 1
  jz no_output

  call delay
  in al, 0x60
  jmp empty_8042_loop

no_output:
  test al, 2
  jnz empty_8042_loop

empty_8042_end_loop:
  pop ecx
  ret

delay:
  out 0x80, al
  ret
