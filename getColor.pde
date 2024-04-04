// color from the camera capture are collected into the colo palette 
// and are used in when drawing the visual note projectory with the sand painter
import processing.video.*;

int[] bright;
int increment = 20;
color[] captureColors;
Capture video;
int index;


// setup the video capture from camera
void setCam(){

  String[] cameras = Capture.list();
  video = new Capture(this, 320, 240, cameras[0]);
  video.start(); 
  int count = ((video.width * video.height) / (increment * increment))+46 ;
  captureColors = new color[count];
}  



void getColor() {
  index = 0;
  if (video.available()) {
    video.read();
    video.loadPixels();
    
    noStroke();
    // only collect the color of certain points
    for (int j = 0; j < video.height; j += increment) {
      for (int i = 0; i < video.width; i += increment) {
        color pixelColor = video.pixels[j*video.width + i];
        captureColors[index]=pixelColor;
        index++;
      }
    }
    //also pump black and white into the color palette
    for (int x=0;x<22;x++) {
      captureColors[index]=color(0,0,0);
      index++;
      captureColors[index]=color(255,255,255);
      index++;
    }
  }
}  


// generate randomNumber for color selection for VisualNote
color randomNumber(){
    //the number is used for pick color from the captureColors
    int randomNum = int(random(index));
  return randomNum;
}



//display the color palette in vertical color lines collected from camera in real time
void colorPalette(){
  beginShape(QUAD_STRIP);
  for (int i = 0; i < index; i++) {
    fill(captureColors[i]);
    float x = map(i, 0, index, 20, 300);
    vertex(x, 310);
    vertex(x, 370);
  }
  endShape();
}  
