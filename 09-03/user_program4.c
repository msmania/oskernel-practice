#include "print_string.h"

void print_it();

int main() {
  print_it();
}

void print_it() {
  char *s = ".I'm running now.";
  for (;;) {
    print_string(25, 15, "This is User4");
    print_string(25, 16, s);
    ++s[0];
  }
}