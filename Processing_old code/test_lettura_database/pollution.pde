public class Pollution {
  
  // ATTRIBUTES
  
  private float xyIncrement;
  private float zoff;
  private float zIncrement;
 
  private color[][] matrix;
  private color extColor1;
  private color extColor2;
  
  
  // ======================================================
  // CONSTRUCTOR
  
  public Pollution() {
    
    noiseDetail(5, 0.2);
    this.xyIncrement = 0.01;
    this.zoff = 0.0;
    this.zIncrement = 0.1;
    
    this.matrix = new color[width][height];
    this.extColor1 = color(121, 114, 97);
    this.extColor2 = color(21, 17, 7, 10);
    
  }
  
  // ======================================================
  // PRIVATE METHODS
  
  // ======================================================
  // PUBLIC METHODS
  
  public void update() {
    
    color colore;
    
    float xoff = 0.0; // noise generation parameter
    
    // For every x,y coordinate in a 2D space, calculate a noise value
    for (int x = 0; x < width; x++) {
      xoff += xyIncrement;   // increment xoff
      float yoff = 0.0;   // noise generation parameter
      for (int y = 0; y < height; y++) {
        yoff += xyIncrement; // increment yoff
        
        float percentage = noise(xoff, yoff, zoff); // use noise value as percentage for the lerpColor
        colore = lerpColor(this.extColor1, this.extColor2, percentage);
        
        matrix[x][y] = colore; // store the computed color inside a matrix
      }
    }
    zoff += zIncrement; // increment zoff
  }
  
  public void plot(float xPuntatore, float yPuntatore, float pointerRadius) {
    
    color colore;
    
    loadPixels();
    
    for(int i = 0; i<width; i++) {
      for(int j = 0; j<height; j++) {
        
        if (dist(xPuntatore, yPuntatore, i, j) > pointerRadius) {
          colore = lerpColor(pollution.matrix[i][j], pixels[i+j*width], 0.1);
          pixels[i+j*width] = colore;
        }
        else
          countingStars(pixels[i+j*width]);
      }
    }
    updatePixels();
  }
  
}
