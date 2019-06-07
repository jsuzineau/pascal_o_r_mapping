(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["Cle_Sol_8vb-Cle_Sol_8vb-module"],{

/***/ "./node_modules/webmidi/webmidi.min.js":
/*!*********************************************!*\
  !*** ./node_modules/webmidi/webmidi.min.js ***!
  \*********************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;/*

WebMidi v2.3.3

WebMidi.js helps you tame the Web MIDI API. Send and receive MIDI messages with ease. Control instruments with user-friendly functions (playNote, sendPitchBend, etc.). React to MIDI input with simple event listeners (noteon, pitchbend, controlchange, etc.).
https://github.com/djipco/webmidi


The MIT License (MIT)

Copyright (c) 2015-2018, Jean-Philippe Côté

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

!function(scope){"use strict";function WebMidi(){if(WebMidi.prototype._singleton)throw new Error("WebMidi is a singleton, it cannot be instantiated directly.");WebMidi.prototype._singleton=this,this._inputs=[],this._outputs=[],this._userHandlers={},this._stateChangeQueue=[],this._processingStateChange=!1,this._midiInterfaceEvents=["connected","disconnected"],this._notes=["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"],this._semitones={C:0,D:2,E:4,F:5,G:7,A:9,B:11},Object.defineProperties(this,{MIDI_SYSTEM_MESSAGES:{value:{sysex:240,timecode:241,songposition:242,songselect:243,tuningrequest:246,sysexend:247,clock:248,start:250,"continue":251,stop:252,activesensing:254,reset:255,midimessage:0,unknownsystemmessage:-1},writable:!1,enumerable:!0,configurable:!1},MIDI_CHANNEL_MESSAGES:{value:{noteoff:8,noteon:9,keyaftertouch:10,controlchange:11,channelmode:11,programchange:12,channelaftertouch:13,pitchbend:14},writable:!1,enumerable:!0,configurable:!1},MIDI_REGISTERED_PARAMETER:{value:{pitchbendrange:[0,0],channelfinetuning:[0,1],channelcoarsetuning:[0,2],tuningprogram:[0,3],tuningbank:[0,4],modulationrange:[0,5],azimuthangle:[61,0],elevationangle:[61,1],gain:[61,2],distanceratio:[61,3],maximumdistance:[61,4],maximumdistancegain:[61,5],referencedistanceratio:[61,6],panspreadangle:[61,7],rollangle:[61,8]},writable:!1,enumerable:!0,configurable:!1},MIDI_CONTROL_CHANGE_MESSAGES:{value:{bankselectcoarse:0,modulationwheelcoarse:1,breathcontrollercoarse:2,footcontrollercoarse:4,portamentotimecoarse:5,dataentrycoarse:6,volumecoarse:7,balancecoarse:8,pancoarse:10,expressioncoarse:11,effectcontrol1coarse:12,effectcontrol2coarse:13,generalpurposeslider1:16,generalpurposeslider2:17,generalpurposeslider3:18,generalpurposeslider4:19,bankselectfine:32,modulationwheelfine:33,breathcontrollerfine:34,footcontrollerfine:36,portamentotimefine:37,dataentryfine:38,volumefine:39,balancefine:40,panfine:42,expressionfine:43,effectcontrol1fine:44,effectcontrol2fine:45,holdpedal:64,portamento:65,sustenutopedal:66,softpedal:67,legatopedal:68,hold2pedal:69,soundvariation:70,resonance:71,soundreleasetime:72,soundattacktime:73,brightness:74,soundcontrol6:75,soundcontrol7:76,soundcontrol8:77,soundcontrol9:78,soundcontrol10:79,generalpurposebutton1:80,generalpurposebutton2:81,generalpurposebutton3:82,generalpurposebutton4:83,reverblevel:91,tremololevel:92,choruslevel:93,celestelevel:94,phaserlevel:95,databuttonincrement:96,databuttondecrement:97,nonregisteredparametercoarse:98,nonregisteredparameterfine:99,registeredparametercoarse:100,registeredparameterfine:101},writable:!1,enumerable:!0,configurable:!1},MIDI_CHANNEL_MODE_MESSAGES:{value:{allsoundoff:120,resetallcontrollers:121,localcontrol:122,allnotesoff:123,omnimodeoff:124,omnimodeon:125,monomodeon:126,polymodeon:127},writable:!1,enumerable:!0,configurable:!1},octaveOffset:{value:0,writable:!0,enumerable:!0,configurable:!1}}),Object.defineProperties(this,{supported:{enumerable:!0,get:function(){return"requestMIDIAccess"in navigator}},enabled:{enumerable:!0,get:function(){return void 0!==this["interface"]}.bind(this)},inputs:{enumerable:!0,get:function(){return this._inputs}.bind(this)},outputs:{enumerable:!0,get:function(){return this._outputs}.bind(this)},sysexEnabled:{enumerable:!0,get:function(){return!(!this["interface"]||!this["interface"].sysexEnabled)}.bind(this)},time:{enumerable:!0,get:function(){return performance.now()}}})}function Input(midiInput){var that=this;this._userHandlers={channel:{},system:{}},this._midiInput=midiInput,Object.defineProperties(this,{connection:{enumerable:!0,get:function(){return that._midiInput.connection}},id:{enumerable:!0,get:function(){return that._midiInput.id}},manufacturer:{enumerable:!0,get:function(){return that._midiInput.manufacturer}},name:{enumerable:!0,get:function(){return that._midiInput.name}},state:{enumerable:!0,get:function(){return that._midiInput.state}},type:{enumerable:!0,get:function(){return that._midiInput.type}}}),this._initializeUserHandlers(),this._midiInput.onmidimessage=this._onMidiMessage.bind(this)}function Output(midiOutput){var that=this;this._midiOutput=midiOutput,Object.defineProperties(this,{connection:{enumerable:!0,get:function(){return that._midiOutput.connection}},id:{enumerable:!0,get:function(){return that._midiOutput.id}},manufacturer:{enumerable:!0,get:function(){return that._midiOutput.manufacturer}},name:{enumerable:!0,get:function(){return that._midiOutput.name}},state:{enumerable:!0,get:function(){return that._midiOutput.state}},type:{enumerable:!0,get:function(){return that._midiOutput.type}}})}var wm=new WebMidi;WebMidi.prototype.enable=function(callback,sysex){return this.enabled?void 0:this.supported?void navigator.requestMIDIAccess({sysex:sysex}).then(function(midiAccess){function onPortsOpen(){clearTimeout(promiseTimeout),this._updateInputsAndOutputs(),this["interface"].onstatechange=this._onInterfaceStateChange.bind(this),"function"==typeof callback&&callback.call(this),events.forEach(function(event){this._onInterfaceStateChange(event)}.bind(this))}var promiseTimeout,events=[],promises=[];this["interface"]=midiAccess,this._resetInterfaceUserHandlers(),this["interface"].onstatechange=function(e){events.push(e)};for(var inputs=midiAccess.inputs.values(),input=inputs.next();input&&!input.done;input=inputs.next())promises.push(input.value.open());for(var outputs=midiAccess.outputs.values(),output=outputs.next();output&&!output.done;output=outputs.next())promises.push(output.value.open());promiseTimeout=setTimeout(onPortsOpen.bind(this),200),Promise&&Promise.all(promises)["catch"](function(err){}).then(onPortsOpen.bind(this))}.bind(this),function(err){"function"==typeof callback&&callback.call(this,err)}.bind(this)):void("function"==typeof callback&&callback(new Error("The Web MIDI API is not supported by your browser.")))},WebMidi.prototype.disable=function(){if(!this.supported)throw new Error("The Web MIDI API is not supported by your browser.");this["interface"]&&(this["interface"].onstatechange=void 0),this["interface"]=void 0,this._inputs=[],this._outputs=[],this._resetInterfaceUserHandlers()},WebMidi.prototype.addListener=function(type,listener){if(!this.enabled)throw new Error("WebMidi must be enabled before adding event listeners.");if("function"!=typeof listener)throw new TypeError("The 'listener' parameter must be a function.");if(!(this._midiInterfaceEvents.indexOf(type)>=0))throw new TypeError("The specified event type is not supported.");return this._userHandlers[type].push(listener),this},WebMidi.prototype.hasListener=function(type,listener){if(!this.enabled)throw new Error("WebMidi must be enabled before checking event listeners.");if("function"!=typeof listener)throw new TypeError("The 'listener' parameter must be a function.");if(!(this._midiInterfaceEvents.indexOf(type)>=0))throw new TypeError("The specified event type is not supported.");for(var o=0;o<this._userHandlers[type].length;o++)if(this._userHandlers[type][o]===listener)return!0;return!1},WebMidi.prototype.removeListener=function(type,listener){if(!this.enabled)throw new Error("WebMidi must be enabled before removing event listeners.");if(void 0!==listener&&"function"!=typeof listener)throw new TypeError("The 'listener' parameter must be a function.");if(this._midiInterfaceEvents.indexOf(type)>=0)if(listener)for(var o=0;o<this._userHandlers[type].length;o++)this._userHandlers[type][o]===listener&&this._userHandlers[type].splice(o,1);else this._userHandlers[type]=[];else{if(void 0!==type)throw new TypeError("The specified event type is not supported.");this._resetInterfaceUserHandlers()}return this},WebMidi.prototype.toMIDIChannels=function(channel){var channels;return channels="all"===channel||void 0===channel?["all"]:Array.isArray(channel)?channel:[channel],channels.indexOf("all")>-1&&(channels=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]),channels.map(function(ch){return parseInt(ch)}).filter(function(ch){return ch>=1&&16>=ch})},WebMidi.prototype.getInputById=function(id){if(!this.enabled)throw new Error("WebMidi is not enabled.");id=String(id);for(var i=0;i<this.inputs.length;i++)if(this.inputs[i].id===id)return this.inputs[i];return!1},WebMidi.prototype.getOutputById=function(id){if(!this.enabled)throw new Error("WebMidi is not enabled.");id=String(id);for(var i=0;i<this.outputs.length;i++)if(this.outputs[i].id===id)return this.outputs[i];return!1},WebMidi.prototype.getInputByName=function(name){if(!this.enabled)throw new Error("WebMidi is not enabled.");for(var i=0;i<this.inputs.length;i++)if(~this.inputs[i].name.indexOf(name))return this.inputs[i];return!1},WebMidi.prototype.getOctave=function(number){return null!=number&&number>=0&&127>=number?Math.floor(Math.floor(number)/12-1)+Math.floor(wm.octaveOffset):void 0},WebMidi.prototype.getOutputByName=function(name){if(!this.enabled)throw new Error("WebMidi is not enabled.");for(var i=0;i<this.outputs.length;i++)if(~this.outputs[i].name.indexOf(name))return this.outputs[i];return!1},WebMidi.prototype.guessNoteNumber=function(input){var output=!1;if(input&&input.toFixed&&input>=0&&127>=input?output=Math.round(input):parseInt(input)>=0&&parseInt(input)<=127?output=parseInt(input):("string"==typeof input||input instanceof String)&&(output=this.noteNameToNumber(input)),output===!1)throw new Error("Invalid input value ("+input+").");return output},WebMidi.prototype.noteNameToNumber=function(name){"string"!=typeof name&&(name="");var matches=name.match(/([CDEFGAB])(#{0,2}|b{0,2})(-?\d+)/i);if(!matches)throw new RangeError("Invalid note name.");var semitones=wm._semitones[matches[1].toUpperCase()],octave=parseInt(matches[3]),result=12*(octave+1-Math.floor(wm.octaveOffset))+semitones;if(matches[2].toLowerCase().indexOf("b")>-1?result-=matches[2].length:matches[2].toLowerCase().indexOf("#")>-1&&(result+=matches[2].length),0>result||result>127)throw new RangeError("Invalid note name or note outside valid range.");return result},WebMidi.prototype._updateInputsAndOutputs=function(){this._updateInputs(),this._updateOutputs()},WebMidi.prototype._updateInputs=function(){for(var i=0;i<this._inputs.length;i++){for(var remove=!0,updated=this["interface"].inputs.values(),input=updated.next();input&&!input.done;input=updated.next())if(this._inputs[i]._midiInput===input.value){remove=!1;break}remove&&this._inputs.splice(i,1)}this["interface"]&&this["interface"].inputs.forEach(function(nInput){for(var add=!0,j=0;j<this._inputs.length;j++)this._inputs[j]._midiInput===nInput&&(add=!1);add&&this._inputs.push(new Input(nInput))}.bind(this))},WebMidi.prototype._updateOutputs=function(){for(var i=0;i<this._outputs.length;i++){for(var remove=!0,updated=this["interface"].outputs.values(),output=updated.next();output&&!output.done;output=updated.next())if(this._outputs[i]._midiOutput===output.value){remove=!1;break}remove&&this._outputs.splice(i,1)}this["interface"]&&this["interface"].outputs.forEach(function(nOutput){for(var add=!0,j=0;j<this._outputs.length;j++)this._outputs[j]._midiOutput===nOutput&&(add=!1);add&&this._outputs.push(new Output(nOutput))}.bind(this))},WebMidi.prototype._onInterfaceStateChange=function(e){this._updateInputsAndOutputs();var event={timestamp:e.timeStamp,type:e.port.state};this["interface"]&&"connected"===e.port.state?"output"===e.port.type?event.port=this.getOutputById(e.port.id):"input"===e.port.type&&(event.port=this.getInputById(e.port.id)):event.port={connection:"closed",id:e.port.id,manufacturer:e.port.manufacturer,name:e.port.name,state:e.port.state,type:e.port.type},this._userHandlers[e.port.state].forEach(function(handler){handler(event)})},WebMidi.prototype._resetInterfaceUserHandlers=function(){for(var i=0;i<this._midiInterfaceEvents.length;i++)this._userHandlers[this._midiInterfaceEvents[i]]=[]},Input.prototype.addListener=function(type,channel,listener){var that=this;if(void 0===channel&&(channel="all"),Array.isArray(channel)||(channel=[channel]),channel.forEach(function(item){if("all"!==item&&!(item>=1&&16>=item))throw new RangeError("The 'channel' parameter is invalid.")}),"function"!=typeof listener)throw new TypeError("The 'listener' parameter must be a function.");if(void 0!==wm.MIDI_SYSTEM_MESSAGES[type])this._userHandlers.system[type]||(this._userHandlers.system[type]=[]),this._userHandlers.system[type].push(listener);else{if(void 0===wm.MIDI_CHANNEL_MESSAGES[type])throw new TypeError("The specified event type is not supported.");if(channel.indexOf("all")>-1){channel=[];for(var j=1;16>=j;j++)channel.push(j)}this._userHandlers.channel[type]||(this._userHandlers.channel[type]=[]),channel.forEach(function(ch){that._userHandlers.channel[type][ch]||(that._userHandlers.channel[type][ch]=[]),that._userHandlers.channel[type][ch].push(listener)})}return this},Input.prototype.on=Input.prototype.addListener,Input.prototype.hasListener=function(type,channel,listener){var that=this;if("function"!=typeof listener)throw new TypeError("The 'listener' parameter must be a function.");if(void 0===channel&&(channel="all"),channel.constructor!==Array&&(channel=[channel]),void 0!==wm.MIDI_SYSTEM_MESSAGES[type]){for(var o=0;o<this._userHandlers.system[type].length;o++)if(this._userHandlers.system[type][o]===listener)return!0}else if(void 0!==wm.MIDI_CHANNEL_MESSAGES[type]){if(channel.indexOf("all")>-1){channel=[];for(var j=1;16>=j;j++)channel.push(j)}return this._userHandlers.channel[type]?channel.every(function(chNum){var listeners=that._userHandlers.channel[type][chNum];return listeners&&listeners.indexOf(listener)>-1}):!1}return!1},Input.prototype.removeListener=function(type,channel,listener){var that=this;if(void 0!==listener&&"function"!=typeof listener)throw new TypeError("The 'listener' parameter must be a function.");if(void 0===channel&&(channel="all"),channel.constructor!==Array&&(channel=[channel]),void 0!==wm.MIDI_SYSTEM_MESSAGES[type])if(void 0===listener)this._userHandlers.system[type]=[];else for(var o=0;o<this._userHandlers.system[type].length;o++)this._userHandlers.system[type][o]===listener&&this._userHandlers.system[type].splice(o,1);else if(void 0!==wm.MIDI_CHANNEL_MESSAGES[type]){if(channel.indexOf("all")>-1){channel=[];for(var j=1;16>=j;j++)channel.push(j)}if(!this._userHandlers.channel[type])return this;channel.forEach(function(chNum){var listeners=that._userHandlers.channel[type][chNum];if(listeners)if(void 0===listener)that._userHandlers.channel[type][chNum]=[];else for(var l=0;l<listeners.length;l++)listeners[l]===listener&&listeners.splice(l,1)})}else{if(void 0!==type)throw new TypeError("The specified event type is not supported.");this._initializeUserHandlers()}return this},Input.prototype._initializeUserHandlers=function(){for(var prop1 in wm.MIDI_CHANNEL_MESSAGES)wm.MIDI_CHANNEL_MESSAGES.hasOwnProperty(prop1)&&(this._userHandlers.channel[prop1]={});for(var prop2 in wm.MIDI_SYSTEM_MESSAGES)wm.MIDI_SYSTEM_MESSAGES.hasOwnProperty(prop2)&&(this._userHandlers.system[prop2]=[])},Input.prototype._onMidiMessage=function(e){if(this._userHandlers.system.midimessage.length>0){var event={target:this,data:e.data,timestamp:e.timeStamp,type:"midimessage"};this._userHandlers.system.midimessage.forEach(function(callback){callback(event)})}e.data[0]<240?this._parseChannelEvent(e):e.data[0]<=255&&this._parseSystemEvent(e)},Input.prototype._parseChannelEvent=function(e){var data1,data2,command=e.data[0]>>4,channel=(15&e.data[0])+1;e.data.length>1&&(data1=e.data[1],data2=e.data.length>2?e.data[2]:void 0);var event={target:this,data:e.data,timestamp:e.timeStamp,channel:channel};command===wm.MIDI_CHANNEL_MESSAGES.noteoff||command===wm.MIDI_CHANNEL_MESSAGES.noteon&&0===data2?(event.type="noteoff",event.note={number:data1,name:wm._notes[data1%12],octave:wm.getOctave(data1)},event.velocity=data2/127,event.rawVelocity=data2):command===wm.MIDI_CHANNEL_MESSAGES.noteon?(event.type="noteon",event.note={number:data1,name:wm._notes[data1%12],octave:wm.getOctave(data1)},event.velocity=data2/127,event.rawVelocity=data2):command===wm.MIDI_CHANNEL_MESSAGES.keyaftertouch?(event.type="keyaftertouch",event.note={number:data1,name:wm._notes[data1%12],octave:wm.getOctave(data1)},event.value=data2/127):command===wm.MIDI_CHANNEL_MESSAGES.controlchange&&data1>=0&&119>=data1?(event.type="controlchange",event.controller={number:data1,name:this.getCcNameByNumber(data1)},event.value=data2):command===wm.MIDI_CHANNEL_MESSAGES.channelmode&&data1>=120&&127>=data1?(event.type="channelmode",event.controller={number:data1,name:this.getChannelModeByNumber(data1)},event.value=data2):command===wm.MIDI_CHANNEL_MESSAGES.programchange?(event.type="programchange",event.value=data1):command===wm.MIDI_CHANNEL_MESSAGES.channelaftertouch?(event.type="channelaftertouch",event.value=data1/127):command===wm.MIDI_CHANNEL_MESSAGES.pitchbend?(event.type="pitchbend",event.value=((data2<<7)+data1-8192)/8192):event.type="unknownchannelmessage",this._userHandlers.channel[event.type]&&this._userHandlers.channel[event.type][channel]&&this._userHandlers.channel[event.type][channel].forEach(function(callback){callback(event)})},Input.prototype.getCcNameByNumber=function(number){if(number=Math.floor(number),!(number>=0&&119>=number))throw new RangeError("The control change number must be between 0 and 119.");for(var cc in wm.MIDI_CONTROL_CHANGE_MESSAGES)if(wm.MIDI_CONTROL_CHANGE_MESSAGES.hasOwnProperty(cc)&&number===wm.MIDI_CONTROL_CHANGE_MESSAGES[cc])return cc;return void 0},Input.prototype.getChannelModeByNumber=function(number){if(number=Math.floor(number),!(number>=120&&status<=127))throw new RangeError("The control change number must be between 120 and 127.");for(var cm in wm.MIDI_CHANNEL_MODE_MESSAGES)if(wm.MIDI_CHANNEL_MODE_MESSAGES.hasOwnProperty(cm)&&number===wm.MIDI_CHANNEL_MODE_MESSAGES[cm])return cm},Input.prototype._parseSystemEvent=function(e){var command=e.data[0],event={target:this,data:e.data,timestamp:e.timeStamp};command===wm.MIDI_SYSTEM_MESSAGES.sysex?event.type="sysex":command===wm.MIDI_SYSTEM_MESSAGES.timecode?event.type="timecode":command===wm.MIDI_SYSTEM_MESSAGES.songposition?event.type="songposition":command===wm.MIDI_SYSTEM_MESSAGES.songselect?(event.type="songselect",event.song=e.data[1]):command===wm.MIDI_SYSTEM_MESSAGES.tuningrequest?event.type="tuningrequest":command===wm.MIDI_SYSTEM_MESSAGES.clock?event.type="clock":command===wm.MIDI_SYSTEM_MESSAGES.start?event.type="start":command===wm.MIDI_SYSTEM_MESSAGES["continue"]?event.type="continue":command===wm.MIDI_SYSTEM_MESSAGES.stop?event.type="stop":command===wm.MIDI_SYSTEM_MESSAGES.activesensing?event.type="activesensing":command===wm.MIDI_SYSTEM_MESSAGES.reset?event.type="reset":event.type="unknownsystemmessage",this._userHandlers.system[event.type]&&this._userHandlers.system[event.type].forEach(function(callback){callback(event)})},Output.prototype.send=function(status,data,timestamp){if(!(status>=128&&255>=status))throw new RangeError("The status byte must be an integer between 128 (0x80) and 255 (0xFF).");void 0===data&&(data=[]),Array.isArray(data)||(data=[data]);var message=[];return data.forEach(function(item,index){var parsed=Math.floor(item);if(!(parsed>=0&&255>=parsed))throw new RangeError("Data bytes must be integers between 0 (0x00) and 255 (0xFF).");message.push(parsed)}),this._midiOutput.send([status].concat(message),parseFloat(timestamp)||0),this},Output.prototype.sendSysex=function(manufacturer,data,options){if(!wm.sysexEnabled)throw new Error("Sysex message support must first be activated.");return options=options||{},manufacturer=[].concat(manufacturer),data.forEach(function(item){if(0>item||item>127)throw new RangeError("The data bytes of a sysex message must be integers between 0 (0x00) and 127 (0x7F).")}),data=manufacturer.concat(data,wm.MIDI_SYSTEM_MESSAGES.sysexend),this.send(wm.MIDI_SYSTEM_MESSAGES.sysex,data,this._parseTimeParameter(options.time)),this},Output.prototype.sendTimecodeQuarterFrame=function(value,options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES.timecode,value,this._parseTimeParameter(options.time)),this},Output.prototype.sendSongPosition=function(value,options){value=Math.floor(value)||0,options=options||{};var msb=value>>7&127,lsb=127&value;return this.send(wm.MIDI_SYSTEM_MESSAGES.songposition,[msb,lsb],this._parseTimeParameter(options.time)),this},Output.prototype.sendSongSelect=function(value,options){if(value=Math.floor(value),options=options||{},!(value>=0&&127>=value))throw new RangeError("The song number must be between 0 and 127.");return this.send(wm.MIDI_SYSTEM_MESSAGES.songselect,[value],this._parseTimeParameter(options.time)),this},Output.prototype.sendTuningRequest=function(options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES.tuningrequest,void 0,this._parseTimeParameter(options.time)),this},Output.prototype.sendClock=function(options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES.clock,void 0,this._parseTimeParameter(options.time)),this},Output.prototype.sendStart=function(options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES.start,void 0,this._parseTimeParameter(options.time)),this},Output.prototype.sendContinue=function(options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES["continue"],void 0,this._parseTimeParameter(options.time)),this},Output.prototype.sendStop=function(options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES.stop,void 0,this._parseTimeParameter(options.time)),this},Output.prototype.sendActiveSensing=function(options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES.activesensing,[],this._parseTimeParameter(options.time)),this},Output.prototype.sendReset=function(options){return options=options||{},this.send(wm.MIDI_SYSTEM_MESSAGES.reset,void 0,this._parseTimeParameter(options.time)),this},Output.prototype.stopNote=function(note,channel,options){if("all"===note)return this.sendChannelMode("allnotesoff",0,channel,options);var nVelocity=64;return options=options||{},options.rawVelocity?!isNaN(options.velocity)&&options.velocity>=0&&options.velocity<=127&&(nVelocity=options.velocity):!isNaN(options.velocity)&&options.velocity>=0&&options.velocity<=1&&(nVelocity=127*options.velocity),this._convertNoteToArray(note).forEach(function(item){wm.toMIDIChannels(channel).forEach(function(ch){this.send((wm.MIDI_CHANNEL_MESSAGES.noteoff<<4)+(ch-1),[item,Math.round(nVelocity)],this._parseTimeParameter(options.time))}.bind(this))}.bind(this)),this},Output.prototype.playNote=function(note,channel,options){var time,nVelocity=64;if(options=options||{},options.rawVelocity?!isNaN(options.velocity)&&options.velocity>=0&&options.velocity<=127&&(nVelocity=options.velocity):!isNaN(options.velocity)&&options.velocity>=0&&options.velocity<=1&&(nVelocity=127*options.velocity),time=this._parseTimeParameter(options.time),this._convertNoteToArray(note).forEach(function(item){wm.toMIDIChannels(channel).forEach(function(ch){this.send((wm.MIDI_CHANNEL_MESSAGES.noteon<<4)+(ch-1),[item,Math.round(nVelocity)],time)}.bind(this))}.bind(this)),!isNaN(options.duration)){options.duration<=0&&(options.duration=0);var nRelease=64;options.rawVelocity?!isNaN(options.release)&&options.release>=0&&options.release<=127&&(nRelease=options.release):!isNaN(options.release)&&options.release>=0&&options.release<=1&&(nRelease=127*options.release),this._convertNoteToArray(note).forEach(function(item){wm.toMIDIChannels(channel).forEach(function(ch){this.send((wm.MIDI_CHANNEL_MESSAGES.noteoff<<4)+(ch-1),[item,Math.round(nRelease)],(time||wm.time)+options.duration)}.bind(this))}.bind(this))}return this},Output.prototype.sendKeyAftertouch=function(note,channel,pressure,options){var that=this;if(options=options||{},1>channel||channel>16)throw new RangeError("The channel must be between 1 and 16.");(isNaN(pressure)||0>pressure||pressure>1)&&(pressure=.5);var nPressure=Math.round(127*pressure);return this._convertNoteToArray(note).forEach(function(item){wm.toMIDIChannels(channel).forEach(function(ch){that.send((wm.MIDI_CHANNEL_MESSAGES.keyaftertouch<<4)+(ch-1),[item,nPressure],that._parseTimeParameter(options.time))})}),this},Output.prototype.sendControlChange=function(controller,value,channel,options){if(options=options||{},"string"==typeof controller){if(controller=wm.MIDI_CONTROL_CHANGE_MESSAGES[controller],void 0===controller)throw new TypeError("Invalid controller name.")}else if(controller=Math.floor(controller),!(controller>=0&&119>=controller))throw new RangeError("Controller numbers must be between 0 and 119.");if(value=Math.floor(value)||0,!(value>=0&&127>=value))throw new RangeError("Controller value must be between 0 and 127.");return wm.toMIDIChannels(channel).forEach(function(ch){this.send((wm.MIDI_CHANNEL_MESSAGES.controlchange<<4)+(ch-1),[controller,value],this._parseTimeParameter(options.time))}.bind(this)),this},Output.prototype._selectRegisteredParameter=function(parameter,channel,time){var that=this;if(parameter[0]=Math.floor(parameter[0]),!(parameter[0]>=0&&parameter[0]<=127))throw new RangeError("The control65 value must be between 0 and 127");if(parameter[1]=Math.floor(parameter[1]),!(parameter[1]>=0&&parameter[1]<=127))throw new RangeError("The control64 value must be between 0 and 127");return wm.toMIDIChannels(channel).forEach(function(ch){that.sendControlChange(101,parameter[0],channel,{time:time}),that.sendControlChange(100,parameter[1],channel,{time:time})}),this},Output.prototype._selectNonRegisteredParameter=function(parameter,channel,time){var that=this;if(parameter[0]=Math.floor(parameter[0]),!(parameter[0]>=0&&parameter[0]<=127))throw new RangeError("The control63 value must be between 0 and 127");if(parameter[1]=Math.floor(parameter[1]),!(parameter[1]>=0&&parameter[1]<=127))throw new RangeError("The control62 value must be between 0 and 127");return wm.toMIDIChannels(channel).forEach(function(ch){that.sendControlChange(99,parameter[0],channel,{time:time}),that.sendControlChange(98,parameter[1],channel,{time:time})}),this},Output.prototype._setCurrentRegisteredParameter=function(data,channel,time){var that=this;if(data=[].concat(data),data[0]=Math.floor(data[0]),!(data[0]>=0&&data[0]<=127))throw new RangeError("The msb value must be between 0 and 127");return wm.toMIDIChannels(channel).forEach(function(ch){that.sendControlChange(6,data[0],channel,{time:time})}),data[1]=Math.floor(data[1]),data[1]>=0&&data[1]<=127&&wm.toMIDIChannels(channel).forEach(function(ch){that.sendControlChange(38,data[1],channel,{time:time})}),this},Output.prototype._deselectRegisteredParameter=function(channel,time){var that=this;return wm.toMIDIChannels(channel).forEach(function(ch){that.sendControlChange(101,127,channel,{time:time}),that.sendControlChange(100,127,channel,{time:time})}),this},Output.prototype.setRegisteredParameter=function(parameter,data,channel,options){var that=this;if(options=options||{},!Array.isArray(parameter)){if(!wm.MIDI_REGISTERED_PARAMETER[parameter])throw new Error("The specified parameter is not available.");parameter=wm.MIDI_REGISTERED_PARAMETER[parameter]}return wm.toMIDIChannels(channel).forEach(function(ch){that._selectRegisteredParameter(parameter,channel,options.time),that._setCurrentRegisteredParameter(data,channel,options.time),that._deselectRegisteredParameter(channel,options.time)}),this},Output.prototype.setNonRegisteredParameter=function(parameter,data,channel,options){var that=this;if(options=options||{},!(parameter[0]>=0&&parameter[0]<=127&&parameter[1]>=0&&parameter[1]<=127))throw new Error("Position 0 and 1 of the 2-position parameter array must both be between 0 and 127.");return data=[].concat(data),wm.toMIDIChannels(channel).forEach(function(ch){that._selectNonRegisteredParameter(parameter,channel,options.time),that._setCurrentRegisteredParameter(data,channel,options.time),that._deselectRegisteredParameter(channel,options.time)}),this},Output.prototype.incrementRegisteredParameter=function(parameter,channel,options){var that=this;if(options=options||{},!Array.isArray(parameter)){if(!wm.MIDI_REGISTERED_PARAMETER[parameter])throw new Error("The specified parameter is not available.");parameter=wm.MIDI_REGISTERED_PARAMETER[parameter]}return wm.toMIDIChannels(channel).forEach(function(ch){that._selectRegisteredParameter(parameter,channel,options.time),that.sendControlChange(96,0,channel,{time:options.time}),that._deselectRegisteredParameter(channel,options.time)}),this},Output.prototype.decrementRegisteredParameter=function(parameter,channel,options){if(options=options||{},!Array.isArray(parameter)){if(!wm.MIDI_REGISTERED_PARAMETER[parameter])throw new TypeError("The specified parameter is not available.");parameter=wm.MIDI_REGISTERED_PARAMETER[parameter]}return wm.toMIDIChannels(channel).forEach(function(ch){this._selectRegisteredParameter(parameter,channel,options.time),this.sendControlChange(97,0,channel,{time:options.time}),this._deselectRegisteredParameter(channel,options.time)}.bind(this)),this},Output.prototype.setPitchBendRange=function(semitones,cents,channel,options){var that=this;if(options=options||{},semitones=Math.floor(semitones)||0,!(semitones>=0&&127>=semitones))throw new RangeError("The semitones value must be between 0 and 127");if(cents=Math.floor(cents)||0,!(cents>=0&&127>=cents))throw new RangeError("The cents value must be between 0 and 127");return wm.toMIDIChannels(channel).forEach(function(ch){that.setRegisteredParameter("pitchbendrange",[semitones,cents],channel,{time:options.time})}),this},Output.prototype.setModulationRange=function(semitones,cents,channel,options){var that=this;if(options=options||{},semitones=Math.floor(semitones)||0,!(semitones>=0&&127>=semitones))throw new RangeError("The semitones value must be between 0 and 127");if(cents=Math.floor(cents)||0,!(cents>=0&&127>=cents))throw new RangeError("The cents value must be between 0 and 127");return wm.toMIDIChannels(channel).forEach(function(ch){that.setRegisteredParameter("modulationrange",[semitones,cents],channel,{time:options.time})}),this},Output.prototype.setMasterTuning=function(value,channel,options){var that=this;if(options=options||{},value=parseFloat(value)||0,-65>=value||value>=64)throw new RangeError("The value must be a decimal number larger than -65 and smaller than 64.");var coarse=Math.floor(value)+64,fine=value-Math.floor(value);fine=Math.round((fine+1)/2*16383);var msb=fine>>7&127,lsb=127&fine;return wm.toMIDIChannels(channel).forEach(function(ch){that.setRegisteredParameter("channelcoarsetuning",coarse,channel,{time:options.time}),that.setRegisteredParameter("channelfinetuning",[msb,lsb],channel,{time:options.time})}),this},Output.prototype.setTuningProgram=function(value,channel,options){var that=this;if(options=options||{},value=Math.floor(value),!(value>=0&&127>=value))throw new RangeError("The program value must be between 0 and 127");return wm.toMIDIChannels(channel).forEach(function(ch){that.setRegisteredParameter("tuningprogram",value,channel,{time:options.time})}),this},Output.prototype.setTuningBank=function(value,channel,options){var that=this;if(options=options||{},value=Math.floor(value)||0,!(value>=0&&127>=value))throw new RangeError("The bank value must be between 0 and 127");return wm.toMIDIChannels(channel).forEach(function(ch){that.setRegisteredParameter("tuningbank",value,channel,{time:options.time})}),this},Output.prototype.sendChannelMode=function(command,value,channel,options){if(options=options||{},"string"==typeof command){if(command=wm.MIDI_CHANNEL_MODE_MESSAGES[command],!command)throw new TypeError("Invalid channel mode message name.")}else if(command=Math.floor(command),!(command>=120&&127>=command))throw new RangeError("Channel mode numerical identifiers must be between 120 and 127.");if(value=Math.floor(value)||0,0>value||value>127)throw new RangeError("Value must be an integer between 0 and 127.");return wm.toMIDIChannels(channel).forEach(function(ch){this.send((wm.MIDI_CHANNEL_MESSAGES.channelmode<<4)+(ch-1),[command,value],this._parseTimeParameter(options.time))}.bind(this)),this},Output.prototype.sendProgramChange=function(program,channel,options){
var that=this;if(options=options||{},program=Math.floor(program),isNaN(program)||0>program||program>127)throw new RangeError("Program numbers must be between 0 and 127.");return wm.toMIDIChannels(channel).forEach(function(ch){that.send((wm.MIDI_CHANNEL_MESSAGES.programchange<<4)+(ch-1),[program],that._parseTimeParameter(options.time))}),this},Output.prototype.sendChannelAftertouch=function(pressure,channel,options){var that=this;options=options||{},pressure=parseFloat(pressure),(isNaN(pressure)||0>pressure||pressure>1)&&(pressure=.5);var nPressure=Math.round(127*pressure);return wm.toMIDIChannels(channel).forEach(function(ch){that.send((wm.MIDI_CHANNEL_MESSAGES.channelaftertouch<<4)+(ch-1),[nPressure],that._parseTimeParameter(options.time))}),this},Output.prototype.sendPitchBend=function(bend,channel,options){var that=this;if(options=options||{},isNaN(bend)||-1>bend||bend>1)throw new RangeError("Pitch bend value must be between -1 and 1.");var nLevel=Math.round((bend+1)/2*16383),msb=nLevel>>7&127,lsb=127&nLevel;return wm.toMIDIChannels(channel).forEach(function(ch){that.send((wm.MIDI_CHANNEL_MESSAGES.pitchbend<<4)+(ch-1),[lsb,msb],that._parseTimeParameter(options.time))}),this},Output.prototype._parseTimeParameter=function(time){var value,parsed=parseFloat(time);return"string"==typeof time&&"+"===time.substring(0,1)?parsed&&parsed>0&&(value=wm.time+parsed):parsed>wm.time&&(value=parsed),value},Output.prototype._convertNoteToArray=function(note){var notes=[];return Array.isArray(note)||(note=[note]),note.forEach(function(item){notes.push(wm.guessNoteNumber(item))}),notes}, true?!(__WEBPACK_AMD_DEFINE_ARRAY__ = [], __WEBPACK_AMD_DEFINE_RESULT__ = (function(){return wm}).apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__)):undefined}(this);

/***/ }),

