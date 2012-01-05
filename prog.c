/*****************************************************
Project : Robot_sutaz Istambul
Version : V1.2
Date    : 21. 5. 2011
Author  : Juraj Fojtik
Company : PrianicSlovakia

Chip type           : ATmega8535
Program type        : Application
Clock frequency     : 11,059200 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 128
*****************************************************/
#include <mega32.h>

// I2C Bus function
#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=3
   .equ __scl_bit=2
#endasm

//---------------------------------
//zmena rychlosti Uart
//---------------------------------
void nastav_9600(){
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x47;
}
void nastav_115200(){
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x05;
}
//---------------------------------
//--------------------------------
// Kniznice
//--------------------------------
#include <i2c.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <string.h>
#define ADC_VREF_TYPE 0x60
#include "library_snimace.c"
#include "protocol.c"
#include "library_motor.c"
//--------------------------------
//Definovanie
//--------------------------------
#define LED         PORTB.4
#define Kick        PORTB.0                    //kicker riadeni
//---------------------------------
// Premenne
//---------------------------------
eeprom int branka=0;
unsigned char rychlost_presunu = 210;
unsigned char rychlost_presunu_zrychlene = 210;
unsigned char rychlost_presunu_vzad = 200;
unsigned char prog=0;
unsigned char smer=0;
unsigned int x1;
unsigned char rychlost=200;
unsigned char rychl;
//---------------------------------
//inicializacia procesoru
//---------------------------------
void init_8535(){
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x20;
DDRB=0x1F;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xF0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1382,400 kHz
// Mode: Fast PWM top=FFh
// OC0 output: Non-Inverted PWM
TCCR0=0x6A;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1382,400 kHz
// Mode: Fast PWM top=00FFh
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x0A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 1382,400 kHz
// Mode: Fast PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x6A;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x05;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691,200 kHz
// ADC Voltage Reference: AVCC pin
// ADC High Speed Mode: On
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;
SFIOR&=0xEF;
SFIOR|=0x10;
                           
// I2C Bus initialization
i2c_init();
}
//---------------------------------
//------------------------------
//kicker
//------------------------------
void kick(){
    int senzory;
    if (Kick_sens == 0){
    m_vyp();
    Kick = 1;
    LED = 0;
    delay_ms(200);
    while (Kick_sens == 0);
    Kick = 0;
    LED = 1;
    x1 = 400;
    while(x1 != 0 ){
        senzory = maxx(200);
        if (maxh < 75){
        switch (senzory){
            case 1: m_0(rychlost_presunu);          break;
    //---------------------------------------------------------------------
            case 2: m_90(rychlost_presunu);              break;       
            case 3: m_135(rychlost_presunu);                 break;
            case 4: m_135(rychlost_presunu);                 break;  
            case 5: m_180(rychlost_presunu);                 break;  //stvrtina z kruhu
    //---------------------------------------------------------------------
            case 6: m_225(rychlost_presunu);                 break;
            case 7: m_225(rychlost_presunu);                break;
            case 8: m_270(rychlost_presunu);                 break;
            case 9: m_270(rychlost_presunu);                 break;  //polovica kruhu
    //----------------------------------------------------------------------
            case 10: m_90(rychlost_presunu);               break;
            case 11: m_135(rychlost_presunu);                break;
            case 12: m_135(rychlost_presunu);                break;
            case 13: m_180(rychlost_presunu);                 break;  //tretina kruhu
    //----------------------------------------------------------------------
            case 14: m_225(rychlost_presunu);                break;
            case 15: m_225(rychlost_presunu);                break;
            case 16: m_270(rychlost_presunu);             break;  //cely kruh
    //----------------------------------------------------------------------
            case 17: m_vyp();                                break;    
        }
    }
        else{
       switch (senzory){
            case 1: m_0(rychlost_presunu);        break;
    //---------------------------------------------------------------------
            case 2: m_90(rychlost_presunu);              break;       
            case 3: m_90(rychlost_presunu);                 break;
            case 4: m_90(rychlost_presunu);                 break;  
            case 5: m_90(rychlost_presunu);                 break;  //stvrtina z kruhu
    //---------------------------------------------------------------------
            case 6: m_135(rychlost_presunu);                 break;
            case 7: m_135(rychlost_presunu);                break;
            case 8: m_135(rychlost_presunu);                 break;
            case 9: m_180(rychlost_presunu);                 break;  //polovica kruhu
    //----------------------------------------------------------------------
            case 10: m_225(rychlost_presunu);               break;
            case 11: m_225(rychlost_presunu);                break;
            case 12: m_225(rychlost_presunu);                break;
            case 13: m_270(rychlost_presunu);                 break;  //tretina kruhu
    //----------------------------------------------------------------------
            case 14: m_315(rychlost_presunu);                break;
            case 15: m_315(rychlost_presunu);                break;
            case 16: m_315(rychlost_presunu);             break;  //cely kruh
    //----------------------------------------------------------------------
            case 17: m_vyp();                                break;    
        }
    }
        x1--;
        delay_ms(2);
        }
    }
    else{
    Kick = 0;
}
}
void kick_no(){
    Kick = 1;
    LED = 0;
    delay_ms(200);
    while (Kick_sens == 0);
    Kick = 0;
    LED = 1;
}
//------------------------------
//------------------------------
int nastav_podla_kompasu(int kompas){             //prepocetcompasu(branka,1)*0.71
    int komp_ret = 0;
    if (kompas > 180)
        kompas = 180;
    //prepocet rychlost kolies pre kompas------------------
    if (kompas < 90){
        rychl = kompas + 100;
    }
    else{
        rychl = (180 - kompas) + 100;       
    }
    //------------------------------------------------------
    if (kompas <= 10){
        LED = 1;
        komp_ret = 1;      
    }
    else{
        if( kompas <= 90){
            LED = 0;
            m_ot(-rychl);
        }
        else{
            if (kompas <= 170){
                LED = 0;
                m_ot(rychl);
            }
            else {
                LED = 1;
                komp_ret = 1;
            }
        }
    }
    return komp_ret;
}
void obchadzanie(int senzory){  
    if (maxh < 80){
            switch (senzory){
                case 1: m_0(rychlost_presunu);          break;
        //---------------------------------------------------------------------
                case 2: m_90(rychlost_presunu-10);              break;       
                case 3: m_135(rychlost_presunu);                break;
                case 4: m_135(rychlost_presunu);                break;  
                case 5: m_180(rychlost_presunu);                break;
        //---------------------------------------------------------------------
                case 6: m_225(rychlost_presunu_vzad);           break;
                case 7: m_225(rychlost_presunu_vzad);           break;
                case 8: m_270(rychlost_presunu_vzad);           break;
                case 9: m_270(rychlost_presunu_vzad);           break;
                case 10: m_90(rychlost_presunu_vzad);           break;
                case 11: m_135(rychlost_presunu_vzad);          break;
                case 12: m_135(rychlost_presunu_vzad);          break;
        //----------------------------------------------------------------------
                case 13: m_180(rychlost_presunu);               break;
                case 14: m_225(rychlost_presunu);               break;
                case 15: m_225(rychlost_presunu);               break;
                case 16: m_270(rychlost_presunu-10);            break;
        //----------------------------------------------------------------------
                case 17: m_vyp();                               break;    
            }
       }
    else{
           switch (senzory){
                case 1: m_0(rychlost_presunu_zrychlene);         break;
        //---------------------------------------------------------------------
                case 2: m_45(rychlost_presunu_zrychlene);                 break;       
                case 3: m_45(rychlost_presunu_zrychlene);                 break;
                case 4: m_90(rychlost_presunu_zrychlene);                 break;  
                case 5: m_90(rychlost_presunu_zrychlene);                 break;
        //---------------------------------------------------------------------
                case 6: m_135(rychlost_presunu);                     break;
                case 7: m_135(rychlost_presunu);                     break;
                case 8: m_135(rychlost_presunu);                          break;
                case 9: m_180(rychlost_presunu);                          break;
                case 10: m_225(rychlost_presunu);                         break;
                case 11: m_225(rychlost_presunu);                         break;
                case 12: m_225(rychlost_presunu);                         break;
        //----------------------------------------------------------------------
                case 13: m_270(rychlost_presunu_zrychlene);               break;
                case 14: m_270(rychlost_presunu_zrychlene);               break;
                case 15: m_315(rychlost_presunu_zrychlene);               break;
                case 16: m_315(rychlost_presunu_zrychlene);               break;
        //----------------------------------------------------------------------
                case 17: m_vyp();                                         break;
        }
    }
}
//------------------------------ 
//------------------------------
//odosielanie do PC
//------------------------------
void odosli_dataPC(){
//--prijem_dat------------------------
    char str[20];
    scanf ("%s",str);
//------------------------------------
//spracovanie dat---------------------
//------------------------------------ 
    if (strcmpf(str,"data") == 0){
        char data[12];
        data[0] = Senzor_1;
        data[1] = Senzor_2; 
        data[2] = Senzor_3;
        data[3] = Senzor_4;
        data[4] = Senzor_5;
        data[5] = Senzor_6;
        data[6] = Senzor_7;
        data[7] = Senzor_8;
        data[8] = maxx(200);
        data[9] = (int)(prepocetcompasu(branka,1)*0.71);
        data[10] = Kick_sens;
        puts(data);   
        }           
    else if (strcmpf(str,"kick") == 0)     kick_no();
    else if (strcmpf(str,"LED0") == 0)     LED = 1;
    else if (strcmpf(str,"LED1") == 0)     LED = 0;
    else if (strcmpf(str,"blik") == 0)    {
        int pocet;
        char str1[20];
        scanf ("%s",str1);
        for(pocet = atoi(str1);pocet!=0;pocet--){    
            LED = 0;
            delay_ms(500);
            LED = 1;
            delay_ms(500);
            }
    }
    else if (strcmpf(str,"smer") == 0)    {
        char str1[20];
        scanf ("%s",str1);
        smer = atoi(str1); 
        switch(smer){
            case 0:
                m_vyp();
                break;
            case 1:
                m_0(rychlost);
                break;
            case 2:
                m_45(rychlost);
                break;
            case 3:
                m_90(rychlost);
                break;
            case 4:
                m_135(rychlost);
                break;
            case 5:
                m_180(rychlost);
                break;
            case 6:
                m_225(rychlost);
                break;
            case 7:
                m_270(rychlost);
                break;
            case 8:
                m_315(rychlost);
                break;
            case 10:
                m_ot(170);
                break;
            case 9:
                m_ot(-170);
                break;
            } 
        }  
    else if (strcmpf(str,"rych") == 0)    {
        char str1[20];
        scanf ("%s",str1);
        rychlost = atoi(str1);
        switch(smer){
            case 0:
                m_vyp();
                break;
            case 1:
                m_0(rychlost);
                break;
            case 2:
                m_45(rychlost);
                break;
            case 3:
                m_90(rychlost);
                break;
            case 4:
                m_135(rychlost);
                break;
            case 5:
                m_180(rychlost);
                break;
            case 6:
                m_225(rychlost);
                break;
            case 7:
                m_270(rychlost);
                break;
            case 8:
                m_315(rychlost);
                break;
            case 10:
                m_ot(170);
                break;
            case 9:
                m_ot(-170);
                break;
            } 
        }                    
    }  
