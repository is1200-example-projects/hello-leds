#include <proc/p32mx320f128h.h>

int answer_to_life_the_universe_and_everything();

void delay(int cyc) {
	int i;
	for(i = cyc; i > 0; i--);
}

int main(void) {
	unsigned int sweep = 0x1;

	answer_to_life_the_universe_and_everything();	
	
	AD1PCFG = 0xFFFF;
	ODCE = 0x0;
	TRISECLR = 0xFF;
	
	TRISDSET = (1 << 8);
	TRISFSET = (1 << 1);
	
	for(;;) {
		PORTE = sweep;
		
		if(PORTD & (1 << 8)) {
			if((sweep <<= 1) >= 256)
				sweep = 0x1;
		} else {
			if(!(sweep >>= 1))
				sweep = 0x80;
		}
		
		delay((PORTF & (1 << 1)) ? 150000 : 1000000);
	}
	
	return 0;
}

