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
    this.radius = 2;
    this.colore = colore;
  }
  
  //---------------------------------------
  // PUBLIC METHODS
  
  public void plot() {
    noStroke();
    fill(this.colore);
    ellipse(this.location.x, this.location.y, this.radius, this.radius);
  }
  
}
