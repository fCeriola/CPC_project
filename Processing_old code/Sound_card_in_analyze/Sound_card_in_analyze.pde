import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 32;
float[] spectrum = new float[bands];


void setup() {
  size(1080, 720);
  background(0);
  frameRate(60);
    
  //Setting Inputdevice 9 = Focusrite 18i8;
  Sound s = new Sound(this);
  s.inputDevice(0);

  fft = new FFT(this, bands);
  //set the input in to number 5 in the sound card
  //(in processing starts from 0)
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn in the fft
  fft.input(in);
}      

void draw() { 
  background(0);
  smooth();
  
 
  fft.analyze(spectrum);
  float cx = width/2; 
  float cy = height/2;
 for(int i = 1; i < bands; i++){
   float angle = 2*PI/bands*i;
   float px =  cx+spectrum[i-1]*cos(angle)*100000;
   float py =  cy+spectrum[i-1]*sin(angle)*100000;
   float x =  cx+spectrum[i]*cos(angle)*100000;
   float y =  cy+spectrum[i]*sin(angle)*100000;
   stroke(255);
   line(px, py, x, y);
  }
    //float posx = map (i, 0, bands, 0, width);
    //line( posx, height, posx, height - spectrum[i]*height*40 );
  
  

}
