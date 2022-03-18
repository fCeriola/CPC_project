public class Sky{
  
  color col1;
  color col2;
  float x;
  float y;
  int gradient;


  Sky(float x, float y,color col1, color col2){
    this.x = x;
    this.y = y;
    this.col1 = col1;
    this.col2 = col2;
    
    
  }
  
  public void plot(){
    for(int i=50;i>=0;i--){
      noStroke();
      color c = lerpColor(col1, col2, float(i)/50.0);
      fill(c);
      ellipse(x,y,i*width/100.0,i*width/100.0);
    }
  }
  
  public void updateCoord(float xCoord, float yCoord){
    x = xCoord;
    y = yCoord;
  }
}
