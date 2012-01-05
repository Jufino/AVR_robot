#include <string.h>

#define byte_for_dat 1        //2 na bit_for_dat = pocet dat ktore sa daju prenpiest
#define byte_for_char 1        //2 na bit_for_char = pocet znakov v jednotlivych datach
#define char_for_array 10    //pocet znakov pre pole

//funkcia zakoduje data do klastroveho protokolu, data_vystup = tu su zakodovane data, data_vstup=je to 
//vstup vo forme multiarray, size = velkost pola
int zakoduj(char data_vystup[],char data_vstup[][char_for_array],int size){
    int posun = 0;
    int i=0;
    int z=0;
//urcuje pocet dat-----------------------      
    data_vystup[posun] = size&0xFF;
    posun++;
//----------------------------------------
    for(i=0;i < size;i++){
//pocet znakov v nasledujucom data------------------    
        data_vystup[posun] = strlen(data_vstup[i])&0xFF;
        posun++;
//vkladanie data do znakov--------------------------
        for(z=0;z< strlen(data_vstup[i]);z++){
            data_vystup[posun] = data_vstup[i][z];    //vlozi hodnotu znaku
            posun++;
        }
//--------------------------------------------------
    } 
    return posun;   
}
//data_vystup je multiarray = vystupne rozkodovane data
//data_vstup je char = zakodovane data v klastrovom protokole
int dekoduj(char data_vystup[][char_for_array],char data_vstup[]){
    int posun=0;
    int size=0;
    int poc_znakov=0;
    int i=0;
    int z=0;
//nacita pocet dat--------------------
    size=data_vstup[posun];
    posun++;
//------------------------------------
    for(i=0;i < size;i++){
//------------------------------------
        poc_znakov=data_vstup[posun];
        posun++;
//prijma znaky----------------------
        for(z=0;z< poc_znakov;z++){
            data_vystup[i][z] = data_vstup[posun];
            posun++;
        }
//------------------------------------------
    }
    return posun;
}
void odosli_data_beagle(char data[][char_for_array],int pocet_dat){
    char buffer[128];
    zakoduj(buffer,data,pocet_dat);
    puts(buffer);
}
char datax[5][char_for_array];
void prijem_dat(){
//---------------------------
    char str[128];
    scanf ("%s",str);
    dekoduj(datax,str);
}
//------------------------------
//------------------------------