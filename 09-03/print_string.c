#include "print_string.h"

void print_string(int x, int y, char *str) {
  __asm__ __volatile__ (
    "push %%eax\n\t"
    "push %%ebx\n\t"
    "push %%ecx\n\t"
    "mov %0, %%eax\n\t"
    "mov %1, %%ebx\n\t"
    "mov %2, %%ecx\n\t"
    "int $0x80\n\t"
    "pop %%ecx\n\t"
    "pop %%ebx\n\t"
    "pop %%eax\n\t"
    :
    : "m"(x), "m"(y), "m"(str));
}

void print_user_message(int x, int y, char *msg1, char *msg2) {
  for (;;) {
    print_string(x, y, msg1);
    print_string(x, y + 1, msg2);
    ++msg2[0];
  }
}