const int A0PIN=8,  // PB0
          WRPIN=9,  // PB1
          ICPIN=10; // PB2

void setup() {
	// Set ports B and D as an output
	DDRD=0xff;
	DDRB=0xff;
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
	wrReg(0,0x95);
	wrReg(3,0xd);
	wrReg(5,0xab);
	wrReg(2,0x6);
	wrReg(4,0x53);

	// wrReg(0x2d,0); // pre scaler 658 kHz
	// wrReg(0x2e,0);    // pre scaler 1.3 MHz
	wrReg(0x21,0); 		// no test
	wrReg(0x2f,0);    	// pre scaler 2.0 MHz, SSG=full clock
	wrReg(7, 0376 ); 	// tone enabled, IO ports as outputs
	// wrReg(7, 0334 ); 	// noise enabled, IO ports as outputs
	wrReg(6, 0x1f ); 	// noise
	wrReg( 010, 0 );
	wrReg( 011, 0 );
	wrReg( 012, 0 );


	wrReg( 010, 15 );
	wrReg( 011, 0 );
	wrReg( 012, 0 );
	delay(11);
}

void loop() {
	int amp = analogRead(A0)>>6;
	wrReg( 0xf, amp ); // show on port B	
	wrReg( 010, amp ); // volume channel A
	delay(20);
}

