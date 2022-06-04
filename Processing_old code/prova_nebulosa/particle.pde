class Particle{
  String type;
  PVector pos, vel, acc, dir;
  float radius, lifespan;
  color colore;
  
  Particle(String typeOfCelestial, PVector origin, PVector celestialDirection, color celestialColor){
    float xDeviation = 7*cos(random(0, 2*PI));
    float yDeviation = 7*sin(random(0, 2*PI));
    this.type = typeOfCelestial;
    this.pos = origin.copy();
    this.pos.x += xDeviation;
    this.pos.y += yDeviation;
    this.vel = new PVector();
    this.acc = new PVector();
    this.dir = celestialDirection.copy();
    this.colore = celestialColor;
    
    if (this.type == "nebula") {
      this.radius = 10;
      this.lifespan = random(0,255);
    }
    else if (this.type == "comet") {
      this.radius = 2;
      this.lifespan = random(0,255);
    }
  }
  
  void update(){
    this.vel.add(this.acc);
    this.pos.add(this.acc);
    this.acc.mult(0);
    this.radius += 0.1;
  }
  
  void applyForce(){
    
    if (this.type == "nebula") {
      float angle = this.dir.heading();
      angle += PI;
      PVector force = PVector.fromAngle(random(angle-(PI/2), angle+(PI/2)));
      force.mult(1);
      this.acc.add(force);
    }
    else if (this.type == "comet") {
      
    }
  }
  
  void plot(){
    
    if (this.type == "nebula") {
      float cRed = red(this.colore);
      float cGreen = green(this.colore);
      float cBlue = blue(this.colore);
      float alpha = map(lifespan, 0, 255, 0, 50);
      
      noStroke();
      fill(cRed, cGreen, cBlue, alpha);
      ellipse(this.pos.x, this.pos.y, this.radius, this.radius);
    }
    else if (this.type == "comet") {
      
    }
    
  }
  
  boolean isDead(){
    if (this.lifespan <= 0)
      return true;
    return false;
  }
}
