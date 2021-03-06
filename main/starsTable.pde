//class containing all the coordinates and parameters of the stars //<>//
//reads from file with reference J2000 in equatorial coordinates

public class StarsTable{
  
  // ATTRIBUTES
  
  private Table starsAttributes; //contains data
  private float appStartHourFraction; //time corresponding to app launch as a fraction of 24 hours
  private float timePassedFromAppStart; //stores the amount of time passed from app launch
  private int starIndex; //enumerate stars
  
  public float userLatitude;
  public float userLongitude;
  
  //ROME coordinates (for testing)
  //public float userLatitude = 41.902782;
  //public float userLongitude = 12.496366;
  
  //DEBUG VARIABLE
  //private int starsNeglected;
  
  // ======================================================
  //CONSTRUCTOR
  
  public StarsTable(float latitude, float longitude) {
    
    //sets coordinates from the gps
    this.userLatitude = latitude;
    this.userLongitude = longitude;
    
    //load file
    String[] lines = loadStrings("bsc5.dat");
    
    //initialize time reference variables
    this.appStartHourFraction = timeControl.localHourFraction();
    this.timePassedFromAppStart = 0;
    
    //create the table to be filled with stars data
    this.starsAttributes = new Table();
    
    //add columns to the table
    
    this.starsAttributes.addColumn("index");
    
    //Right Asception
    //angle with respect to the meridian passing through the "First Point of Aries"
    //measured along the place of the equator
    //RAh [0;24) -> hours; RAm [0;60) -> minutes; RAs [0;60) -> seconds
    //it will be converted to single float value RA [degrees]
    this.starsAttributes.addColumn("RA");
    //Declination
    //angle with respect to the celestial equator
    //measured along the meridian passing through the star
    //DECd (-90;+90) -> degrees; DECm [0;60) -> arcminutes; DECs [0;60) -> arcseconds
    //it will be converted to single float value DEC [degrees]
    this.starsAttributes.addColumn("DEC");
    
    //Horizontal Coordinates
    //converted horizontal coordinates in deg through the 
    //private method convHorizCoord(int index)
    this.starsAttributes.addColumn("AZ");
    this.starsAttributes.addColumn("AL");
    
    //Cartesian Coordinates
    //converted cartesian coordinates through the private 
    //method convCartCoord
    this.starsAttributes.addColumn("X");
    this.starsAttributes.addColumn("Y");
    
    //Apparent Magnitude
    //from visual magnitude (index representing brightness and distance)
    //we obtain a mapped value in the range (0-100) with the
    //private method convMagnitude(int index)
    this.starsAttributes.addColumn("AM");
    
    //Class
    //character representing the class of the star
    //it indicates the temperature interval into which the star resides
    this.starsAttributes.addColumn("class");
    
    //SubClass
    //integer value representing the subclass of the star
    //it indicates the temperature percentage into the temperature interval given by the class
    this.starsAttributes.addColumn("subclass");
     
    //Temperature
    //converted values (0-100) for the temperature with the 
    //private method convTemperature(int index)
    this.starsAttributes.addColumn("T");
    
   
    for (int i=0; i<lines.length; i++) {
      
      //grab one line
      String line = lines[i];
      
      this.starIndex++;
      
      //substring(beginIndex(inclusive), endIndex(exclusive))
      
      float RAh = float(line.substring(75,77));
      float RAm = float(line.substring(77,79));
      float RAs = float(line.substring(79,83));
      
      float DECd = float(line.substring(83,86));
      float DECm = float(line.substring(86,88));
      float DECs = float(line.substring(88,90));
      
      float VM = float(line.substring(102,107));    
      
      //class is given by a number, so take the char from the line,
      //convert to int in order to save on table and it will be
      //converted back to char when used
      int sClass = int(line.charAt(129));
      float sSubClass = float(line.substring(130,131));
      
      float[] values = {sClass, RAh, RAm, RAs, DECd, DECm, DECs, sSubClass};
      
      
      //add new row to table for the each star
      if (this.isAStar(values)){
        TableRow newRow = starsAttributes.addRow();
        newRow.setInt("index", starIndex);     
        
        newRow.setInt("class", sClass);
        newRow.setFloat("subclass", sSubClass);
        
        float RA = convRA(RAh, RAm, RAs);
        newRow.setFloat("RA", RA);
        float DEC = convDEC(DECd, DECm, DECs);
        newRow.setFloat("DEC", DEC);
        
        float[] HC = fromEquaToHoriz(newRow);
        float AZ = HC[0];
        float AL = HC[1];
        newRow.setFloat("AZ", AZ);
        newRow.setFloat("AL", AL);
        
        float T = convTemperature(newRow);
        newRow.setFloat("T", T);
        
        float AM = convApparentMagnitude(VM);
        newRow.setFloat("AM", AM);
        
      } else {
        starIndex--;
        //println("Neglected star at index " + i+1); //debug
      }
    
    }
    //println("Number of neglected lines: " + starsNeglected); //debug
    
  }
  
  
  // ======================================================
  //PRIVATE METHODS
  
