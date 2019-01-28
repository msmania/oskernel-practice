#include "print_string.h"

void print_it();

int main() {
  print_it();
}

void print_it() {
  char *s = ".I'm running now.";
  for (;;) {
    print_string(5, 15, "This is User3");
    print_string(5, 16, s);
    ++s[0];
  }
}