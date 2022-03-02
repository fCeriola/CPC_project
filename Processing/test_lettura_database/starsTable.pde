//class containing all the coordinates and parameters of the stars
//reads from file with reference J2000 in equatorial coordinates

public class StarsTable{
  
  // ATTRIBUTES
  
  private Table starsAttributes; //containes data
  //extremes used to map values from indexes to usable numbers
  //these are initialized inside the contructor with values searched directly from the database
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
  
  //ROME coordinates (for testing)
  private float userLatitude = 41.902782;
  private float userLongitude = 12.496366;
  
  //DEBUG VARIABLE
  int starIndex;
  int starsNeglected;
  
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
    maxVM = 7.96;
    minVM = -1.46;
    
    //B-V
    //difference in magnitude between blue index and visual index
    //index representing the color
    //lower value -> blue, higher value -> red
    starsAttributes.addColumn("B-V");
    maxBV = 2.35;
    minBV = -0.28;
    
    //U-B
    //difference in magnitude between ultraviolet index and blue index
    //index representing the temperature
    //the higher the value, the lower the temperature
    starsAttributes.addColumn("U-B");
    maxUB = 2.48;
    minUB = -1.11;
    
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
    //converted values (0-100) for the magnitude with the  //<>//
    //private method convMagnitude(int index)
    starsAttributes.addColumn("AM"); //<>//
     
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
      float UB = float(line.substring(115,120));     
      
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
        
        float T = convTemperature(newRow);
        newRow.setFloat("T", T);
        
