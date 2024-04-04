// all buttons, sliders, and texts are displayed using the controlP5 library elements
import controlP5.*;

// Controls in the UI
ControlP5 cp5;
Button RecordButton;
Button stopButton;
Button playButton;
Button resetButton;

Slider  UltimateVelocitySlider;
Slider UltimateFadeSlider;
Slider DissonanceSlider;

Textlabel gestureSensor;
Textlabel colorSpectrum;
Textlabel noteSpeed;
Textlabel fadeAwayTime;
Textlabel dissonanceEffect;

Textarea myTextarea;

color backgroundColor;
color highlightColor;
color activeColor;


private void setupCP5(){
 
  cp5 = new ControlP5(this);
  infoScreen = new InfoScreen(this);
  
  backgroundColor = color(#636363);     
  highlightColor = color(#B0B0B0);    
  activeColor = color(#FAFAFA);
  
  RecordButton = cp5.addButton("Record")
     .setValue(1)
     .setPosition(60,560)
     .setColorBackground(backgroundColor)
     .setColorForeground(highlightColor)      
     .setSize(200,20);
     
  stopButton = cp5.addButton("Stop Record")
     .setValue(0)
     .setPosition(60,582)
     .setColorBackground(backgroundColor)
     .setColorForeground(highlightColor) 
     .setSize(200,20);
     
  playButton = cp5.addButton("Play")
     .setValue(0)
     .setPosition(60,604)
     .setColorBackground(backgroundColor)
     .setColorForeground(highlightColor)      
     .setSize(200,20);   
     
  resetButton = cp5.addButton("Reset")
     .setValue(0)
     .setPosition(60,626)
     .setColorBackground(backgroundColor)
     .setColorForeground(highlightColor)      
     .setSize(200,20);       
     
  UltimateVelocitySlider = cp5.addSlider("ultimateVelocity")
     .setPosition(20,510)
     .setSize(280,20)
     .setRange(0.01,-0.01)
     .setValue(0.0)
     .setColorBackground(backgroundColor)
     .setColorForeground(highlightColor) 
     .setLabelVisible(false);
     ;
  UltimateFadeSlider = cp5.addSlider("ultimateFade")
   .setPosition(20,460)
   .setSize(280,20)
   .setRange(0.01, 0.0)
   .setValue(0.002)
   .setColorBackground(backgroundColor)
   .setColorForeground(highlightColor)    
   .setLabelVisible(false);
   ;
   
  DissonanceSlider =  cp5.addSlider("effectOfDissonance")
   .setPosition(20,410)
   .setSize(280,20)
   .setRange(0.0, 0.5)
   .setValue(0.0)
   .setColorBackground(backgroundColor)
   .setColorForeground(highlightColor)    
   .setLabelVisible(false);
   ;
  
  gestureSensor = cp5.addTextlabel("Gesture Sensor")
   .setText("Gesture Sensor")
   .setPosition(18,48)
   .setColor(color(255))
   ; 
     
  colorSpectrum = cp5.addTextlabel("Color Palette")
   .setText("Color Palette")
   .setPosition(18,298)
   .setColor(color(255))
   ; 
   
  noteSpeed = cp5.addTextlabel("Note Speed")
   .setText("Note Speed")
   .setPosition(18,498)
   .setColor(color(255))
   ; 
   
  fadeAwayTime = cp5.addTextlabel("Fade Out Time")
   .setText("Fade Out Time")
   .setPosition(18,448)
   .setColor(color(255))
   ; 
  
  dissonanceEffect = cp5.addTextlabel("Effect of Dissonance")
   .setText("Effect of Dissonance")
   .setPosition(18,398)
   .setColor(color(255))
   ; 
}
