//class containing all the coordinates and parameters of the stars
//reads from file with reference J2000 in equatorial coordinates

public class StarsTable{
  
  // ATTRIBUTES
  
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
  
  //ROME coordinates (for testing)
  private float userLatitude = 40.779897;//41.902782;
  private float userLongitude = -73.968565;//12.496366;
  
  //DEBUG VARIABLE
  int columnIndex;
  int starIndex;
  int starNumb;
  
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
    
    //Right Ascension and Declination converted in single float values [degrees]
    starsAttributes.addColumn("RA");
    starsAttributes.addColumn("DEC");
    
    //Visual Magnitude
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
    
    //Class
    //character representing the class of the star
    //it indicates the temperature interval into which the star resides
    starsAttributes.addColumn("class");
    
    //SubClass
    //integer value representing the subclass of the star
    //it indicates the temperature percentage into the temperature interval given by the class
    starsAttributes.addColumn("subclass");
    
    //Horizontal Coordinates
    //converted horizontal coordinates in deg through the 
    //private method convHorizCoord(int index)
    starsAttributes.addColumn("HC1");
    starsAttributes.addColumn("HC2");
    
    //Cartesian Coordinates
    //converted cartesian coordinates through the private 
    //method convCartCoord
    starsAttributes.addColumn("X");
    starsAttributes.addColumn("Y");
    
    //Apparent Magnitude
    //converted values (0-100) for the magnitude with the 
    //private method convMagnitude(int index)
    starsAttributes.addColumn("AM");
     
    //T Temperature
    //converted values (0-100) for the temperature with the 
    //private method convTemperature(int index)
    starsAttributes.addColumn("T"); //<>//
    
    //<>//
    for (int i=0; i<lines.length; i++) {
      
      //grab the single read line
      String line = lines[i];
      
      starIndex = i+1;
      
      //substring(beginIndex(inclusive), endIndex(exclusive))
      float RAh = float(line.substring(75,77));
      float RAm = float(line.substring(77,79));
      float RAs = float(line.substring(79,83));
      
      float DECd = float(line.substring(83,86));
      float DECm = float(line.substring(86,88));
      float DECs = float(line.substring(88,90));
      
      float VM = float(line.substring(102,107));
      
      float BV = float(line.substring(109,114));
      float UB = float(line.substring(115,119));     
      
      //class is given by a number, so take the char from the line,
      //convert to int in order to save on table and it will be
      //converted back to char when used
      int sClass = int(line.charAt(129));
      float sSubClass = float(line.substring(130,131));
      
      float[] values = {sClass, RAh, RAm, RAs, DECd, DECm, DECs, sSubClass};
      
      
      //add new row to table for the each star
      if (isAStar(values)){
        TableRow newRow = starsAttributes.addRow();
        newRow.setInt("index", starIndex);
      
        newRow.setFloat("RAh", RAh);
        newRow.setFloat("RAm", RAm);
        newRow.setFloat("RAs", RAs);
        
        newRow.setFloat("DECd", DECd);
        newRow.setFloat("DECm", DECm);
        newRow.setFloat("DECs", DECs);
        
        newRow.setFloat("VM", VM);
        
        newRow.setFloat("B-V", BV);
        newRow.setFloat("U-B", UB);
        
        newRow.setInt("class", sClass);
        newRow.setFloat("subclass", sSubClass);
        
        float RA = convRA(newRow);
        newRow.setFloat("RA", RA);
        float DEC = convDEC(newRow);
        newRow.setFloat("DEC", DEC);
        
        float[] HC = convHorizCoord(newRow);
        float HC1 = HC[0];
        float HC2 = HC[1];
        newRow.setFloat("HC1", HC1);
        newRow.setFloat("HC2", HC2);
        
        float [] XY = convCartCoord(newRow);
        float X = XY[0];
        float Y = XY[1];
        newRow.setFloat("X", X);
        newRow.setFloat("Y", Y);
       
        /* //debug
        if (str(X) == "NaN" || str(Y) == "NaN") {
          println(RAh, RAm, RAs, DECd, DECm, DECs);
          println(RA, DEC);
          println(HC1, HC2);
          println(X, Y);
        }
        */
        
        float T = convTemperature(newRow);
        newRow.setFloat("T", T);
        
        float AM = convApparentMagnitude(newRow);
        newRow.setFloat("AM", AM);
        
      } else {
        //println("NaN number found at element: " + starIndex + " at the column at index: " + columnIndex); //debug
        starNumb++;
      } //<>//
       //<>//
    }
    //println("Number of neglected lines: " + starNumb); //debug
    
