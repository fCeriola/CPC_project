import processing.sound.*;  //<>//
import oscP5.*;
import netP5.*;

//Objects instances
Sky sky;
Sun sun;
StarsTable database;
Star star;
StarSystem starSystem;
Time timeControl;
OscP5 ableton;
NetAddress ip;

//Time control
float timeLapseValue;

//Audio analysis
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

//Threads
Thread updateDB;
Thread updateSys;
Thread updatePoll;


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

  fft.analyze(spectrum);
  
  float n = map(signalAmp.analyze(), 0, 1, 0, 255);
  background(0);
  
  database.timePassedFromStarApp = timeControl.timePassingCalc(database.timePassedFromStarApp);
  
  Runnable updateDatabase = new Update(database, starSystem, pollution, "starsTable", true);
  updateDB = new Thread(updateDatabase);
  updateDB.start();
  
  Runnable updateSystem = new Update(database, starSystem, pollution, "starSystem", true);
  updateSys = new Thread(updateSystem);
  updateSys.start();
  
  Runnable updatePollution = new Update(database, starSystem, pollution, "pollution", true);
  updatePoll = new Thread(updatePollution);
  updatePoll.start();
  
  starSystem.plot();
  
  pollution.plot(mouseX, mouseY, 50);
  
  /*
  sky.plot(n/2);
  
  pushMatrix();
  //sun.xCoord=cos(frameCount/220.0)*width/2.0+width/2;
  //sun.yCoord=sin(frameCount/220.0)*height/2.0+height/2;
  sun.xCoord=frameCount*2.0-600;
  sun.yCoord=height/2;
  
  sun.plot(spectrum);
  popMatrix();
  
  */
  city.resize(width,height);
  citylight.resize(width,height);
  noTint();
  image(city,0,0);
  
  tint(255,n*4.0);
  image(citylight,0,0);
  noTint();
  
  sky.update(sun.xCoord, sun.yCoord);
  
  //OSC Messages
  sunVolFreq(sun.xCoord, ableton, ip);
  starMode(mouseX, mouseY, ableton, ip);
}


void countingStars(color colore) {
  println(red(colore), green(colore), blue(colore));
}
