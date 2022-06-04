public class Sky{
  
  // ATTRIBUTES 
  
  private color col1;
  private color col2;
  private float x;
  private float y;
  private float smooth;
  private int nStrati;
  private float[] prevOpacity;

  // ======================================================
  // CONSTRUCTOR
  
  public Sky(){
    this.x = 0;
    this.y = 0;
    this.col1 = color(250, 225, 200);
    this.col2 = color(166, 215, 232);
    this.smooth = 0.2; 
    this.nStrati = 50;
    this.prevOpacity = new float[nStrati];
  }
  
  // ======================================================
  // PRIVATE MATHODS
  
  // ======================================================
  // PUBLIC METHODS
  
  public void plot(float currentOpacity){
    
    float opacity;
    
    for(int i=nStrati-1;i>=0;i--){
      noStroke();
      
      color c = lerpColor(col1, col2, float(i)/50.0);
      
      opacity = smooth*currentOpacity + (1-smooth)*prevOpacity[i];
      
      fill(c, i*opacity/20.0);
      ellipse(x,y,i*width/24.0,i*width/24.0);
      
      prevOpacity[i] = opacity;
    }
  }
  
  public void update(float xCoord, float yCoord){
    this.x = xCoord;
    this.y = yCoord;
  }
   
}
