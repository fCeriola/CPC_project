import processing.sound.*; //<>//

//objects instances
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

//debug
PrintWriter output; 


void setup() {
  
  fullScreen();
  frameRate(60);
  background(0);
  
  this.in = new AudioIn(this,0);
  in.start();
  fft = new FFT(this, bands);
  fft.input(in);
  signalAmp = new Amplitude(this);
  signalAmp.input(in);
  
  bpfilter = new BandPass(this);
  bpfilter.process(in);
  bpfilter.freq(10000);
  bpfilter.bw(20000);
  
  timeLapseValue = 120;
  timeControl = new Time(timeLapseValue);
  database = new StarsTable();
  
  sun = new Sun(mouseX, mouseY);

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
  background(n);
  
  
  //background(0);
  
  database.timePassedFromStarApp = timeControl.timePassingCalc(database.timePassedFromStarApp);
  
  Runnable updateDatabase = new Update(database, starSystem, "starsTable", true);
  Thread updateDB = new Thread(updateDatabase);
  updateDB.start();
  
  Runnable updateSystem = new Update(database, starSystem, "starSystem", true);
  Thread updateSys = new Thread(updateSystem);
  updateSys.start();
  
  starSystem.plot();
  
  sun.plot(spectrum);
  
  
  
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
