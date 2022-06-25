public class Pollution {
  
  // ATTRIBUTES
  
  private float xyIncrement;
  private float zoff;
  private float zIncrement;
 
  private color[][] matrix;
  private color extColor1;
  private color extColor2;
  
  private float maxMajority;
  private float minMajority;
  private float smooth;
  private float step;
  private float prevStep;
  
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
    
    this.maxMajority = 0.02;
    this.minMajority = 0.0;
    this.smooth = 0.2;
    this.step = 0.001;
    this.prevStep = 0.001;
    
  }
  
  // ======================================================
  // PRIVATE METHODS
  
  private float[] countingStars(int totN, int nRed, int nBlue, int totRedBlue, int nWhite) {
    
    float totalStarDensity;
    float majority;
    
    majority = (float)(nBlue - nRed) / (float)totRedBlue;
    majority = map(majority, -1.0, 1.0, 0.0, 1.0);
    
    totalStarDensity = (float)(nRed + nBlue + 0.2*nWhite) / (float)totN;
    totalStarDensity = map(totalStarDensity, 0.01, 0.2, 0.0, 1.0);


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
    int nWhitePixels = 0;
    int totRedBlue = 0;
    int nTotPixels = 0;
    
    loadPixels();
    
    for(int i = 0; i<width; i++) {
      for(int j = 0; j<height; j++) {
        
        if (dist(xPuntatore, yPuntatore, i, j) > pointerRadius) {
          colore = lerpColor(pollution.matrix[i][j], pixels[i+j*width], 0.1);
          pixels[i+j*width] = colore;
        }
        else {
          if (pixels[i+j*width] != backColor) {
            red = red(pixels[i+j*width]);
            blue = blue(pixels[i+j*width]);
            //println(red, blue);
            if (red > blue) {
              nRedPixels += 2;
            }
            else if (blue > red) {
              nBluePixels += 1;
            }
            else {
              nWhitePixels += 1;
            }
            totRedBlue += 1;
          }
          nTotPixels += 1;
        }
      }
    }
    
    float[] rateColor = countingStars(nTotPixels, nRedPixels, nBluePixels, totRedBlue, nWhitePixels);
    
    starRate(rateColor[0], ableton, ip);
    starColor(rateColor[1], ableton, ip);
    
    updatePixels();
  }
  
}
