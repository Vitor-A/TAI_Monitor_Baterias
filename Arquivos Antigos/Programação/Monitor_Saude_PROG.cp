#line 1 "C:/Users/Vitor/Desktop/Projeto_Monitor_de_Saúde_Baterias/Programação/Monitor_Saude_PROG.c"




sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB7_bit;
sbit LCD_D5 at RB6_bit;
sbit LCD_D6 at RB5_bit;
sbit LCD_D7 at RB4_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB7_bit;
sbit LCD_D5_Direction at TRISB6_bit;
sbit LCD_D6_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB4_bit;




 char txt[15],flag = 0x00,k = 0;
 char vetor[20],aux_1 = 0x00,vetor_2[60],x[2],j=0x00;
 int dx = 0x00,media = 0x00, old=0x00;
 unsigned int provisorio = 0x00;
 unsigned char i = 0x00;




void Interrupt(){

 if(ADIF_bit){

 ADIF_bit = 0x00;

 if(aux_1 == 0x01){

 vetor[k] = ADRESH;
 k++;
 RC0_bit = ! RC0_bit;
 }

 if(aux_1 == 0x02){

 x[k]= ADRESH;
 k++;
 if(k == 0x02) k = 0x00;
 RC0_bit = ! RC0_bit;

 }

 if(aux_1 == 0x03){

 vetor_2[k] = ADRESH;
 k++;
 RC0_bit = ! RC0_bit;


 }

 }

 if(INTF_bit){

 INTF_bit = 0x00;
 TMR0IE_bit = 0x01;
 Go_bit = 0x01;
 INTE_bit = 0x00;
 aux_1 = 0x01;
 delay_us(20);

 }

 if(TMR0IF_bit){

 TMR0IF_bit = 0x00;
 if(aux_1 < 3)TMR0 = 0x56;
 if(aux_1 == 3)TMR0 = 0x10;

 if(k<60){

 Go_bit = 0x01;
 delay_us(20);

 }

 if(aux_1 == 2){

 if(k == 0x00){

 old = media;
 dx = (x[1] - x[0]);
 media = (dx*2 + media*8);

 if(media<0){

 aux_1 = 0x03;
 k = 0x00;
 Go_bit = 0x01;
 delay_us(20);
 RC1_bit = 0x01;

 }

 }

 }

 if(k == 20 && aux_1 == 0x01){

 aux_1 = 0x02;
 k = 0x00;
 delay_ms(150);
 Go_bit = 0x01;
 delay_us(20);

 }

 if(k == 60 && aux_1 == 0x03){

 flag = 0x01;
 TMR0IE_bit = 0x00;
 ADIE_bit = 0x00;
 ADON_bit = 0x00;

 }
 }
}

void main() {



 CMCON = 0x07;
 ADCON0 = 0x01;
 ADCON1 = 0x0E;

 INTCON = 0xF0;
 OPTION_REG = 0x83;
 ADIE_bit = 0x01;
 TMR0 = 0x56;
 TMR0IE_bit = 0x00;

 TRISA = 0xFF;
 TRISB = 0xFF;
 TRISC = 0xF0;
 TRISD = 0xFF;

 PORTC = 0x00;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Aguardando...");

 while(1){


 if(flag == 0x01){

 aux_1 = vetor[0];

 for(i=0;i<20;i++){

 if(vetor[i]<aux_1) aux_1 = vetor[i];

 }

 provisorio = (aux_1 *15)/2.55;
 IntToStr(provisorio,txt);
 Lcd_Out(1,10,txt);

 aux_1 = vetor_2[0];

 for(i=0;i<60;i++){

 if(vetor_2[i]<aux_1) aux_1 = vetor_2[i];

 }

 Lcd_Out(1,1,"V1       ");
 Lcd_Out(2,1,"V2");

 provisorio = (aux_1 *15)/2.55;
 IntToStr(provisorio,txt);
 Lcd_Out(2,10,txt);

 }

 }

}
