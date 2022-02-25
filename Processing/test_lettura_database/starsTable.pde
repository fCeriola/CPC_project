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
    starsAttributes.addColumn("DECd");
    starsAttributes.addColumn("DECm");
    starsAttributes.addColumn("DECs");
    
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
      
      float DECd = float(line.substring(75,77));
      float DECm = float(line.substring(77,79));
      float DECs = float(line.substring(79,83));
      
      float VM = float(line.substring(102,107));
      
      float BV = float(line.substring(109,114));
      
      float UB = float(line.substring(115,120));      
      
      
      //add new row to table for the each star
      TableRow newRow = starsAttributes.addRow();
      
      newRow.setFloat("RAh", RAh);
      newRow.setFloat("RAm", RAm);
      newRow.setFloat("RAs", RAs);
      
      newRow.setFloat("DECd", DECd);
      newRow.setFloat("DECm", DECm);
      newRow.setFloat("DECs", DECs);
      
      newRow.setFloat("VM", VM);
      
      newRow.setFloat("B-V", BV);
      
      newRow.setFloat("U-B", UB);
      
    }
    
    maxVM = findMax("VM");
    minVM = findMin("VM");
    maxBV = findMax("B-V");
    minBV = findMin("B-V");
    maxUB = findMax("U-B");
    
    colorMode(HSB, 360, 100, 100);
    redStar = color(14, 27, 100);
    blueStar = color(235, 21, 98);
    whiteStar = color(0, 0, 100);
    
  }
  
  //methods
  private float getRA(int index) {
    //converts right ascension from hour-minute-second to a single value in degrees
    TableRow row = starsAttributes.getRow(index);
    float hour = row.getFloat("RAh");
    float min = row.getFloat("RAm");
    float sec = row.getFloat("RAs");
    
    float secFraction = sec/60;
    float minFraction = min/60 + secFraction;
    float hourTot = hour + minFraction;
    
    float RA = hourTot * 15;  // 24 hour -> 360/24 = 15 degrees each
    
    return RA;
  }
  
  private float getDEC(int index) {
    //converts declination degree-arcminute-arcseconds to a single value in degrees
    TableRow row = starsAttributes.getRow(index);
    float deg = row.getFloat("DECd");
    float min = row.getFloat("DECm");
    float sec = row.getFloat("DECs");
    
    float secFraction = sec/60;
    float minFraction = min/60 + secFraction;
    float DEC = deg + minFraction;
    
    return DEC; 
  }
  
  public float[] getHorizCoord(int index) {
    //converts equatorial coordinates into horizontal coordinates
    float[] horizCoord = new float[2];
    
    float RA = getRA(index);
    float DEC = getDEC(index);
    
    float daysToday = daysSinceJ2000();
    float currentHour = localHourFraction();
    
    // ricavare coordinate latitudine e longitudine di utente da gps
    // float userLatitude = latitudine
    // float userLongitude = longitudine
    
    //find local siderial time with given formula
    float LST = (100.46 + 0.985647 * daysToday + userLongitude + 15 * currentHour) % 360;
    
    //Hour angle
    float HA = LST - RA;
    
    float starAltitude = asin(sin(DEC)*sin(userLatitude) + cos(DEC)*cos(userLatitude)*cos(HA));
    float starAzimuth = (sin(DEC) - pow(sin(starAltitude),2)) / pow(cos(starAltitude),2);
    
    horizCoord[0] = starAzimuth;
    horizCoord[1] = starAltitude;
    
    return horizCoord;
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
    
    color colore = color(0,0,0);
    
    if (percentage < 0) {
      colore = lerpColor(whiteStar, blueStar, abs(percentage));
    }
    else if (percentage >= 0) {
      colore = lerpColor(whiteStar, redStar, percentage);
    }
    
    return colore;
  }
  
  public float getTemperature(int index) {
    //converts U-B index value into temperature in Kelvin
    TableRow row = starsAttributes.getRow(index);
    float UB = row.getFloat("U-B");
    
    float Tkelvin = 4600 * ( 1/(0.92*UB+1.7) + 1/(0.92*UB+0.62));
    float Tmax = 4600 * ( 1/(0.92*maxUB+1.7) + 1/(0.92*maxUB+0.62));
    
    float T = map(Tkelvin, 0, Tmax, 0, 100);
    
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
