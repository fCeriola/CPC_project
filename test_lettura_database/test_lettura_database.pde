import processing.sound.*;  //<>//
import oscP5.*;
import netP5.*;

//Objects instances
StarsTable database;
Star star;
StarSystem starSystem;
Pollution pollution;
Sky sky;
Sun sun;
Moon moon;

//Images and Colors
PImage city;
PImage cityLights;

//Time control
Time timeControl;
float timeLapseValue;

//Audio analysis
AudioIn in;
FFT fft;
int bands;
BandPass bpfilter;
Amplitude signalAmp;
float[] spectrum;

//Osc
OscP5 ableton;
NetAddress ip;

//Threads
Runnable updateDatabase;
Thread updateDB;
Runnable updateSystem;
Thread updateSys;
Runnable updatePollution;
Thread updatePoll;

//Positions
OscP5 oscP5;
private float x;
private float y;


void setup() {
  
  fullScreen();
  //size(1500,800);
  frameRate(60);
  
  ableton = new OscP5(this, 8000);
  ip = new NetAddress("127.0.0.1", 8000);
  
  oscP5= new OscP5(this, 9999);
  x = width/2;
  y = height/2;
  
  Sound s = new Sound(this);
  s.inputDevice(5);
  this. in = new AudioIn(this, 0);
  
  bands = 128;
  spectrum = new float[bands];
  
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
  
  starSystem = new StarSystem(database);
  
  pollution = new Pollution();
  
  sky = new Sky();
  
  sun = new Sun(0, 0);
  
  moon = new Moon(width/4, height/4);
  
  city = loadImage("city.png");
  cityLights = loadImage("citylight3.png");
  
}


void draw() {

  fft.analyze(spectrum);
  
  float n = map(signalAmp.analyze(), 0, 1, 0, 255);
  background(0);
  
  database.timePassedFromAppStart = timeControl.timePassingCalc(database.timePassedFromAppStart);
  
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
  moon.plot();
  
  
  pollution.plot(x, y, 50); //give pointer position and radius as arguments
  /*
  sun.update();
  
  sky.update(sun.xCoord, sun.yCoord);
  sky.plot(n/2);
  
  sun.plot(spectrum);  
  */
  city.resize(width,height);
  cityLights.resize(width,height);
  noTint();
  image(city, 0, 0);
  
  tint(255, n*4.0);
  image(cityLights, 0, 0);
  noTint();
  
  //OSC Messages
  sunVolFreq(sun.xCoord, ableton, ip);
  starMode(x, y, ableton, ip);
  
}

void oscEvent(OscMessage theOscMessage){
  // use the button in the mobile app to set the zero
  
  println("MESSAGE: " + theOscMessage.addrPattern() + "\nTAG: " + theOscMessage.typetag() + "\nVALUES.NUMBER: " + theOscMessage.arguments().length);
  Object[] testValues = theOscMessage.arguments();
  
  x = x - (float)testValues[2];
  if (x>= (width - 50)) {
    x = width - 50;
  } else if (x<=0) {
    x= 0.0;
  }
  
  y = y - ((float)testValues[0]);
  if (y>=(height - 50)) {
    y = height - 50;
  } else if (y<=0) {
    y = 0.0;
  }
}


void countingStars(color colore) {
  //println(red(colore), green(colore), blue(colore));
}
