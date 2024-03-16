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
	PORTB=0xff; // A0 high
	wrDout(v);
	delay(1);
}

void psg_setup() {
	// reset
	digitalWrite(ICPIN,0);
	delay(100);
	digitalWrite(ICPIN,1);
	delay(100);
	for(int k=0;k<6;k+=2) { // set minimum freq for all channels
		wrReg(0+k,(k<<2)+1);
		wrReg(1+k,0x0);
	}
	// wrReg(0x2d,0); // pre scaler 658 kHz
	// wrReg(0x2e,0);    // pre scaler 1.3 MHz
	wrReg(0x21,0); 		// no test
	wrReg(0x2f,0);    	// pre scaler 2.0 MHz, SSG=full clock
	wrReg(7, 0xc0 ); 	// tone enabled, IO ports as outputs
	wrReg(6, 0x10 ); 	// noise
	wrReg( 010,0x7);
	wrReg( 011, 6 );
	wrReg( 012, 7 );
}

int cnt=1;
void loop() {
	cnt++;
	// wrReg(0xe,cnt);
	wrReg(0xf,cnt);	
	if((cnt&0x1f)==0) {
		wrReg(010,(cnt>>5)&0xf);
		wrReg(011,(cnt>>5)&0xf);
		wrReg(012,(cnt>>5)&0xf);
	}
	// delay(10);
}

