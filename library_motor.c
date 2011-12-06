//kniznice pre riadeie motorov
//---------------------------------
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
//------------------------------