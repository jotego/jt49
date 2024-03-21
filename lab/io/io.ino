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
	// delay(1);
	PORTB=0xff; // A0 high
	wrDout(v);
	// delay(1);
}

void psg_setup() {
	// reset
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
	wrReg(7, 0370 ); 	// tone enabled, IO ports as outputs
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
	int pot = analogRead(A0);
	// wrReg( 010, pot>>6 );
	delay(20);
}

struct Delta{
	int h, l;
};

void delta( struct Delta* d ) {
	const int LEN=50;
	int v[LEN];
	long int h=0,l=0,hk=0,lk=0;
	long int ave=0;
	for( int k=0; k<LEN; k++ ) {
		v[k] = analogRead(A0);
		delay(random(25));
		ave+=v[k];
	}
	ave/=LEN;
	for( int k=0; k<LEN; k++ ) {
		if(v[k]>ave) {
			h+=v[k]; 
			hk++;
		} else {
			l+=v[k];
			lk++;
		}
	}
	if(hk==0||lk==0) {
		d->h=0;
		d->l=0;
		return;
	}
	d->h = h/hk;
	d->l = l/lk;
}

void dump( struct Delta *d, int len ) {
	char str[40];
	Serial.begin(9600);	
	for( int k=0; k<len; k++ ) {
		sprintf(str,"%d,%d,%d,%d",k,d[k].l,d[k].h,d[k].h-d[k].l);	
		Serial.println(str);
	}
	Serial.end();
}

void sweep_all() {
	struct Delta d[16*3];
	int ch=0;
	for( ch=0; ch<3; ch++ ) {
		wrReg(010+ch,0);
	}
	for( ch=0; ch<3; ch++ ) {
		for( int vol=0; vol<16; vol++ ) {
			wrReg(010+ch,vol&0xf);
			delta(&d[vol+(ch<<4)]);
		}
	}
	dump(d,sizeof(d)/sizeof(Delta));
}

