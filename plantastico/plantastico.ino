#include <CapPin.h>

//const int valor_aire = 565;   //you need to replace this value with Value_1
//const int valor_agua = 256;  //you need to replace this value with Value_2

CapPin cPin_5 = CapPin(5);

int foto_res = A0;
int sens_cap = A1;
int sens_touch = A2;
int luz = 0;
int tierra = 0;
int touch = 0;

void setup() {
  Serial.begin(9600);
  //ref = ADCTouch.read(sens_touch, 500);
  
}

void loop() {
  //touch = ADCTouch.read(sens_touch);
  //touch -= ref;
  touch = cPin_5.readPin(100);
  luz = analogRead(foto_res);
  tierra = analogRead(sens_cap);
  //Serial.print(ref);
  Serial.print(luz);
  Serial.println('a');
  Serial.print(touch);
  Serial.println('b');
  Serial.print(tierra);
  Serial.println('c');
  delay(100);
}
