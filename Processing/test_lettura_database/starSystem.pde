//class that manages the star object instances
//takes the database as input

public class StarSystem{
  
  // ATTRIBUTES
  ArrayList<Star> stars;
  StarsTable database;
  
  
  //-------------------------------------------------
  // CONSTRUCTOR
  public StarSystem(StarsTable database){
    this.stars = new ArrayList<Star>();
    this.database = database;
    this.fillSystem();
  }
  
  
  //-------------------------------------------------
  // PRIVATE METHODS
  private void fillSystem(){
    //the idea is to create instances of star objects only if the star is visible from where we are
    //we need to set limits on (x,y) cartesian place in order to do that
    //we will build a new method inside this class that will take information by gyrOsc and will decide
    //wether the projection of each star falls or not inside the plane we want to show into the screen
    int numberOfStars = this.database.starsAttributes.getRowCount();
    for (int i=0; i<numberOfStars; i++) {
      TableRow row = this.database.starsAttributes.getRow(i);
      float starX = row.getFloat("X");
      float starY = row.getFloat("Y");
      color starColor = this.database.convColor(row);
      this.stars.add(new Star(starX, starY, starColor));
    }
  }
  
  
  //--------------------------------------------------
  // PUBLIC METHODS
  void plotStarSystem(){
    Star star;
    for (int i = this.stars.size()-1; i>=0; i--){
      star = this.stars.get(i);
      star.plot();
    }
  }
  
  void updateSystem(StarsTable database) {
    //we use the updated database inside the StarsTable object instance to update the database instance
    //that we have inside this class, it's like having two identical databases:
    //StarsTable takes information directly from the txt file, the one inside this class is a mirror of StarsTable
    for (int i = this.stars.size()-1; i>=0; i--)
      stars.remove(i);
    
    this.database = database;
    this.fillSystem();
  }
  
}
