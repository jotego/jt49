// Drives two channels with overlapping amplitudes

const int A0PIN=8,  // PB0
          WRPIN=9,  // PB1
          ICPIN=10; // PB2

void setup() {
	// Set ports B and D as an output
	DDRD=0xff;
	DDRB=0x07;
	// PSG
	psg_setup();
}

void wrDout(int v, int a0 ) {
	PORTD=v;
	a0=(a0&1)|4;	// keep IC high (bit 2)
	PORTB=a0; // WR low
	PORTB=a0|0x02; // WR high
	// delay(1);
}

void wrReg( int r, int v) {
	wrDout(r,0);
	wrDout(v,1);
}

void psg_setup() {
	// reset - if not c
	digitalWrite(ICPIN,0);
	delay(100);
	digitalWrite(ICPIN,1);
	delay(100);

	wrReg(1,0xf);
	wrReg(0,0x80);
	wrReg(3,0xf);
	wrReg(5,0x80);
	wrReg(2,0xf);
	wrReg(4,0x80);

	// wrReg(0x2d,0); // pre scaler 658 kHz
	// wrReg(0x2e,0);    // pre scaler 1.3 MHz
	wrReg(0x21,0); 		// no test
	wrReg(0x2f,0);    	// pre scaler 2.0 MHz, SSG=full clock
	wrReg(7, 0370 ); 	// tone enabled, IO ports as outputs
	wrReg(6, 0x1f ); 	// noise

	for(int k=010; k<013;k++ ) wrReg( k, 15 );
	wrReg(011,13);
	delay(11);
}

int edge() {
	static int last=0;
	int b = (PINB>>5)&1;
	int edge = b && !last;
	last = b;
	return edge;
}

void loop() {
	static unsigned old=0, volB=0;
	unsigned amp = analogRead(A0)>>2;
	// if( edge() ) volB += 4;
	// 	// volB = volB==15 ? 0 : (volB<<1)|1;
	// wrReg( 011, volB ); // volume channel B
	// wrReg( 0xf, volB ); // show on YM2203's port B	
	if( old!= amp ) wrReg(2,0x80|(amp>>3));
	old=amp;
	delay(20);
}

