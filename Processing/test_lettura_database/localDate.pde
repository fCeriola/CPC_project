public float localHourFraction() {
  //returns the local hour value read from computer converted in a single decimal value
  float lHour = float(hour());       //hour() returns current UTD local hour [0,24)
  float lMin = float(minute());      //minute() returns current UTD local minute [0,60)
  float lSec = float(second());      //second() returns current UTD local second [0,60)
  float lMillis = float(millis());   //millis() returns current UTD local milliseconds [0,100)
  
  float secFraction = lSec + lMillis/100;
  float minFraction = lMin + secFraction/60;
  float localHour = lHour + minFraction/60;
  
  return localHour;
}

public float daysSinceJ2000() {
  //returns the number of days between 1st January 2000 and today
  //takes into account passed hours from the beginning of today's day
  float lDay = float(day());   //day() returns current day [1,31]
  int lMonth = month();        //month() returns current month [1,12]
  int lYear = year();          //year() returns current year
  
  switch(lYear%4) {
    case 0:
      switch(lMonth) {
        case 2: 
          lDay = lDay + 31;
          break;
        case 3: 
          lDay = lDay + 60;
          break;
        case 4: 
          lDay = lDay + 91;
          break;
        case 5: 
          lDay = lDay + 121;
          break;
        case 6: 
          lDay = lDay + 152;
          break;
        case 7: 
          lDay = lDay + 182;
          break;
        case 8: 
          lDay = lDay + 213;
          break;
        case 9: 
          lDay = lDay + 244;
          break;
        case 10: 
          lDay = lDay + 274;
          break;
        case 11: 
          lDay = lDay + 305;
          break;
        case 12: 
          lDay = lDay + 335;
          break;
        default:
          break;
      }
    default:
      switch(lMonth) {
        case 2: 
          lDay = lDay + 31;
          break;
        case 3: 
          lDay = lDay + 59;
          break;
        case 4: 
          lDay = lDay + 90;
          break;
        case 5: 
          lDay = lDay + 120;
          break;
        case 6: 
          lDay = lDay + 151;
          break;
        case 7: 
          lDay = lDay + 181;
          break;
        case 8: 
          lDay = lDay + 212;
          break;
        case 9: 
          lDay = lDay + 243;
          break;
        case 10: 
          lDay = lDay + 273;
          break;
        case 11: 
          lDay = lDay + 304;
          break;
        case 12: 
          lDay = lDay + 334;
          break;
        default:
          break;
      }
  }
  
  float fromJ2000 = lYear-2000;
  float daysSince = -1.5 + 365*fromJ2000 + floor(lYear/4) + lDay + localHourFraction()/24;
  
  return daysSince;  
}
