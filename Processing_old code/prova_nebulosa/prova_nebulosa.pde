ArrayList<Celestial> comets;
ArrayList<Celestial> nebulas;
Celestial nebula;
Celestial comet;
int nebulaParticles = 1000;
PVector nebulaOrigin;
PVector nebulaDirection;
int cometParticles = 1000;
PVector cometOrigin;
PVector cometDirection;
int counter;


void setup(){
  size(1520,850);
  counter = 400;
  
  nebulaOrigin = new PVector(-10, -10);
  nebulaDirection = new PVector(1, 0.5);
  nebulas = new ArrayList<Celestial>();
  
  comets = new ArrayList<Celestial>();
  
  background(0);
}


void draw(){
  fill(0, 30);
  noStroke();
  rect(0, 0, width, height);
  counter++;
  
  if (counter % 500 == 0) {
    for (int i = 0; i < 5; i++){
      cometOrigin = new PVector(width+random(-50, 50), random(-100,-20));
      cometDirection = new PVector(random(-2,-1), random(0.7, 1.2));
      counter = 0;
      comet = new Celestial("comet", cometOrigin, cometDirection, color(255));
      comets.add(comet);
    }
  }
  
  
  for (int i=nebulas.size()-1; i>=0; i--) {
    Celestial nebula = nebulas.get(i);
    nebula.update();
    nebula.plot();
  }
  
  for (int i=comets.size()-1; i>=0; i--) {
    Celestial comet = comets.get(i);
    comet.update();
    comet.plot();
  }
  
}

void mousePressed() {
  nebula = new Celestial("nebula", nebulaOrigin, nebulaDirection, color(255));
  nebulas.add(nebula);
}
