import { Component } from '@angular/core';
import { Message } from '@angular/compiler/src/i18n/i18n_ast';
import  WebMidi from "webmidi";

@Component(
  {
  selector: 'app-Cle-Sol-8vb',
  templateUrl: 'Cle_Sol_8vb.page.svg',
  styleUrls: ['Cle_Sol_8vb.page.scss'],
  })
export class Cle_Sol_8vbPage 
  {
  fill:string="blue";  
  private audioContext: AudioContext;  
  oscillator=null;
  gain = null;
  
  mo = null;
  truc:string="troc";
  constructor()
    {
    }

  ngOnInit(): void
    {
    this.audioContext = new AudioContext();  
    this.gain = this.audioContext.createGain();
    this.gain.value = 1.0;
    this.oscillator = this.audioContext.createOscillator();
    this.oscillator.type = 'sawtooth';
    this.oscillator.frequency.value = 440;
    this.oscillator.connect(this.gain);
    this.oscillator.start();
    
    this.midi_connect();
    }
  midi_connect()
    {
    reuc: AudioContext;  
    console.log("midi_connect: truc:"+this.truc);  
    WebMidi.enable(function (err) 
      {
      console.log("WebMidi.enable: truc:"+this.truc);  
      if (err) 
        console.log("WebMidi could not be enabled.", err);
      else 
        {
        console.log("WebMidi enabled!");      
        console.log("WebMidi.inputs:");
        console.log(WebMidi.inputs);
        console.log("WebMidi.outputs:");
        console.log(WebMidi.outputs);      
        if (WebMidi.outputs.length)
          {
          this.mo= WebMidi.outputs[0];
          console.log("utilisation de ");        
          console.log(this.mo);   
          //this.mo.playNote( "C4");
          //this.playNote( "C4");
          }
        }
      });
    }

  Base_from_Octave( _Octave: string): number
    {
    var Result: number = 0;
    switch( _Octave)
     {
     case "-1": Result=   0; break;
     case  "0": Result=  12; break;
     case  "1": Result=  24; break;
     case  "2": Result=  36; break;
     case  "3": Result=  48; break;
     case  "4": Result=  60; break;
     case  "5": Result=  72; break;
     case  "6": Result=  84; break;
     case  "7": Result=  96; break;
     case  "8": Result= 108; break;
     default  : Result =  0; break;
     };
    return Result;
    }
  Offset_from_Note( _Note: string): number
    {
    var Result: number = 0;
    switch( _Note)
      {
      case "C": Result=  0; break;
      case "D": Result=  2; break;
      case "E": Result=  4; break;
      case "F": Result=  5; break;
      case "G": Result=  7; break;
      case "A": Result=  9; break;
      case "B": Result= 11; break;
      default : Result=  0; break;
      };
    return Result;
    }
  DieseBemol( _c: string): number
    {
    var Result: number = 0;
    switch( _c)
      {
      case "#": Result= +1; break;
      case "b": Result= -1; break;
      default : Result=  0; break;
      }
    return Result;
    }
  Midi_from_note( _note: string): number
    {
    var Result: number= 0;
    var Note  = _note.charAt(0);
    var Octave= _note.charAt(1);
    var truc  = _note.charAt(2);
    Result
    =
        this.Base_from_Octave(Octave)
     +this.Offset_from_Note  (Note)
     +this.DieseBemol        (truc);
    return Result;
    }
  PlayNote( _Note: string)
    {
    this.changeColor(); 
    if (!WebMidi.enabled) return;

    if (null === this.mo) 
      {
      if (WebMidi.outputs.length) 
        this.mo= WebMidi.outputs[0];
      if (null === this.mo) return;
      }
    console.log( _Note);
    var MidiNote= this.Midi_from_note( _Note);
    var noteOnMessage = [0x90, MidiNote, 0x7f];    // note on, MidiNote, full velocity
    console.log( noteOnMessage);
    const MIDI_Channel_1_note_on=0x90;
    const MIDI_Note_Velocity=127;/* 0..127 */ 
    WebMidi.outputs[0].send( MIDI_Channel_1_note_on, [MidiNote, MIDI_Note_Velocity]);  //omitting the timestamp means send immediately.
    //midi_output.send( [0x80, MidiNote, 0x40], window.performance.now() + 1000.0 ); // Inlined array creation- note off, middle C,
    }
  changeColor() 
    {
    this.fill="green"==this.fill?"blue":"green";  
    }
  }
