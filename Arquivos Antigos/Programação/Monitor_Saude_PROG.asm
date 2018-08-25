
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Monitor_Saude_PROG.c,31 :: 		void Interrupt(){                                           // Função responsável pelo tratamento das Interrupções
;Monitor_Saude_PROG.c,33 :: 		if(ADIF_bit){                                             // Houve Interrupção do conversor AD?
	BTFSS      ADIF_bit+0, 6
	GOTO       L_Interrupt0
;Monitor_Saude_PROG.c,35 :: 		ADIF_bit = 0x00;                                        // Se sim, limpa flag de indicação da interrupção do AD
	BCF        ADIF_bit+0, 6
;Monitor_Saude_PROG.c,37 :: 		if(aux_1 == 0x01){                                     // Amostra primeiro ponto de mínimo da FDO
	MOVF       _aux_1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt1
;Monitor_Saude_PROG.c,39 :: 		vetor[k] = ADRESH;                                    // Guarda o valor de 8bits lido pelo conversor AD
	MOVF       _k+0, 0
	ADDLW      _vetor+0
	MOVWF      FSR
	MOVF       ADRESH+0, 0
	MOVWF      INDF+0
;Monitor_Saude_PROG.c,40 :: 		k++;                                                  // Incrementa posição do vetor de aquisição de V1
	INCF       _k+0, 1
;Monitor_Saude_PROG.c,41 :: 		RC0_bit = ! RC0_bit;
	MOVLW      1
	XORWF      RC0_bit+0, 1
;Monitor_Saude_PROG.c,42 :: 		}
L_Interrupt1:
;Monitor_Saude_PROG.c,44 :: 		if(aux_1 == 0x02){                                      // Procura indícios do segundo ponto de mínimo da FDO (V2)
	MOVF       _aux_1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt2
;Monitor_Saude_PROG.c,46 :: 		x[k]= ADRESH;                                         // Guarda o valor de 8bits lido pelo conversor AD
	MOVF       _k+0, 0
	ADDLW      _x+0
	MOVWF      FSR
	MOVF       ADRESH+0, 0
	MOVWF      INDF+0
;Monitor_Saude_PROG.c,47 :: 		k++;                                                  // Incrementa posição do vetor para encontrar V2
	INCF       _k+0, 1
;Monitor_Saude_PROG.c,48 :: 		if(k == 0x02) k = 0x00;                               // Limita a variável k em 0 e 1
	MOVF       _k+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt3
	CLRF       _k+0
L_Interrupt3:
;Monitor_Saude_PROG.c,49 :: 		RC0_bit = ! RC0_bit;
	MOVLW      1
	XORWF      RC0_bit+0, 1
;Monitor_Saude_PROG.c,51 :: 		}
L_Interrupt2:
;Monitor_Saude_PROG.c,53 :: 		if(aux_1 == 0x03){                                      // Amostra segundo ponto de mínimo da FDO V2
	MOVF       _aux_1+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt4
;Monitor_Saude_PROG.c,55 :: 		vetor_2[k] = ADRESH;                                  // Guarda o valor de 8bits lido pelo conversor AD
	MOVF       _k+0, 0
	ADDLW      _vetor_2+0
	MOVWF      FSR
	MOVF       ADRESH+0, 0
	MOVWF      INDF+0
;Monitor_Saude_PROG.c,56 :: 		k++;                                                  // Incrementa posição de aquisição de V2
	INCF       _k+0, 1
;Monitor_Saude_PROG.c,57 :: 		RC0_bit = ! RC0_bit;
	MOVLW      1
	XORWF      RC0_bit+0, 1
;Monitor_Saude_PROG.c,60 :: 		}
L_Interrupt4:
;Monitor_Saude_PROG.c,62 :: 		}
L_Interrupt0:
;Monitor_Saude_PROG.c,64 :: 		if(INTF_bit){
	BTFSS      INTF_bit+0, 1
	GOTO       L_Interrupt5
;Monitor_Saude_PROG.c,66 :: 		INTF_bit = 0x00;
	BCF        INTF_bit+0, 1
;Monitor_Saude_PROG.c,67 :: 		TMR0IE_bit = 0x01;
	BSF        TMR0IE_bit+0, 5
;Monitor_Saude_PROG.c,68 :: 		Go_bit = 0x01;
	BSF        GO_bit+0, 2
;Monitor_Saude_PROG.c,69 :: 		INTE_bit = 0x00;
	BCF        INTE_bit+0, 4
;Monitor_Saude_PROG.c,70 :: 		aux_1 = 0x01;
	MOVLW      1
	MOVWF      _aux_1+0
;Monitor_Saude_PROG.c,71 :: 		delay_us(20);
	MOVLW      26
	MOVWF      R13+0
L_Interrupt6:
	DECFSZ     R13+0, 1
	GOTO       L_Interrupt6
	NOP
;Monitor_Saude_PROG.c,73 :: 		}
L_Interrupt5:
;Monitor_Saude_PROG.c,75 :: 		if(TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, 2
	GOTO       L_Interrupt7
;Monitor_Saude_PROG.c,77 :: 		TMR0IF_bit = 0x00;
	BCF        TMR0IF_bit+0, 2
;Monitor_Saude_PROG.c,78 :: 		if(aux_1 < 3)TMR0 = 0x56; // Amostragem a cada 680 us
	MOVLW      3
	SUBWF      _aux_1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Interrupt8
	MOVLW      86
	MOVWF      TMR0+0
L_Interrupt8:
;Monitor_Saude_PROG.c,79 :: 		if(aux_1 == 3)TMR0 = 0x10; // Amostragem a cada 1 ms
	MOVF       _aux_1+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt9
	MOVLW      16
	MOVWF      TMR0+0
L_Interrupt9:
;Monitor_Saude_PROG.c,81 :: 		if(k<60){
	MOVLW      60
	SUBWF      _k+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Interrupt10
;Monitor_Saude_PROG.c,83 :: 		Go_bit = 0x01;
	BSF        GO_bit+0, 2
;Monitor_Saude_PROG.c,84 :: 		delay_us(20);
	MOVLW      26
	MOVWF      R13+0
L_Interrupt11:
	DECFSZ     R13+0, 1
	GOTO       L_Interrupt11
	NOP
;Monitor_Saude_PROG.c,86 :: 		}
L_Interrupt10:
;Monitor_Saude_PROG.c,88 :: 		if(aux_1 == 2){
	MOVF       _aux_1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt12
;Monitor_Saude_PROG.c,90 :: 		if(k == 0x00){
	MOVF       _k+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt13
;Monitor_Saude_PROG.c,92 :: 		old = media;
	MOVF       _media+0, 0
	MOVWF      _old+0
	MOVF       _media+1, 0
	MOVWF      _old+1
;Monitor_Saude_PROG.c,93 :: 		dx = (x[1] - x[0]);
	MOVF       _x+0, 0
	SUBWF      _x+1, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSS      STATUS+0, 0
	DECF       R1+1, 1
	MOVF       R1+0, 0
	MOVWF      _dx+0
	MOVF       R1+1, 0
	MOVWF      _dx+1
;Monitor_Saude_PROG.c,94 :: 		media = (dx*2 + media*8);
	MOVF       R1+0, 0
	MOVWF      R4+0
	MOVF       R1+1, 0
	MOVWF      R4+1
	RLF        R4+0, 1
	RLF        R4+1, 1
	BCF        R4+0, 0
	MOVLW      3
	MOVWF      R2+0
	MOVF       _media+0, 0
	MOVWF      R0+0
	MOVF       _media+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Interrupt38:
	BTFSC      STATUS+0, 2
	GOTO       L__Interrupt39
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__Interrupt38
L__Interrupt39:
	MOVF       R0+0, 0
	ADDWF      R4+0, 0
	MOVWF      R2+0
	MOVF       R4+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      _media+0
	MOVF       R2+1, 0
	MOVWF      _media+1
;Monitor_Saude_PROG.c,96 :: 		if(media<0){
	MOVLW      128
	XORWF      R2+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt40
	MOVLW      0
	SUBWF      R2+0, 0
L__Interrupt40:
	BTFSC      STATUS+0, 0
	GOTO       L_Interrupt14
;Monitor_Saude_PROG.c,98 :: 		aux_1 = 0x03;
	MOVLW      3
	MOVWF      _aux_1+0
;Monitor_Saude_PROG.c,99 :: 		k = 0x00;
	CLRF       _k+0
;Monitor_Saude_PROG.c,100 :: 		Go_bit = 0x01;
	BSF        GO_bit+0, 2
;Monitor_Saude_PROG.c,101 :: 		delay_us(20);
	MOVLW      26
	MOVWF      R13+0
L_Interrupt15:
	DECFSZ     R13+0, 1
	GOTO       L_Interrupt15
	NOP
;Monitor_Saude_PROG.c,102 :: 		RC1_bit = 0x01;
	BSF        RC1_bit+0, 1
;Monitor_Saude_PROG.c,104 :: 		}
L_Interrupt14:
;Monitor_Saude_PROG.c,106 :: 		}
L_Interrupt13:
;Monitor_Saude_PROG.c,108 :: 		}
L_Interrupt12:
;Monitor_Saude_PROG.c,110 :: 		if(k == 20 && aux_1 == 0x01){
	MOVF       _k+0, 0
	XORLW      20
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt18
	MOVF       _aux_1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt18
L__Interrupt36:
;Monitor_Saude_PROG.c,112 :: 		aux_1 = 0x02;
	MOVLW      2
	MOVWF      _aux_1+0
;Monitor_Saude_PROG.c,113 :: 		k = 0x00;
	CLRF       _k+0
;Monitor_Saude_PROG.c,114 :: 		delay_ms(150);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_Interrupt19:
	DECFSZ     R13+0, 1
	GOTO       L_Interrupt19
	DECFSZ     R12+0, 1
	GOTO       L_Interrupt19
	DECFSZ     R11+0, 1
	GOTO       L_Interrupt19
	NOP
	NOP
;Monitor_Saude_PROG.c,115 :: 		Go_bit = 0x01;
	BSF        GO_bit+0, 2
;Monitor_Saude_PROG.c,116 :: 		delay_us(20);
	MOVLW      26
	MOVWF      R13+0
L_Interrupt20:
	DECFSZ     R13+0, 1
	GOTO       L_Interrupt20
	NOP
;Monitor_Saude_PROG.c,118 :: 		}
L_Interrupt18:
;Monitor_Saude_PROG.c,120 :: 		if(k == 60 && aux_1 == 0x03){
	MOVF       _k+0, 0
	XORLW      60
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt23
	MOVF       _aux_1+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Interrupt23
L__Interrupt35:
;Monitor_Saude_PROG.c,122 :: 		flag = 0x01;
	MOVLW      1
	MOVWF      _flag+0
;Monitor_Saude_PROG.c,123 :: 		TMR0IE_bit = 0x00;
	BCF        TMR0IE_bit+0, 5
;Monitor_Saude_PROG.c,124 :: 		ADIE_bit = 0x00;
	BCF        ADIE_bit+0, 6
;Monitor_Saude_PROG.c,125 :: 		ADON_bit = 0x00;
	BCF        ADON_bit+0, 0
;Monitor_Saude_PROG.c,127 :: 		}
L_Interrupt23:
;Monitor_Saude_PROG.c,128 :: 		}
L_Interrupt7:
;Monitor_Saude_PROG.c,129 :: 		}
L__Interrupt37:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;Monitor_Saude_PROG.c,131 :: 		void main() {
;Monitor_Saude_PROG.c,135 :: 		CMCON = 0x07;                                                                   // Desabilita comparadores
	MOVLW      7
	MOVWF      CMCON+0
;Monitor_Saude_PROG.c,136 :: 		ADCON0 = 0x01;
	MOVLW      1
	MOVWF      ADCON0+0
;Monitor_Saude_PROG.c,137 :: 		ADCON1 = 0x0E;
	MOVLW      14
	MOVWF      ADCON1+0
;Monitor_Saude_PROG.c,139 :: 		INTCON = 0xF0;
	MOVLW      240
	MOVWF      INTCON+0
;Monitor_Saude_PROG.c,140 :: 		OPTION_REG = 0x83;
	MOVLW      131
	MOVWF      OPTION_REG+0
;Monitor_Saude_PROG.c,141 :: 		ADIE_bit = 0x01;
	BSF        ADIE_bit+0, 6
;Monitor_Saude_PROG.c,142 :: 		TMR0 = 0x56;
	MOVLW      86
	MOVWF      TMR0+0
;Monitor_Saude_PROG.c,143 :: 		TMR0IE_bit = 0x00;
	BCF        TMR0IE_bit+0, 5
;Monitor_Saude_PROG.c,145 :: 		TRISA = 0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;Monitor_Saude_PROG.c,146 :: 		TRISB = 0xFF;
	MOVLW      255
	MOVWF      TRISB+0
;Monitor_Saude_PROG.c,147 :: 		TRISC = 0xF0;
	MOVLW      240
	MOVWF      TRISC+0
;Monitor_Saude_PROG.c,148 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;Monitor_Saude_PROG.c,150 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Monitor_Saude_PROG.c,152 :: 		Lcd_Init();                                                                     // Initialize LCD
	CALL       _Lcd_Init+0
;Monitor_Saude_PROG.c,153 :: 		Lcd_Cmd(_LCD_CLEAR);                                                            // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Monitor_Saude_PROG.c,154 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                                                       // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Monitor_Saude_PROG.c,155 :: 		Lcd_Out(1,1,"Aguardando...");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Monitor_Saude_PROG+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Monitor_Saude_PROG.c,157 :: 		while(1){
L_main24:
;Monitor_Saude_PROG.c,160 :: 		if(flag == 0x01){
	MOVF       _flag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main26
;Monitor_Saude_PROG.c,162 :: 		aux_1 = vetor[0];
	MOVF       _vetor+0, 0
	MOVWF      _aux_1+0
;Monitor_Saude_PROG.c,164 :: 		for(i=0;i<20;i++){
	CLRF       _i+0
L_main27:
	MOVLW      20
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main28
;Monitor_Saude_PROG.c,166 :: 		if(vetor[i]<aux_1) aux_1 = vetor[i];
	MOVF       _i+0, 0
	ADDLW      _vetor+0
	MOVWF      FSR
	MOVF       _aux_1+0, 0
	SUBWF      INDF+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main30
	MOVF       _i+0, 0
	ADDLW      _vetor+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      _aux_1+0
L_main30:
;Monitor_Saude_PROG.c,164 :: 		for(i=0;i<20;i++){
	INCF       _i+0, 1
;Monitor_Saude_PROG.c,168 :: 		}
	GOTO       L_main27
L_main28:
;Monitor_Saude_PROG.c,170 :: 		provisorio = (aux_1 *15)/2.55;
	MOVF       _aux_1+0, 0
	MOVWF      R0+0
	MOVLW      15
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	CALL       _Int2Double+0
	MOVLW      51
	MOVWF      R4+0
	MOVLW      51
	MOVWF      R4+1
	MOVLW      35
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _Double2Word+0
	MOVF       R0+0, 0
	MOVWF      _provisorio+0
	MOVF       R0+1, 0
	MOVWF      _provisorio+1
;Monitor_Saude_PROG.c,171 :: 		IntToStr(provisorio,txt);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Monitor_Saude_PROG.c,172 :: 		Lcd_Out(1,10,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Monitor_Saude_PROG.c,174 :: 		aux_1 = vetor_2[0];
	MOVF       _vetor_2+0, 0
	MOVWF      _aux_1+0
;Monitor_Saude_PROG.c,176 :: 		for(i=0;i<60;i++){
	CLRF       _i+0
L_main31:
	MOVLW      60
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main32
;Monitor_Saude_PROG.c,178 :: 		if(vetor_2[i]<aux_1) aux_1 = vetor_2[i];
	MOVF       _i+0, 0
	ADDLW      _vetor_2+0
	MOVWF      FSR
	MOVF       _aux_1+0, 0
	SUBWF      INDF+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main34
	MOVF       _i+0, 0
	ADDLW      _vetor_2+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      _aux_1+0
L_main34:
;Monitor_Saude_PROG.c,176 :: 		for(i=0;i<60;i++){
	INCF       _i+0, 1
;Monitor_Saude_PROG.c,180 :: 		}
	GOTO       L_main31
L_main32:
;Monitor_Saude_PROG.c,182 :: 		Lcd_Out(1,1,"V1       ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Monitor_Saude_PROG+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Monitor_Saude_PROG.c,183 :: 		Lcd_Out(2,1,"V2");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Monitor_Saude_PROG+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Monitor_Saude_PROG.c,185 :: 		provisorio = (aux_1 *15)/2.55;
	MOVF       _aux_1+0, 0
	MOVWF      R0+0
	MOVLW      15
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	CALL       _Int2Double+0
	MOVLW      51
	MOVWF      R4+0
	MOVLW      51
	MOVWF      R4+1
	MOVLW      35
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _Double2Word+0
	MOVF       R0+0, 0
	MOVWF      _provisorio+0
	MOVF       R0+1, 0
	MOVWF      _provisorio+1
;Monitor_Saude_PROG.c,186 :: 		IntToStr(provisorio,txt);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Monitor_Saude_PROG.c,187 :: 		Lcd_Out(2,10,txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Monitor_Saude_PROG.c,189 :: 		}
L_main26:
;Monitor_Saude_PROG.c,191 :: 		}
	GOTO       L_main24
;Monitor_Saude_PROG.c,193 :: 		}
	GOTO       $+0
; end of _main
