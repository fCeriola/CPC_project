public class Point{
  
  int posx;
  int posy;
  float diam;
  
  
  Point(int posx, int posy, float diam){
    this.posx = posx;
    this.posy = posy;
    this.diam = diam;
    
    
    circle(posx, posy, diam); 
  }
  
 public int getPosx(){
    return this.posx;
  }
  
  public int getPosy(){
    return this.posy;
  }
  
}
