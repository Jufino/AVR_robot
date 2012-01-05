
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADCSR=6;     
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=3
   .equ __scl_bit=2
#endasm

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

#pragma used+
void i2c_init(void);
unsigned char i2c_start(void);
void i2c_stop(void);
unsigned char i2c_read(unsigned char ack);
unsigned char i2c_write(unsigned char data);
#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
char *strtok(char *str1,char flash *str2);

unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x60 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
} 

unsigned char maxh;
unsigned char inrange(unsigned char a, unsigned char b, unsigned char range){
if (a <= b && b <= (a+range))
return 1; 
if (b <= a && a <= (b+range))
return 1;
else
return 0;
}
unsigned char maxx(unsigned char maxvid){
unsigned char sens = 17;
unsigned char s[8];
unsigned char rozptyl = 8;
maxh = 255;
s[0] = read_adc(7);
if (s[0] < maxvid ){
if (s[0] <= maxh){
sens = 1;
maxh = s[0];
}
}    
s[1] = read_adc(6);
if (s[1] < maxvid ){
if (s[1] <= maxh){
sens = 3;
maxh = s[1];
}
}  
s[2] = read_adc(5);
if (s[2] < maxvid ){
if (s[2] < maxh){
sens = 5;
maxh = s[2];
}
}  
s[3] = read_adc(4);
if (s[3] < maxvid ){
if (s[3] <= maxh){
sens = 7;
maxh = s[3];
}
}  
s[4] = read_adc(0);
if (s[4] < maxvid ){
if (s[4] <= maxh){
sens = 9;
maxh = s[4];
}
}  
s[5] = read_adc(1);
if (s[5] < maxvid ){
if (s[5] <= maxh){
sens = 11;
maxh = s[5];
}
}  
s[6] = read_adc(2);
if (s[6] < maxvid ){
if (s[6] <= maxh){
sens = 13;
maxh = s[6];
}
}  
s[7] = read_adc(3);
if (s[7] < maxvid ){
if (s[7] <= maxh){
sens = 15;
maxh = s[7];
}
}  
if (sens == 1){
if (inrange(s[0],s[1],rozptyl) == 1)
sens = 2;                       
else if(inrange(s[7],s[0],rozptyl) == 1)
sens = 16;                              
}
else if (sens == 3){
if (inrange(s[1],s[2],rozptyl) == 1) 
sens = 4;                          
else if(inrange(s[0],s[1],rozptyl) == 1)
sens = 2;                             
}
else if (sens == 5){
if (inrange(s[2],s[3],rozptyl) == 1)
sens = 6;                          
else if(inrange(s[1],s[2],rozptyl) == 1)
sens = 4;                               
}
else if (sens == 7){
if (inrange(s[3],s[4],rozptyl) == 1)
sens = 8;                         
else if(inrange(s[2],s[3],rozptyl) == 1)
sens = 6;                               
}
else if (sens == 9){
if (inrange(s[4],s[5],rozptyl) == 1)     
sens = 10;                               
else if(inrange(s[3],s[4],rozptyl) == 1)  
sens = 8;                                  
}
else if (sens == 11){
if (inrange(s[5],s[6],rozptyl) == 1)          
sens = 12;                                   
else if(inrange(s[4],s[5],rozptyl) == 1)       
sens = 10;                                      
}
else if (sens == 13){
if (inrange(s[6],s[7],rozptyl) == 1)             
sens = 14;                                       
else if(inrange(s[5],s[6],rozptyl) == 1)          
sens = 12;                                          
}
else if (sens == 15){
if (inrange(s[7],s[0],rozptyl) == 1)                  
sens = 16;                                           
else if(inrange(s[6],s[7],rozptyl) == 1)               
sens = 14;                                             
}
return sens;
}                                                             

unsigned char compass_2(){
unsigned char value;
i2c_start();
i2c_write(0xC0);
i2c_write(1);
i2c_start();
i2c_write(0xC1);
value = i2c_read(0);
i2c_stop();
return value;
}

