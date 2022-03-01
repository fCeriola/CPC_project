// class that containes information and methods about the single star


public class Star{
  
  // ATTRIBUTES
  PVector location;
  float radius;
  
  
  //---------------------------------------
  // CONSTRUCTOR
  
  Star(float xCoord, float yCoord) {
    this.location = new PVector(xCoord, yCoord);
    this.radius = 2;
  }
  
  //---------------------------------------
  // PUBLIC METHODS
  
  public void plot() {
    noStroke();
    fill(255);
    ellipse(this.location.x, this.location.y, this.radius, this.radius);
  }
  
}