/***/ "./src/app/Cle_Sol_8vb/Cle_Sol_8vb.module.ts":
/*!***************************************************!*\
  !*** ./src/app/Cle_Sol_8vb/Cle_Sol_8vb.module.ts ***!
  \***************************************************/
/*! exports provided: Cle_Sol_8vbPageModule */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Cle_Sol_8vbPageModule", function() { return Cle_Sol_8vbPageModule; });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/__ivy_ngcc__/fesm5/core.js");
/* harmony import */ var _angular_common__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/common */ "./node_modules/@angular/common/__ivy_ngcc__/fesm5/common.js");
/* harmony import */ var _angular_forms__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/forms */ "./node_modules/@angular/forms/__ivy_ngcc__/fesm5/forms.js");
/* harmony import */ var _angular_router__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @angular/router */ "./node_modules/@angular/router/__ivy_ngcc__/fesm5/router.js");
/* harmony import */ var _Cle_Sol_8vb_page__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./Cle_Sol_8vb.page */ "./src/app/Cle_Sol_8vb/Cle_Sol_8vb.page.ts");







var Cle_Sol_8vbPageModule = /** @class */ (function () {
    function Cle_Sol_8vbPageModule() {
    }
    Cle_Sol_8vbPageModule.ngModuleDef = _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵdefineNgModule"]({ type: Cle_Sol_8vbPageModule });
    Cle_Sol_8vbPageModule.ngInjectorDef = _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵdefineInjector"]({ factory: function Cle_Sol_8vbPageModule_Factory(t) { return new (t || Cle_Sol_8vbPageModule)(); }, imports: [[
                _angular_common__WEBPACK_IMPORTED_MODULE_1__["CommonModule"],
                _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormsModule"],
                _angular_router__WEBPACK_IMPORTED_MODULE_3__["RouterModule"].forChild([
                    {
                        path: '',
                        component: _Cle_Sol_8vb_page__WEBPACK_IMPORTED_MODULE_4__["Cle_Sol_8vbPage"]
                    }
                ])
            ]] });
    return Cle_Sol_8vbPageModule;
}());

