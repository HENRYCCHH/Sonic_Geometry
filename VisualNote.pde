// the MIDI music note is visualize by tranforming as a "visual note"

class VisualNote {
  float x, y;
  float dx, dy;
  float velocity;
  PVector pVelocity; 
  float angle;
  int pitch;
  int pitchDifference;
  int alpha = 255;
    
  color c;
     
  
  // number of sand painters for each visual note
  int numsands = 3;
  SandPainter[] sands = new SandPainter[numsands];  
  
  
  
  //constructor
  VisualNote(float X, float Y, float velocity, float angle, int pitch){
    this.x = X;
    this.y = Y;
    this.angle = angle;
    this.velocity = velocity;
    this.pitch = pitch;
    for (int n=0;n<numsands;n++) {
      sands[n] = new SandPainter(X,Y, velocity);
      sands[n].render(this.x, this.y, ultimateFade);
    }
  }
  
  VisualNote(float X, float Y, float velocity, float angle, int pitchDifference, int pitch){
    this.x = X;
    this.y = Y;
    this.angle = angle;
    this.velocity = velocity;
    this.pitchDifference = pitchDifference;
    this.pitch = pitch;
    for (int n=0;n<numsands;n++) {
      sands[n] = new SandPainter(X,Y, velocity);
      sands[n].render(this.x, this.y, ultimateFade);
    }
  
  }
  
  
  
  //function for the first note , updating its position in draw()
  void firstNoteMotion(float ultimateVelocity, float ultimateFade){
    
    //the motion velocity of the visual note is based on the velocity of the MIDI note being played.
    //the motion velocity can be further attenuated by the slider value "ultimateVelocity"
    if (velocity >0){
      this.velocity = this.velocity - ultimateVelocity;
    }
    else if (velocity <0){
      this.velocity = this.velocity + ultimateVelocity;
    }
    
    if (abs(this.velocity)<0.01){
      this.velocity =0;
    }
    
    // the projection angle of the visual note is based on the interval between its previous note.
    // the projection angle is further affected by the dissonance value of that interval,
    // and can be attenuated by the slider value "effectOfDissonance"
    variationValue =random(-(dissonanceValue)/15,dissonanceValue/15);
    this.angle += variationValue *effectOfDissonance + dAngle;
    this.dx = cos(this.angle)*this.velocity;
    this.dy = sin(this.angle)*this.velocity;
    if (velocity > 3){
       this.velocity -= this.velocity/200;
    }
    
    // Radius and center position of the circular boundary
    float boundaryRadius = diameter * 0.5; 
    float centerX = (width+340) / 2;
    float centerY = height / 2;
    
    float distance = dist(centerX, centerY, this.x, this.y);
    if (this.alpha>0){
      this.alpha-= 8;
    }

    // bounce back when the visualNote reach the circular boundary
    if (distance > boundaryRadius) {
 
       this.velocity = -this.velocity;
       this.x = this.x  - this.dx;
       this.y = this.y  - this.dy;
    }
    else{
      this.x = this.x + this.dx;
      this.y = this.y + this.dy;
    }
    
    for (int n=0;n<numsands;n++) {
      sands[n].render(this.x,this.y, ultimateFade);
    }      
  }
  
  
  // function for all other note, updating their position in draw()
  void updatePosition(float previousNoteAngle, float ultimateVelocity, float ultimateFade){
    if (velocity >0){
      this.velocity = this.velocity - ultimateVelocity;
    }
    else if (velocity <0) {
      this.velocity = this.velocity + ultimateVelocity;
    }
   
    if (abs(this.velocity)<0.01){
      this.velocity =0;
    }  
    
    this.angle = pitchAngleRelationship(previousNoteAngle, this.pitchDifference);
    this.dx = cos(this.angle)*this.velocity;
    this.dy = sin(this.angle)*this.velocity;
    
    if (velocity > 3){
       this.velocity -= this.velocity/200;
    }
    
    float boundaryRadius = diameter * 0.5; // Radius of the circular boundary
    float centerX = (width+340)/ 2;
    float centerY = height / 2;
    
    float distance = dist(centerX, centerY, this.x, this.y);
    if (this.alpha>0){
      this.alpha-= 8;
    }
    
    // bounce back when the visualNote reach the circular boundary
    if (distance > boundaryRadius) {
      this.velocity = -this.velocity;
      this.x = this.x  - this.dx;
      this.y = this.y  - this.dy;
    }
    else{
      this.x = this.x + this.dx;
      this.y = this.y + this.dy;
    }
    
    for (int n=0;n<numsands;n++) {
      sands[n].render(this.x,this.y, ultimateFade);
    } 
  }




  public float getAngle(){
    return angle;
  }
  
  
  
  public int getPitch(){
    return pitch;
  }  
  
  
}  
