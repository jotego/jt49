/*

pin connections

Arduino   | YM2203  | Use
----------|---------|-----
  2       |   40    | D0
  3       |    2    | D1
  4       |    3    | D2
  5       |    4    | D3
  6       |    5    | D4
  7       |    6    | D5
  8       |    7    | D6
  9       |   38    | phi M
 10       |    8    | D7
 11       |   37    | A0
 12       |   35    | /WR
 13       |   24    | /IC (reset)
 A0       |   20    | resistor (channel A)

Other YM2203 pins

YM2203 | Connection
-------|--------------
 1     | GND (ground)
9-16   | NC
 17    | GND
 18-19 | NC/short to 20 (channels B, C)
 39    | NC
 36    | VCC (/RD)
 34    | GND (/CS)R_US
 25-33 | NC
 22-23 | NC
 21    | VCC (supply)

Measure:

Run the program for each of these configurations:

 1. Connect channel A to  1  kOhm, leave channels B,C disconnected
 2. Connect channel A to 10 kOhm,  leave channels B,C disconnected
 3. Join channels A,B,C to the same  1 kOhm resistor
 4. Join channels A,B,C to the same 10 kOhm resistor

*/

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
	PORTB=0xff; // A0 hihg
	wrDout(v);
}

void psg_setup() {
	// reset
	digitalWrite(ICPIN,0);
	delay(100);
	digitalWrite(ICPIN,1);
	delay(100);

	for(int k=0;k<6;k+=2) { // set minimum freq for all channels
		wrReg(0+k,0xff);
		wrReg(1+k,0x0);
	}
	wrReg(7, 7<<3 ); // tone enable
	wrReg(11, 0 );   // fast envelope
	wrReg(12, 0 );
	wrReg(13, 13 ); // envelope held high
}

// void loop() {
// 	for(int k=0;;k++) PORTD=k&0xff;
// }

void loop() {
	psg_setup();
	int vol[3]={0,0,0};
	char str[64];
	for(int ch=0;ch<3;ch++) {
		for(int k=0;k<16;k++) {
			vol[ch]=k;
			wrReg( 8,vol[0]);
			wrReg( 9,vol[1]);
			wrReg(10,vol[2]);
			delay(50);
			int amp = analogRead(A0);
			sprintf(str,"%d,%d,%d,%04d",vol[0],vol[1],vol[2],amp);
			// Serial.println(str);
		}
	}
}

