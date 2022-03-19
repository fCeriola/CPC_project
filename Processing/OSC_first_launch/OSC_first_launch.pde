import oscP5.*;
import netP5.*;
import processing.sound.*; 


OscP5 ableton;
NetAddress ip;

AudioIn in;


void setup(){
  
  ableton = new OscP5(this, 8000);
  ip = new NetAddress("127.0.0.1", 8000);
  
  //check audio devices
  Sound s = new Sound(this);
  println(Sound.list());
  s.inputDevice(9);
  AudioIn in = new AudioIn(this, 4);
  
  background(0);
  size(800,400);
  fill(102,178,255);
  rect(0,0,200,200);
  fill(255,102,102);
  rect(0,200,200,200);
  
  fill(102,255,255);
  rect(200,0,200,200);
  fill(255,178,102);
  rect(200,200,200,200);
  
  fill(102,255,178);
  rect(400,0,200,200);
  fill(255,255,102);
  rect(400,200,200,200);
  
  fill(102,255,102);
  rect(600,0,200,200);
  fill(178,255,102);
  rect(600,200,200,200);
  
  
}

void draw() {
  
}

void mousePressed(){
  color c = checkcolor();
  //1
  if (c == color(102,178,255)){
    OscMessage A = new OscMessage("/stars/rate");
    A.add(1.0);
    ableton.send(A,ip);}
  //2
  if (c == color(102,255,255)){
    OscMessage B = new OscMessage("/stars/mode");
    B.add(1.0);
    ableton.send(B,ip);}
  //3
  if (c == color(102,255,178)){
    OscMessage C = new OscMessage("/sun/volume");
    C.add(1.0);
    ableton.send(C,ip);}
  //4
  if (c == color(102,255,102)){
   }
  //5
  if (c == color(178,255,102)){
  }
  //6
  if (c == color(255,255,102)){
   }
  //7
  if (c == color(255,178,102)){
   }
  //8
  if (c == color(255,102,102)){
   }
   
}

color checkcolor(){
  color c = get(mouseX,mouseY);
  return c;
}

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
