
#pragma used+
sfrb ADCSRB=0x03;
sfrb ADCL=0x04;
sfrb ADCH=0x05;
sfrw ADCW=0x04; 
sfrb ADCSRA=0x06;
sfrb ADMUX=0x07;
sfrb ACSR=0x08;
sfrb USICR=0x0d;
sfrb USISR=0x0e;
sfrb USIDR=0x0f;
sfrb USIBR=0x10;
sfrb GPIOR0=0x11;
sfrb GPIOR1=0x12;
sfrb GPIOR2=0x13;
sfrb DIDR0=0x14;
sfrb PCMSK=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb PRR=0x20;
sfrb WDTCR=0x21;
sfrb DWDR=0x22;
sfrb DTPS=0x23;
sfrb DTVALB=0x24;
sfrb DTVALC=0x25;
sfrb CLKPR=0x26;
sfrb PLLCSR=0x27;
sfrb OCR0B=0x28;
sfrb OCR0A=0x29;
sfrb TCCR0A=0x2a;
sfrb OCR1B=0x2b;
sfrb GTCCR=0x2c;
sfrb OCR1C=0x2d;
sfrb OCR1A=0x2e;
sfrb TCNT1=0x2f;
sfrb TCCR1=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
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

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

void main(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

PORTB=0x00;
DDRB=0x03;

TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

PLLCSR=0x00;
TCCR1=0x00;
GTCCR=0x00;
TCNT1=0x00;
OCR1A=0x00;
OCR1B=0x00;
OCR1C=0x00;

GIMSK=0x00;
MCUCR=0x00;

TIMSK=0x00;

USICR=0x00;

ACSR=0x80;
ADCSRB=0x00;

DIDR0&=0x03;
DIDR0|=0x00;
ADMUX=0x20 & 0xff;
ADCSRA=0x81;
ADCSRB&=0x5F;

while (1)
{
if (read_adc(0) > 171 && read_adc(1) > 171 && read_adc(2) > 171 && read_adc(3) > 171)       
PORTB.0 = 1; 
else
PORTB.0 = 0; 
if (read_adc(0) > 163 && read_adc(1) > 163 && read_adc(2) > 163 && read_adc(3) > 163)
PORTB.1 = 1; 
else
PORTB.1 = 0; 

};
}
