//class that manages the star object instances
//it containes all the stars inside an ArrayList and 

public class StarSystem{
  
  // ATTRIBUTES
  
  private ArrayList<Star> stars;
  private StarsTable database;
  
  // ======================================================
  // CONSTRUCTOR
  
  public StarSystem(StarsTable starDatabase){
    this.stars = new ArrayList<Star>();
    //we pass the reference to the database to this constructor and we create a new reference to it
    //it basically means having a new pointer
    this.database = starDatabase;
    this.fillSystem();
  }
  
  // ======================================================
  // PRIVATE METHODS
  
  private void fillSystem(){
    int numberOfStars = this.database.starsAttributes.getRowCount();
    TableRow row;
    
    for (int i=0; i<numberOfStars; i++) {
      row = this.database.starsAttributes.getRow(i);
      this.stars.add(new Star(row));
    }
  }
  
  private boolean starFallsIntoScreen(Star star) {
    boolean answer = false;
    
    float AL = star.AL;
    float X = star.xCoord;
    float Y = star.yCoord;
    
    if (AL > 20 && X > 0 && X < width && Y > 0 && Y < height)
      answer = true;
      
    return answer;
  }
  
  // ======================================================
  // PUBLIC METHODS
  
  public void plot(){
    Star star;
    for (int i = this.stars.size()-1; i>=0; i--){
      star = this.stars.get(i);
      if (starFallsIntoScreen(star))
        star.plot();
    }
  }
  
  public void update() {
    //updating the starsTable object instance is enough since the
    //local database is just a reference to that one
    //but we need to empty the arraylist and rebuild it
    TableRow row;
    Star star;
    float AZ;
    float AL;
    
    for (int i = this.stars.size()-1; i>=0; i--) {
      star = this.stars.get(i);
      row = database.starsAttributes.getRow(star.index-1);
      
      AZ = row.getFloat("AZ");
      AL = row.getFloat("AL");
      
      star.update(AZ, AL);   
    }
  }
  
}