void cmps03_scanmode(unsigned char mode){
i2c_start();
i2c_write(0xC0);
i2c_write(0x12);
i2c_write(0x55);
i2c_write(0x5A);
i2c_write(0xA5);
i2c_write(0x09 + mode);
i2c_stop();
}
void cmps03_reset(void){
i2c_start();
i2c_write(0xC0);
i2c_write(0x12);
i2c_write(0x55);
i2c_write(0x5A);
i2c_write(0xA5);
i2c_write(0xF2);
i2c_stop();
}
int cmps03_read(unsigned char mode){
unsigned char a,b;
if (mode==1){
i2c_start();
i2c_write(0xC0);
i2c_write(0x01);
i2c_start();
i2c_write(0xC1);
a = i2c_read(0);
i2c_stop();
return a;
}
else if(mode==2){
i2c_start();
i2c_write(0xC0);
i2c_write(0x02);
i2c_start();
i2c_write(0xC1);
a = i2c_read(1);
b = i2c_read(0);
i2c_stop();
return (a * 256 + b);
}
else{
return -1;
}
}
int prepocetcompasu(int stupen, unsigned char mode){
int prepocet;    
if (mode == 1){
prepocet = cmps03_read(1) - stupen;
if (prepocet >= 255){
prepocet = prepocet - 255;
}
if (prepocet < 0){
prepocet = prepocet + 255;
}
}   
else {      
prepocet = cmps03_read(2) - stupen;
if (prepocet > 3599){
prepocet = prepocet - 3599;
}
if (prepocet < 0){
prepocet = prepocet + 3599;
}
}

return prepocet;
}

int ult_lavy()
{
char ulth[3];
int vysl;
nastav_9600();
PORTC.5 = 1 ;
delay_ms(10); 
while(getchar() != 0x52);
ulth[0] = getchar();
ulth[1] = getchar();
ulth[2] = getchar();
PORTC.5 = 0 ;
vysl = atoi(ulth); 
nastav_115200(); 
delay_ms(5); 
return vysl;
}
int ult_zadny()
{
char ulth[3];
int vysl;
nastav_9600();
PORTC.7 = 1 ;
delay_ms(10); 
while(getchar() != 0x52);
ulth[0] = getchar();
ulth[1] = getchar();
ulth[2] = getchar();
PORTC.7 = 0 ;
vysl = atoi(ulth); 
nastav_115200();     
delay_ms(5);
return vysl;
}

int zakoduj(char data_vystup[],char data_vstup[][10    ],int size){
int posun = 0;
int i=0;
int z=0;

data_vystup[posun] = size&0xFF;
posun++;

for(i=0;i < size;i++){

data_vystup[posun] = strlen(data_vstup[i])&0xFF;
posun++;

for(z=0;z< strlen(data_vstup[i]);z++){
data_vystup[posun] = data_vstup[i][z];    
posun++;
}

} 
return posun;   
}

int dekoduj(char data_vystup[][10    ],char data_vstup[]){
int posun=0;
int size=0;
int poc_znakov=0;
int i=0;
int z=0;

size=data_vstup[posun];
posun++;

for(i=0;i < size;i++){

poc_znakov=data_vstup[posun];
posun++;

for(z=0;z< poc_znakov;z++){
data_vystup[i][z] = data_vstup[posun];
posun++;
}

}
return posun;
}
void odosli_data_beagle(char data[][10    ],int pocet_dat){
char buffer[128];
zakoduj(buffer,data,pocet_dat);
puts(buffer);
}
char datax[5][10    ];
void prijem_dat(){

char str[128];
scanf ("%s",str);
dekoduj(datax,str);
}

void motor1(int rychlost ){
if (rychlost > 0){
PORTC.3 = 1;
PORTC.4 = 0;
}
else if(rychlost == 0){
PORTC.3 = 0;
PORTC.4 = 0;    
}
else{
PORTC.3 = 0;
PORTC.4 = 1; 
rychlost = rychlost*(-1);         
}
OCR1B = rychlost;
}
void motor3(int rychlost){
if (rychlost > 0){
PORTC.2 = 0;
PORTD.6 = 1;
}
else if(rychlost == 0){
PORTC.2 = 0;
PORTD.6 = 0;  
}
else{
PORTC.2 = 1;
PORTD.6 = 0;
rychlost = rychlost*(-1);         
}
OCR1A = rychlost;
}
void motor2(int rychlost){
if (rychlost > 0){
PORTC.1 = 1;
PORTC.0 = 0;
}
else if(rychlost == 0){
PORTC.1 = 0;
PORTC.0 = 0;  
}
else{
PORTC.1 = 0;
PORTC.0 = 1;
rychlost = rychlost*(-1);         
}
OCR2 = rychlost;
}
void motor4(int rychlost){
if (rychlost > 0){
PORTB.1 = 0;
PORTB.2 = 1;
}
else if(rychlost == 0){
PORTB.1 = 0;
PORTB.2 = 0; 
}
else{
PORTB.1 = 1;
PORTB.2 = 0;
rychlost = rychlost*(-1);         
}
OCR0 = rychlost;
}
void m_0(unsigned char rychlost){
motor1(-rychlost);
motor2(-rychlost);
motor3(rychlost);
motor4(rychlost);
}
void m_45(unsigned char rychlost){
motor1(0);
motor2(-rychlost);
motor3(0);
motor4(rychlost);
}
void m_90(unsigned char rychlost){
motor1(rychlost);
motor2(-rychlost);
motor3(-rychlost);
motor4(rychlost);
}
void m_135(unsigned char rychlost){
motor1(rychlost);
motor2(0);
motor3(-rychlost);
motor4(0);
}
void m_180(unsigned char rychlost){
motor1(rychlost);
motor2(rychlost);
motor3(-rychlost);
motor4(-rychlost);
}
void m_225(unsigned char rychlost){
motor1(0);
motor2(rychlost);
motor3(0);
motor4(-rychlost);
}
void m_270(unsigned char rychlost){
motor1(-rychlost);
motor2(rychlost);
motor3(rychlost);
motor4(-rychlost);
}
void m_315(unsigned char rychlost){
motor1(-rychlost);
motor2(0);
motor3(rychlost);
motor4(0);
}
void m_ot(int rychlost){
motor1(rychlost);
motor2(rychlost/3);
motor3(rychlost/3);
motor4(rychlost);
}
void m_vyp(){
motor1(0);
motor2(0);
motor3(0);
motor4(0);
}

