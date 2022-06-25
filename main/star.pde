// class that containes information and methods about the single star


public class Star{
  
  // ATTRIBUTES
  private int index;
  private float AZ;
  private float AL;
  private float xCoord;
  private float yCoord;
  private float temperature;
  private float apparentMagnitude;
  private color colore;
  private float radius;
  private float angle;
  
  //extreme colors
  private color redStar;
  private color blueStar;
  private color whiteStar;
  
  // ======================================================
  // CONSTRUCTOR
  
  public Star(TableRow row) {
    //takes a row of the database table as argument and grabs all the information needed
    redStar = color(255,156,60);
    blueStar = color(143,182,255);
    whiteStar = color(240,240,253);
    
    this.index = row.getInt("index");
    this.AZ = row.getFloat("AZ");
    this.AL = row.getFloat("AL");
    this.fromHorizToCart(this.AZ, this.AL);
    this.temperature = row.getFloat("T");
    this.apparentMagnitude = row.getFloat("AM");
    this.convColor(this.temperature);
    this.radius = map(this.apparentMagnitude, 0, 255, 0.2, 5);
    this.angle = random(0,2*PI);
  }
  
  // ======================================================
  // PRIVATE METHODS
  
  private void convColor(float temperature) {
    //from temperature computes the color based on star classification chart
    
    color colore;
    float percentage;
    
    if (temperature > 6750) {
      percentage = map(temperature, 6750, 50000, 0, 1);
      colore = lerpColor(whiteStar, blueStar, percentage);
    } else {
      percentage = map(temperature, 2000, 6750, 0, 1);
      colore = lerpColor(redStar, whiteStar, percentage);
    }
    
    this.colore = colore;
  }
  
  private void fromHorizToCart(float AZ, float AL){
    //converts horizontal coordinates to cartesian coordinates
    float AZ_rad = radians(AZ);
    float AL_rad = radians(AL);
    
    //cos(altitude) projects the star onto the plane (x,y)
    //north is at azimuth = 0 and lies on y axis from bottom left corner to top left corner
    float X = sin(AZ_rad)*cos(AL_rad);
    float Y = cos(AZ_rad)*cos(AL_rad);
    
    //zoom in / zoom out
    float beta = 100;
    this.xCoord = map(X, -1, 1, -beta, beta+width);
    this.yCoord = map(Y, -1, 1, -beta, beta+height);
  }
  
  // ======================================================
  // PUBLIC METHODS
  
  public void plot() {
    
    pushMatrix();
    beginShape();
    noStroke();
    translate(this.xCoord, this.yCoord);
    rotate(this.angle);
    
    /*
    fill(this.colore, apparentMagnitude/6);
    ellipse(1, 0, this.radius*4.5, this.radius/3);
    fill(this.colore, apparentMagnitude/3);
    ellipse(0, -1, this.radius/2, this.radius*3);
    */
    
    
    fill(this.colore, apparentMagnitude);    
    ellipse(0, 0, this.radius, this.radius);
    
    endShape();
    popMatrix();
    
  }
  
  public void update(float AZ, float AL) {
    this.AZ = AZ;
    this.AL = AL;
    this.fromHorizToCart(this.AZ, this.AL);
  }
  
}