  //-----------------------------------------------------
  //CONVERSIONS
  
  private float convRA(float RAh, float RAm, float RAs) {
    //converts right ascension from hour-minute-second to a single value in degrees
    
    float secFraction = RAs/60;
    float minFraction = RAm/60 + secFraction;
    float hourTot = RAh + minFraction;
    
    float RA = hourTot * 15;  // 24 hour -> 360/24 = 15 degrees each
    
    return RA;
  }
  
  private float convDEC(float DECd, float DECm, float DECs) {
    //converts declination degree-arcminute-arcseconds to a single value in degrees
    
    float secFraction = DECs/60;
    float minFraction = DECm/60 + secFraction;
    float DEC = DECd + minFraction;
    
    return DEC;
  }
  
  private float[] fromEquaToHoriz(TableRow row) {
    //converts equatorial coordinates into horizontal coordinates
    
    float RA = row.getFloat("RA");
    float DEC = row.getFloat("DEC");
    
    float currentHour = this.appStartHourFraction + this.timePassedFromAppStart;
    float daysToday = timeControl.daysSinceJ2000(currentHour);
    
    //find local siderial time with given formula
    float LST = (100.46 + 0.985647 * daysToday + userLongitude + 15 * currentHour) % 360;
    
    //Hour angle
    float HA = LST - RA;
    
    RA = radians(RA);
    DEC = radians(DEC);
    HA = radians(HA);
    float userLat = radians(userLatitude);
    
    float starAltitude = asin(sin(DEC)*sin(userLat) + cos(DEC)*cos(userLat)*cos(HA));
    float A = (sin(DEC) - sin(starAltitude)*sin(userLat)) / (cos(starAltitude)*cos(userLat));
    A = constrain(A, -1, 1);
    A = acos(A);

    float starAzimuth = 0;
    if (sin(HA) >= 0)
      starAzimuth = 360 - degrees(A);
    else
      starAzimuth = degrees(A);
    
    float[] horizCoord = {starAzimuth, degrees(starAltitude)};
    
    return horizCoord;
  }
  
  private float convApparentMagnitude(float VM) {
    //converts VM index value into a scale 0-100 
    
    //extremes found from database inspection
    float maxVM = 7.96;
    float minVM = -1.46;
    
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
  }
  
  
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
    
    //debug
    //if (answer == false)
      //starsNeglected++;
      
    return answer;
  }
  
  
  // ======================================================
  //PUBLIC METHODS
  
  public void update(){
    this.timePassedFromAppStart = timeControl.timePassingCalc(this.timePassedFromAppStart);
    
    for (int i=0; i<starsAttributes.getRowCount(); i++){
      TableRow row = starsAttributes.getRow(i);
      
      float[] updatedHC = fromEquaToHoriz(row);
      row.setFloat("AZ", updatedHC[0]);
      row.setFloat("AL", updatedHC[1]);
    }
  }
  
  

  
  
  // ------------------------------------------------------
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
  
}