eeprom int branka=0;
unsigned char rychlost_presunu = 210;
unsigned char rychlost_presunu_zrychlene = 210;
unsigned char rychlost_presunu_vzad = 200;
unsigned char prog=0;
unsigned char smer=0;
unsigned int x1;
unsigned char rychlost=200;
unsigned char rychl;

void init_8535(){

PORTA=0x00;
DDRA=0x00;

PORTB=0x20;
DDRB=0x1F;

PORTC=0x00;
DDRC=0xFF;

PORTD=0x00;
DDRD=0xF0;

TCCR0=0x6A;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x6A;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x00;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x05;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x60 & 0xff;
ADCSRA=0x84;
SFIOR&=0xEF;
SFIOR|=0x10;

i2c_init();
}

void kick(){
int senzory;
if (PINB.5                      == 0){
m_vyp();
PORTB.0                     = 1;
PORTB.4 = 0;
delay_ms(200);
while (PINB.5                      == 0);
PORTB.0                     = 0;
PORTB.4 = 1;
x1 = 400;
while(x1 != 0 ){
senzory = maxx(200);
if (maxh < 75){
switch (senzory){
case 1: m_0(rychlost_presunu);          break;

case 2: m_90(rychlost_presunu);              break;       
case 3: m_135(rychlost_presunu);                 break;
case 4: m_135(rychlost_presunu);                 break;  
case 5: m_180(rychlost_presunu);                 break;  

case 6: m_225(rychlost_presunu);                 break;
case 7: m_225(rychlost_presunu);                break;
case 8: m_270(rychlost_presunu);                 break;
case 9: m_270(rychlost_presunu);                 break;  

case 10: m_90(rychlost_presunu);               break;
case 11: m_135(rychlost_presunu);                break;
case 12: m_135(rychlost_presunu);                break;
case 13: m_180(rychlost_presunu);                 break;  

case 14: m_225(rychlost_presunu);                break;
case 15: m_225(rychlost_presunu);                break;
case 16: m_270(rychlost_presunu);             break;  

case 17: m_vyp();                                break;    
}
}
else{
switch (senzory){
case 1: m_0(rychlost_presunu);        break;

case 2: m_90(rychlost_presunu);              break;       
case 3: m_90(rychlost_presunu);                 break;
case 4: m_90(rychlost_presunu);                 break;  
case 5: m_90(rychlost_presunu);                 break;  

case 6: m_135(rychlost_presunu);                 break;
case 7: m_135(rychlost_presunu);                break;
case 8: m_135(rychlost_presunu);                 break;
case 9: m_180(rychlost_presunu);                 break;  

case 10: m_225(rychlost_presunu);               break;
case 11: m_225(rychlost_presunu);                break;
case 12: m_225(rychlost_presunu);                break;
case 13: m_270(rychlost_presunu);                 break;  

case 14: m_315(rychlost_presunu);                break;
case 15: m_315(rychlost_presunu);                break;
case 16: m_315(rychlost_presunu);             break;  

case 17: m_vyp();                                break;    
}
}
x1--;
delay_ms(2);
}
}
else{
PORTB.0                     = 0;
}
}
void kick_no(){
PORTB.0                     = 1;
PORTB.4 = 0;
delay_ms(200);
while (PINB.5                      == 0);
PORTB.0                     = 0;
PORTB.4 = 1;
}

