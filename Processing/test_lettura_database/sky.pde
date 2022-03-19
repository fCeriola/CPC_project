public class Sky{
  
  // ATTRIBUTES 
  
  private color col1;
  private color col2;
  private float x;
  private float y;
  private float smooth;
  private int nStrati = 50;
  private float[] prevAmp = new float[nStrati];

  // ======================================================
  // CONSTRUCTOR
  
  public Sky(float x, float y,color col1, color col2){
    this.x = x;
    this.y = y;
    this.col1 = col1;
    this.col2 = col2;
    this.smooth = 0.2; 
  }
  
  // ======================================================
  // PRIVATE MATHODS
  
  // ======================================================
  // PUBLIC METHODS
  
  public void plot(float amp){
    float amplitude;
    for(int i=nStrati-1;i>=0;i--){
      noStroke();
      color c = lerpColor(col1, col2, float(i)/50.0);
      amplitude = smooth*amp + (1-smooth)*prevAmp[i];
      fill(c,i*amplitude/20.0);
      ellipse(x,y,i*width/24.0,i*width/24.0);
      prevAmp[i] = amplitude;
    }
  }
  
  public void update(float xCoord, float yCoord){
    this.x = xCoord;
    this.y = yCoord;
  }
   
}