//---------------------------------                                     
void kalibracia_kompas(unsigned char mode){
    int kompas;
    if (mode == 1){
        if (Kick_sens == 0){                                   
        while (Kick_sens == 0){
            delay_ms(20);
            branka = cmps03_read(1);
                    }
        while(1){                                                                                          
            kompas = prepocetcompasu(branka,1)*0.71;
            if (kompas > 180)
                kompas = 180;
            if (kompas < 20){
                LED = 0;
            }
            else{
                if( kompas < 90){
                    LED = 1;
                }
                else
                {
                    if (kompas < 160){
                        LED = 1;
                    }
                    else {
                        LED = 0;
                        }
                }
            }
        }
        }
        }                                                                             
    else{
         while (Kick_sens == 0){
                    branka = cmps03_read(2);
                    delay_ms(10);
                            }
         delay_ms(1000);
         while(1){
                    kompas = prepocetcompasu(branka,2);
                    if (kompas < 200){
                        LED = 0;
                    }
                    else{
                        if( kompas < 1800){
                            LED = 1;
                        }
                        else
                        {
                            if (kompas < 3400){
                                LED = 1;
                            }
                            else {
                                LED = 0;
                                }
                        }
                    }  
                }    
    }
}
//--------------------------------------------------
void main(void)
{
init_8535();
// pre odosielanie do pc nastav 1
prog = 1;
//kompas reset, nastavenie rychlosti na 33ms
cmps03_reset();
cmps03_scanmode(3);
//-----------------------------------
delay_ms(200);
kalibracia_kompas(1);
//----------------------------------- 
testmotor:                     
    while(1){
    /*
        if (Mot_sens == 1)  {
          goto zaciatok;
        }
        else{
            switch (senzory){
                case 1:     goto zaciatok;                  break;
        //---------------------------------------------------------------------
                case 2:     m_0(255);          break;       
                case 3:     m_0(255);          break;
                case 4:     m_45(255);          break;  
                case 5:     m_45(255);         break;
        //---------------------------------------------------------------------
                case 6:     m_vyp();                        break;
                case 7:     m_vyp();                        break;
                case 8:     m_vyp();                        break;
                case 9:     m_vyp();                        break;
                case 10:    m_vyp();                        break;
                case 11:    m_vyp();                        break;
                case 12:    m_vyp();                        break;
        //----------------------------------------------------------------------
                case 13:    m_315(255);        break;
                case 14:    m_315(255);          break;
                case 15:    m_0(255);          break;
                case 16:    m_0(255);          break;
        //----------------------------------------------------------------------
                case 17:    m_vyp();                        break;   
            }
            if (senzory != 1){
                delay_ms(400);
            }
        }
        */
//        while(1){
          odosli_dataPC();
    //    }
goto testmotor;
goto zaciatok;
}
//-----------------------------------
zaciatok:
    while (1){
        if (0 != nastav_podla_kompasu((int)(prepocetcompasu(branka,1)*0.71))){
            obchadzanie(maxx(200));    
        }
        delay_ms(30);
};
//-----------------------------------
}