int nastav_podla_kompasu(int kompas){             
int komp_ret = 0;
if (kompas > 180)
kompas = 180;

if (kompas < 90){
rychl = kompas + 100;
}
else{
rychl = (180 - kompas) + 100;       
}

if (kompas <= 10){
PORTB.4 = 1;
komp_ret = 1;      
}
else{
if( kompas <= 90){
PORTB.4 = 0;
m_ot(-rychl);
}
else{
if (kompas <= 170){
PORTB.4 = 0;
m_ot(rychl);
}
else {
PORTB.4 = 1;
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

case 2: m_90(rychlost_presunu-10);              break;       
case 3: m_135(rychlost_presunu);                break;
case 4: m_135(rychlost_presunu);                break;  
case 5: m_180(rychlost_presunu);                break;

case 6: m_225(rychlost_presunu_vzad);           break;
case 7: m_225(rychlost_presunu_vzad);           break;
case 8: m_270(rychlost_presunu_vzad);           break;
case 9: m_270(rychlost_presunu_vzad);           break;
case 10: m_90(rychlost_presunu_vzad);           break;
case 11: m_135(rychlost_presunu_vzad);          break;
case 12: m_135(rychlost_presunu_vzad);          break;

case 13: m_180(rychlost_presunu);               break;
case 14: m_225(rychlost_presunu);               break;
case 15: m_225(rychlost_presunu);               break;
case 16: m_270(rychlost_presunu-10);            break;

case 17: m_vyp();                               break;    
}
}
else{
switch (senzory){
case 1: m_0(rychlost_presunu_zrychlene);         break;

case 2: m_45(rychlost_presunu_zrychlene);                 break;       
case 3: m_45(rychlost_presunu_zrychlene);                 break;
case 4: m_90(rychlost_presunu_zrychlene);                 break;  
case 5: m_90(rychlost_presunu_zrychlene);                 break;

case 6: m_135(rychlost_presunu);                     break;
case 7: m_135(rychlost_presunu);                     break;
case 8: m_135(rychlost_presunu);                          break;
case 9: m_180(rychlost_presunu);                          break;
case 10: m_225(rychlost_presunu);                         break;
case 11: m_225(rychlost_presunu);                         break;
case 12: m_225(rychlost_presunu);                         break;

case 13: m_270(rychlost_presunu_zrychlene);               break;
case 14: m_270(rychlost_presunu_zrychlene);               break;
case 15: m_315(rychlost_presunu_zrychlene);               break;
case 16: m_315(rychlost_presunu_zrychlene);               break;

case 17: m_vyp();                                         break;
}
}
}

void odosli_dataPC(){

char str[20];
scanf ("%s",str);

if (strcmpf(str,"data") == 0){
char data[12];
data[0] = read_adc(7);
data[1] = read_adc(6); 
data[2] = read_adc(5);
data[3] = read_adc(4);
data[4] = read_adc(0);
data[5] = read_adc(1);
data[6] = read_adc(2);
data[7] = read_adc(3);
data[8] = maxx(200);
data[9] = (int)(prepocetcompasu(branka,1)*0.71);
data[10] = PINB.5                     ;
puts(data);   
}           
else if (strcmpf(str,"kick") == 0)     kick_no();
else if (strcmpf(str,"LED0") == 0)     PORTB.4 = 1;
else if (strcmpf(str,"LED1") == 0)     PORTB.4 = 0;
else if (strcmpf(str,"blik") == 0)    {
int pocet;
char str1[20];
scanf ("%s",str1);
for(pocet = atoi(str1);pocet!=0;pocet--){    
PORTB.4 = 0;
delay_ms(500);
PORTB.4 = 1;
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

void kalibracia_kompas(unsigned char mode){
int kompas;
if (mode == 1){
if (PINB.5                      == 0){                                   
while (PINB.5                      == 0){
delay_ms(20);
branka = cmps03_read(1);
}
while(1){                                                                                          
kompas = prepocetcompasu(branka,1)*0.71;
if (kompas > 180)
kompas = 180;
if (kompas < 20){
PORTB.4 = 0;
}
else{
if( kompas < 90){
PORTB.4 = 1;
}
else
{
if (kompas < 160){
PORTB.4 = 1;
}
else {
PORTB.4 = 0;
}
}
}
}
}
}                                                                             
else{
while (PINB.5                      == 0){
branka = cmps03_read(2);
delay_ms(10);
}
delay_ms(1000);
while(1){
kompas = prepocetcompasu(branka,2);
if (kompas < 200){
PORTB.4 = 0;
}
else{
if( kompas < 1800){
PORTB.4 = 1;
}
else
{
if (kompas < 3400){
PORTB.4 = 1;
}
else {
PORTB.4 = 0;
}
}
}  
}    
}
}

void main(void)
{
init_8535();

prog = 1;

cmps03_reset();
cmps03_scanmode(3);

delay_ms(200);
kalibracia_kompas(1);

testmotor:                     
while(1){

odosli_dataPC();

goto testmotor;
goto zaciatok;
}

zaciatok:
while (1){
if (0 != nastav_podla_kompasu((int)(prepocetcompasu(branka,1)*0.71))){
obchadzanie(maxx(200));    
}
delay_ms(30);
};

}
