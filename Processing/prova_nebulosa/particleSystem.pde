// a Celestial object may be a nebula or may be a comet depending on the type given
// as argument to the constructor. the particles behaviour depends on the type, but the behaviour
// itself is controlled by the Particle class

public class Celestial{
  
  // ATTRIBUTES
  
  String type;
  ArrayList<Particle> trail;
  int particleNumber;
  PVector position;
  float velocity;
  PVector direction;
  color colore;
  
  // ===================================================
  // CONSTRUCTOR
  
  public Celestial(String type, PVector origin, PVector direction, color colore){
    this.type = type;
    this.trail = new ArrayList<Particle>();
    this.position = origin.copy();
    this.direction = direction.copy();
    this.colore = colore;
    
    if (this.type == "nebula") {
      this.particleNumber = 1000;
      this.velocity = 0.4;
    }
    else if (this.type == "comet") {
      this.particleNumber = 10;
      this.velocity = 4;
    }
    
    for(int i=0; i<particleNumber; i++){
      this.addParticle();
    }
    
  }
  
  // ===================================================
  // PRIVATE METHODS
  
  private void addParticle(){
    this.trail.add(new Particle(this.type, this.position, this.direction, this.colore));
  }
  
  // ===================================================
  // PUBLIC METHODS
  
  public void plot(){
    
    fill(this.colore);
    
    if (this.type == "nebula") {
      ellipse(this.position.x, this.position.y, 7, 7);
    }
    
    if(this.type == "comet") {
      float angle = this.direction.heading();
      pushMatrix();
      beginShape();
      translate(this.position.x, this.position.y);
      rotate(angle);
      ellipse(0, 0, 7, 5);
      endShape();
      popMatrix();
    }
    
    Particle p;
    for (int i=this.trail.size()-1; i>=0; i--) {
      p = this.trail.get(i);
      p.applyForce();
      p.update();
      p.plot();
      p.lifespan -= 0.5;
      if(p.isDead()){
         trail.remove(i);
         this.addParticle();
      }
    }
  }
  
  public void update() {
    PVector movement = this.direction.copy();
    movement.mult(this.velocity);
    this.position.add(movement);
  }
}
