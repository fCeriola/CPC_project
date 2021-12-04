import oscP5.*;
import netP5.*;

OscP5 ableton;
NetAddress ip;

void setup()
{
  size(800, 800);
  background(255, 255, 255);
  frameRate(60);
  ableton = new OscP5(this, 7000);
  ip = new NetAddress("127.0.0.1", 8000);
}

void draw()
{
  background(255, 255, 0);
  circle(mouseX, mouseY, 20);
  
  //OscMessage x = new OscMessage("/position/X");
  //OscMessage y = new OscMessage("/position/Y");

  //x.add(mouseX/800*127);
  //y.add(mouseY/800*127);

  //ableton.send(x, ip);
  //ableton.send(y, ip);

}

void mousePressed() {
  OscMessage x = new OscMessage("/position/X");
  OscMessage y = new OscMessage("/position/Y");

  x.add(mouseX/800*127);
  y.add(mouseY/800*127);

  ableton.send(x, ip);
  ableton.send(y, ip);


  println(x, y);
}
