// the introductory information screen

public class InfoScreen{
  ControlP5 screenController;
  Textlabel title;
  Textlabel infoText;
  Button closeButton;
  String titleString;
  String infoTextString;
  PFont titleFont;
  PFont textFont;
  
  boolean enabled;
  
  public InfoScreen(Sonic_Geometry ass3){
    screenController = new ControlP5(ass3);
    setupScreen();
    enabled = true;
  }
  
  private void setupScreen(){
    backgroundColor = color(#636363);     
    highlightColor = color(#B0B0B0);    
    activeColor = color(#FAFAFA);
    
    titleFont = createFont("calibri.ttf", 24);
    textFont = createFont("calibri.ttf", 15);
    
    titleString = "Welcome to Sonic Geometry, where music becomes art in motion!";
    title = screenController.addTextlabel(titleString)
              .setPosition(900/2 , height/5)
              .setValue(titleString)
              .setColor(0)
              .setFont(titleFont)
              ;
              
    infoTextString = "Imagine your melodies taking on a vibrant life of their own, each note dancing across the canvas. \nThis isn't just music; it's an animated masterpiece.\n" +
                     "\n" +
                     "Watch as the sand painters bring your notes to life, guided by the notes' velocity and the harmonious intervals \nbetween each successive note, all following the ancient wisdom of Pythagorean tuning." +
                     "The intensity of \ndissonance between intervals adding a tactile dimension, creating bumps and rugs along the path of your \nauditory and visual tapestry.\n"+
                     "\n" +
                     "But here's where it gets even more fascinating - the color of your sand painters is drawn from the real world. \nYou can use your camera to infuse your music with the colors of your surroundings.\n" +
                     "\n" +
                     "And the creative power is in your hands. Customize the path your sand painters follow with your unique gestures \n(a skill honed with a little help from Wekinator). Adjust the fade-out time and speed to perfect your musical masterpiece.\n" +
                     "\n" +
                     "To embark on your visual journey, follow these simple steps:\n" +
                     "\n" +
                      "    1.  Hit \"Record\" to capture your music through your MIDI device.\n" +
                      "    2.  When your masterpiece is complete, press \"Stop Record.\"\n" +
                      "    3.  Press \"Play\" to set your musical notes in motion on the canvas.\n" +
                      "    4.  Ready to start anew? A tap of \"Reset\" clears your canvas, and the artistry begins again.";


    infoText = screenController.addTextlabel("body text")
              .setPosition(450, height/4 + 10)
              .setValue(infoTextString)
              .setColor(0)
              .setFont(textFont)
              ;
    closeButton = screenController.addButton("Close Info")
                  .setPosition(900/2 + 320, height * 7/8 - 70)
                  .setColorBackground(backgroundColor)
                  .setColorForeground(highlightColor) 
                  ;              
       
    screenController.setAutoDraw(false);
  }
  
  public void drawScreen(){
    if(enabled){
      fill(#999999);
      rectMode(CORNER);
      rect(400, 100, 820,650);
      screenController.draw();
      playButton.lock();
      resetButton.lock();
      RecordButton.lock();
      stopButton.lock();

      
      if(closeButton.isPressed()){
        enabled = false;
        
        // cover the information with the background 
        rectMode(CORNER);
        fill(#393939);
        rect(320, 0, 1300, 900);
        fill(#292929);
        rect(0, 0, 320, 900);
        playButton.unlock();
        resetButton.unlock();
        RecordButton.unlock();
        stopButton.unlock();
      }
    }
  }
  
  public void enable(){
    enabled = true;
  }
}
