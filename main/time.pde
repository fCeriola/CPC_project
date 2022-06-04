import java.util.Calendar;


public class Time {
  
  //ARGUMENTS
  
  private Calendar currentMoment;
  private float timeLapse;
  
  // ======================================================
  // CONSTRUCTOR
  
  public Time(float timeLapse) {
    this.timeLapse = timeLapse;
    this.currentMoment = Calendar.getInstance();
  }
  
  // ======================================================
  // METHODS
  
  public float localHourFraction() {
    //returns the local hour value read from computer converted in a single decimal value
    //it's called only once in the app, when the starsTable object is instantiated inside the setup
    int hour = currentMoment.get(Calendar.HOUR_OF_DAY);
    int minute = currentMoment.get(Calendar.MINUTE);
    int second = currentMoment.get(Calendar.SECOND);
    int millisecond = currentMoment.get(Calendar.MILLISECOND);
    
    float secFraction = second + millisecond/1000;
    float minFraction = minute + secFraction/60;
    float localHour = hour + minFraction/60;
    
    return localHour;
  }
  
  public float timePassingCalc(float valueToIncrease) {
    //returns a value to be added to the computed localHourFraction given to
    //starsTable object instance as it is created
    //use this function as a counter that controls time evolution instead of continuously grabbing
    //the current hour/minute/second from the computer
    //the value of timeLapse controls the speed
    float increament = timeLapse * 1/frameRate;
    float increasedValue = valueToIncrease + increament / (60*60);
    
    return increasedValue;
  }
  
  public float daysSinceJ2000(float hour) {
    //returns the number of days between 1st January 2000 and today
    //takes into account passed hours from the beginning of today's day
    int year = currentMoment.get(Calendar.YEAR);
    int month = currentMoment.get(Calendar.MONTH);
    int day = currentMoment.get(Calendar.DAY_OF_MONTH);
    
    switch(year%4) {
      case 0:
        switch(month) {
          case 2: 
            day += 31;
            break;
          case 3: 
            day += 60;
            break;
          case 4: 
            day += 91;
            break;
          case 5: 
            day += 121;
            break;
          case 6: 
            day += 152;
            break;
          case 7: 
            day += 182;
            break;
          case 8: 
            day += 213;
            break;
          case 9: 
            day += 244;
            break;
          case 10: 
            day += 274;
            break;
          case 11: 
            day += 305;
            break;
          case 12: 
            day += 335;
            break;
          default:
            break;
        }
      default:
        switch(month) {
          case 2: 
            day += 31;
            break;
          case 3: 
            day += 59;
            break;
          case 4: 
            day += 90;
            break;
          case 5: 
            day += 120;
            break;
          case 6: 
            day += 151;
            break;
          case 7: 
            day += 181;
            break;
          case 8: 
            day += 212;
            break;
          case 9: 
            day += 243;
            break;
          case 10: 
            day += 273;
            break;
          case 11: 
            day += 304;
            break;
          case 12: 
            day += 334;
            break;
          default:
            break;
        }
    }
    
    float fromJ2000 = year-2000;
    float daysSince = -1.5 + 365*fromJ2000 + floor(year/4) + day + hour/24;
    
    return daysSince;  
  }
  
}
