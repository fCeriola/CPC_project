// class that containes information and methods about the single star


public class Star{
  
  // ATTRIBUTES
  private float xCoord;
  private float yCoord;
  private float temperature;
  private float apparentMagnitude;
  private color colore;
  private float radius;
  
  //extreme colors
  private color redStar;
  private color blueStar;
  private color whiteStar;
  
  //---------------------------------------
  // CONSTRUCTOR
  
  public Star(TableRow row) {
    //takes a row of the database table as argument and grabs all the information needed
    colorMode(RGB, 255);
    redStar = color(255,156,60,255);
    blueStar = color(143,182,255,73);
    whiteStar = color(240,240,253,255);
    
    this.xCoord = row.getFloat("X");
    this.yCoord = row.getFloat("Y");
    this.temperature = row.getFloat("T");
    this.apparentMagnitude = row.getFloat("AM");
    this.convColor(this.temperature, this.apparentMagnitude);
    this.radius = map(alpha(colore), 0, 255, 1, 5);
  }
  
  //---------------------------------------
  // PRIVATE METHODS
  
  private void convColor(float temperature, float apparentMagnitude) {
    //from temperature computes the color based on star classification chart
    
    color colore = color(0,0,0);
    float percentage = 0;
    
    if (temperature > 6750) {
      percentage = map(temperature, 6750, 50000, 0, 1);
      colore = lerpColor(whiteStar, blueStar, percentage);
    } else {
      percentage = map(temperature, 2000, 6750, 0, 1);
      colore = lerpColor(redStar, whiteStar, percentage);
    }
    
    float cRed = red(colore);
    float cGreen = green(colore);
    float cBlue = blue(colore);
    
    colore = color(cRed, cGreen, cBlue, apparentMagnitude);
    
    this.colore = colore;
  }
  
  //---------------------------------------
  // PUBLIC METHODS
  
  public void plot() {
    float cRed = red(this.colore);
    float cGreen = green(this.colore);
    float cBlue = blue(this.colore);
    float alpha = alpha(this.colore);
    
    beginShape();
    noStroke();
    fill(cRed, cGreen, cBlue, alpha/6);
    ellipse(this.xCoord, this.yCoord, this.radius*4.5, this.radius/3);
    fill(cRed, cGreen, cBlue, alpha/3);
    ellipse(this.xCoord, this.yCoord, this.radius/2, this.radius*3);
    fill(cRed, cGreen, cBlue, alpha);
    ellipse(this.xCoord, this.yCoord, this.radius, this.radius);
    endShape();
  }
  
}
