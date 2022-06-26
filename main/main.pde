import processing.sound.*; //<>//
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
float direction;

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
private float roofDistance;
private float projectionMaxDimension;
private float projectionMinDimension;
private float maxAngleX;
private float maxAngleY;
private float pointerSmooth;
private float pointerRadius;
private float xPointer;
private float yPointer;
private float prevXPointer;
private float prevYPointer;
private float accXPointer;
private float accYPointer;
private float prevAccX;
private float prevAccY;
private float accSmooth;
private float latitude;
private float longitude;

//background color
public color backColor;


void setup() {
  
  // main window setup
  fullScreen();
  //size(1500, 800);
  frameRate(60);
  backColor = color(5, 3, 30);
  
  // connect processing to ableton
  ableton = new OscP5(this, 8000);
  ip = new NetAddress("127.0.0.1", 8000);
  
  // connect processing to gyrosc
  oscP5= new OscP5(this, 9999);
  roofDistance = 1.3;
  projectionMaxDimension = 1.7;
  projectionMinDimension = 16.0/9.0 * projectionMaxDimension;
  maxAngleX = atan(projectionMaxDimension/2/roofDistance);
  maxAngleY = atan(projectionMinDimension/2/roofDistance);  
  pointerSmooth = 0.2;
  pointerRadius = 50;
  xPointer = width/2;
  yPointer = height/2;
  prevXPointer = width/2;
  prevYPointer = height/2;
  accXPointer = width/2;
  accYPointer = height/2;
  accSmooth = 0.2;
  
  // get audio input signal
  Sound s = new Sound(this);
  //s.inputDevice(19);
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
  if (timeLapseValue > 0)
    direction = 1;
  if (timeLapseValue < 0)
    direction = -1;
  timeControl = new Time(timeLapseValue);
 
 
  // objects instantiation
  
  database = new StarsTable(latitude, longitude);
  
  starSystem = new StarSystem(database);
  
  pollution = new Pollution();
  
  sky = new Sky();
  
  sun = new Sun(2*width, height/2);
  
  moon = new Moon(2*width, height/3);
  
  city = loadImage("city.png");
  cityLights = loadImage("citylight3.png");
  
}

/*---------------DRAW-------------------*/
void draw() {
  
  // nightblue background
  background(backColor);

  // audio analysis
  fft.analyze(spectrum);
  float n = map(signalAmp.analyze(), 0, 1, 0, 255);
  
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
  
  /*----------------OBJECTS PLOT--------------*/
  
  starSystem.plot();
  

  moonEvent();

  pollution.plot(xPointer, yPointer, pointerRadius);
   
  sunEvent(n);
    
  city.resize(width,height);
  cityLights.resize(width,height);
  noTint();
  image(city, 0, 0);
  
  cityEvent(n);

  
  //OSC Messages
  sunVolFreq(sun.xCoord, ableton, ip);
  starMode(xPointer, yPointer, ableton, ip);
  accFilter(accXPointer, accYPointer, ableton,ip);
  
  
}
/*-------------------------------------------*/

/*--------- OSC FROM GYROSC --------------- */
void oscEvent(OscMessage theOscMessage){
  //println("MESSAGE: " + theOscMessage.addrPattern() + "\nTAG: " + theOscMessage.typetag() + "\nVALUES.NUMBER: " + theOscMessage.arguments().length);
  if(theOscMessage.checkAddrPattern("/gyrosc/gyro")==true){
    Object[] testValues = theOscMessage.arguments();
    
    xPointer = (float)testValues[2];
    xPointer = constrain(xPointer, -maxAngleX, maxAngleX);
    xPointer = map(xPointer, -maxAngleX, maxAngleX, 0, PI);
    xPointer = width/2 + width/2 * cos(xPointer);
    xPointer = pointerSmooth * xPointer + (1 - pointerSmooth) * prevXPointer;
    prevXPointer = xPointer;
    //if (xPointer >= (width - pointerRadius)) {
    //  xPointer = width - pointerRadius;
    //} else if (xPointer <= 0) {
    //  xPointer = 0.0;
    //}
    yPointer = (float)testValues[0];
    yPointer = constrain(yPointer, -maxAngleY, maxAngleY);
    yPointer = map(yPointer, -maxAngleY, maxAngleY, 0, PI);
    yPointer = height/2 + height/2 * cos(yPointer);
    yPointer = pointerSmooth * yPointer + (1 - pointerSmooth) * prevYPointer;
    prevYPointer = yPointer;
    //if (yPointer >= (height - pointerRadius)) {
    //  yPointer = height - pointerRadius;
    //} else if (yPointer <= 0) {
    //  yPointer = 0.0;
    //}
    
  }
  
  if(theOscMessage.checkAddrPattern("/gyrosc/accel")==true){
    Object[] accelValues = theOscMessage.arguments();
    accXPointer = (float)accelValues[0];
    accXPointer = accSmooth*accXPointer + (1-accSmooth)*prevAccX;
    prevAccX = accXPointer;
    if (accXPointer >= (width - pointerRadius)) {
      accXPointer = width - pointerRadius;
    } else if (accXPointer <= 0) {
      accXPointer = abs(accXPointer);
    }
    accYPointer = (float)accelValues[1];
    accYPointer = accSmooth*accYPointer + (1-accSmooth)*prevAccY;
    prevAccY = accYPointer;
    if (accYPointer >= (width - pointerRadius)) {
      accYPointer = width - pointerRadius;
    } else if (accYPointer <= 0) {
      accYPointer = abs(accYPointer);
    }
  }
  //println(accXPointer);
  //xPointer = mouseX;
  //yPointer = mouseY;
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


void exit(){
  sceneChange(ableton, ip, 2);
  super.exit();
}
