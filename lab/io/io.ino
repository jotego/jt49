const int A0PIN=8, WRPIN=9, ICPIN=10;

void setup() {
	// Set Pins 2-12 as an output
	DDRD=0xff;
	DDRB=0xff;
	// pinMode(A0PIN, OUTPUT);
	// pinMode(WRPIN, OUTPUT);
	// pinMode(ICPIN, OUTPUT);
	// PSG
	psg_setup();
	// Serial.begin(9600);
}

void wrDout(int v) {
	PORTD=v&0xff;
	PORTB=PINB&0xfd; // WR low
	PORTB=PINB|0x02; // WR high
}

void wrReg( int r, int v) {
	PORTB=0xfe; // A0 low
	wrDout(r);
	delay(1);
	PORTB=0xff; // A0 hihg
	wrDout(v);
	delay(1);
}

void psg_setup() {
	// reset
	digitalWrite(ICPIN,0);
	delay(100);
	digitalWrite(ICPIN,1);
	delay(100);
	wrReg(7, 0xe0 ); // tone enabled, IO ports as outputs
}

void loop() {
	for(int cnt=0;;cnt++) {
		wrReg(0xe,cnt);
		wrReg(0xf,~cnt);
	}
}

