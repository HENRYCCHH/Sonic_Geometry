/*
* Sonic Geometry
* by Cheuk Hang Henry CHIU , 10th Nov 2023
*
* This script aims to visually represent MIDI note sequences 
* by analyzing the interval relationships between consecutive notes 
* and quantifying the level of dissonance.
*/

import themidibus.*; 
import javax.sound.midi.*;
import java.util.*;
import gifAnimation.*;


MidiBus myBus; // MidiBus for reading MIDI Input and Output

ArrayList<MidiEvent> midiEventsOn = new ArrayList<MidiEvent>();
ArrayList<MidiEvent> midiEventsOff = new ArrayList<MidiEvent>();
ArrayList<VisualNote> visualNotes = new ArrayList<VisualNote>();

// image data
Gif wave;
PImage mic;
PImage titleName;

// introductory information 
InfoScreen infoScreen;

// parameter for the start and end counter of MIDI sequence 
long startTime =0;
long endTime = 0;
long startPlayTime;
long endPlayTime;


// visual display circle
int  diameter = 800;

// for startPlay function
int currentPitch;
int previousPitch;
int pitchDiff;

int rawVelocity;
float mappedVelocity;

// as index for MidiEventsOn and MidiEventOff arraylist
int counterOn = 0;
int counterOff = 0;

float previousX;
float previousY;
float previousRadian = 0;

// control the curvature of the "visual note" line
float dAngle = 0.0; // e.g. straight line: 0.0,  slight curve: 0.002, circular motion : 0.01 

// speed for the "visual note"
float maxVelocity = 25.0;
float minVelocity = 1.0;

// parameter controlled by the slider to alter the speed and fading time of the "visual note"
float ultimateVelocity = 0.0;
float ultimateFade = 0.0;


boolean isPlaying = false;
boolean isRecording = false;


// counter how many midi on signal is presently coming in
int midiNoteExist =0;

float variationValue = 0;
float dissonanceValue = 0;  // normally is 0.1
float effectOfDissonance = 0.0; // range from 0.0 - 0.5


