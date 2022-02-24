
Table starsCoord; 

void setup() {
  
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
    
    float DCh = float(line.substring(75,77));
    float DCm = float(line.substring(77,79));
    float DCs = float(line.substring(79,83));
    
    TableRow newRow = starsCoord.addRow();
    
    newRow.setFloat("RAh", RAh);
    newRow.setFloat("RAm", RAm);
    newRow.setFloat("RAs", RAs);
    
    newRow.setFloat("DCh", RAh);
    newRow.setFloat("DCm", RAm);
    newRow.setFloat("DCs", RAs);
  }
  
  
  
  //char b1 = lines[1].charAt(81);
  
  //println(binary(b1));
}


void draw() {

}
