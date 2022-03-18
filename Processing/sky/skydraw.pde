import processing.sound.*; 

Sky sky;
AudioIn in;
Amplitude signalAmp;
color orange = (#F7C870);
color azure = (#A6D7E8);

void setup(){
  size(600,600);
  background(0);
   signalAmp = new Amplitude(this);
  signalAmp.input(in);
  
  sky = new Sky(width/2,height/2,orange,azure);
  //sky.plot();
}

void draw(){
  background(0);
  sky.updateCoord(mouseX,mouseY);
  sky.plot();
}