/*@__PURE__*/ _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵsetNgModuleScope"](Cle_Sol_8vbPageModule, { declarations: [_Cle_Sol_8vb_page__WEBPACK_IMPORTED_MODULE_4__["Cle_Sol_8vbPage"]], imports: [_angular_common__WEBPACK_IMPORTED_MODULE_1__["CommonModule"],
        _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormsModule"], _angular_router__WEBPACK_IMPORTED_MODULE_3__["RouterModule"]] });
/*@__PURE__*/ _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵsetClassMetadata"](Cle_Sol_8vbPageModule, [{
        type: _angular_core__WEBPACK_IMPORTED_MODULE_0__["NgModule"],
        args: [{
                imports: [
                    _angular_common__WEBPACK_IMPORTED_MODULE_1__["CommonModule"],
                    _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormsModule"],
                    _angular_router__WEBPACK_IMPORTED_MODULE_3__["RouterModule"].forChild([
                        {
                            path: '',
                            component: _Cle_Sol_8vb_page__WEBPACK_IMPORTED_MODULE_4__["Cle_Sol_8vbPage"]
                        }
                    ])
                ],
                declarations: [_Cle_Sol_8vb_page__WEBPACK_IMPORTED_MODULE_4__["Cle_Sol_8vbPage"]]
            }]
    }], null, null);


