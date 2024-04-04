//each note on and note off is a midi event

class MidiEvent {
  Note note;
  long timestamp;

  MidiEvent(Note note, long timestamp) {
    this.note = note;
    this.timestamp = timestamp;
  }
  
  public long getTimestamp(){
    return timestamp;
  }
  
  public Note getNote(){
    return note;
  }
  
}
