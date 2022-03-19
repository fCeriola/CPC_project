public class Sky{
  
  color col1;
  color col2;
  float x;
  float y;
  float smooth;
  int nStrati = 50;
  float[] prevAmp = new float[nStrati];


  Sky(float x, float y,color col1, color col2){
    this.x = x;
    this.y = y;
    this.col1 = col1;
    this.col2 = col2;
    this.smooth = 0.2; 
    //this.nStrati = 50;
  }
  
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
  
  public void updateCoord(float xCoord, float yCoord){
    this.x = xCoord;
    this.y = yCoord;
  }
  
 
}