    colorMode(RGB, 255);
    redStar = color(255,156,60,255);
    blueStar = color(143,182,255,73);
    whiteStar = color(240,240,253,255);
    
  }
  
  
  
  //PRIVATE METHODS
  //=====================================================
  
  //-----------------------------------------------------
  //CONVERSIONS
  
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
    
    float RA = convRA(row);
    float DEC = convDEC(row);
    
    float daysToday = daysSinceJ2000();
    float currentHour = localHourFraction();
    
    //find local siderial time with given formula
    float LST = (100.46 + 0.985647 * daysToday + userLongitude + 15 * currentHour) % 360;
    
    //Hour angle
    float HA = LST - RA;
    
    RA = radians(RA);
    DEC = radians(DEC);
    HA = radians(HA);
    float userLat = radians(userLatitude);
    
    float starAltitude = asin(sin(DEC)*sin(userLat) + cos(DEC)*cos(userLat)*cos(HA));
    float starAzimuth = acos((sin(DEC) - sin(starAltitude)*sin(userLat)) / (cos(starAltitude)*cos(userLat)));
    
    float[] horizCoord = {degrees(starAzimuth), degrees(starAltitude)};
    
    return horizCoord;
  }
  
  private float[] convCartCoord(TableRow row){
    //converts horizontal coordinates to cartesian coordinates
    float HC1 = row.getFloat("HC1");
    float HC2 = row.getFloat("HC2");
    
    float x = cos(HC1)*sin(HC2);
    float y = sin(HC1)*sin(HC2);

    float [] XY = {x, y};
    return XY;
  }
  
  
  private float convApparentMagnitude(TableRow row) {
    //converts VM index value into a scale 0-100 
    float VM = row.getFloat("VM");
    
    // CHECK FOR EXTREMES
    float AM = map(VM, 0, 7, 0, 255);
    
    return AM;
  }
  
  
  private float convTemperature(TableRow row) {
    
    char sClass = char(row.getInt("class"));
    
    int Tmax = 0;
    int Tmin = 0;
    
    switch(sClass) {
      case 'O': 
        Tmax = 50000;
        Tmin = 28000;
        break;
      case 'B': 
        Tmax = 28000;
        Tmin = 10000;
        break;
      case 'A': 
        Tmax = 10000;
        Tmin = 7500;
        break;
      case 'F':
        Tmax = 7500;
        Tmin = 6000;
        break;
      case 'G':
        Tmax = 6000;
        Tmin = 4900;
        break;
      case 'K':
        Tmax = 4900;
        Tmin = 3500;
        break;
      case 'M':
        Tmax = 3500;
        Tmin = 2000;
        break;
      default:
        break;
    }
    
    float sSubClass = row.getFloat("subclass");
    
    float T = map(sSubClass, 0, 9, Tmin, Tmax);
    return T;
  } //<>//
  
  
  /*
  //-----------------------------------------------------
  //MAXIMA
  
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
  
  */
  
  //----------------------------------------------------
  //EXISTENCE CHECK
  
  private boolean isAStar(float[] values) {
    //used to check if for a certain star all the values we need are given and correctly read
    //starts from false, if the class is correct, sets it to true, than checks the rest
    boolean answer = false;
    
    char sClass = char(int(values[0]));
    char[] possibleClasses = {'O', 'B', 'A', 'F', 'G', 'K', 'M'};
    for (int i=0; i< possibleClasses.length; i++) {
      if (sClass == possibleClasses[i])
        answer = true;
    }
    for (int i=1; i < values.length; i++) {
      if (str(values[i]) == "NaN")
        answer = false;
        columnIndex = i;
    }
    return answer;
  }
  
  
  
  //PUBLIC METHODS
  //=====================================================
 
  //The table cannot store color type data: setting the color has to be 
  //in another rendering function
 
  public color convColor(TableRow row) {
    //from temperature computes the color based on star classification chart
    float T = row.getFloat("T");
    
    color colore = color(0,0,0);
    float percentage = 0;
    
    if (T > 6750) {
      percentage = map(T, 6750, 50000, 0, 1);
      colore = lerpColor(whiteStar, blueStar, percentage);
    } else {
      percentage = map(T, 2000, 6750, 0, 1);
      colore = lerpColor(redStar, whiteStar, percentage);
    }
    
    float cRed = red(colore);
    float cGreen = green(colore);
    float cBlue = blue(colore);
    
    float AM = row.getFloat("AM");
    
    colore = color(cRed, cGreen, cBlue, AM);
    
    println(AM);
    
    return colore;
  }
  
  
  
  //MAPPING CART COORD
  //----------------------------------------
  
  //public float[][] cartCoordMap (int xScreen, int yScreen){
  //      Xmax = findMax("X");
  //      Xmin = findMin("X");
  //      float [][] mapXY = new float[starsAttributes.getRowCount()][starsAttributes.getRowCount()];
  //      float[] X = map(
        
       
       
  //  return 
  //}
  
  
  
  
  
  
  /*
  
  //Overloading
  public int getRowCount(){
    return starsAttributes.getRowCount();
  }
  
  
  //get params from the new object StarsTable 
  //
  
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
    
  */
  
  
}
