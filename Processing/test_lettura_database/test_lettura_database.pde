
//Table starsCoord;
StarsTable database;


void setup() {
  
  //good for MacbookPro 2021
  //size(1512,850);
  
  //size(1080,720);
  //frameRate(60);
  //background(255);
  database = new StarsTable();
  print("ciao");
  
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
