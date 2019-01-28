void FloppyMotorOn();
void FloppyMotorOff();
void WaitFloppy();
void initializeDMA(unsigned int page, unsigned int offset);
void FloppyCode(unsigned int code);
void ReadSector(int head,
                int track,
                int sector,
                unsigned char *source,
                unsigned char *destiny);
int FloppyCalibrateHead();
int FloppySeek(int head, int cylinder);
void FloppyHandler();
void delay(int tenMillisecond);
char ResultPhase();
unsigned int inb(unsigned int port);
void outb(unsigned int port, unsigned int value);