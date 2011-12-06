
#pragma used+
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSR=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb WDTCR=0x21;
sfrb PLLCSR=0x29;
sfrb OCR1C=0x2b;
sfrb OCR1B=0x2c;
sfrb OCR1A=0x2d;
sfrb TCNT1=0x2e;
sfrb TCCR1B=0x2f;
sfrb TCCR1A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb SP=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_mask=0x18
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x20 & 0xff);

delay_us(10);

ADCSR|=0x40;

while ((ADCSR & 0x10)==0);
ADCSR|=0x10;
return ADCH;
}

void init_attiny26(){

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x8F;

TCCR0=0x00;
TCNT0=0x00;

PLLCSR=0x00;
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1=0x00;
OCR1A=0x00;
OCR1B=0x00;
OCR1C=0x00;

GIMSK=0x00;
MCUCR=0x00;

TIMSK=0x00;

USICR=0x00;

ACSR=0x80;

ADMUX=0x20 & 0xff;
ADCSR=0x81;
}

int bateriamin[4];
int bateriamin_indik[4];
int motorymin;
int kriticalmot;
int cas;
int poc = 0;   
unsigned char mot1x;
unsigned char mot2x;
unsigned char mot3x;
unsigned char mot4x;
int poc1=3;

void main(void)
{

bateriamin[0] = 200;
bateriamin[1] = 200;
bateriamin[2] = 213;
bateriamin[3] = 213;

bateriamin_indik[0] = 220;
bateriamin_indik[1] = 220;
bateriamin_indik[2] = 230;
bateriamin_indik[3] = 230;

cas = 4;          
motorymin = 12;      

init_attiny26();    

while(1){

while (read_adc(0) > motorymin | read_adc(1) > motorymin | 
read_adc(2) > motorymin | read_adc(9) > motorymin){

poc++;
PORTB.1 = 1;
PORTB.2 = 1;
if (poc > cas)
{
PORTB.0 = 0;
delay_ms(70);
}    

delay_us(60);
delay_ms(49); 

}  
poc = 0;    
PORTB.0 = 1;
PORTB.1 = 0;
PORTB.2 = 0;

};

}