void setup() {
  
  //UI 
  size(1300,900);
  background(#393939);
  fill(#292929);
  rect(0, 0, 320, 900);
  fill(#414141);
  rect(0, 0, 320, 20);
  
 
  frameRate(300);
  setupCP5();
  setCam();
  setOSC();

  wave = new Gif(this, "wave.gif");
  mic = loadImage("mic2.png"); 
  titleName = loadImage("title.png"); 
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  //                 Parent In Out
  myBus = new MidiBus(this, 1, 4); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
                                   // in my video demo, for input, "1" represent the "MIDI OUT1" from my MIDI keyboard "RD-88"
                                   // for output, "4" represent "bus 1" which is the "IAC Driver bus 1".
                                   // in the midi.cty sound engine, "IAC Driver bus 1" is selected as MIDI input , so that sound can be triggered.
}





void draw() {  
  // the left bottom corner title
  tint(255, 128);
  image(titleName, 20, 620, 280,280);
  noTint();
  // the left uppder corner bar
  fill(#414141);
  rect(0, 0, 320, 20);
  
  // function drawing the gesture detector camera 
  drawBoxDisplay();
  // get color from the camera and display the color palette
  getColor();
  colorPalette();
  
  // Detect if there is MIDI signal coming in
  if (midiNoteExist >0){
    fill(255);
    text("* MIDI IN", 280, 12);
  }
  if (midiNoteExist ==0){
    noTint();
    fill(0,0,0,1);
    rect(0, 0, 1300, 900);
  }
  
  
  if (RecordButton.isPressed()){
    if (millis() >1500){
      isRecording = true;
      midiEventsOn.clear();
      midiEventsOff.clear();
      startTime = millis();
      wave.play();
      wave.loop();    
    }
  }  
  
  //function for all button pressed
  if (stopButton.isPressed()){
    if (millis() >1500){
      isRecording = false;
      endTime = millis();
      wave.stop();
      rectMode(CORNER);
      fill(#393939);
      rect(320, 0, 1300, 900);
    }
  }
  
  if (playButton.isPressed()){
    if (!isPlaying){
      startPlayTime = millis();
    }  
    isPlaying = true;
  }
  
  if (resetButton.isPressed()){
    isPlaying = false;
    visualNotes.clear();  
    counterOn = 0;
    counterOff = 0;
    rectMode(CORNER);
    fill(#393939);
    rect(320, 0, 1300, 900);
    fill(#414141);
    rect(0, 0, 320, 20);
    startPlayTime = millis();
    dAngle = 0.0;
    variationValue = 0;
    dissonanceValue = 0;
  }
  
  // when recording, disable the play and reset button
  if(isRecording){
    playButton.setVisible(false);
    resetButton.setVisible(false);
    rectMode(CORNER);
    fill(#393939);
    rect(400, 0, 1300, 900);
    fill(0,0,0,1);
    rect(0, 0, 1300, 900);
    image(mic, width/2 -25 + 160, height/2 +150, 60,60);
    tint(255, 128);
    image(wave, 560, 720, 500,80);
    noTint();
    
  }  
  
  // Play button is enable only when the MidiEventsOn list is not empty
  if(!isRecording){
    if (!(midiEventsOn.isEmpty())){
      playButton.setVisible(true);
    }  
    resetButton.setVisible(true);
  }  
  
  
  if (!isPlaying){
    RecordButton.setVisible(true);
    stopButton.setVisible(true);
    if ((!isRecording) && (!(midiEventsOn.isEmpty()))){
        playButton.setVisible(true);
    }
  }  
  
  // after play button is pressed
  if (isPlaying){
    RecordButton.setVisible(false);
    stopButton.setVisible(false);
    resetButton.setVisible(true);
    
    startPlay();
 
    if (!visualNotes.isEmpty() && frameCount%10==0){ // when the visualNote arraylist is not empty & reduce the visual framerate to 30 frames per second
    
      //for the 1st note to move around
      visualNotes.get(0).firstNoteMotion(ultimateVelocity, ultimateFade);
      
      // other notes based on the their interval relationship with the previous note 
      for ( int i = 1; i < visualNotes.size(); i++){
        visualNotes.get(i).updatePosition(visualNotes.get(i-1).getAngle(), ultimateVelocity, ultimateFade);
      }
    }
  }
  // draw the introductory information 
  infoScreen.drawScreen();
}



// Receive a noteOn
void noteOn(Note note) {
  myBus.sendNoteOn(note);
  midiNoteExist++;
  
  //when recording
  if (isRecording){
    long timestamp = millis();
    midiEventsOn.add(new MidiEvent(note, timestamp));
  }
}

// Receive a noteOff
void noteOff(Note note) {
  myBus.sendNoteOff(note);
  midiNoteExist--;
  
  //when recording
  if (isRecording){
    long timestamp = millis();
    midiEventsOff.add(new MidiEvent(note, timestamp));
  }
}


public void startPlay(){
    
      if(counterOn< midiEventsOn.size() && (millis() - startPlayTime) >= (midiEventsOn.get(counterOn).getTimestamp() - startTime)){
        
        // for the first NoteOn (since it has not previous note for calculate the interval relationship, it will be the ultimate reference for all notes
        if (counterOn ==0){
          Note note = midiEventsOn.get(counterOn).getNote();
          rawVelocity = note.velocity(); 
          currentPitch = note.pitch();
          mappedVelocity = mapVelocity(rawVelocity);
          firstNoteStartPosition(mappedVelocity, currentPitch);
          myBus.sendNoteOn(note);
          counterOn++; 
          previousRadian = 0;
        }  
        
        // for all other NoteOn    
        else if (counterOn >0){
          Note note = midiEventsOn.get(counterOn).getNote();
          Note previousNote = midiEventsOn.get(counterOn-1).getNote();
          
          rawVelocity = note.velocity();        
          previousPitch = previousNote.pitch();       
          currentPitch = note.pitch();
          pitchDiff = abs(note.pitch() - previousNote.pitch());    
          dissonanceValue = dissonanceCalculation (pitchDiff);
          mappedVelocity = mapVelocity(rawVelocity);
          noteStartPosition(mappedVelocity, pitchDiff, previousNote.pitch(), currentPitch);
          myBus.sendNoteOn(note);
          counterOn++; 
        } 
     }
     
     //for Noteoff
     if(counterOff< midiEventsOff.size() && (millis() - startPlayTime) >= (midiEventsOff.get(counterOff).getTimestamp() - startTime)){
        Note note = midiEventsOff.get(counterOff).getNote();
        myBus.sendNoteOff(note);
        counterOff++;
     }      
        
}  


// function for deciding the start position of the first note 
public void firstNoteStartPosition(float mappedVelocity, int pitch){
  float fx = (width + 340)/2 + 0.5*diameter*cos(0);
  float fy = height/2 +0.5*diameter*sin(0);
  float angle = PI;
  VisualNote newNote = new VisualNote(fx, fy, mappedVelocity, angle, pitch);
  visualNotes.add(newNote);
  previousX = fx;
  previousY = fy;
}



// function for deciding the start position of the all other note
void noteStartPosition(float mappedVelocity, int pitchDifference, float previousPitchAngle, int pitch){
  // every note starting point is position on the circumference
  // there is maximum 88 keys in a digital keyboard, and the maximum distance between consecutive notes are set to be 180 degree
  // if the same note is played repeatedly, they will have a minmum distance of 2 degree
  // while every semitone interval is equal to 1 degree
  // e.g. if two consecutive notes are 7 semitone apart, they will be  2 + 7 = 9 degree apart from each other
  float fx = (width+340)/2 + 0.5*diameter*cos(previousRadian + PI*2/90 + PI * pitchDifference/90);
  float fy = height/2 + 0.5*diameter*sin(previousRadian + PI*2/90 + PI * pitchDifference/90);
  float currentPitchAngle = pitchAngleRelationship(previousPitchAngle, pitchDifference);
  
  VisualNote newNote = new VisualNote(fx, fy, mappedVelocity, currentPitchAngle, pitchDifference, pitch);
  visualNotes.add(newNote);
  previousX = fx;
  previousY = fy;
  previousRadian += PI*2/90 + PI * pitchDifference/90;
}


public float mapVelocity(int rawVelocity){
  float mappedvelocity = map(rawVelocity, 0 , 128, minVelocity, maxVelocity);
  return mappedvelocity;
}



//the ratio between two consecutive pitches are based on the Pythagorean tuning ratio with respect to the first note
public float pitchAngleRelationship(float previousAngle, int pitchDifference){
  int pitchDifferenceIn8ve;
  float currentPitchAngle = 0;
  
  //turn interval higher than octave into within an octave 
  pitchDifferenceIn8ve = pitchDifference % 12 ;

  switch (pitchDifferenceIn8ve){
    case 0:
      currentPitchAngle = previousAngle + (round(TWO_PI * 1/2)*100)/100 ;  // Unison or Octave , Extremely consonant
      break;
    case 1:
      currentPitchAngle = previousAngle + TWO_PI * 256/243;  // minor 2nd, Highly dissonant
      break;
    case 2:
      currentPitchAngle = previousAngle + TWO_PI * 9/8; // major 2nd, Consonant
      break;
    case 3:
      currentPitchAngle = previousAngle + TWO_PI * 32/27; //minor 3rd, Moderately Consonant
      break;
    case 4:
       currentPitchAngle = previousAngle + TWO_PI * 81/64; //major 3rd, Moderately Consonant
      break;
    case 5:
      currentPitchAngle = previousAngle + TWO_PI * 4/3;  //Perfect 4th, Highly Consonant
      break;
    case 6:
      currentPitchAngle = previousAngle + TWO_PI * 729/512; // Augmented 4th, Extremely dissonant
      break;
    case 7:
      currentPitchAngle = previousAngle + TWO_PI *3/2;  // Perfect 5th, Highly Consonant
    case 8:
      currentPitchAngle = previousAngle + TWO_PI * 128/81; //minor 6th, Moderately dissonant
      break;
    case 9:
      currentPitchAngle = previousAngle + TWO_PI * 27/16; // major 6th, Moderately Consonant
      break;
    case 10:
      currentPitchAngle = previousAngle + TWO_PI * 16/9; // minor 7th, Consonant
      break;
    case 11:
      currentPitchAngle = previousAngle + TWO_PI * 243/128; // major 7th, Highly dissonant
      break;  
  }
  return currentPitchAngle;
}


// Since for more dissonance interval, the value of denominator and numerator in pythagorean tuning is larger,
// here utilize the value of denominator and numerator to calculate the "amount of dissonance".
public float dissonanceCalculation(int pitchDifference){
  int pitchDifferenceIn8ve;
  float dissonanceValue =0;
  
  pitchDifferenceIn8ve = pitchDifference % 12 ;
  
  switch (pitchDifferenceIn8ve){
    case 0:
      dissonanceValue = log(1);
      break;
    case 1:
      dissonanceValue = log(256 + 243);
      break;
    case 2:
      dissonanceValue = log(9+ 8);
      break;
    case 3:
      dissonanceValue = log(32 + 27);
      break;
    case 4:
      dissonanceValue = log(81 + 64);
      break;
    case 5:
      dissonanceValue =  log(4 + 3);
      break;
    case 6:
      dissonanceValue = log(729 + 512);
      break;
    case 7:
      dissonanceValue = log(3 + 2);
    case 8:
      dissonanceValue = log(128 + 81);
      break;
    case 9:
      dissonanceValue = log(27 + 16);
      break;
    case 10:
      dissonanceValue = log(16 + 9);
      break;
    case 11:
      dissonanceValue = log(243 + 128);
      break;  
  }
  return dissonanceValue;
}
