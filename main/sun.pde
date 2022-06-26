public class Sun {
  
  // ARGUMENTS
  private float xCoord;
  private float yCoord;
  private float[] bandAmp = new float[bands];
  private float[] prevBandAmp = new float[bands];
  private float smooth;
  
  private color sunInt;
  private color sunExt;
  private color rayExt;
  private int radius;
  
  // ======================================================
  // CONSTRUCTOR
  public Sun(float xCoord, float yCoord) {
    this.xCoord = xCoord;
    this.yCoord = yCoord;
    this.radius = 75;
    this.smooth = 0.1;
    
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
      ellipse(0,0, 2*this.radius/10*j, 2*this.radius/10*j);
    }
    
    popMatrix();
   
  }
  
  public void update() {
    
    this.xCoord -= direction*0.5*frameRate;
    //sinusoid:   y offset   amplitude      screen width as half wavelength     x offset
    this.yCoord = height/3 + (height/3)*sin(PI*(1.1*width-xCoord)/(1.1*width) - PI/12);
  }
  
  //public void reflex(PImage citylight){
  //  city.tint();
  //}
  
}
