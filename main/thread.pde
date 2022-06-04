import java.util.concurrent.Semaphore;

static Semaphore semaphore = new Semaphore(1);

public class Update implements Runnable {
  
  // ATTRIBUTES
  
  private StarsTable starsTable;
  private StarSystem starSystem;
  private Pollution pollution;
  String whatToUpdate;
  boolean lock;
  
  // ======================================================
  // CONSTRUCTOR
  
  public Update(StarsTable starsTable, StarSystem starSystem, Pollution pollution, String whatToUpdate, boolean lock) {
    this.starsTable = starsTable;
    this.starSystem = starSystem;
    this.pollution = pollution;
    this.whatToUpdate = whatToUpdate;
    this.lock = lock;
  }
  
  // ======================================================
  // PRIVATE METHODS
  
  // ======================================================
  // PUBLIC METHODS
  
  public void run() {
    try {
      if (lock)
        semaphore.acquire();
      try {
        if (this.whatToUpdate == "starsTable"){
          this.starsTable.update();
        }
        else if (this.whatToUpdate == "starSystem") {
          this.starSystem.update();
        }
        else if (this.whatToUpdate == "pollution") {
          this.pollution.update();
        }
      } finally {
        if (lock)
          semaphore.release();
      }
    } catch (InterruptedException e) {
      println("error");
    }
  }
}