        float AM = convApparentMagnitude(newRow);
        newRow.setFloat("AM", AM);
        
      } else {
        println("Neglected star at index " + starIndex); //debug
      } //<>//
       //<>// //<>//
    } //<>//
    println("Number of neglected lines: " + starsNeglected); //debug
    
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
    float AM = map(VM, minVM, maxVM, 0, 255);
    
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
  
  private float convBV(TableRow row) {
    //converts VM index value into a scale 0-100  //<>//
    float BV = row.getFloat("B-V");
    
    // CHECK FOR EXTREMES
    BV = map(BV, minBV, maxBV, 0, 100);
    
    return BV;
  }
  
  private float convUB(TableRow row) { //<>//
    //converts VM index value into a scale 0-100 
    float UB = row.getFloat("U-B"); //<>//
    
    // CHECK FOR EXTREMES
    UB = map(UB, minUB, maxUB, 0, 100);
    
    return UB;
  }
   //<>// //<>//
  
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
    }
    if (answer == false)
      starsNeglected++;
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
    
    return colore;
  }
  
  
  
  
  // -------------------------------------
  //DEBUG
  
  public void debug(TableRow row, boolean printAllStars, boolean onlyUsefullValues) {
    //all the columns inside the given row are considered
    //if printAllStars is given true then prints the line even if the star does not present any NaN
    //if onlyUsefullValues is given true then it doesn't consider the column just read and not processed
    //remember that under columns "index" and "class" we have int values, all the other columns contain floats
    
    //HOW TO USE:
    //give the row you want to analyse;
    //set printAllStars only if you want to print the row even if no NaN is detected, in general it should be set to false
    //set onlyUsefullValues if you don't want to see also stuff that is directly inserted inside the row as it is read from database, but
    //only those values that are processed inside the constructor and then inserted
    
    int columnNumber = row.getColumnCount();
    int index = row.getInt("index");
    
    if (onlyUsefullValues) {
      if (printAllStars) {
        String phraseToBePrinted = "star " + index + ":   ";
        
        String addToPhrase;
        String column;
        
        for (int i=0; i<columnNumber; i++) {
          column = row.getColumnTitle(i);
          if (column=="index" || column=="RAh" || column=="RAm" || column=="RAs" || column=="DECd" || column=="DECm" || column=="DECs" || column=="VM" || column=="B-V" || column=="U-B")
            continue;
          else if (column == "class")
            addToPhrase = str(row.getInt(column));
          else 
            addToPhrase = str(row.getFloat(column));
          
          if (addToPhrase == "NaN") {
            println("\n Found NaN on star at index " + index + " and column " + column + "\n");
            return;
          }
          phraseToBePrinted = phraseToBePrinted + column + ": " + addToPhrase + " ;   ";
        }
        println(phraseToBePrinted + "\n");
        return;
      }
      else {
        String valueToCheck;
        String column;
        
        for (int i=0; i<columnNumber; i++) {
          column = row.getColumnTitle(i);
          if (column=="index" || column=="RAh" || column=="RAm" || column=="RAs" || column=="DECd" || column=="DECm" || column=="DECs" || column=="VM" || column=="B-V" || column=="U-B")
            continue;
          else if (column == "class")
            valueToCheck = str(row.getInt(column));
          else
            valueToCheck = str(row.getFloat(column));
            
          if (valueToCheck == "NaN") {
            println("\n Found NaN on star at index " + index + " and column " + column + "\n");
            return;
          }
        }
        return;
      }
    }
    else {
      if (printAllStars) {
        String phraseToBePrinted = "star " + index + ":   ";
        
        String addToPhrase;
        String column;
        
        for (int i=0; i<columnNumber; i++) {
          column = row.getColumnTitle(i);
          if (column == "index")
            continue;
          else if (column == "class")
            addToPhrase = str(row.getInt(column));
          else 
            addToPhrase = str(row.getFloat(column));
          
          if (addToPhrase == "NaN") {
            println("\n Found NaN on star at index " + index + " and column " + column + "\n");
            return;
          }
          phraseToBePrinted = phraseToBePrinted + column + ": " + addToPhrase + " ;   ";
        }
        print(phraseToBePrinted + "\n");
        return;
      }
      else {
        String valueToCheck;
        String column;
        
        for (int i=0; i<columnNumber; i++) {
          column = row.getColumnTitle(i);
          if (column == "index")
            continue;
          else if (column == "class")
            valueToCheck = str(row.getInt(column));
          else
            valueToCheck = str(row.getFloat(column));
            
          if (valueToCheck == "NaN") {
            println("\n Found NaN on star at index " + index + " and column " + column + "\n");
            return;
          }
        }
        return;
      }
    }
  }
  
  
  public void debug(TableRow row, String[] values, boolean printAllStars) {
    //values should contain the columnn names (strings) you want to print for the given row
    //if printAllStars is true then the function prints the row even if the star does not present any NaN
    //remember that under columns "index" and "class" we have int values, all the other columns contain floats
    
    //HOW TO USE:
    //give the row you want to analyse; give a String array with the name of the columns you want to print;
    //set printAllStars only if you want to print the row even if no NaN is detected, in general it should be set to false
    
    int index = row.getInt("index");
    
    if (printAllStars) {
      String phraseToBePrinted = "star " + index + ":   ";
      String addToPhrase;
      
      for (int i=0; i<values.length; i++) {
        if (values[i] == "index")
          continue;
        else if (values[i] == "class")
          addToPhrase = str(row.getInt(values[i]));
        else
          addToPhrase = str(row.getFloat(values[i]));
          
        if (addToPhrase == "NaN") {
          println("\n Found NaN on star at index " + index + " and column " + values[i] + "\n");
          return;
        }
        phraseToBePrinted = phraseToBePrinted + values[i] + ": " + addToPhrase + " ;   ";
      }
      println(phraseToBePrinted + "\n");
      return;
    }
    else {
      String valueToCheck;
      
      for (int i=0; i<values.length; i++) {
        if (values[i] == "index")
          continue;
        else if (values[i] == "class")
          valueToCheck = str(row.getInt(values[i]));
        else
          valueToCheck = str(row.getFloat(values[i]));
          
        if (valueToCheck == "NaN") {
          println("\n Found NaN on star at index " + index + " and column " + values[i] + "\n");
          return;
        }
      }
      return;
    }
  }
  public float[] minMaxHC(){
      float[] coord1 = new float[starsAttributes.getRowCount()];
      float[] coord2 = new float[starsAttributes.getRowCount()];
    
      for (int i=0;i<starsAttributes.getRowCount();i++){
          coord1[i] = starsAttributes.getFloat(i, "HC1");
          coord2[i] = starsAttributes.getFloat(i, "HC2");
      }
    
      coord1 = sort(coord1);
      coord2 = sort(coord2);
      
      float HC1max = coord1[coord1.length-1];
      int a = 1;
      while (str(HC1max)=="NaN"){
        a++;
        HC1max = coord1[coord1.length-a];
      }
      float HC1min = coord1[0];
      float HC2max = coord2[coord2.length-1];
      float HC2min = coord2[0];
      float[] minMax = {HC1min,HC1max,HC2min,HC2max};
      return minMax;
  }
  
  
  
  public void updateDatabase(){
  for (int i=0; i<starsAttributes.getRowCount(); i++){
      TableRow row = starsAttributes.getRow(i);
      float[] updatedHC = convHorizCoord(row);
      row.setFloat("HC1",updatedHC[0]);
      row.setFloat("HC2",updatedHC[1]);
    }
  }
  
  
  
}
