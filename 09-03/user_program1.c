#include "print_string.h"

void print_it();

int main() {
  print_it();
}

void print_it() {
  char *s = ".I'm running now.";
  for (;;) {
    print_string(5, 10, "This is User1");
    print_string(5, 11, s);
    ++s[0];
  }
}