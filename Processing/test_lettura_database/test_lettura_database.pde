StarsTable database;
Star star;
Star[] starSet;
PrintWriter output;
float[] extremes;

void setup() {
  
  size(1512,850);
  frameRate(60);
  background(0);
  
  database = new StarsTable();  
  
  starSet = new Star[database.starsAttributes.getRowCount()];
  extremes = database.minMaxHC();
  
  for (int i=0;i<database.starsAttributes.getRowCount();i++) {
    TableRow row = database.starsAttributes.getRow(i);
    
    float x = row.getFloat("HC1");
    float y = row.getFloat("HC2"); 
    x = map(x, extremes[0], extremes[1], 0, width);
    y = map(y, extremes[2], extremes[3], height, 0);
    //float x = row.getFloat("X");
    //float y = row.getFloat("Y");
    //x = map(x, -1, 1, 0, width);
    //y = map(y, -1, 1, height, 0);
    color colore = database.convColor(row);
    star = new Star(x, y, colore);
    starSet[i] = star;
  }
  
} //<>//



void draw() {
  
  //----------------------------------------------
  //DEBUG
  
  //String[] columns = {"HC1","HC2"};
  
  for (int i=0;i<database.starsAttributes.getRowCount();i++) {
    TableRow row = database.starsAttributes.getRow(i);
    database.debug(row, false, true); 
  }
  
  //----------------------------------------------
  
  
  background(0);
  for (int i=0;i<database.starsAttributes.getRowCount();i++){
    TableRow row = database.starsAttributes.getRow(i);
    float x = row.getFloat("HC1");
    float y = row.getFloat("HC2");
    x = map(x, extremes[0], extremes[1], 0, width);
    y = map(y, extremes[2], extremes[3], height, 0);
    starSet[i].updatePosition(x,y);
  }
  
  for (int i=0;i<starSet.length;i++){
    starSet[i].plot();
  }
   
  database.updateDatabase();
  
}
