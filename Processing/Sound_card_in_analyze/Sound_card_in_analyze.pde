import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 1024;
float[] spectrum = new float[bands];

void setup() {
  size(512, 360);
  background(255);
    
  //Setting Inputdevice 9 = Focusrite 18i8;
  Sound s = new Sound(this);
  s.inputDevice(9);

  fft = new FFT(this, bands);
  //set the input in to number 5 in the sound card
  //(in processing starts from 0)
  in = new AudioIn(this, 4);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn in the fft
  fft.input(in);
}      

void draw() { 
  background(255);
  fft.analyze(spectrum);

  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  line( i, height, i, height - spectrum[i]*height*10 );
  } 
}
