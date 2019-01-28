#include "floppy.h"

#define READ_SECTOR_HEAD_DRIVE 1
#define READ_SECTOR_TRACK 2
#define READ_SECTOR_HEAD 3
#define READ_SECTOR 4
#define SEEK_HEAD_DRIVE 1
#define SEEK_CYLINDER 2

unsigned int floppy_code_read_sector[] =
  {0x66, 0x00, 0x00, 0x00, 0x00, 0x02, 18, 0x1b, 0x00};
unsigned int floppy_code_calibrate[] =
  {0x07, 0x00};
unsigned int floppy_code_seek[] =
  {0x0f, 0x00, 0x00};
unsigned int floppy_code_interrupt_status = 0x08;

int g_FloppyInterrupted = 0;
int cont = 0;

static int interrupt_count = 1;

char result_seek[7];

void ReadIt();

void ReadSector(int head,
                int track,
                int sector,
                unsigned char *source,
                unsigned char *destiny) {
  int i, page, offset;
  unsigned int src, dest;
  char result[7];

  src = (unsigned int)source;
  dest = (unsigned int)destiny;

  page = (int)(src >> 16);
  offset = (int)(src & 0xffff);

  FloppyMotorOn();
  delay(20);

  for (i = 0; i < 5; ++i) {
    if (!FloppyCalibrateHead())
      continue;
    if (!FloppySeek(head, track))
      continue;
    else
      break;
  }

  initializeDMA(page, offset);

  floppy_code_read_sector[READ_SECTOR_HEAD_DRIVE] = head << 2;
  floppy_code_read_sector[READ_SECTOR_TRACK] = track;
  floppy_code_read_sector[READ_SECTOR_HEAD] = head;
  floppy_code_read_sector[READ_SECTOR] = sector;

  g_FloppyInterrupted = 0;

  for (i = 0; i < 9; ++i) {
    WaitFloppy();
    FloppyCode(floppy_code_read_sector[i]);
  }

  while (!g_FloppyInterrupted);
  g_FloppyInterrupted = 0;

  delay(20);

  for (i = 0; i < 7; ++i) {
    WaitFloppy();
    result[i] = ResultPhase();
  }

  WaitFloppy();
  FloppyMotorOff();

  for (i = 0; i < 512; ++i)
    destiny[i] = source[i];
}

int FloppyCalibrateHead() {
  int i;
  char result[2];

  for (i = 0; i < 2; ++i) {
    WaitFloppy();
    FloppyCode(floppy_code_calibrate[i]);
  }
  delay(20);

  WaitFloppy();
  FloppyCode(floppy_code_interrupt_status);

  WaitFloppy();
  result[0] = ResultPhase();
  WaitFloppy();
  result[1] = ResultPhase();

  if (result[0] != 0x20)
    return 0;
  else
    return 1;
}

int FloppySeek(int head, int cylinder) {
  int i;
  char result[7];

  floppy_code_seek[SEEK_CYLINDER] = cylinder;
  floppy_code_seek[SEEK_HEAD_DRIVE] = head << 2;

  g_FloppyInterrupted = 0;
  for (i = 0; i < 3; ++i) {
    WaitFloppy();
    FloppyCode(floppy_code_seek[i]);
  }

  while (!g_FloppyInterrupted);
  delay(20);

  WaitFloppy();
  FloppyCode(floppy_code_interrupt_status);

  WaitFloppy();
  result[0] = ResultPhase();
  WaitFloppy();
  result[1] = ResultPhase();

  if (result[0] != 0x20)
    return 0;

  WaitFloppy();
  FloppyCode(0x4a);
  WaitFloppy();
  FloppyCode(head << 2);
  for (i = 0; i < 7; ++i) {
    WaitFloppy();
    result_seek[i] = ResultPhase();
  }

  if (result_seek[3] != cylinder)
    return 0;
  else
    return 1;
}

void FloppyCode(unsigned int code) {
  outb(0x3f5, code);
}

void WaitFloppy() {
  unsigned int result;
  for (;;) {
    result = inb(0x3f4);
    if ((result & 0x80) == 0x80) break;
  }
}

void FloppyHandler() {
  g_FloppyInterrupted = 1;
}