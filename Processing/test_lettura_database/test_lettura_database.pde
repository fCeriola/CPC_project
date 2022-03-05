StarsTable database;
Star star;
StarSystem starSystem;
PrintWriter output;
float[] extremes;

void setup() {
  
  size(1512,850);
  frameRate(60);
  background(0);
  
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
  
} //<>//



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

  database.update();
  starSystem.update();
  starSystem.plot();
  
  
}
