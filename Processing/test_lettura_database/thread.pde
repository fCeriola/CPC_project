import java.util.concurrent.Semaphore;

static Semaphore semaphore = new Semaphore(1);

public class Update implements Runnable {
  private StarsTable starsTable;
  private StarSystem starSystem;
  String whatToUpdate;
  boolean lock;
  
  public Update(StarsTable starsTable, StarSystem starSystem, String whatToUpdate, boolean lock) {
    this.starsTable = starsTable;
    this.starSystem = starSystem;
    this.whatToUpdate = whatToUpdate;
    this.lock = lock;
  }
  
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
      } finally {
        if (lock)
          semaphore.release();
      }
    } catch (InterruptedException e) {
      println("error");
    }
  }
}
