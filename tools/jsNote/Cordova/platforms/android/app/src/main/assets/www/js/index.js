/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();
var midi = null;  // global MIDIAccess object

function onMIDISuccess( midiAccess ) {
  alert( "MIDI ready!" );
  midi = midiAccess;  // store in the global (in real usage, would probably keep in an object instance)
  listInputsAndOutputs( midi);
  sendMiddleC( midi, "native:port-out-0")
}

function onMIDIFailure(msg) {
  alert( "Failed to get MIDI access - " + msg );
}
function listInputsAndOutputs( midiAccess ) 
   {
   if (null===midi) return;   
    for (var entry of midiAccess.inputs) {
      var input = entry[1];
      alert( "Input port [type:'" + input.type + "'] id:'" + input.id +
        "' manufacturer:'" + input.manufacturer + "' name:'" + input.name +
        "' version:'" + input.version + "'" );
    }
  
    for (var entry of midiAccess.outputs) {
      var output = entry[1];
      alert( "Output port [type:'" + output.type + "'] id:'" + output.id +
        "' manufacturer:'" + output.manufacturer + "' name:'" + output.name +
        "' version:'" + output.version + "'" );
    }
  }
  function sendMiddleC( midiAccess, portID ) 
  {
    var noteOnMessage = [0x90, 60, 0x7f];    // note on, middle C, full velocity
    var output = midiAccess.outputs.get(portID);
    output.send( noteOnMessage );  //omitting the timestamp means send immediately.
    output.send( [0x80, 60, 0x40], window.performance.now() + 1000.0 ); // Inlined array creation- note off, middle C,
                                                                        // release velocity = 64, timestamp = now + 1000ms.
  }  
navigator.requestMIDIAccess().then( onMIDISuccess, onMIDIFailure );
