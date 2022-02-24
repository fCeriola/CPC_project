//class containing all the coordinates and parameters of the stars
//reads from file with reference J2000 in equatorial coordinates

public class starsTable{
  
  //attributes
  private Table starsAttributes; //containes data
  //extremes used to map values from indexes to usable numbers
  private float maxVM;
  private float minVM;
  private float maxBV;
  private float minBV;
  private float maxUB;
  private float minUB;
  //extreme colors
  private color redStar;
  private color blueStar;
  private color whiteStar;
  
  //constructor
  starsTable() {
    
    //load file
    String[] lines = loadStrings("bsc5.dat");
    
    starsAttributes = new Table();
    
    //Right Asception
    //angle with respect to the meridian passing through the "First Point of Aries"
    //measured along the place of the equator
    //h [0;24) -> hours; m [0;60) -> minutes; s [0;60) -> seconds
    starsAttributes.addColumn("RAh");
    starsAttributes.addColumn("RAm");
    starsAttributes.addColumn("RAs");
    
    //Declination
    //angle with respect to the celestial equator
    //measured along the meridian passing through the star
    //d (-90;+90) -> degrees; m [0;60) -> arcminutes; s [0;60) -> arcseconds
    starsAttributes.addColumn("DCd");
    starsAttributes.addColumn("DCm");
    starsAttributes.addColumn("DCs");
    
    //visual magnitude
    //index representing brightness and distance
    //the higher the value, the lower the brightness
    starsAttributes.addColumn("VM");
    
    //B-V
    //difference in magnitude between blue index and visual index
    //index representing the color
    //lower value -> blue, higher value -> red
    starsAttributes.addColumn("B-V");
    
    //U-B
    //difference in magnitude between ultraviolet index and blue index
    //index representing the temperature
    //the higher the value, the lower the temperature
    starsAttributes.addColumn("U-B");
    
    
    for (int i=0; i<lines.length; i++) {
      
      //grab the single read line
      String line = lines[i];
      
      //substring(beginIndex(inclusive), endIndex(exclusive))
      float RAh = float(line.substring(75,77));
      float RAm = float(line.substring(77,79));
      float RAs = float(line.substring(79,83));
      
      float DCd = float(line.substring(75,77));
      float DCm = float(line.substring(77,79));
      float DCs = float(line.substring(79,83));
      
      float VM = float(line.substring(102,107));
      
      float BV = float(line.substring(109,114));
      
      float UB = float(line.substring(115,120));      
      
      
      //add new row to table for the each star
      TableRow newRow = starsAttributes.addRow();
      
      newRow.setFloat("RAh", RAh);
      newRow.setFloat("RAm", RAm);
      newRow.setFloat("RAs", RAs);
      
      newRow.setFloat("DCd", DCd);
      newRow.setFloat("DCm", DCm);
      newRow.setFloat("DCs", DCs);
      
      newRow.setFloat("VM", VM);
      
      newRow.setFloat("B-V", BV);
      
      newRow.setFloat("U-B", UB);
      
    }
    
    maxVM = findMax("VM");
    minVM = findMin("VM");
    maxBV = findMax("B-V");
    minBV = findMin("B-V");
    maxUB = findMax("U-B");
    minUB = findMin("U-B");
    
    colorMode(HSB, 360, 100, 100);
    redStar = color(14, 27, 100);
    blueStar = color(235, 21, 98);
    whiteStar = color(0, 0, 100);
    
  }
  
  //methods
  public float getRA(int index) {
    //converts right ascension from hour-minute-second to a single value in degrees
    TableRow row = starsAttributes.getRow(index);
    float hour = row.getFloat("RAh");
    float min = row.getFloat("RAm");
    float sec = row.getFloat("RAs");
    
    // ...............
    
    return 0;
  }
  
  public float getDC(int index) {
    //converts declination degree-arcminute-arcseconds to a single value in degrees
    TableRow row = starsAttributes.getRow(index);
    float deg = row.getFloat("DCd");
    float min = row.getFloat("DCm");
    float sec = row.getFloat("DCs");
    
    // ................
    
    return 0; 
  }
  
  public float getMagnitude(int index) {
    //converts VM index value into a scale 0-100
    TableRow row = starsAttributes.getRow(index);
    float VM = row.getFloat("VM");
    
    float brightness = map(VM, minVM, maxVM, 0, 100);
    
    return brightness;
  }
  
  public color getColor(int index) {
    //converts B-V index value into color
    TableRow row = starsAttributes.getRow(index);
    float BV = row.getFloat("B-V");
    float percentage = map(BV, minBV, maxBV, -1, 1);
    
    if (percentage < 0) {
      color colore = lerpColor(whiteStar, blueStar, abs(percentage));
    }
    else if (percentage >= 0) {
      color colore = lerpColor(whiteStar, redStar, percentage);
    }
    
    return colore;
  }
  
  public float getTemperature(int index) {
    //converts U-B index value into temperature in Kelvin
    TableRow row = starsAttributes.getRow(index);
    float UB = row.getFloat("U-B");
    
    float T = 4600 * ( 1/(0.92*UB+1.7) + 1/(0.92*UB+0.62));
    
    return T;
  }
  
  private float findMax(String attribute) {
    //finds the maximum value inside the table of a given attribute
    float[] column = new float[starsAttributes.getRowCount()];
    for (int i=0; i<column.length; i++) {
      column[i] = starsAttributes.getRow(i).getFloat(attribute);
    }
    column = sort(column);
    return column[column.length-1];
  }
  
  private float findMin(String attribute) {
    //finds the minimum value inside the table of a given attribute
    float[] column = new float[starsAttributes.getRowCount()];
    for (int i=0; i<column.length; i++) {
      column[i] = starsAttributes.getRow(i).getFloat(attribute);
    }
    column = sort(column);
    return column[0];
  }

}
