int a = 0x12345678;

void func();

int main() {
  func();
  return 0;
}

void func() {
  ++a;
}