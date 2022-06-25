import processing.sound.*;  //<>// //<>//
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

//Time flow management
Time timeControl;
float timeLapseValue;

//Audio analysis
AudioIn in;
FFT fft;
int bands;
BandPass bpfilter;
Amplitude signalAmp;
float[] spectrum;

//Osc communication with Ableton
OscP5 ableton;
NetAddress ip;

//Threads
Runnable updateDatabase;
Thread updateDB;
Runnable updateSystem;
Thread updateSys;
Runnable updatePollution;
Thread updatePoll;

//Osc communication with GyrOsc
OscP5 oscP5;
private float pointerRadius;
private float xPointer;
private float yPointer;
private float accXPointer;
private float accYPointer;
private float latitude;
private float longitude;


void setup() {
  
  // main window setup
  //fullScreen();
  size(1500, 800);
  frameRate(60);
  
  // connect processing to ableton
  ableton = new OscP5(this, 8000);
  ip = new NetAddress("127.0.0.1", 8000);
  
  // connect processing to gyrosc
  oscP5= new OscP5(this, 9999);
  pointerRadius = 50;
  xPointer = width/2;
  yPointer = height/2;
  accXPointer = width/2;
  accYPointer = height/2;
  
  // get audio input signal
  Sound s = new Sound(this);
  s.inputDevice(5);
  this. in = new AudioIn(this, 0);
  
  // define audio analysis parameter
  bands = 128;
  spectrum = new float[bands];
  
  in.start();
  fft = new FFT(this, bands);
  fft.input(in);
  signalAmp = new Amplitude(this);
  signalAmp.input(in);
  
  // time flow controller setup
  timeLapseValue = 120;
  timeControl = new Time(timeLapseValue);
 
 
  // objects instantiation
  
  database = new StarsTable(latitude, longitude);
  
  starSystem = new StarSystem(database);
  
  pollution = new Pollution();
  
  sky = new Sky();
  
  sun = new Sun(width+200, height/2);
  
  moon = new Moon(width+100, height/3);
  
  city = loadImage("city.png");
  cityLights = loadImage("citylight3.png");
  
  day = false;
  
}

/*---------------DRAW-------------------*/
void draw() {
  
  // nightblue background
  background(5, 3, 30);

  // audio analysis
  fft.analyze(spectrum);
  float n = map(signalAmp.analyze(), 0, 1, 0, 255);
  
  // keep track of the time starting from the initial launch of the application
  database.timePassedFromAppStart = timeControl.timePassingCalc(database.timePassedFromAppStart);
  sun.timePassedFromAppStart = database.timePassedFromAppStart;
  
  // thread - stars coordinates update
  Runnable updateDatabase = new Update(database, starSystem, pollution, "starsTable", true);
  updateDB = new Thread(updateDatabase);
  updateDB.start();
  
  // thread - graphical stars objects are updated to the just updated coordinates
  Runnable updateSystem = new Update(database, starSystem, pollution, "starSystem", true);
  updateSys = new Thread(updateSystem);
  updateSys.start();
  
  // thread - veil of pollution update
  Runnable updatePollution = new Update(database, starSystem, pollution, "pollution", true);
  updatePoll = new Thread(updatePollution);
  updatePoll.start();
  
  // plot objects
  starSystem.plot();
  
  //must be in an event
 
  moonEvent();
  //moon.plot();
  //moon.update();
  //----
  
  pollution.plot(xPointer, yPointer, pointerRadius);
  
  //must be in an event
  
  sunEvent(n);
  //sun.update();
  //sky.update(sun.xCoord, sun.yCoord);
  //sky.plot(n/2);
  //sun.plot(spectrum);  
  
  //-----
   
  
  city.resize(width,height);
  cityLights.resize(width,height);
  noTint();
  image(city, 0, 0);
  
  cityEvent(n);

  
  //OSC Messages
  sunVolFreq(sun.xCoord, ableton, ip);
  starMode(xPointer, yPointer, ableton, ip);
  accFilter(accXPointer, ableton,ip);
  
}
/*-------------------------------------------*/

/*--------- OSC FROM GYROSC --------------- */
void oscEvent(OscMessage theOscMessage){
  //println("MESSAGE: " + theOscMessage.addrPattern() + "\nTAG: " + theOscMessage.typetag() + "\nVALUES.NUMBER: " + theOscMessage.arguments().length);
  if(theOscMessage.checkAddrPattern("/gyrosc/gyro")==true){
    Object[] testValues = theOscMessage.arguments();
    xPointer = xPointer - (float)testValues[2];
    if (xPointer >= (width - pointerRadius)) {
      xPointer = width - pointerRadius;
    } else if (xPointer <= 0) {
      xPointer = 0.0;
    }
    yPointer = yPointer - (float)testValues[0];
    if (yPointer >= (height - pointerRadius)) {
      yPointer = height - pointerRadius;
    } else if (yPointer <= 0) {
      yPointer = 0.0;
    }
  }
  
   if(theOscMessage.checkAddrPattern("/gyrosc/accel")==true){
    Object[] accelValues = theOscMessage.arguments();
    accXPointer = (float)accelValues[0];
    if (accXPointer >= (width - pointerRadius)) {
      accXPointer = width - pointerRadius;
    } else if (accXPointer <= 0) {
      accXPointer = 0.0;
    }
    accYPointer = (float)accelValues[1];
    if (accYPointer >= (width - pointerRadius)) {
      accYPointer = width - pointerRadius;
    } else if (accYPointer <= 0) {
      accYPointer = 0.0;
    }
  }
  
}
/*--------------------------------------------*/

/*---------- GPS COORDS FROM GYROSC ----------*/
public float returnLatitude(OscMessage theOscMessage){
  if(theOscMessage.checkAddrPattern("/gyrosc/gps")==true){
    Object[] gpsValues = theOscMessage.arguments();
    latitude = (float)gpsValues[0];
    //println("latitude :" + latitude);
  } 
  return latitude;
}

public float returnLongitude(OscMessage theOscMessage){
  if(theOscMessage.checkAddrPattern("/gyrosc/gps")==true){
    Object[] gpsValues = theOscMessage.arguments();
    longitude = (float)gpsValues[1];
    //println("longitude :" + longitude);
  }
  return longitude;
}
