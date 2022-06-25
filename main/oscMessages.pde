import oscP5.*;
import netP5.*;

public void sunVolFreq(float xSunCoord, OscP5 ableton, NetAddress ip){
  if (xSunCoord<=width/2){
    float val = map(xSunCoord, -600, width/2, 0.0, 1.0);
    OscMessage sunVal = new OscMessage("/sun/volume");
    sunVal.add(val);
    ableton.send(sunVal, ip);
  }else{
    float val = map(xSunCoord, width/2, width+600, 1.0, 0.0);
    OscMessage sunVal = new OscMessage("/sun/volume");
    sunVal.add(val);
    ableton.send(sunVal, ip);
  }
}

public void starMode(float xCoord, float yCoord, OscP5 ableton, NetAddress ip){
  if(xCoord<width/2 && yCoord<height/2){
    OscMessage modeVal = new OscMessage("/stars/mode");
    modeVal.add(0.12);
    ableton.send(modeVal, ip);
  }
  if(xCoord>width/2 && yCoord<height/2){
    OscMessage modeVal = new OscMessage("/stars/mode");
    modeVal.add(0.35);
    ableton.send(modeVal, ip);
  }
  if(xCoord>width/2 && yCoord>height/2){
    OscMessage modeVal = new OscMessage("/stars/mode");
    modeVal.add(0.65);
    ableton.send(modeVal, ip);
  }
  if(xCoord<width/2 && yCoord>height/2){
    OscMessage modeVal = new OscMessage("/stars/mode");
    modeVal.add(0.85);
    ableton.send(modeVal, ip);
  }
}

public void accFilter(float testX, OscP5 ableton, NetAddress ip){
  float val = map(testX, 0.0, 5.0, 0.0, 1.0);
  OscMessage filterVal = new OscMessage("/filter/x");
  filterVal.add(val);
  ableton.send(filterVal, ip);
}

public void sceneChange(OscP5 ableton, NetAddress ip, float n){
  OscMessage scene = new OscMessage("/launch/scene");
  scene.add(n);
  ableton.send(scene, ip);
}


public void starRate(float rate, OscP5 ableton, NetAddress ip){
  OscMessage rateVal = new OscMessage("/stars/rate");
  rateVal.add(rate);
  ableton.send(rateVal, ip);
}

public void starColor(float tone, OscP5 ableton, NetAddress ip){
  OscMessage colVal = new OscMessage("/stars/tone");
  colVal.add(tone);
  ableton.send(colVal, ip);
}
