ParticleSystem ps;

int Nparticles = 1000;


void setup(){
  size(1280,720);
  
   ps = new ParticleSystem(new PVector(0,0), new PVector(1,0.5));
  
  // è qui che io riempio inizialmente il particleSystem
  // se non lo faccio poi non disegna nulla, perchè il codice
  // aggiunge una particella solo quando una (già presente) muore
  
  background(0);
}


void draw(){
  background(0);
  
  if (ps.show) {
    ps.update();
    ps.plot();
  }
  
}

void mousePressed() {
  ps.show = true;
  for(int p=0; p<Nparticles; p++){
    ps.addParticle();
  }
}
