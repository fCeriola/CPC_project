class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  PVector direction;
  boolean show;
  
  ParticleSystem(PVector origin, PVector direction){
    this.particles = new ArrayList<Particle>();
    this.origin = origin.copy();
    this.direction = direction.copy();
    this.show = false;
  }
  
  void addParticle(){
    float angle = this.direction.heading();
    angle += PI % (2*PI);
    float maxAngle = angle + PI/5;
    float minAngle = angle - PI/5;
    angle = random(minAngle, maxAngle);
    float x = cos(angle);
    float y = sin(angle);
    PVector force = new PVector(x,y);
    this.particles.add(new Particle(this.origin, 7, random(0,255), force));
  }
  
  void plot(){
    Particle p;
    for(int i=this.particles.size()-1; i>=0; i--){
      p = this.particles.get(i);
      p.applyForce();
      p.update();
      p.plot();
      p.lifespan-=0.5;
      if(p.isDead()){
         particles.remove(i);
         this.addParticle();
      }
    }
  }
  
  void update() {
    if (this.direction.x>0)
      this.origin.x++;
    else
      this.origin.x--;
    if (this.direction.y>0)
      this.origin.y++;
    else
      this.origin.y--;
  }

}
