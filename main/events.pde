public boolean day;

public void moonEvent(){
  if (day==false){
    moon.plot();
    moon.update();
    if(moon.xCoord == width + 200){
       sceneChange(ableton, ip, 1.0);
       println("sending scene 1.0");
     }
  }
  if(moon.xCoord < -50){
    day = true;
    moon.xCoord = width + 200;
  }
}

public void sunEvent(float n){ 
 if (day==true){
     if(sun.xCoord == width + 200){
       sceneChange(ableton, ip, 2.0);
       println("sending scene 2.0");
     }
    sun.update();
    sky.update(sun.xCoord, sun.yCoord);
    sky.plot(n/2);
    sun.plot(spectrum);
 }
 if (sun.xCoord < -300){
   day = false;
   sun.xCoord = width + 200;
 }
}

public void cityEvent(float n){
  if(day==true){
    tint(255, n*4.0);
    image(cityLights, 0, 0);
    noTint();
  }  
}
