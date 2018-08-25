int linha = 0;                               // Variavel que se refere as linhas do excel
int LABEL = 1;  
int valor = 0;                               // Variavel que guarda o valor lido do potenciometro
int media = 0;

void setup(){
  
  Serial.begin(19200);                       // Inicialização da comunicação serial
  Serial.println("CLEARDATA");               // Reset da comunicação serial
  Serial.println("LABEL,Hora,valor,linha");  // Nomeia as colunas

}
 
void loop(){
 
  media = analogRead(A1)*0.2+media*0.8;     // Faz a leitura do potenciometro e guarda o valor em val.
  linha++;                                  // Incrementa a linha do excel para que a leitura pule de linha em linha
 
  Serial.print("DATA,TIME,");               // Inicia a impressão de dados, sempre iniciando
  Serial.print(media);
  Serial.print(",");
  Serial.println(linha);
 
  if (linha > 1000){                        // Laço para limitar a quantidade de dados
  
    linha = 0;
    Serial.println("ROW,SET,2");            // Alimentação das linhas com os dados sempre iniciando
  }
  
  delay(1);                                 // Espera 1 milisegundo
}
