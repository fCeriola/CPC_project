class Particle{
  PVector pos, vel, acc, initPos;
  float radius, lifespan;
  PVector gravity;
  
  Particle(PVector pos, float radius, float lifespan, PVector gravity){
    this.initPos = pos.copy();
    this.pos = pos.copy();
    this.vel = new PVector();
    this.acc = new PVector();
    this.radius = radius;
    this.lifespan = lifespan;
    this.gravity = gravity;
  }
  
  void update(){    
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  void applyForce(){
    this.acc.add(this.gravity.mult(0.5));    
  }
  
  void plot(){
    float diff = this.gravity.heading();
    float hue = map(diff, -PI, PI, 0, 255);
    float alpha = max(0,int(lifespan));
    colorMode(HSB, 255);
    fill(hue, 255, 255, alpha);
    noStroke();
    ellipse(this.pos.x, this.pos.y, this.radius, this.radius);    
  }
  
  boolean isDead(){
    if (this.lifespan <= 0)
      return true;
    return false;
  }
}
