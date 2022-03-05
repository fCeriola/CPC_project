//class that manages the star object instances
//it containes all the stars inside an ArrayList and 

public class StarSystem{
  
  // ATTRIBUTES
  
  private ArrayList<Star> stars;
  private StarsTable database;
  
  
  //-------------------------------------------------
  // CONSTRUCTOR
  
  public StarSystem(StarsTable starDatabase){
    this.stars = new ArrayList<Star>();
    //we pass the reference to the database to this constructor and we create a new reference to it
    //it basically means having a new pointer
    this.database = starDatabase;
    this.fillSystem();
  }
  
  
  //-------------------------------------------------
  // PRIVATE METHODS
  
  private void fillSystem(){
    //the idea is to create instances of star objects only if the star is visible from where we are
    //we need to set limits on (x,y) cartesian plane in order to do that
    //we will build a new method inside this class that will take information by gyrOsc and will decide
    //wether the projection of each star falls or not inside the plane we want to show into the screen
    int numberOfStars = this.database.starsAttributes.getRowCount();
    
    for (int i=0; i<numberOfStars; i++) {
      TableRow row = this.database.starsAttributes.getRow(i);
      //pseudocodice
      //if (la stella ricade nel piano dello schermo) : crea l'istanza stella -> inseriscila nell'arraylist
      if(projectionFallsInsidePlane(row))
        this.stars.add(new Star(row));
      else
        continue;
    }
  }
  
  
  private boolean projectionFallsInsidePlane(TableRow row) {
    boolean answer = false;
    
    float alt = row.getFloat("HC2");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    
    if (alt > 0 && x > 0 && x < width && y > 0 && y < height)
      answer = true;
    
    return answer;
  }
  
  //--------------------------------------------------
  // PUBLIC METHODS
  
  public void plot(){
    Star star;
    for (int i = this.stars.size()-1; i>=0; i--){
      star = this.stars.get(i);
      star.plot();
    }
  }
  
  public void update() {
    //updating the starsTable object instance is enough since the
    //local database is just a reference to that one
    //but we need to empty the arraylist and rebuild it
    for (int i = this.stars.size()-1; i>=0; i--)
      stars.remove(i);
    
    this.fillSystem();
  }
  
}
