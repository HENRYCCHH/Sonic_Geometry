// use OSC message to send video color data collected from the camera to the Wekinator app,
// the color data are used to train up the Wekinator app to classify the gesture 
// e.g. raise left hand or raise right hand
// then the Wekinator app will send OSC messages represent the detected gesture back to processing in real time
// this part of code is referenced on the wekinator demo code from the official website:
//http://www.wekinator.org/kadenze/

/** REMARKS **
Pretraining of the wekinator project is required before the gesture control can be used

Setting for Wekinator project:
Wekinator listening for inputs and control on port: 6448
Inputs OSC message: /wek/inputs
# inputs: 100

Outputs OSC message: /wek/outputs
#outputs: 1

Ports: 9000
Type: All classifiers (default settings)
With 3 classes
**/


import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

int counter;
int boxWidth = 28;
int boxHeight = 21;

int numHoriz = 280/boxWidth;
int numVert = 210/boxHeight;
color[] downPix = new color[numHoriz * numVert];


//set up the OSC input and ouput port
void setOSC(){
   oscP5 = new OscP5(this,9000);
   dest = new NetAddress("127.0.0.1",6448);
}  


void sendOsc(int[] px) {
  OscMessage msg = new OscMessage("/wek/inputs");
 // msg.add(px);
   for (int i = 0; i < px.length; i++) {
      msg.add(float(px[i])); 
   }
  oscP5.send(msg, dest);
}

// the gesture message is used to alter the dAngle,
// which is the value affect the projection curvature of all visual notes
void oscEvent(OscMessage message){
  float dAngleValue = message.get(0).floatValue();
  // if the OSC message from the wekinator is 1 (classify as left hand rised in the demo
  // the value of dAngle increase
  if (dAngleValue == 1.0){
     dAngle +=0.0002;     
  }
  // if the OSC message from the wekinator is 3 (classify as left hand rised in the demo
  // the value of dAngle decrease  
  else if (dAngleValue ==3.0){
    dAngle -=0.0002;
  }  
}



// the camera video is captured as arrays of color and then displayed as boxes of color as the "gesture detector"
void drawBoxDisplay(){
    //-----OSC-----//
    // Begin loop for columns
    counter = 0;
    for (int i = 0; i < numHoriz; i++) {
      // Begin loop for rows
      for (int j = 0; j < numVert; j++) {
      
        int x = i*boxWidth;
        int y = j*boxHeight;
        int loc = x + y*video.width;
        int tot = boxWidth * boxHeight;
        float rtot = 0;
        float gtot = 0;
        float btot = 0;
        for (int k = 0; k < boxHeight; k++) {
           for (int l = 0; l < boxWidth; l++) {
               int loc2 = loc + k*video.width + l;
               rtot += red(video.pixels[loc2]);
               gtot += green(video.pixels[loc2]);
               btot += blue(video.pixels[loc2]);
           }
        }
        color c2 = color((int)(rtot/tot), (int)(gtot/tot), (int)(btot/tot));
      
        rectMode(CENTER);
        fill(c2);
        noStroke();
        rect(x+boxWidth/2+20,y+boxHeight/2+60, boxWidth, boxHeight);
        downPix[counter++] = c2;

      }
    }
    if(frameCount % 10 == 0) {
      sendOsc(downPix);
    }
}
