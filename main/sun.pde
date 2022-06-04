public class Sun {
  
  // ARGUMENTS
  private float appStartHourFraction;
  private float timePassedFromAppStart;
  private float altitude;
  private float xCoord;
  private float yCoord;
  private float[] bandAmp = new float[bands];
  private float[] prevBandAmp = new float[bands];
  private float smooth;
  
  private color sunInt;
  private color sunExt;
  private color rayExt;
  
  // ======================================================
  // CONSTRUCTOR
  public Sun(float xCoord, float yCoord) {
    this.altitude = -1;
    this.xCoord = xCoord;
    this.yCoord = yCoord;
    this.smooth = 0.1;
    
    //initialize time reference variables
    this.appStartHourFraction = timeControl.localHourFraction();
    this.timePassedFromAppStart = 0;
    
    this.sunInt = color(250, 56, 18);
    this.sunExt = color(250, 161, 18);
    this.rayExt = color(250, 225, 200);
  }
  
  // ======================================================
  // PRIVATE METHODS
  
  // ======================================================
  // PUBLIC METHODS
  public void plot(float[] spectrum) {
    
    noStroke();
    
    pushMatrix();
    translate(this.xCoord, this.yCoord);
    rotate(frameCount/50.0);
    
    for (int i = 0; i< bands; i++) {
      bandAmp[i] = (spectrum[i]);
      bandAmp[i] = (smooth*bandAmp[i] + (1-smooth)*prevBandAmp[i]);
      prevBandAmp[i] = bandAmp[i];
    }
    
    for (int j=20; j>=0; j--) {
      color c = lerpColor(sunExt, rayExt, float(j)/10);
      fill(c,(10-j)*10+100);
      beginShape();
      for(int i = 1; i<bands-1; i++) {
        vertex((250*j*i*log(bandAmp[i]+1)+80)*cos(2*i*PI/bands), (250*j*i*log(bandAmp[i]+1)+80)*sin(2*i*PI/bands));
      }
      endShape(CLOSE);
    }
    
    for (int j = 10; j>=0; j--) {
      color c = lerpColor(sunInt, sunExt, float(j)/10);
      fill(c, (10-j)*10+100);
      ellipse(0,0, 15*j, 15*j);
    }
    
    popMatrix();   
   
  }
  
  public void update() {
    
    // find right ascension and declination (equatorial coordinates)
    
    float currentHour = this.appStartHourFraction + this.timePassedFromAppStart;
    float daysToday = timeControl.daysSinceJ2000(currentHour);
    
    float L = 280.46646 + 0.985674 * daysToday; //mean longitude
    float g = 357.52911 + 0.9856003* daysToday; //mean anomaly
    while (L >= 360)
      L -= 360;
    while (g >= 360)
      g -= 360;
    L = radians(L);
    g = radians(g);
    float lambda = L + 1.915*sin(g) + 0.020*sin(2*g); //ecliptic longitude
    float epsilon = 23.439 - 0.0000004*daysToday; //obliquity of the elliptic
    epsilon = radians(epsilon);
    
    float RA = atan(cos(epsilon)*tan(lambda));
    float DEC = asin(sin(epsilon)*sin(lambda));
    
    
    // find latitude and azimuth (horizontal coordinates)
    float LST = (100.46 + 0.985647 * daysToday + longitude + 15 * currentHour) % 360;
    
    float HA = LST - RA;
    
    float userLatitude = radians(latitude);
    
    float sunAltitude = asin(sin(DEC)*sin(userLatitude) + cos(DEC)*cos(userLatitude)*cos(HA));
    float A = (sin(DEC) - sin(sunAltitude)*sin(userLatitude)) / (cos(sunAltitude)*cos(userLatitude));
    A = constrain(A, -1, 1);
    A = acos(A);

    float sunAzimuth = 0;
    if (sin(HA) >= 0)
      sunAzimuth = 360 - degrees(A);
    else
      sunAzimuth = degrees(A);
    
    float AZ_rad = radians(sunAzimuth);
    float AL_rad = radians(sunAltitude);
    this.altitude = AL_rad;
    
    // find x and y (cartesian coordinates)
    
    //cos(altitude) projects the star onto the plane (x,y)
    //north is at azimuth = 0 and lies on y axis from bottom left corner to top left corner
    float X = sin(AZ_rad)*cos(AL_rad);
    float Y = cos(AZ_rad)*cos(AL_rad);
    
    // THIS MUST BE ADJUSTED
    float beta = 100;
    this.xCoord = map(X, -1, 1, -beta, beta+width);
    this.yCoord = map(Y, -1, 1, -beta, beta+height);
    
    
    /*
    //sun.xCoord=cos(frameCount/220.0)*width/2.0+width/2;
    //sun.yCoord=sin(frameCount/220.0)*height/2.0+height/2;
    sun.xCoord = frameCount*2.0-600;
    sun.yCoord = height/2;
    */
  }
  
  //public void reflex(PImage citylight){
  //  city.tint();
  //}
  
}
