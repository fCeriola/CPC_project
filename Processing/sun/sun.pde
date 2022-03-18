import processing.sound.*;

AudioIn in;
FFT fft;
int bands = 64;
float[] spectrum = new float[bands];
BandPass bandpass;

color ext1;
color ext2;
color ext3;
color ext4;
float numb;
float smooth;
float prevAmp;
float amp;

void setup() {
  size(1500, 800);
  frameRate(60);
  
  prevAmp = 0;
  
  smooth = 0.1;
  
  in = new AudioIn(this,0);
  in.start();
  fft = new FFT(this, bands);
  fft.input(in);
  /*
  bandpass = new BandPass(this);
  bandpass.process(in);
  bandpass.freq(2000);
  bandpass.bw(80);
  */
  
  ext2 = color(250, 120, 13);
  ext1 = color(250, 32, 13);
  ext3 = color(250, 227, 13);
  ext4 = color(250, 120, 13);

 
}

void draw() {
  background(0);
  
  fft.analyze(spectrum);
  
  translate(width/2, height/2);
  noStroke();
  
  for (int j=20; j>=0; j--) {
    numb = float(j)/10;
    color c = lerpColor(ext2, ext3, numb);
    fill(c,(10-j)*10+100);
    beginShape();
    for(int i = 0; i<bands; i++) {
      amp = (1000*i*spectrum[i]);
      amp = (smooth*amp + (1-smooth)*prevAmp)+5*j;
      vertex(amp*cos(2*i*PI/bands), amp*sin(2*i*PI/bands));
    }
    endShape(CLOSE);
  }
  
  for (int j = 10; j>=0; j--) {
     numb = float(j)/10;
     color c = lerpColor(ext1, ext2, numb);
    fill(c,(10-j)*10+100);
    fill(250, numb, 13, (10-j)*10+100);
    ellipse(0,0, 20*j, 20*j);
  }
  
  prevAmp = amp;
  
}
