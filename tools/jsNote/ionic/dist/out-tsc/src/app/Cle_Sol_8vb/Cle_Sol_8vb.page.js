import * as tslib_1 from "tslib";
import { Component } from '@angular/core';
import { Message } from '@angular/compiler/src/i18n/i18n_ast';
import WebMidi from "webmidi";
var Cle_Sol_8vbPage = /** @class */ (function () {
    function Cle_Sol_8vbPage() {
        this.ma = null;
        this.mo = null;
    }
    Cle_Sol_8vbPage.prototype.ngOnInit = function () {
        this.midi_connect();
    };
    Cle_Sol_8vbPage.prototype.midi_connect = function () {
        var _this = this;
        var mo = { sysex: false, };
        WebMidi.enable;
        if (Navigator.requestMIDIAccess) {
            //requestMIDIAccess().then(this.onMIDISuccess, this.onMIDIFailure);
            Navigator.requestMIDIAccess()
                .then(function (_MidiAccess) { _this.onMIDISuccess(_MidiAccess); }, function (_Message) { alert("Failed to get MIDI access - " + Message); });
            console.log('This browser supports WebMIDI!');
        }
        else {
            console.log('WebMIDI is not supported in this browser.');
        }
    };
    Cle_Sol_8vbPage.prototype.onMIDISuccess = function (_MidiAccess) {
        console.log("MIDI ready!");
        if (undefined === this)
            console.log("this is undefined");
        this.ma = _MidiAccess; // store in the global (in real usage, would probably keep in an object instance)
        this.listInputsAndOutputs();
        //sendMiddleC();
        //document.PlayNote( "C3#");
        _MidiAccess.onstatechange
            =
                function (e) {
                    console.log(e.port.name + ' appears!');
                };
    };
    Cle_Sol_8vbPage.prototype.listInputsAndOutputs = function () {
        if (null === this.ma)
            return;
        for (var _i = 0, _a = this.ma.inputs; _i < _a.length; _i++) {
            var entry = _a[_i];
            var input = entry[1];
            console.log("Input port [type:'" + input.type + "'] id:'" + input.id
                + "' manufacturer:'" + input.manufacturer + "' name:'" + input.name
                + "' version:'" + input.version + "'");
        }
        for (var _b = 0, _d = this.ma.outputs; _b < _d.length; _b++) {
            var entry = _d[_b];
            var output = entry[1];
            console.log("Output port [type:'" + output.type + "'] id:'" + output.id
                + "' manufacturer:'" + output.manufacturer + "' name:'" + output.name
                + "' version:'" + output.version + "'");
            this.mo = output;
        }
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
    ;
    Cle_Sol_8vbPage.prototype.PlayNote = function (_Note) {
        if (undefined === _Note)
            return;
        if (null === this.mo)
            return;
        console.log(_Note);
        var MidiNote = this.Midi_from_note(_Note);
        var noteOnMessage = [0x90, MidiNote, 0x7f]; // note on, MidiNote, full velocity
        console.log(noteOnMessage);
        this.mo.send(noteOnMessage); //omitting the timestamp means send immediately.
        //midi_output.send( [0x80, MidiNote, 0x40], window.performance.now() + 1000.0 ); // Inlined array creation- note off, middle C,
    };
    Cle_Sol_8vbPage = tslib_1.__decorate([
        Component({
            selector: 'app-Cle-Sol-8vb',
            templateUrl: 'Cle_Sol_8vb.page.html',
            styleUrls: ['Cle_Sol_8vb.page.scss'],
        }),
        tslib_1.__metadata("design:paramtypes", [])
    ], Cle_Sol_8vbPage);
    return Cle_Sol_8vbPage;
}());
export { Cle_Sol_8vbPage };
//# sourceMappingURL=Cle_Sol_8vb.page.js.map