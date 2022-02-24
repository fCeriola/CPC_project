
Table starsCoord; 

void setup() {
  
  String[] lines = loadStrings("bsc5.dat");
  
  starsCoord = new Table();
  
  starsCoord.addColumn("RAh");
  starsCoord.addColumn("RAm");
  starsCoord.addColumn("RAs");
  
  for (int i=0; i<lines.length; i++) {
    char[] line = lines[i].toCharArray();
    char[] c3 = new char[2];
    c3[0] = line[76];
    c3[1] = line[77];
    int[] RAh = int(c3);
    
    TableRow newRow = starsCoord.addRow();
  }
  
  char b1 = lines[1].charAt(81);
  
  println(binary(b1));
}


void draw() {

}
