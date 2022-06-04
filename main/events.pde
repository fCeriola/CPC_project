boolean day;

public void moonEvent(){
  if (day==false){
    moon.plot();
    moon.update();
  }
  if(moon.xCoord>width+100){
    day = true;
  }
}

public void sunEvent(float n){
 if (day==true){
    sun.update();
    sky.update(sun.xCoord, sun.yCoord);
    sky.plot(n/2);
    sun.plot(spectrum);  
 }
 if (sun.xCoord>width){
   day = false;
 }
}
