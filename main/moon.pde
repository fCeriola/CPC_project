public class Moon {
  
  private float xCoord;
  private float yCoord;
  private float increment;
  private float radius;
  
  public Moon(float xCoord, float yCoord){
    this.xCoord = xCoord;
    this.yCoord = yCoord;
    this.increment = 0.05;
    this.radius = 50.0;
  }
  
  public void plot(){
    
    noStroke();
    for (float j = 10; j>=0; j=j-0.5) {
      color c = lerpColor(255,0,j/10);
      fill(c, (10-j)*10+100);
      ellipse(xCoord,yCoord, 20*j, 20*j);
    }
    
    //Perlin Noise2D Moon
    loadPixels();
    float xoff = -frameCount/100.0; // Start xoff at 0
    // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
    for (float i = 0.0; i < this.radius; i=i+0.5) {
      xoff += increment;   // Increment xoff 
      float yoff = frameCount/50.0;   // For every xoff, start yoff at 0
      for (float j = 0.0; j < TWO_PI; j=j+0.01) {
        yoff += increment; // Increment yoff
        
        // Calculate noise and scale by 255
        float bright = map(noise(xoff,yoff)*255, 0, 255, 120, 255);
  
        // Try using this line instead
        //float bright = random(0,255);
        int x = int(xCoord + i*cos(j));
        int y = int(yCoord + i*sin(j));
        // Set each pixel onscreen to a grayscale value
        if((x+y*width)<0||(x+y*width)>(width*height)){
          x=0;
          y=0;
          pixels[x+y*width] = color(bright);
        }
        else {
          pixels[x+y*width] = color(bright);
        }
      }
    }
    
    updatePixels(); 
  }
  
  
  public void update() {
    this.xCoord -= direction*0.1*frameRate;//*timeLapseValue/120.0;
    //sinusoid:   y offset   amplitude      screen width as half wavelength     x offset
    this.yCoord = height/4 + (height/2)*sin(PI*(0.9*width-xCoord)/(0.9*width) + PI/10);
  }
  
}
