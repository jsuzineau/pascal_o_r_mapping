package com.mars42.jsNote;
/*android.jar*/
import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioTrack;
import android.content.Context;
 
/*Draft java code by "Lazarus Android Module Wizard" [04/06/2022 09:35:32]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jAudioTrack {
  
    private long pasobj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;
  
    private android.media.AudioTrack mAudioTrack;
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jAudioTrack( Controls _ctrls, long _Self,
                        int _streamType       ,
                        int _sampleRateInHz   ,
                        int _channelConfig    ,
                        int _audioFormat      ,
                        int _bufferSizeInBytes,
                        int _mode             )
       {
       /*
       mAudioTrack
       =
        new android.media.AudioTrack( _streamType,
                                      _sampleRateInHz,
                                      _channelConfig,
                                      _audioFormat,
                                      _bufferSizeInBytes,
                                      _mode);
       */
       mAudioTrack
       =
        new AudioTrack.Builder()
          .setAudioAttributes(new AudioAttributes.Builder()
                   .setUsage(AudioAttributes.USAGE_MEDIA)
                   .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                   .build())
          .setAudioFormat(new AudioFormat.Builder()
                  .setEncoding(_audioFormat)
                  .setSampleRate(_sampleRateInHz)
                  .setChannelMask(_channelConfig)
                  .build())
          .setBufferSizeInBytes(_bufferSizeInBytes)
          //.setTransferMode( _mode)
          .build();

       context   = _ctrls.activity;
       pasobj = _Self;
       controls  = _ctrls;
       }
  
    public void jFree() {
      //free local objects...
      mAudioTrack = null;
    }
  
 
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  //write others [public] methods code here......
 
   public void SetOffloadDelayPadding(int _arg0,int _arg1) {
      mAudioTrack.setOffloadDelayPadding( _arg0, _arg1);
   }
 
   public int GetOffloadDelay() {
      return mAudioTrack.getOffloadDelay();
   }
 
   public int GetOffloadPadding() {
      return mAudioTrack.getOffloadPadding();
   }
 
   public void SetOffloadEndOfStream() {
      mAudioTrack.setOffloadEndOfStream();
   }
 
   public boolean IsOffloadedPlayback() {
      return mAudioTrack.isOffloadedPlayback();
   }
 
   public static boolean IsDirectPlaybackSupported(android.media.AudioFormat _arg0,android.media.AudioAttributes _arg1) {
      return android.media.AudioTrack.isDirectPlaybackSupported( _arg0, _arg1);
   }
 
   public boolean SetAudioDescriptionMixLeveldB(float _arg0) {
      return mAudioTrack.setAudioDescriptionMixLeveldB( _arg0);
   }
 
   public float GetAudioDescriptionMixLeveldB() {
      return mAudioTrack.getAudioDescriptionMixLeveldB();
   }
 
   public boolean SetDualMonoMode(int _arg0) {
      return mAudioTrack.setDualMonoMode( _arg0);
   }
 
   public int GetDualMonoMode() {
      return mAudioTrack.getDualMonoMode();
   }
 
   public void Release() {
      mAudioTrack.release();
   }
 
   public static float GetMinVolume() {
      return android.media.AudioTrack.getMinVolume();
   }
 
   public static float GetMaxVolume() {
      return android.media.AudioTrack.getMaxVolume();
   }
 
   public int GetSampleRate() {
      return mAudioTrack.getSampleRate();
   }
 
   public int GetPlaybackRate() {
      return mAudioTrack.getPlaybackRate();
   }
 
   public android.media.PlaybackParams GetPlaybackParams() {
      return mAudioTrack.getPlaybackParams();
   }
 
   public android.media.AudioAttributes GetAudioAttributes() {
      return mAudioTrack.getAudioAttributes();
   }
 
   public int GetAudioFormat() {
      return mAudioTrack.getAudioFormat();
   }
 
   public int GetStreamType() {
      return mAudioTrack.getStreamType();
   }
 
   public int GetChannelConfiguration() {
      return mAudioTrack.getChannelConfiguration();
   }
 
   public android.media.AudioFormat GetFormat() {
      return mAudioTrack.getFormat();
   }
 
   public int GetChannelCount() {
      return mAudioTrack.getChannelCount();
   }
 
   public int GetState() {
      return mAudioTrack.getState();
   }
 
   public int GetPlayState() {
      return mAudioTrack.getPlayState();
   }
 
   public int GetBufferSizeInFrames() {
      return mAudioTrack.getBufferSizeInFrames();
   }
 
   public int SetBufferSizeInFrames(int _arg0) {
      return mAudioTrack.setBufferSizeInFrames( _arg0);
   }
 
   public int GetBufferCapacityInFrames() {
      return mAudioTrack.getBufferCapacityInFrames();
   }
 
   public int GetNotificationMarkerPosition() {
      return mAudioTrack.getNotificationMarkerPosition();
   }
 
   public int GetPositionNotificationPeriod() {
      return mAudioTrack.getPositionNotificationPeriod();
   }
 
   public int GetPlaybackHeadPosition() {
      return mAudioTrack.getPlaybackHeadPosition();
   }
 
   public int GetUnderrunCount() {
      return mAudioTrack.getUnderrunCount();
   }
 
   public int GetPerformanceMode() {
      return mAudioTrack.getPerformanceMode();
   }
 
   public static int GetNativeOutputSampleRate(int _arg0) {
      return android.media.AudioTrack.getNativeOutputSampleRate( _arg0);
   }
 
   public static int GetMinBufferSize(int _arg0,int _arg1,int _arg2) {
      return android.media.AudioTrack.getMinBufferSize( _arg0, _arg1, _arg2);
   }
 
   public int GetAudioSessionId() {
      return mAudioTrack.getAudioSessionId();
   }
 
   public boolean GetTimestamp(android.media.AudioTimestamp _arg0) {
      return mAudioTrack.getTimestamp( _arg0);
   }
 
   public android.os.PersistableBundle GetMetrics() {
      return mAudioTrack.getMetrics();
   }

   /*
   public void SetPlaybackPositionUpdateListener(android.media.AudioTrack$OnPlaybackPositionUpdateListener _arg0) {
      mAudioTrack.setPlaybackPositionUpdateListener( _arg0);
   }
 
   public void SetPlaybackPositionUpdateListener(android.media.AudioTrack$OnPlaybackPositionUpdateListener _arg0,android.os.Handler _arg1) {
      mAudioTrack.setPlaybackPositionUpdateListener( _arg0, _arg1);
   }
   */
   public int SetStereoVolume(float _arg0,float _arg1) {
      return mAudioTrack.setStereoVolume( _arg0, _arg1);
   }
 
   public int SetVolume(float _arg0) {
      return mAudioTrack.setVolume( _arg0);
   }

   /*
   public android.media.VolumeShaper CreateVolumeShaper(android.media.VolumeShaper$Configuration _arg0) {
      return mAudioTrack.createVolumeShaper( _arg0);
   }
   */
   public int SetPlaybackRate(int _arg0) {
      return mAudioTrack.setPlaybackRate( _arg0);
   }
 
   public void SetPlaybackParams(android.media.PlaybackParams _arg0) {
      mAudioTrack.setPlaybackParams( _arg0);
   }
 
   public int SetNotificationMarkerPosition(int _arg0) {
      return mAudioTrack.setNotificationMarkerPosition( _arg0);
   }
 
   public int SetPositionNotificationPeriod(int _arg0) {
      return mAudioTrack.setPositionNotificationPeriod( _arg0);
   }
 
   public int SetPlaybackHeadPosition(int _arg0) {
      return mAudioTrack.setPlaybackHeadPosition( _arg0);
   }
 
   public int SetLoopPoints(int _arg0,int _arg1,int _arg2) {
      return mAudioTrack.setLoopPoints( _arg0, _arg1, _arg2);
   }
 
   public int SetPresentation(android.media.AudioPresentation _arg0) {
      return mAudioTrack.setPresentation( _arg0);
   }
 
   public void Play() throws java.lang.IllegalStateException {
      mAudioTrack.play();
   }
 
   public void Stop() throws java.lang.IllegalStateException {
      mAudioTrack.stop();
   }
 
   public void Pause() throws java.lang.IllegalStateException {
      mAudioTrack.pause();
   }
 
   public void Flush() {
      mAudioTrack.flush();
   }
 
   public int Write(byte[]              _arg0     ,int _arg1          ,int _arg2                   ) { return mAudioTrack.write( _arg0, _arg1, _arg2       );}
   public int Write(byte[]              _arg0     ,int _arg1          ,int _arg2        ,int _arg3 ) { return mAudioTrack.write( _arg0, _arg1, _arg2, _arg3);}
   public int Write(short[]             _audioData,int _offsetInShorts,int _sizeInShorts           ) { return mAudioTrack.write( _audioData, _offsetInShorts, _sizeInShorts);}
   public int Write(short[]             _arg0     ,int _arg1          ,int _arg2        ,int _arg3 ) { return mAudioTrack.write( _arg0, _arg1, _arg2, _arg3);}
   public int Write(float[]             _arg0     ,int _arg1          ,int _arg2        ,int _arg3 ) { return mAudioTrack.write( _arg0, _arg1, _arg2, _arg3);}
   public int Write(java.nio.ByteBuffer _arg0     ,int _arg1          ,int _arg2                   ) { return mAudioTrack.write( _arg0, _arg1, _arg2);}
   public int Write(java.nio.ByteBuffer _arg0     ,int _arg1          ,int _arg2        ,long _arg3) { return mAudioTrack.write( _arg0, _arg1, _arg2, _arg3);}
 
   public int ReloadStaticData() {
      return mAudioTrack.reloadStaticData();
   }
 
   public int AttachAuxEffect(int _arg0) {
      return mAudioTrack.attachAuxEffect( _arg0);
   }
 
   public int SetAuxEffectSendLevel(float _arg0) {
      return mAudioTrack.setAuxEffectSendLevel( _arg0);
   }
 
   public boolean SetPreferredDevice(android.media.AudioDeviceInfo _arg0) {
      return mAudioTrack.setPreferredDevice( _arg0);
   }
 
   public android.media.AudioDeviceInfo GetPreferredDevice() {
      return mAudioTrack.getPreferredDevice();
   }
 
   public android.media.AudioDeviceInfo GetRoutedDevice() {
      return mAudioTrack.getRoutedDevice();
   }
   /*
   public void AddOnRoutingChangedListener(android.media.AudioRouting$OnRoutingChangedListener _arg0,android.os.Handler _arg1) {
      mAudioTrack.addOnRoutingChangedListener( _arg0, _arg1);
   }
 
   public void RemoveOnRoutingChangedListener(android.media.AudioRouting$OnRoutingChangedListener _arg0) {
      mAudioTrack.removeOnRoutingChangedListener( _arg0);
   }

   public void AddOnCodecFormatChangedListener(java.util.concurrent.Executor _arg0,android.media.AudioTrack$OnCodecFormatChangedListener _arg1) {
      mAudioTrack.addOnCodecFormatChangedListener( _arg0, _arg1);
   }
 
   public void RemoveOnCodecFormatChangedListener(android.media.AudioTrack$OnCodecFormatChangedListener _arg0) {
      mAudioTrack.removeOnCodecFormatChangedListener( _arg0);
   }

   public void RegisterStreamEventCallback(java.util.concurrent.Executor _arg0,android.media.AudioTrack$StreamEventCallback _arg1) {
      mAudioTrack.registerStreamEventCallback( _arg0, _arg1);
   }
 
   public void UnregisterStreamEventCallback(android.media.AudioTrack$StreamEventCallback _arg0) {
      mAudioTrack.unregisterStreamEventCallback( _arg0);
   }
   */
}
