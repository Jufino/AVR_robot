/**************************************
Project : Stavovy procesor
Author  : Juraj Fojtik
Chip type           : ATtiny26L
Clock frequency     : 1,000 MHz
**************************************/
//------------kniznice-------
#include <tiny26.h>
#include <delay.h>
#define ADC_VREF_TYPE 0x20
//---------------------------
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSR|=0x40;
// Wait for the AD conversion to complete
while ((ADCSR & 0x10)==0);
ADCSR|=0x10;
return ADCH;
}
//inicializacia mikroprocesora
void init_attiny26(){
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTB=0x00;
DDRB=0x8F;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFh
// OC1A output: Disconnected
// OC1B output: Disconnected
// Timer 1 Overflow Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
PLLCSR=0x00;
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1=0x00;
OCR1A=0x00;
OCR1B=0x00;
OCR1C=0x00;

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PA3, PA6, PA7 and PB4-7: Off
// Interrupt on any change on pins PB0-3: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
ACSR=0x80;

// ADC initialization
// ADC Clock frequency: 500,000 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSR=0x81;
}
//-----------------------
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
//-----------------------
//Ukazka vstupov a vystupov
/*
********Baterie************
ADC3 <<----- Bat1
ADC4 <<----- Bat2
ADC5 <<----- Bat3
ADC6 <<----- Bat4
********Motory*************
ADC0 <<----- Mot1
ADC1 <<----- Mot2
ADC2 <<----- Mot3
ADC9 <<----- Mot4
*******Vystupy*************
PORTB.2 ------>> LED zelena
PORTB.3 ------>> LED cervena
PORTB.0 ------>> Bateria kriticky stav
PORTB.1 ------>> Motor kriticky stav
***************************
*/
//Definovanie------------
#define Bat1 read_adc(3)
#define Bat2 read_adc(4)
#define Bat3 read_adc(5)
#define Bat4 read_adc(6)
//-----------------------
#define Mot1 read_adc(0)
#define Mot2 read_adc(1)
#define Mot3 read_adc(2)
#define Mot4 read_adc(9)
//-----------------------
#define Led_G PORTB.1
#define Led_R PORTB.2
//-----------------------
#define Batx PORTB.3
#define Motx PORTB.0
//-----------------------
void main(void)
{
//--Kriticke napätie baterii--
bateriamin[0] = 200;
bateriamin[1] = 200;
bateriamin[2] = 213;
bateriamin[3] = 213;
//--Indikovanie stavu baterii--
bateriamin_indik[0] = 220;
bateriamin_indik[1] = 220;
bateriamin_indik[2] = 230;
bateriamin_indik[3] = 230;
//-------------------------
cas = 4;          //cas ktory moze prekrocit prud na motoroch
motorymin = 12;      //prud na motoroch
//-------------------------
init_attiny26();    // inicializacia mikroprocesor
//-----------------------------
//Baterie OK        -   B0 = 1
//Baterie Vyp       -   B0 = 0
//Prud motor Ok     -   B1 = 1
//Prud motor Vyp    -   B1 = 0
//-----------------------------
while(1){
//------------------kriticke stavy-----------------------------------------
/*
        if (Bat1 > bateriamin[0] & Bat2 > bateriamin[1] & 
            Bat3 > bateriamin[2] & Bat4 > bateriamin[3]){
            Batx = 1;    
        }
        else{
            Batx = 0;
        }
        */
/*
if (poc1 == 0){
//------------------indikacia baterie--------------------------------------
        if (Bat1 > bateriamin_indik[0] & Bat2 > bateriamin_indik[1] & 
            Bat3 > bateriamin_indik[2] & Bat4 > bateriamin_indik[3]){
//-----------------------------
            Led_G = 1;    
            Led_R = 0;   
//-----------------------------
        }
        else{
//-----------------------------
            Led_G = 0;   
            Led_R = 1;
//-----------------------------
        } 
        poc1 = 1000;  
}
else
    poc1 = poc1-1;
*/
//Nacitaj stav-----------------  
//------------------Prudove obmedzenie motorov-----------------------------
       while (Mot1 > motorymin | Mot2 > motorymin | 
               Mot3 > motorymin | Mot4 > motorymin){
//--------------------------------
                poc++;
                Led_G = 1;
                Led_R = 1;
                if (poc > cas)
                {
                    Motx = 0;
                    delay_ms(70);
                }    
//Nacitaj stav-----------------------------
                delay_us(60);
                delay_ms(49); 
                         
//-----------------------------------------
            }  
        poc = 0;    //nulovanie pocitadlo
        Motx = 1;
                Led_G = 0;
                Led_R = 0;
//-------------------------------------------------------------------------
      };
//-------------------------------------------------------------------------
}
