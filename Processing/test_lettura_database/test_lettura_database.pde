import processing.sound.*;  //<>//
import oscP5.*;
import netP5.*;

//objects instances
Sky sky;
Sun sun;
StarsTable database;
Star star;
StarSystem starSystem;
Time timeControl;
OscP5 ableton;
NetAddress ip;

//time control
float timeLapseValue;

//audio analysis
AudioIn in;
FFT fft;
int bands = 128;
BandPass bpfilter;
Amplitude signalAmp;
float[] spectrum = new float[bands];

//Images and Colors
PImage city;
PImage citylight;
color orange = color(250, 225, 200);
color azure = (#A6D7E8);

//Pollution
Pollution pollution;



void setup() {
  
  ableton = new OscP5(this, 8000);
  ip = new NetAddress("127.0.0.1", 8000);
  
  //fullScreen();
  size(1500,800);
  frameRate(60);
  background(0);
  
  city = loadImage("city.png");
  citylight = loadImage("citylight3.png");
  
  Sound s = new Sound(this);
  s.inputDevice(5);
  this. in = new AudioIn(this, 0);
  
  in.start();
  fft = new FFT(this, bands);
  fft.input(in);
  signalAmp = new Amplitude(this);
  signalAmp.input(in);
  
  //bpfilter = new BandPass(this);
  //bpfilter.process(in);
  //bpfilter.freq(10000);
  //bpfilter.bw(20000);
  
  timeLapseValue = 120;
  timeControl = new Time(timeLapseValue);
  database = new StarsTable();
  
  sky = new Sky(width/2,height/2,orange,azure);
  
  sun = new Sun(0, 0);

  starSystem = new StarSystem(database);
  
  pollution = new Pollution();
  
}


void draw() {
  
  pollution.update("night", 0, 0);

  fft.analyze(spectrum);
  
  float n = map(signalAmp.analyze(), 0, 1, 0, 255);
  background(0);
  
  database.timePassedFromStarApp = timeControl.timePassingCalc(database.timePassedFromStarApp);
  
  Runnable updateDatabase = new Update(database, starSystem, "starsTable", true);
  Thread updateDB = new Thread(updateDatabase);
  updateDB.start();
  
  Runnable updateSystem = new Update(database, starSystem, "starSystem", true);
  Thread updateSys = new Thread(updateSystem);
  updateSys.start();
  starSystem.plot();
  
  
  loadPixels();
  
  color c;
  
  float percentage = dist(sun.xCoord, 0, width/2, 0);
  percentage = map(percentage, 0, width/2, 1, 0);
  
  for(int i = 0; i<width; i++) {
    for(int j = 0; j<height; j++) {
      c = lerpColor(pollution.matrix[i][j], pixels[i+j*width], 0.03);
      pixels[i+j*width] = c;
    }
  }
  
  updatePixels();
  
  
  sky.plot(n/2);
  
  pushMatrix();
  //sun.xCoord=cos(frameCount/220.0)*width/2.0+width/2;
  //sun.yCoord=sin(frameCount/220.0)*height/2.0+height/2;
  //sun.xCoord=frameCount*2.0-600;
  sun.xCoord = 0;
  sun.yCoord=height/2;
  
  sun.plot(spectrum);
  popMatrix();
  
  
  city.resize(width,height);
  citylight.resize(width,height);
  noTint();
  image(city,0,0);
  
  tint(255,n*4.0);
  image(citylight,0,0);
  noTint();
  
  
  sky.updateCoord(sun.xCoord, sun.yCoord);
  
  
  //OSC Messages
  sunVolFreq(sun.xCoord, ableton, ip);
  starMode(mouseX, mouseY, ableton, ip);

  
  
  
  
}
