private boolean day = true;
private boolean changeScene = true;

public void moonEvent(){
  if (day==false){
    if(changeScene == true){
      sceneChange(ableton, ip, 1.0);
      println("sending scene 1.0");
      changeScene = false;
    }
    moon.plot();
    moon.update();
    if(moon.xCoord < -2*moon.radius){
      day = true;
      changeScene = true;
      moon.xCoord = width + 2*moon.radius;
    }
  }
}

public void sunEvent(float n){ 
  if (day==true){
    if(changeScene == true){
      sceneChange(ableton, ip, 2.0);
      println("sending scene 2.0");
      changeScene = false;
    }
    sky.update(sun.xCoord, sun.yCoord);
    sky.plot(n/2);
    sun.update();
    sun.plot(spectrum);
    if (sun.xCoord < -3*sun.radius){
      day = false;
      changeScene = true;
      sun.xCoord = width + 3*sun.radius;
    }
  }
}

public void cityEvent(float n){
  if(day==true){
    tint(255, n*4.0);
    image(cityLights, 0, 0);
    noTint();
  }  
}
