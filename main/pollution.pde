//import processing.sound.*; 
//import oscP5.*;
//import netP5.*;

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
  
  private float[] countingStars(int tot, int red, int blue) {
    
    float totalStarDensity;
    float majority;
    
    majority = ( (float)blue - (float)red ) / (float)tot;
      
    majority = constrain(majority, -0.2, 0.2);
    majority = map(majority, -0.2, 0.2, 0.0, 1.0);
    
    totalStarDensity = (float)(red + blue) / (float)tot;
    
    totalStarDensity = constrain(totalStarDensity, 0.0, 0.3);
    totalStarDensity = map(totalStarDensity, 0.0, 0.3, 0.0, 1.0);
    
    float[] rateColor = {totalStarDensity, majority};
    
    return rateColor;
    
  }
  
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
    float red = 0;
    float blue = 0;
    int nRedPixels = 0;
    int nBluePixels = 0;
    int nTotPixels = 0;
    
    loadPixels();
    
    for(int i = 0; i<width; i++) {
      for(int j = 0; j<height; j++) {
        
        if (dist(xPuntatore, yPuntatore, i, j) > pointerRadius) {
          colore = lerpColor(pollution.matrix[i][j], pixels[i+j*width], 0.1);
          pixels[i+j*width] = colore;
        }
        else {
          if (pixels[i+j*width] != color(5, 3, 30)) {
            red = red(pixels[i+j*width]);
            blue = blue(pixels[i+j*width]);
            if (red > blue)
              nRedPixels += 1;
            else
              nBluePixels += 1;
          }
          nTotPixels += 1;
        }
      }
    }
    float[] rateColor = countingStars(nTotPixels, nRedPixels, nBluePixels);
    
    starRate(rateColor[0], ableton, ip);
    starColor(rateColor[1], ableton, ip);
    
    updatePixels();
  }
  
}
