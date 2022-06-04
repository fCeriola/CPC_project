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
