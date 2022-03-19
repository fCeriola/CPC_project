public class Pollution {
  
  // ATTRIBUTES
  
  private float xyIncrement;
  private float zoff;
  private float zIncrement;
 
  private color[][] matrix = new color[width][height];
  private color dayExt1;
  private color dayExt2;
  private color nightExt1;
  private color nightExt2;
  
  
  // ======================================================
  // CONSTRUCTOR
  
  public Pollution() {
    
    noiseDetail(5, 0.2);
    this.xyIncrement = 0.01;
    this.zoff = 0.0;
    this.zIncrement = 0.1;
    
    this.dayExt1 = color(242, 205, 152, 40);
    this.dayExt2 = color(130, 147, 122, 60);
    this.nightExt1 = color(121, 114, 97);
    this.nightExt2 = color(21, 17, 7, 10);
    
  }
  
  // ======================================================
  // PRIVATE METHODS
  
  // ======================================================
  // PUBLIC METHODS
  
  public void update(String string) {
    
    color colore;
    color ext1;
    color ext2;
    
    if (string == "night") {
      ext1 = this.nightExt1;
      ext2 = this.nightExt2;
    }
    else {
      ext1 = this.dayExt1;
      ext2 = this.dayExt2;
    }
    float xoff = 0.0; // Start xoff at 0
    
    // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
    for (int x = 0; x < width; x++) {
      xoff += xyIncrement;   // Increment xoff
      float yoff = 0.0;   // For every xoff, start yoff at 0
      for (int y = 0; y < height; y++) {
        yoff += xyIncrement; // Increment yoff

        // Calculate noise and scale by 255
        float percentage = noise(xoff, yoff, zoff);
        colore = lerpColor(ext1, ext2, percentage);
      
        // Set each pixel onscreen to a grayscale value
        matrix[x][y] = colore;
      }
    }
    zoff += zIncrement;
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
