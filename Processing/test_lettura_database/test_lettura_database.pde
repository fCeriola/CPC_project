
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
  color colore;
  
  for (int i=0;i<database.starsAttributes.getRowCount();i++) {
    x = database.starsAttributes.getFloat(i, "X");
    y = database.starsAttributes.getFloat(i, "Y");
    x = map(x, -1, 1, 0, width);
    y = map(y, -1, 1, height, 0);
    colore = database.convColor(i);
    star = new Star(x, y, colore);
    star.plot();
  }
   //<>//
  
  //for (int ii=0; ii<database.getRowCount(); ii++){
  //  print(database.RAh);
  //}
  
  /*
  
  
  String[] lines = loadStrings("bsc5.dat");
  
  starsCoord = new Table();
  
  //Given a Certain meridian, this is the angle 
  //over the meridian 0-360 degrees (h,m,s) --> Right Asception
  starsCoord.addColumn("RAh");
  starsCoord.addColumn("RAm");
  starsCoord.addColumn("RAs");
  
  //
  //over the meridian -90 - +90 degrees (degrees,m,s)
  starsCoord.addColumn("DCh");
  starsCoord.addColumn("DCm");
  starsCoord.addColumn("DCs");
  
  
  
  for (int i=0; i<lines.length; i++) {
    String line = lines[i];
    //substring(beginIndex(inclusive), endIndex(exclusive))
    float RAh = float(line.substring(75,77));
    float RAm = float(line.substring(77,79));
    float RAs = float(line.substring(79,83));
    
    float DCh = float(line.substring(83,86));
    float DCm = float(line.substring(86,88));
    float DCs = float(line.substring(88,90));
    
    TableRow newRow = starsCoord.addRow();
    
    newRow.setFloat("RAh", RAh);
    newRow.setFloat("RAm", RAm);
    newRow.setFloat("RAs", RAs);
    
    newRow.setFloat("DCh", DCh);
    newRow.setFloat("DCm", DCm);
    newRow.setFloat("DCs", DCs);
    
    println(starsCoord.getRow(i).getString("DCh"));
  }
  
  
 */
 
 
}


//void draw() {
  
  
  
//}
