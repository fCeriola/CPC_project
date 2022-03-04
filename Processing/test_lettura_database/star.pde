// class that containes information and methods about the single star


public class Star{
  
  // ATTRIBUTES
  PVector location;
  float radius;
  color colore;
  
  //---------------------------------------
  // CONSTRUCTOR
  
  Star(float xCoord, float yCoord, color colore) {
    this.location = new PVector(xCoord, yCoord);
    this.radius = map(alpha(colore), 0, 255, 1, 5);
    this.colore = colore;
  }
  
  //---------------------------------------
  // PUBLIC METHODS
  
  public void plot() {
    noStroke();
    fill(this.colore);
    ellipse(this.location.x, this.location.y, this.radius, this.radius);
  }
  
  public void updatePosition(float coord1, float coord2){
    this.location.x = coord1;
    this.location.y = coord2;
  }
  
}
