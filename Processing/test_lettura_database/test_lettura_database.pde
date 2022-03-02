
//Table starsCoord;
StarsTable database;
Star star;
PrintWriter output;
int xScreen = 1080;
int yScreen = 720;

void setup() {
  
  //good for MacbookPro 2021
  size(1512,850);
  
  //size(xScreen,yScreen);
  //frameRate(60);
  
  background(0);
  
  database = new StarsTable();  
  
  
  //In order to acces to the database attribute:
  //databse.starsAttributes.getFloat(row,column)
  
  
  //----------------------------------------------
  //DEBUG
  
  output = createWriter("debug_out.txt");
  for (int i=0;i<database.starsAttributes.getRowCount();i++){
    output.println(database.starsAttributes.getInt(i,"index")+" -  class: "+ char(database.starsAttributes.getInt(i,"class")) + "    subclass: "+ database.starsAttributes.getFloat(i,"subclass") + "   T: " + database.starsAttributes.getFloat(i, "T"));
  }
  //----------------------------------------------
  
  float x=0;
  float y=0;
  color colore = color(250);
  String[] columns = {"X", "Y"};
  
  for (int i=0;i<database.starsAttributes.getRowCount();i++) {
    TableRow row = database.starsAttributes.getRow(i);
    
    database.debug(row, columns, false);
    
    x = row.getFloat("X");
    y = row.getFloat("Y");
    x = map(x, -1, 1, 0, width);
    y = map(y, -1, 1, height, 0);
    colore = database.convColor(row);
    star = new Star(x, y, colore);
    star.plot();
  }   //<>//
 
 
}


void draw() {
  
  
  
}
