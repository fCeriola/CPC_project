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
  
  // ======================================================
  // CONSTRUCTOR
  public Sun(float xCoord, float yCoord) {
    this.xCoord = xCoord;
    this.yCoord = yCoord;
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
    translate(xCoord, yCoord);    
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
    //sun.xCoord=cos(frameCount/220.0)*width/2.0+width/2;
    //sun.yCoord=sin(frameCount/220.0)*height/2.0+height/2;
    sun.xCoord = frameCount*2.0-600;
    sun.yCoord = height/2;
  }
  
  //public void reflex(PImage citylight){
  //  city.tint();
  //}
  
}