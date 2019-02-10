int a = 0x12345678;

void func();
int Launcher();

int thunk() {
  return 0xdeadbeef;
}

int main() {
  func();
  return Launcher();
}

void func() {
  ++a;
}