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
 34    | GND (/CS)
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

const int CLKPIN=9, A0PIN=11, WRPIN=12, ICPIN=13;

void setup() {
	// Set Pins 2-12 as an output
	for (int pin = 2; pin <= 13; pin++) {
		pinMode(pin, OUTPUT);
	}
	digitalWrite(ICPIN,0);
	// set a 2MHz frequency at pin 9 (CLKPIN)
	noInterrupts();
	// Set Timer1 in Fast PWM mode with the top in ICR1
	TCCR1A = 0;
	TCCR1A |= (1 << COM1A0);  // Toggle OC1A on Compare Match
	TCCR1A |= (1 << WGM11);   // Mode 14 Fast PWM
	TCCR1B = 0;
	TCCR1B |= (1 << WGM12) | (1 << WGM13); // Mode 14 Fast PWM
	TCCR1B |= (1 << CS11);    // Set prescaler to 8
	// Set ICR1 to value for 2MHz frequency
	ICR1 = 3;  // With a 16MHz clock and prescaler of 8, this yields a frequency close to 2MHz
	interrupts();
	// PSG
	psg_setup();
	Serial.begin(9600);
}

void wrDout(int v) {
	for( int pin=2; pin<11; pin++ ) {
		if( pin==CLKPIN ) continue;
		digitalWrite(pin,v&1);
		v>>=1;
	}
	digitalWrite(WRPIN,1);
	digitalWrite(WRPIN,0);
	digitalWrite(WRPIN,1);
}

void wrReg( int r, int v) {
	digitalWrite(A0PIN,0);
	wrDout(r);
	digitalWrite(A0PIN,1);
	wrDout(r);
}

void psg_setup() {
	// reset
	digitalWrite(ICPIN,0);
	delay(10);
	digitalWrite(ICPIN,1);
	delay(10);

	for(int k=0;k<3;k++) { // set minimum freq for all channels
		wrReg(0+k,0xff);
		wrReg(1+k,0x0f);
	}
	wrReg(7, 7<<3 ); // tone enable
	wrReg(11, 0 );   // fast envelope
	wrReg(12, 0 );
	wrReg(13, 13 ); // envelope held high
}

void loop() {
	int vol[3]={0,0,0};
	char str[64];
	for(int ch=0;ch<3;ch++) {
		for(int k=0;k<16;k++) {
			vol[ch]=k;
			wrReg( 8,vol[0]);
			wrReg( 9,vol[1]);
			wrReg(10,vol[2]);
			delay(10);
			int amp = analogRead(A0);
			sprintf(str,"%d,%d,%d,%04d",vol[0],vol[1],vol[2],amp);
			Serial.println(str);
		}
	}
}

