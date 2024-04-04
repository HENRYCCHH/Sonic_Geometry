//each "visual note" is visualize by a number of SandPainter


class SandPainter {
  float x, y;
  float p;
  color c;
  float g;
  int colorNum ;
  float alpha;

  //Constructor
  SandPainter(float x, float y, float v) {
    this.x = x;
    this.y = y;
    
    this.alpha = map(v, 0.5, 8.0, 0.5, 1.0);
    p = random(1.0);
    
    // random get a color from the color palette
    colorNum = randomNumber();
    c = captureColors[colorNum];
    g = map(v, 0, 128, 0.01, 0.11);
  }


  
  void render(float x, float y, float ultimateFade) {
    this.x = x;
    this.y = y;
    // the alpha of the color is attenuated by the slider value "ultimateFade"
    this.alpha -= ultimateFade;
    if (alpha <0){
      alpha =0;
    }  
    
    // drawing the centre line
    stroke(red(this.c),green(this.c),blue(this.c),256*alpha);
    point(this.x, this.y);
    
    //adding kind of "white" and "black" nearby to articulate the centre line
    for (int dx=-3;dx<3;dx++) {
      float a = 0.5-abs(dx)/5.0;
      stroke(10,256*a*alpha);
      point(x+dx,y);
      stroke(230,256*a*alpha);
      point(x+dx-1,y-1);
    }
    for (int dy=-3;dy<3;dy++) {
      float a = 0.5-abs(dy)/5.0;
      stroke(20,256*a*alpha);
      point(x,y+dy);
      stroke(240,256*a*alpha);
      point(x-1,y+dy-1);
    }

    g+=random(-0.05,0.05);
    float maxg = 0.22;
    if (g<-maxg) g=-maxg;
    if (g>maxg) g=maxg;

    float w = g/10.0;
    for (int i=0;i<30;i++) {
      float a = (0.8-i/10);
      if ((colorNum + i +5)>index){
       colorNum = 0; 
      }  
      //use the color that is near to the selected color in the color palette arraylist
      // drawing the "sand" texture around the centre line
      stroke(red(captureColors[colorNum+i+5]),green(captureColors[colorNum+i+5]),blue(captureColors[colorNum+i+5]),256*a*alpha);
      point(this.x+(i*i*(p+sin(i*w))), this.y+(i*i*(p+sin(i*w))));
      point(this.x-(i*i*(p+sin(i*w))), this.y-(i*i*(p+sin(i*w))));
    }
  }
}
