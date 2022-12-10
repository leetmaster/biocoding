import oscP5.*;
import netP5.*;
OscP5 oscP5;

float x, y, z; // global variable

void setup() {
  //size(displayWidth, displayHeight);
  fullScreen();
  frameRate(20);
  
  smooth();

  OscProperties properties = new OscProperties();
  properties.setListeningPort(47120); // osc receive port (from sc)
  oscP5 = new OscP5(this, properties);
  print(oscP5);
}

void draw() {
  background(142,78,222);
  println("POST: ", x);
  println("POST: ", y);
  println("POST: ", z);

  noStroke();
  
fill(98,202,245);
circle(displayWidth/4, displayHeight/2, 200+x);

fill(250,229,81);
circle(displayWidth/2, displayHeight/2, 100+y);

fill(78,222,90);
circle(displayWidth/4 + displayWidth/2, displayHeight/2, 300+z);
}

void oscEvent(OscMessage msg) {
  
  if (msg.checkAddrPattern("/hum")) {
    x = msg.get(0).floatValue(); // receive floats from sc
  } else if (msg.checkAddrPattern("/luz")) {
    y = msg.get(0).floatValue(); // receive floats from sc
  }
  else if (msg.checkAddrPattern("/touch")) {
    z = msg.get(0).floatValue(); // receive floats from sc
  }
 
}
