StarsTable database; //<>//
Star star;
StarSystem starSystem;
Time timeControl;
PrintWriter output;
float[] extremes;
float timeLapseValue;
//float numero = 0;


void setup() {
  
  size(1512,850);
  frameRate(60);
  background(0);
  
  timeLapseValue = 1;
  timeControl = new Time(timeLapseValue);
  database = new StarsTable();
  
  //---------------------------------------
  // DEBUG
  /*
  output = createWriter("debug_out.txt");
  for (int i=0;i<database.starsAttributes.getRowCount();i++){
    output.println(database.starsAttributes.getInt(i,"index")+" -  HC1: "+database.starsAttributes.getFloat(i,"HC1")+" -  HC2: "+database.starsAttributes.getFloat(i,"HC1")+" -   X: "+database.starsAttributes.getFloat(i,"X")+" -   Y: "+database.starsAttributes.getFloat(i,"Y"));
  }
  */
  //---------------------------------------
  
  starSystem = new StarSystem(database);
  
  starSystem.plot();
  
}


void draw() {
  
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

  
  background(0);
  
  database.timePassedFromStarApp = timeControl.timePassingCalc(database.timePassedFromStarApp);
  
  Runnable updateDatabase = new Update(database, starSystem, "starsTable", true);
  Thread updateDB = new Thread(updateDatabase);
  updateDB.start();
  
  Runnable updateSystem = new Update(database, starSystem, "starSystem", true);
  Thread updateSys = new Thread(updateSystem);
  updateSys.start();
  
  starSystem.plot();
  
  /*
  fill(255, 0, 0);
  rect(numero++, numero++, 30,30);
  */
  
}
