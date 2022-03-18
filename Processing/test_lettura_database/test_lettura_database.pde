import processing.sound.*;  //<>//

//objects instances
Sky sky;
Sun sun;
StarsTable database;
Star star;
StarSystem starSystem;
Time timeControl;

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

//debug
PrintWriter output; 


void setup() {
  
  fullScreen();
  frameRate(60);
  background(0);
  
  city = loadImage("city.png");
  citylight = loadImage("citylight3.png");
  
  Sound s = new Sound(this);
  s.inputDevice(9);
  this. in = new AudioIn(this, 4);
  
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
  
  
  
  //---------------------------------------
  // DEBUG
  /*
  output = createWriter("debug_out.txt");
  for (int i=0;i<database.starsAttributes.getRowCount();i++){
    output.println(database.starsAttributes.getInt(i,"index")+" -  HC1: "+database.starsAttributes.getFloat(i,"HC1")+" -  HC2: "+database.starsAttributes.getFloat(i,"HC1")+" -   X: "+database.starsAttributes.getFloat(i,"X")+" -   Y: "+database.starsAttributes.getFloat(i,"Y"));
  }
  */
  //---------------------------------------
  
}


void draw() {
  
  

  fft.analyze(spectrum);
  
  float n = map(signalAmp.analyze(), 0, 0.5, 0, 255);
  background(0);
  
  
  //background(0);
  
  database.timePassedFromStarApp = timeControl.timePassingCalc(database.timePassedFromStarApp);
  
  Runnable updateDatabase = new Update(database, starSystem, "starsTable", true);
  Thread updateDB = new Thread(updateDatabase);
  updateDB.start();
  
  Runnable updateSystem = new Update(database, starSystem, "starSystem", true);
  Thread updateSys = new Thread(updateSystem);
  updateSys.start();
  starSystem.plot();
  
  sky.plot(n/2);
  
  pushMatrix();
  //sun.xCoord=cos(frameCount/220.0)*width/2.0+width/2;
  //sun.yCoord=sin(frameCount/220.0)*height/2.0+height/2;
  sun.xCoord=frameCount*2.0;
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
  

  
  
  
  //----------------------------------------------
  //DEBUG
  /*
  String[] columns = {"HC1", "HC2", "X", "Y"};
  
  for (int i=0;i<database.starsAttributes.getRowCount();i++) {
    TableRow row = database.starsAttributes.getRow(i);
    database.debug(row, columns, false); 
  }
  */
  //----------------------------------------------
  
}
