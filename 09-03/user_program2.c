#include "print_string.h"

void print_it();

int main() {
  print_it();
}

void print_it() {
  char *s = ".I'm running now.";
  for (;;) {
    print_string(25, 10, "This is User2");
    print_string(25, 11, s);
    ++s[0];
  }
}