/***/ }),

/***/ "./src/app/Cle_Sol_8vb/Cle_Sol_8vb.page.ts":
/*!*************************************************!*\
  !*** ./src/app/Cle_Sol_8vb/Cle_Sol_8vb.page.ts ***!
  \*************************************************/
/*! exports provided: Cle_Sol_8vbPage */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Cle_Sol_8vbPage", function() { return Cle_Sol_8vbPage; });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/__ivy_ngcc__/fesm5/core.js");
/* harmony import */ var webmidi__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! webmidi */ "./node_modules/webmidi/webmidi.min.js");
/* harmony import */ var webmidi__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(webmidi__WEBPACK_IMPORTED_MODULE_1__);



var _c0 = ["id", "svg2", "width", "394", "height", "785", "viewBox", "0 0 394 785"];
var _c1 = ["x", "0", "y", "0", "width", "100", "height", "100", 3, "fill", "click"];
var _c2 = ["cx", "200", "cy", "10", "rx", "24", "ry", "30", 2, "stroke-width", "0.6875", 3, "fill", "click"];
var _c3 = ["d", "m 152.99353,763.06566 c -12.50641,-3.80428 -20.28021,-12.56054 -20.3546,-22.92705 -0.0488,-6.80578 1.76211,-10.56767 8.53423,-17.72818 l 4.92324,-5.2056 -2.96215,-2.10924 c -4.12182,-2.93499 -8.13962,-11.3754 -8.11229,-17.04193 0.0465,-9.65057 7.87609,-19.17512 18.513,-22.52084 8.12522,-2.55569 24.21015,-1.82488 30.46504,1.38417 8.58476,4.40438 12,9.07507 12,16.41123 0,5.54988 -1.77418,9.83954 -6.88006,16.63483 l -4.00862,5.33497 3.8413,2.78262 c 13.08229,9.47676 14.65388,26.15496 3.51428,37.29456 -6.60749,6.60749 -12.87588,8.64619 -26.25441,8.53885 -5.89187,-0.0473 -11.8404,-0.42905 -13.21896,-0.84839 z m 20.92716,-4.52465 c 6.48152,-3.35172 9.16441,-13.63658 5.22785,-20.04101 -1.22679,-1.99587 -5.97798,-5.34296 -14.19502,-10 -6.79307,-3.85 -12.88723,-7.13599 -13.54256,-7.30219 -1.54845,-0.39272 -7.93544,7.41987 -9.88975,12.09717 -2.14604,5.13621 -1.90169,8.5488 1.03392,14.43981 5.35174,10.73954 21.04143,16.14504 31.36556,10.80622 z m 8.38956,-50.06313 c 5.94393,-7.44944 7.38244,-16.18929 3.66752,-22.28245 -4.50866,-7.39506 -19.88541,-10.75029 -27.07989,-5.90887 -6.128,4.12375 -7.24982,13.15528 -2.22087,17.87974 2.07349,1.94794 20.80504,13.48306 22.32299,13.74678 0.275,0.0478 1.76461,-1.49806 3.31025,-3.4352 z M 155.5,660.06448 c -22.71775,-3.71667 -41.69039,-17.79406 -52.42085,-38.8954 -5.698374,-11.20579 -8.118227,-32.68357 -4.724171,-41.93006 3.987821,-10.86409 13.798491,-19.70937 25.956421,-23.40222 17.7479,-5.39076 33.99392,2.00377 42.09586,19.16034 2.68159,5.67848 3.06953,7.58042 3.06016,15.00286 -0.013,10.29459 -2.86442,17.44963 -9.66368,24.24889 -7.16302,7.16302 -12.56993,9.25148 -23.94529,9.24904 l -9.64155,-0.002 1.8258,2.5641 c 2.80887,3.94469 10.09801,10.35512 15.0204,13.20967 7.83605,4.54423 15.04661,6.02394 26.96207,5.53301 9.77405,-0.40271 11.33777,-0.75296 18.45786,-4.13427 17.25628,-8.19498 31.558,-29.67163 35.40585,-53.16838 1.56923,-9.58242 2.39636,-33.43087 1.61216,-46.48271 L 224.77899,529 H 112.8895 1 v -3.5 -3.5 l 76.75,-0.0134 76.75,-0.0134 -9.62494,-4.77133 C 117.71749,503.73919 95.425956,478.56214 83.382979,447.75 L 79.572175,438 H 40.286088 1 v -3.5 -3.5 h 38.608408 38.608408 l -0.541564,-2.25 c -2.284609,-9.4917 -3.052706,-17.52229 -3.084599,-32.25 -0.03858,-17.81449 0.904208,-24.48596 5.877802,-41.5933 L 82.76716,347 H 41.88358 1 v -3.5 -3.5 h 42.424891 42.424891 l 2.908991,-5.25 c 5.673584,-10.2394 14.585187,-25.3128 17.588617,-29.75 3.41286,-5.04209 20.01823,-25.68949 31.96835,-39.75 L 146.17738,256 H 73.588691 1 v -3.5 -3.5 h 75.809275 75.809275 l 4.63772,-5.37185 4.63772,-5.37185 -4.36587,-15.49013 c -5.44415,-19.31589 -9.29719,-36.38303 -10.87772,-48.18303 L 145.43378,165.5 73.21689,165.24342 1,164.98685 V 161.49342 158 l 71.75,7.9e-4 71.75,7.9e-4 -0.32714,-26.75079 c -0.35299,-28.86377 0.35003,-36.915729 4.4664,-51.156088 2.66686,-9.225847 9.49828,-24.457488 14.61564,-32.587688 C 174.69959,29.324264 193.37863,11 200.46872,11 c 3.0037,0 3.83819,0.77793 9.61615,8.964327 13.15682,18.641002 22.55884,37.957738 31.4114,64.535673 7.37499,22.14183 9.00373,31.95537 9.00373,54.24954 v 19.24955 l 71.75,4.5e-4 L 394,158 v 3.5 3.5 h -72.46146 -72.46145 l -1.07407,4.25 c -2.03875,8.06718 -7.18378,22.15887 -10.48091,28.70609 -3.94228,7.82834 -18.55758,30.06827 -27.79405,42.29391 L 203.11744,249 H 298.55872 394 v 3.5 3.5 h -98.38495 -98.38494 l -5.12302,6.25 c -3.11675,3.80239 -4.89614,6.83743 -4.54368,7.75 1.33205,3.44898 9.78475,33.82793 14.19032,51 l 4.74627,18.5 93.75,0.25513 93.75,0.25512 V 343.50513 347 l -74.25,0.0263 -74.25,0.0263 7,3.73403 c 10.57804,5.64269 15.27262,9.20498 23.5514,17.87103 8.7246,9.13273 12.30554,14.09619 17.2013,23.84232 4.6177,9.19258 7.46073,18.62094 8.92004,29.5816 l 1.18741,8.9184 H 348.68007 394 v 3.5 3.5 H 348.5 303 v 2.36901 c 0,1.30296 -0.68383,6.29036 -1.51961,11.08312 -5.30669,30.4308 -26.01552,55.42324 -56.48039,68.16331 l -5.5,2.30004 77.25,0.0423 L 394,522 v 3.5 3.5 h -77.15656 -77.15656 l 0.60652,15.25 c 0.80799,20.31596 -0.64141,45.05847 -3.23653,55.25 -7.18217,28.20579 -29.37742,52.63127 -53.59139,58.97638 -7.27559,1.90652 -21.18953,2.69666 -27.96548,1.5881 z m 56.62108,-148.12484 c 5.68314,-0.58321 10.46086,-1.18825 10.61715,-1.34454 0.73544,-0.73544 -6.79501,-52.3849 -9.81886,-67.3451 L 211.8582,438 h -26.94349 -26.9435 l 3.10995,6.16077 c 3.59069,7.11313 10.738,14.62745 19.66884,20.67885 5.44643,3.69042 6.25,4.63968 6.25,7.38319 0,4.27134 -3.42171,7.77719 -7.59054,7.77719 -8.65726,0 -30.21186,-19.7699 -37.00405,-33.94015 L 138.5421,438 h -18.89886 -18.89886 l 0.65681,4.10746 c 0.36125,2.25911 1.98675,7.54661 3.61224,11.75 7.4958,19.38366 24.72588,37.62496 45.78503,48.47211 18.56961,9.56484 35.6616,12.24338 61.32262,9.61007 z m 34.55598,-9.08308 c 10.36932,-5.84832 20.97151,-18.02585 26.42234,-30.34836 3.9095,-8.83809 6.10404,-25.41569 4.27031,-32.2582 L 276.76674,438 h -24.96283 -24.96282 l 0.57269,2.75 c 1.29215,6.20478 6.53986,39.68058 8.22922,52.49518 2.06132,15.6361 1.38951,15.05092 11.03406,9.61138 z M 135.91855,427.25 c -1.40696,-6.05865 -1.04593,-21.78117 0.6786,-29.55259 4.50153,-20.28578 18.47924,-37.77771 38.16724,-47.76308 l 5.73561,-2.909 -28.5,-0.006 -28.5,-0.006 -1.89134,3.24367 c -4.46173,7.65191 -9.64728,18.87215 -12.59096,27.24368 -6.34127,18.03396 -8.12055,26.23985 -8.7274,40.25 l -0.573928,13.25 h 18.536498 18.53651 l -0.87083,-3.75 z M 210,428.9788 c 0,-2.81482 -9.11337,-46.31801 -9.88474,-47.18536 -1.17421,-1.3203 -14.58701,2.41331 -21.39001,5.95416 -8.07567,4.20326 -15.43047,11.82248 -19.29247,19.98608 -2.08288,4.40283 -2.82599,7.75882 -3.21023,14.49767 L 155.72259,431 h 27.1387 C 209.4282,431 210,430.95741 210,428.9788 Z m 65,0.30854 c 0,-0.94197 -1.89565,-5.55447 -4.21257,-10.25 -3.36258,-6.81475 -6.03932,-10.39039 -13.26617,-17.72123 -7.5464,-7.65498 -10.46597,-9.86137 -17.53744,-13.25345 -6.83907,-3.28061 -22.64312,-7.7367 -23.69796,-6.68185 -0.23902,0.23902 8.52451,46.00895 9.26121,48.36919 0.29822,0.95543 6.17119,1.25 24.92155,1.25 C 272.96144,431 275,430.85768 275,429.28734 Z M 185.91526,321.25 c -2.70013,-10.3125 -6.17859,-23.43648 -7.72992,-29.16439 l -2.82059,-10.41439 -10.93238,12.29038 c -10.21307,11.48174 -35.33487,43.61894 -35.40215,45.2884 -0.0166,0.4125 13.88031,0.75 30.88207,0.75 h 30.91229 z m 4.18348,-118.25434 c 7.97768,-10.99912 22.83653,-35.18317 22.884,-37.24566 0.009,-0.4125 -11.73459,-0.75 -26.09796,-0.75 h -26.11523 l 0.69103,5.75 c 1.18733,9.87971 5.35995,30.11699 8.68458,42.12042 l 3.18886,11.51322 3.84765,-4.44182 c 2.11621,-2.443 7.92889,-10.06877 12.91707,-16.94616 z m 28.11597,-50.28135 c 6.24531,-16.82459 8.75167,-37.14632 6.91616,-56.076718 -1.0716,-11.05189 -5.00054,-30.840593 -6.40136,-32.241412 C 217.87935,63.546014 209.05149,68.38143 202,73.559686 188.59955,83.4003 177.97409,96.45384 170.4704,112.2943 c -5.83949,12.32728 -8.54711,22.7627 -9.20365,35.47175 l -0.53034,10.26605 27.85092,-0.26605 27.85093,-0.26605 z", "id", "path12", 2, "fill", "#000000"];
var _c4 = ["id", "E3", "cx", "340", "cy", "523.94031", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "fill", "click"];
var _c5 = ["id", "F3", "cx", "340", "cy", "478.89972", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c6 = ["id", "G3", "cx", "340", "cy", "436.33109", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c7 = ["id", "A3", "cx", "340", "cy", "392.22668", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c8 = ["id", "B3", "cx", "340", "cy", "345.17059", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c9 = ["id", "C3", "cx", "340", "cy", "607.32513", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c10 = ["id", "D3", "cx", "340", "cy", "565.92480", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c11 = ["id", "C4", "cx", "340", "cy", "302.81781", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c12 = ["id", "D4", "cx", "340", "cy", "249.73567", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c13 = ["id", "E4", "cx", "340", "cy", "201.49153", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c14 = ["id", "F4", "cx", "340", "cy", "158.48875", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c15 = ["id", "G4", "cx", "340", "cy", "116.18430", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c16 = ["id", "A4", "cx", "340", "cy", "73.143707", "rx", "24", "ry", "19.437899", 2, "stroke-width", "0.6875", 3, "click"];
var _c17 = ["x", "300", "y", "200", "width", "500", "height", "4.5357141", "fill", "red", 2, "stroke-width", "0.26458332"];
var _c18 = ["x", "300", "y", "295", "width", "500", "height", "4.5357141", "fill", "red", 2, "stroke-width", "0.26458332"];
var _c19 = ["x", "300", "y", "395", "width", "500", "height", "4.5357141", "fill", "red", 2, "stroke-width", "0.26458332"];
var _c20 = ["x", "300", "y", "500", "fill", "green"];
var Cle_Sol_8vbPage = /** @class */ (function () {
    function Cle_Sol_8vbPage() {
        this.fill = "blue";
        this.oscillator = null;
        this.gain = null;
        this.mo = null;
        this.truc = "troc";
    }
    Cle_Sol_8vbPage.prototype.ngOnInit = function () {
        this.audioContext = new AudioContext();
        this.gain = this.audioContext.createGain();
        this.gain.value = 1.0;
        this.oscillator = this.audioContext.createOscillator();
        this.oscillator.type = 'sawtooth';
        this.oscillator.frequency.value = 440;
        this.oscillator.connect(this.gain);
        this.oscillator.start();
        this.midi_connect();
    };
    Cle_Sol_8vbPage.prototype.midi_connect = function () {
        reuc: AudioContext;
        console.log("midi_connect: truc:" + this.truc);
        webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.enable(function (err) {
            console.log("WebMidi.enable: truc:" + this.truc);
            if (err)
                console.log("WebMidi could not be enabled.", err);
            else {
                console.log("WebMidi enabled!");
                console.log("WebMidi.inputs:");
                console.log(webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.inputs);
                console.log("WebMidi.outputs:");
                console.log(webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.outputs);
                if (webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.outputs.length) {
                    this.mo = webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.outputs[0];
                    console.log("utilisation de ");
                    console.log(this.mo);
                    //this.mo.playNote( "C4");
                    //this.playNote( "C4");
                }
            }
        });
    };
    Cle_Sol_8vbPage.prototype.Base_from_Octave = function (_Octave) {
        var Result = 0;
        switch (_Octave) {
            case "-1":
                Result = 0;
                break;
            case "0":
                Result = 12;
                break;
            case "1":
                Result = 24;
                break;
            case "2":
                Result = 36;
                break;
            case "3":
                Result = 48;
                break;
            case "4":
                Result = 60;
                break;
            case "5":
                Result = 72;
                break;
            case "6":
                Result = 84;
                break;
            case "7":
                Result = 96;
                break;
            case "8":
                Result = 108;
                break;
            default:
                Result = 0;
                break;
        }
        ;
        return Result;
    };
    Cle_Sol_8vbPage.prototype.Offset_from_Note = function (_Note) {
        var Result = 0;
        switch (_Note) {
            case "C":
                Result = 0;
                break;
            case "D":
                Result = 2;
                break;
            case "E":
                Result = 4;
                break;
            case "F":
                Result = 5;
                break;
            case "G":
                Result = 7;
                break;
            case "A":
                Result = 9;
                break;
            case "B":
                Result = 11;
                break;
            default:
                Result = 0;
                break;
        }
        ;
        return Result;
    };
    Cle_Sol_8vbPage.prototype.DieseBemol = function (_c) {
        var Result = 0;
        switch (_c) {
            case "#":
                Result = +1;
                break;
            case "b":
                Result = -1;
                break;
            default:
                Result = 0;
                break;
        }
        return Result;
    };
    Cle_Sol_8vbPage.prototype.Midi_from_note = function (_note) {
        var Result = 0;
        var Note = _note.charAt(0);
        var Octave = _note.charAt(1);
        var truc = _note.charAt(2);
        Result
            =
                this.Base_from_Octave(Octave)
                    + this.Offset_from_Note(Note)
                    + this.DieseBemol(truc);
        return Result;
    };
    Cle_Sol_8vbPage.prototype.PlayNote = function (_Note) {
        this.changeColor();
        if (!webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.enabled)
            return;
        if (null === this.mo) {
            if (webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.outputs.length)
                this.mo = webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.outputs[0];
            if (null === this.mo)
                return;
        }
        console.log(_Note);
        var MidiNote = this.Midi_from_note(_Note);
        var noteOnMessage = [0x90, MidiNote, 0x7f]; // note on, MidiNote, full velocity
        console.log(noteOnMessage);
        var MIDI_Channel_1_note_on = 0x90;
        var MIDI_Note_Velocity = 127; /* 0..127 */
        webmidi__WEBPACK_IMPORTED_MODULE_1___default.a.outputs[0].send(MIDI_Channel_1_note_on, [MidiNote, MIDI_Note_Velocity]); //omitting the timestamp means send immediately.
        //midi_output.send( [0x80, MidiNote, 0x40], window.performance.now() + 1000.0 ); // Inlined array creation- note off, middle C,
    };
    Cle_Sol_8vbPage.prototype.changeColor = function () {
        this.fill = "green" == this.fill ? "blue" : "green";
    };
    Cle_Sol_8vbPage.ngComponentDef = _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵdefineComponent"]({ type: Cle_Sol_8vbPage, selectors: [["app-Cle-Sol-8vb"]], factory: function Cle_Sol_8vbPage_Factory(t) { return new (t || Cle_Sol_8vbPage)(); }, consts: 22, vars: 3, template: function Cle_Sol_8vbPage_Template(rf, ctx) { if (rf & 1) {
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵnamespaceSVG"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](0, "svg", _c0);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](1, "rect", _c1);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_rect_click_1_listener($event) { return ctx.changeColor(); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](2, "ellipse", _c2);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_2_listener($event) { return ctx.changeColor(); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelement"](3, "path", _c3);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](4, "ellipse", _c4);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_4_listener($event) { return ctx.PlayNote("E3"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](5, "ellipse", _c5);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_5_listener($event) { return ctx.PlayNote("F3"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](6, "ellipse", _c6);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_6_listener($event) { return ctx.PlayNote("G3"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](7, "ellipse", _c7);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_7_listener($event) { return ctx.PlayNote("A3"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](8, "ellipse", _c8);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_8_listener($event) { return ctx.playNote("B3"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](9, "ellipse", _c9);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_9_listener($event) { return ctx.PlayNote("C3"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](10, "ellipse", _c10);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_10_listener($event) { return ctx.PlayNote("D3"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](11, "ellipse", _c11);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_11_listener($event) { return ctx.PlayNote("C4"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](12, "ellipse", _c12);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_12_listener($event) { return ctx.PlayNote("D4"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](13, "ellipse", _c13);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_13_listener($event) { return ctx.PlayNote("E4"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](14, "ellipse", _c14);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_14_listener($event) { return ctx.PlayNote("F4"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](15, "ellipse", _c15);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_15_listener($event) { return ctx.PlayNote("G4"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](16, "ellipse", _c16);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵlistener"]("click", function Cle_Sol_8vbPage_Template__svg_ellipse_click_16_listener($event) { return ctx.PlayNote("A4"); });
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelement"](17, "rect", _c17);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelement"](18, "rect", _c18);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelement"](19, "rect", _c19);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementStart"](20, "text", _c20);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵtext"](21, "truc");
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementEnd"]();
        } if (rf & 2) {
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵselect"](1);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementAttribute"](1, "fill", _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵbind"](ctx.fill));
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵselect"](2);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementAttribute"](2, "fill", _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵbind"](ctx.fill));
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵselect"](4);
            _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵelementAttribute"](4, "fill", _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵbind"](ctx.fill));
        } }, styles: ["\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL0NsZV9Tb2xfOHZiL0NsZV9Tb2xfOHZiLnBhZ2Uuc2NzcyJ9 */"] });
    return Cle_Sol_8vbPage;
}());

/*@__PURE__*/ _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵsetClassMetadata"](Cle_Sol_8vbPage, [{
        type: _angular_core__WEBPACK_IMPORTED_MODULE_0__["Component"],
        args: [{
                selector: 'app-Cle-Sol-8vb',
                templateUrl: 'Cle_Sol_8vb.page.svg',
                styleUrls: ['Cle_Sol_8vb.page.scss'],
            }]
    }], function () { return []; }, null);


/***/ })

}]);
//# sourceMappingURL=Cle_Sol_8vb-Cle_Sol_8vb-module.js.map