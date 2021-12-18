public class Particle{
  
  int posx;
  int posy;
  float diam;
  
  
  Particle(int posx, int posy, float diam){
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
