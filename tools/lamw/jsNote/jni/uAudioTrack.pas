unit uAudioTrack;

{$mode delphi}

interface

uses
 AudioTrack,
 uFrequence,
 uFrequences,
 Classes, SysUtils, AndroidWidget,And_jni;

type

  { TAudioTrack }
  TAudioTrack
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //Constantes
   public const
     SampleRate = 22050; // Hz (maximum frequency is 7902.13Hz (B8))
   //Methodes
   public
     class procedure Play_Old( _Note: String; _Duration: Integer);
     class procedure Play( _Note: String);
   end;

implementation

{ TAudioTrack }

constructor TAudioTrack.Create;
begin

end;

destructor TAudioTrack.Destroy;
begin
     inherited Destroy;
end;

class procedure TAudioTrack.Play_Old( _Note: String; _Duration: Integer);
var
   Buffer : TDynArrayOfSmallint;
   procedure Cree_Buffer;
   var
      Frequence: double;
      NumSamples: Integer;
      i: Integer;
      a: double;
      Sample: double;
   begin
        Frequence:= Frequences.Frequence_from_Midi( Midi_from_note( _Note));
        NumSamples:= _Duration * SampleRate;
        SetLength( Buffer, NumSamples);
        for i:= Low(Buffer) to High(Buffer)
        do
          begin
          a:= IfThen<double>( i > SampleRate, 1, i/SampleRate);//montée de volume de 0 à 1 sur la première seconde
          Sample:= a*sin(2 * PI * i / (SampleRate / Frequence)); // Sine wave
          Buffer[i]:= Trunc(Sample * SmallInt.MaxValue);  // Higher amplitude increases volume
          end;
   end;
   procedure Process_AudioTrack_procedure;
   var
      jo: jObject;
   begin
        jo
        :=
          jAudioTrack_jCreate( gApp.jni.jEnv,
                               0,//Self de jAudioTrack
                               3,//FstreamType:= 3;//AudioManager.STREAM_MUSIC 3
                               SampleRate,
                               4,//FchannelConfig:= 4; //AudioFormat.CHANNEL_OUT_MONO 4
                               2,//FaudioFormat:= 2; //AudioFormat.ENCODING_PCM_16BIT 2
                               Length(Buffer),// FbufferSizeInBytes:= buffer.length;
                               0,//FMode= 0; //AudioTrack.MODE_STATIC 0
                               gApp.jni.jThis
                               );
        jAudioTrack_Write(gApp.jni.jEnv, jo, Buffer, 0, Length(Buffer));
        jAudioTrack_Play(gApp.jni.jEnv, jo);
   end;
   procedure Process_AudioTrack_component;
   var
      jat: jAudioTrack;
   begin
        WriteLn(ClassName+'.Play::Process_AudioTrack_component: avant jat:= jAudioTrack.Create( nil); ');
        jat:= jAudioTrack.Create( nil);
        try
           jat.Duration         := _Duration;
           jat.StreamType       :=3;//AudioManager.STREAM_MUSIC 3
           jat.SampleRateInHz   :=SampleRate;
           jat.ChannelConfig    := 4; //AudioFormat.CHANNEL_OUT_MONO 4
           jat.AudioFormat      := 2; //AudioFormat.ENCODING_PCM_16BIT 2
           jat.Mode             := 0; //AudioTrack.MODE_STATIC 0
           WriteLn(ClassName+'.Play::Process_AudioTrack_component: avant jat.Init; ');
           jat.Init;

           WriteLn(ClassName+'.Play::Process_AudioTrack_component: avant jat.Write; ');
           jat.Write( Buffer, 0, Length(Buffer));

           WriteLn(ClassName+'.Play::Process_AudioTrack_component: avant jat.Play; ');
           jat.Play;
        finally
               FreeAndNil( jat);
               end;

   end;
begin
     WriteLn(ClassName+'.Play: avant Cree_Buffer');
     Cree_Buffer;
     //Process_AudioTrack;
     WriteLn(ClassName+'.Play: avant Process_AudioTrack_component');
     //Process_AudioTrack_component_old;
     Process_AudioTrack_component;
     WriteLn(ClassName+'.Play: Fin');
end;

class procedure TAudioTrack.Play(_Note: String);
var
   at: jAudioTrack;
   Frequence: double;
   i: Integer;
   a: double;
   Sample: double;
begin
     Frequence:= Frequences.Frequence_from_Midi( Midi_from_note( _Note));
     at:= jAudioTrack.Create( nil);
     try
        at.Duration         := 5;
        at.StreamType       := 3;//AudioManager.STREAM_MUSIC 3
        at.SampleRateInHz   := SampleRate;
        at.ChannelConfig    := 4; //AudioFormat.CHANNEL_OUT_MONO 4
        at.AudioFormat      := 2; //AudioFormat.ENCODING_PCM_16BIT 2
        at.Mode             := 0; //AudioTrack.MODE_STATIC 0
        at.Init;
        WriteLn( ClassName+'.Play: aprés at.Init, ',
                 'at.GetState=',at.GetState, ', ',
                 'Length(at.Buffer)=',Length(at.Buffer), ', ',
                 'at.getMaxVolume=',at.GetMaxVolume);
        for i:= Low(at.Buffer) to High(at.Buffer)
        do
          begin
          a:= IfThen<double>( i > at.SampleRateInHz, 1, i/at.SampleRateInHz);//montée de volume de 0 à 1 sur la première seconde
          Sample:= a*sin(2 * PI * i / (at.SampleRateInHz / Frequence)); // Sine wave
          at.Buffer[i]:= Trunc(Sample * SmallInt.MaxValue);  // Higher amplitude increases volume
          end;
        at.Write_Buffer_all;
        WriteLn( ClassName+'.Play: aprés at.Write_Buffer_all, ',
                 'at.GetState=',at.GetState,', ',
                 'at.getMaxVolume=',at.GetMaxVolume);
        at.SetVolume(1);
        at.Play;
     finally
            FreeAndNil( at);
            end;
end;

end.

