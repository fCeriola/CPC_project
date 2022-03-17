import oscP5.*;
import netP5.*;

OscP5 ableton;
NetAddress ip;

int fps;
int sizex;
int sizey;
Point par;

void setup()
{
  fps = 60;
  sizex = 800;
  sizey = 800;
  
  size(800, 800);
  background(255, 255, 255);
  frameRate(fps);
  ableton = new OscP5(this, 8000);
  ip = new NetAddress("127.0.0.1", 8000);
  
}

void draw()
{
  background(255, 255, 0);
  Point myPar = new Point(mouseX,mouseY,23.0);
  //circularTraj(myPar, 200.0, 0.0);
  
  OscMessage x = new OscMessage("/position/X");
  OscMessage y = new OscMessage("/position/Y");
  
  x.add(myPar.posx/float(width));
  y.add(myPar.posy/float(height));

  ableton.send(x, ip);
  ableton.send(y, ip);
  
  
} 

//void mousePressed(){
//    OscMessage scene = new OscMessage("/launch/scene");
//    scene.add(1.0);
//    ableton.send(scene, ip);
//  }

//void circularTraj(Particle par,float radius, float angle){
//      par.getPosx() = radius*cos(angle);
//      par.getPosy() = radius*sin(angle);
//      angle += 0.1;
//  }
//void oscEvent(OscMessage theMessage){
//  if(theMessage.checkAddrPattern("/position/X")==true){
//    if(theMessage.checkTypetag("f")){
//      float value = theMessage.get(0).floatValue();
//      println(value);
//      return;
//    }else{println("second if");}
//  }else{println("first if");}
//  println("### received an osc message. with address pattern "+theMessage.addrPattern());
//}
