/*
 * Calibração do Servo
 * Autor: Alex Cani
 */

#include <Servo.h> 

/*
 * Este código serve para determinar o valor de offset
 * do servo e os limites da atuação. O posicionamento do servo 
 * no veículo deve ser feito de forma que a posição 90º do servo 
 * deixe o disco horizontalmente alinhado. Como isto não é 
 * possível, deve ser feita uma pequena correção de offset de 
 * modo que a origem do sistema seja equivalente à posição do 
 * servo que alinha o disco.
 * 
 * Também é necessário determinar qual o menor ângulo para o servo
 * e qual o maior ângulo, de modo que o giroscópio não encoste e
 * danifique o protótipo.
 */
Servo servo;

// Altere aqui o pino no qual o servo está conectado.
const int pino_servo = 5;

/*
 * Basicamente o programa pega o número digitado
 * no serial e torna este a referência da posição do servo.
 * Como pode ser observado, nenhuma verificação quanto ao conteúdo
 * é realizada, portanto utilize com atenção.
 * 
 * O servos em geral podem assumir posição entre 0 e 180 graus.
 * No Arduino, o valor esperado pelo servo é UM INTEIRO.
 * Abra o Monitor Serial e envie para o servo posições desejadas 
 * até que seja observado que o giroscópio está paralelo ao chassi
 * da moto. Anote a posição relacionada e utilize-a no campo correspondente
 * do código de controle.
 * 
 * Faça o mesmo para determinar o maior e menor valor para a posição do servo.
 */
int pos = 90;

void setup() {
servo.attach(pino_servo);
Serial.begin(115200);
}

void loop() {
  if(Serial.available() > 0){ // Se houver algo no serial
    pos = Serial.parseInt(); // Supõe-se que é int
    servo.write(pos); // Manda para o servo
  }
  Serial.println(servo.read());
}
