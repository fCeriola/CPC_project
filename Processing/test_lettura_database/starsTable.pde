//class containing all the coordinates and parameters of the stars
//reads from file with reference J2000 in equatorial coordinates

public class StarsTable{
  
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
  
  //ROME 
  private float userLatitude = 41.902782;
  private float userLongitude = 12.496366;
  //
  
  //constructor
  StarsTable() {
    
    //load file
    String[] lines = loadStrings("bsc5.dat");
    
    starsAttributes = new Table();
    
    starsAttributes.addColumn("index");
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
    
    
    starsAttributes.addColumn("RA");
    starsAttributes.addColumn("DEC");
    
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
    
    //Horizontal Coordinates
    //converted horizontal coordinates in deg through the 
    //private method convHorizCoord(int index)
    starsAttributes.addColumn("HC1");
    starsAttributes.addColumn("HC2");
    
    //M Magnitude
    //converted values (0-100) for the magnitude with the 
    //private method convMagnitude(int index)
    starsAttributes.addColumn("M");
     
    //T Temperature
    //converted values (0-100) for the temperature with the 
    //private method convTemperature(int index)
    starsAttributes.addColumn("T");
    //<>//
      for (int i=0; i<lines.length; i++) {
      
        //grab the single read line
        String line = lines[i];
        
        int index = i+1;
        
        //substring(beginIndex(inclusive), endIndex(exclusive))
        float RAh = float(line.substring(75,77));
        float RAm = float(line.substring(77,79));
        float RAs = float(line.substring(79,83));
        
        float DECd = float(line.substring(68,71));
        float DECm = float(line.substring(71,73));
        float DECs = float(line.substring(73,75));
        
        float VM = float(line.substring(102,107));
        
        float BV = float(line.substring(109,114));
        
        float UB = float(line.substring(115,119));     
        
        //add new row to table for the each star
      
        if (str(RAh)!= "NaN"){
          TableRow newRow = starsAttributes.addRow();
          newRow.setInt("index", index);
        
          newRow.setFloat("RAh", RAh);
          newRow.setFloat("RAm", RAm);
          newRow.setFloat("RAs", RAs);
          
          newRow.setFloat("DECd", DECd);
          newRow.setFloat("DECm", DECm);
          newRow.setFloat("DECs", DECs);
          
          newRow.setFloat("VM", VM);
          
          newRow.setFloat("B-V", BV);
          
          newRow.setFloat("U-B", UB);
          
          float RA = convRA(newRow);
          newRow.setFloat("RA", RA);
          float DEC = convDEC(newRow);
          newRow.setFloat("DEC", DEC);
          
          float[] HC = convHorizCoord(newRow);
          float HC1 = HC[0];
          float HC2 = HC[1];
          newRow.setFloat("HC1", HC1);
          newRow.setFloat("HC2", HC2);
          
          float T = convTemperature(newRow);
          newRow.setFloat("T", T);
         
          
          //maxVM = findMax("VM");
          //minVM = findMin("VM");
          //maxBV = findMax("B-V");
          //minBV = findMin("B-V");
          //maxUB = findMax("U-B");
          
          //float M = convMagnitude(newRow);
          //newRow.setFloat("M", M);
        }else{
        println(" NaN number find at elemnt: "+i);
        } //<>//
      }
    
    
    
    colorMode(HSB, 360, 100, 100);
    redStar = color(14, 27, 100);
    blueStar = color(235, 21, 98);
    whiteStar = color(0, 0, 100);
  }
  
  
  
  //PRIVATE METHODS
  //=====================================================
  
  //CONVERSIONS
  //-----------------------------------------------------
  private float convRA(TableRow row) {
    //converts right ascension from hour-minute-second to a single value in degrees
    float hour = row.getFloat("RAh");
    float min = row.getFloat("RAm");
    float sec = row.getFloat("RAs");
    
    float secFraction = sec/60;
    float minFraction = min/60 + secFraction;
    float hourTot = hour + minFraction;
    
    float RA = hourTot * 15;  // 24 hour -> 360/24 = 15 degrees each
    
    return RA;
  }
  
  private float convDEC(TableRow row) {
    //converts declination degree-arcminute-arcseconds to a single value in degrees
    float deg = row.getFloat("DECd");
    float min = row.getFloat("DECm");
    float sec = row.getFloat("DECs");
    
    float secFraction = sec/60;
    float minFraction = min/60 + secFraction;
    float DEC = deg + minFraction;
    
    return DEC; 
  }
  
  private float[] convHorizCoord(TableRow row) {
    //converts equatorial coordinates into horizontal coordinates
    float[] horizCoord = new float[2];
    
    float RA = convRA(row);
    float DEC = convDEC(row);
    
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
  
  private float convMagnitude(TableRow row) {
    //converts VM index value into a scale 0-100
    float VM = row.getFloat("VM");
    
    float brightness = map(VM, minVM, maxVM, 0, 100);
    
    return brightness;
  }
  
  
  private float convTemperature(TableRow row) {
    //converts U-B index value into temperature in Kelvin
    float UB = row.getFloat("U-B");
    
    float Tkelvin = 4600 * ( 1/(0.92*UB+1.7) + 1/(0.92*UB+0.62));
    float Tmax = 4600 * ( 1/(0.92*maxUB+1.7) + 1/(0.92*maxUB+0.62));
    
    float T = map(Tkelvin, 0, Tmax, 0, 100);
    
    return T;
  }
  
  
  
  //MAXIMA
  //-----------------------------------------------------
  
  private float findMax(String attribute) {
    //finds the maximum value inside the table of a given attribute
    float[] column = new float[starsAttributes.getRowCount()]; //<>//
    print(column.length);
    for (int i=0; i<column.length; i++) { //<>//
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
  
  
  
  //PUBLIC METHODS
 //=====================================================
 
 //The table cannot store color type data: setting the color has to be 
 //in another rendering function
 
  public color convColor(int index) {
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
  
  
  //Overloading
  public int getRowCount(){
    return starsAttributes.getRowCount();
  }
  
  //get params from the new object StarsTable 
  
   public float getRA(int index){
        return starsAttributes.getFloat(index, "RA");
      }
      public float getRAh(int index){
        return starsAttributes.getFloat(index, "RAh");
      }
      public float getRAm(int index){
        return starsAttributes.getFloat(index, "RAm");
      }
      public float getRAs(int index){
        return starsAttributes.getFloat(index, "RAs");
      }
      
  public float getDEC(int index){
        return starsAttributes.getFloat(index, "DEC");
      }
      public float getDECd(int index){
        return starsAttributes.getFloat(index, "DECd");
      }
      public float getDECm(int index){
        return starsAttributes.getFloat(index, "DECm");
      }
      public float getDECs(int index){
        return starsAttributes.getFloat(index, "DECs");
      }
      
  public float getVM(int index){
        return starsAttributes.getFloat(index, "VM");
      }
  
  public float getBV(int index){
        return starsAttributes.getFloat(index, "B-V");
      }
      
  public float getUB(int index){
      return starsAttributes.getFloat(index, "U-B");
    }
  
  public float getT(int index){
      return starsAttributes.getFloat(index, "T");
    }
    

  
  
  
  
}
