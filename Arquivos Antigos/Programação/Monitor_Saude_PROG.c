// Monitoramento de Bateria Veicular
// TAI

 // LCD module connections
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
// End LCD module connections

//Declaração de Variáveis

 char txt[15],flag = 0x00,k = 0;
 char vetor[20],aux_1 = 0x00,vetor_2[60],x[2],j=0x00;
 int dx = 0x00,media = 0x00, old=0x00;
 unsigned int provisorio = 0x00;
 unsigned char i = 0x00;

 //Fim Declaração de Variáveis


void Interrupt(){                                           // Função responsável pelo tratamento das Interrupções

  if(ADIF_bit){                                             // Houve Interrupção do conversor AD?

    ADIF_bit = 0x00;                                        // Se sim, limpa flag de indicação da interrupção do AD

     if(aux_1 == 0x01){                                     // Amostra primeiro ponto de mínimo da FDO

      vetor[k] = ADRESH;                                    // Guarda o valor de 8bits lido pelo conversor AD
      k++;                                                  // Incrementa posição do vetor de aquisição de V1
      RC0_bit = ! RC0_bit;
    }

    if(aux_1 == 0x02){                                      // Procura indícios do segundo ponto de mínimo da FDO (V2)

      x[k]= ADRESH;                                         // Guarda o valor de 8bits lido pelo conversor AD
      k++;                                                  // Incrementa posição do vetor para encontrar V2
      if(k == 0x02) k = 0x00;                               // Limita a variável k em 0 e 1
      RC0_bit = ! RC0_bit;

    }

    if(aux_1 == 0x03){                                      // Amostra segundo ponto de mínimo da FDO V2

      vetor_2[k] = ADRESH;                                  // Guarda o valor de 8bits lido pelo conversor AD
      k++;                                                  // Incrementa posição de aquisição de V2
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
     if(aux_1 < 3)TMR0 = 0x56; // Amostragem a cada 680 us
     if(aux_1 == 3)TMR0 = 0x10; // Amostragem a cada 1 ms

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

 // -- Configuração de Registradores --

 CMCON = 0x07;                                                                   // Desabilita comparadores
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

 Lcd_Init();                                                                     // Initialize LCD
 Lcd_Cmd(_LCD_CLEAR);                                                            // Clear display
 Lcd_Cmd(_LCD_CURSOR_OFF);                                                       // Cursor off
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