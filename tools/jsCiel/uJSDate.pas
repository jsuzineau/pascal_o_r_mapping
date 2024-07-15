unit uJSDate;

{$mode Delphi}

interface

uses
 Classes, SysUtils;

//type
(*
  { TJSDate - wrapper for JavaScript Date }

  TJSDate = class external name 'Date'(TJSFunction)
  private
    function getDate: NativeInt;
    function getFullYear: NativeInt;
    function getHours: NativeInt;
    function getMilliseconds: NativeInt;
    function getMinutes: NativeInt;
    function getMonth: NativeInt;
    function getSeconds: NativeInt;
    function getYear: NativeInt;
    function getTime: NativeInt;
    function getUTCDate: NativeInt;
    function getUTCFullYear: NativeInt;
    function getUTCHours: NativeInt;
    function getUTCMilliseconds: NativeInt;
    function getUTCMinutes: NativeInt;
    function getUTCMonth: NativeInt;
    function getUTCSeconds: NativeInt;
    procedure setDate(const AValue: NativeInt);
    procedure setFullYear(const AValue: NativeInt);
    procedure setHours(const AValue: NativeInt);
    procedure setMilliseconds(const AValue: NativeInt);
    procedure setMinutes(const AValue: NativeInt);
    procedure setMonth(const AValue: NativeInt);
    procedure setSeconds(const AValue: NativeInt);
    procedure setYear(const AValue: NativeInt);
    procedure setTime(const AValue: NativeInt);
    procedure setUTCDate(const AValue: NativeInt);
    procedure setUTCFullYear(const AValue: NativeInt);
    procedure setUTCHours(const AValue: NativeInt);
    procedure setUTCMilliseconds(const AValue: NativeInt);
    procedure setUTCMinutes(const AValue: NativeInt);
    procedure setUTCMonth(const AValue: NativeInt);
    procedure setUTCSeconds(const AValue: NativeInt);
  public
    constructor New; reintroduce;
    constructor New(const MilliSecsSince1970: NativeInt); // milliseconds since 1 January 1970 00:00:00 UTC, with leap seconds ignored
    constructor New(const aDateString: String); // RFC 2822, ISO8601
    constructor New(aYear: NativeInt; aMonth: NativeInt; aDayOfMonth: NativeInt = 1;
      TheHours: NativeInt = 0; TheMinutes: NativeInt = 0; TheSeconds: NativeInt = 0;
      TheMilliseconds: NativeInt = 0);
    class function now: NativeInt; // current date and time in milliseconds since 1 January 1970 00:00:00 UTC, with leap seconds ignored
    class function parse(const aDateString: string): NativeInt; // format depends on browser
    class function UTC(aYear: NativeInt; aMonth: NativeInt = 0; aDayOfMonth: NativeInt = 1;
      TheHours: NativeInt = 0; TheMinutes: NativeInt = 0; TheSeconds: NativeInt = 0;
      TheMilliseconds: NativeInt = 0): NativeInt;
    function getDay: NativeInt;
    function getTimezoneOffset: NativeInt;
    function getUTCDay: NativeInt; // day of the week
    function toDateString: string; // human readable date, without time
    function toISOString: string; // ISO 8601 Extended Format
    function toJSON: string;
    function toGMTString: string; // in GMT timezone
    function toLocaleDateString: string; overload; // date in locale timezone, no time
    function toLocaleDateString(const aLocale : string) : string; overload; // date in locale timezone, no time
    function toLocaleDateString(const aLocale : string; aOptions : TJSObject) : string; overload; // date in locale timezone, no time
    function toLocaleString: string; reintroduce; // date and time in locale timezone
    function toLocaleTimeString: string; // time in locale timezone, no date
    function toTimeString: string; // time human readable, no date
    function toUTCString: string; // date and time using UTC timezone
    property Year: NativeInt read getYear write setYear;
    property Time: NativeInt read getTime write setTime; // milliseconds since 1 January 1970 00:00:00 UTC, with leap seconds ignored
    property FullYear: NativeInt read getFullYear write setFullYear;
    property UTCDate: NativeInt read getUTCDate write setUTCDate; // day of month
    property UTCFullYear: NativeInt read getUTCFullYear write setUTCFullYear;
    property UTCHours: NativeInt read getUTCHours write setUTCHours;
    property UTCMilliseconds: NativeInt read getUTCMilliseconds write setUTCMilliseconds;
    property UTCMinutes: NativeInt read getUTCMinutes write setUTCMinutes;
    property UTCMonth: NativeInt read getUTCMonth write setUTCMonth;
    property UTCSeconds: NativeInt read getUTCSeconds write setUTCSeconds;
    property Month: NativeInt read getMonth write setMonth;
    property Date: NativeInt read getDate write setDate; // day of the month, starting at 1
    property Hours: NativeInt read getHours write setHours;
    property Minutes: NativeInt read getMinutes write setMinutes;
    property Seconds: NativeInt read getSeconds write setSeconds;
    property Milliseconds: NativeInt read getMilliseconds write setMilliseconds;
*)

 //non implémenté
(*
 { TJSDate}
 IJSDate
 =
  interface(IJSObject)
  ['{2956BAA6-D400-4686-BEBC-AB4C24A39E14}']
    function _getDate: NativeInt;
    function _getFullYear: NativeInt;
    function _getHours: NativeInt;
    function _getMilliseconds: NativeInt;
    function _getMinutes: NativeInt;
    function _getMonth: NativeInt;
    function _getSeconds: NativeInt;
    function _getYear: NativeInt;
    function _getTime: NativeInt;
    function _getUTCDate: NativeInt;
    function _getUTCFullYear: NativeInt;
    function _getUTCHours: NativeInt;
    function _getUTCMilliseconds: NativeInt;
    function _getUTCMinutes: NativeInt;
    function _getUTCMonth: NativeInt;
    function _getUTCSeconds: NativeInt;
    procedure _setDate(const AValue: NativeInt);
    procedure _setFullYear(const AValue: NativeInt);
    procedure _setHours(const AValue: NativeInt);
    procedure _setMilliseconds(const AValue: NativeInt);
    procedure _setMinutes(const AValue: NativeInt);
    procedure _setMonth(const AValue: NativeInt);
    procedure _setSeconds(const AValue: NativeInt);
    procedure _setYear(const AValue: NativeInt);
    procedure _setTime(const AValue: NativeInt);
    procedure _setUTCDate(const AValue: NativeInt);
    procedure _setUTCFullYear(const AValue: NativeInt);
    procedure _setUTCHours(const AValue: NativeInt);
    procedure _setUTCMilliseconds(const AValue: NativeInt);
    procedure _setUTCMinutes(const AValue: NativeInt);
    procedure _setUTCMonth(const AValue: NativeInt);
    procedure _setUTCSeconds(const AValue: NativeInt);
    constructor New(const aDateString: String); // RFC 2822, ISO8601
    constructor New(aYear: NativeInt; aMonth: NativeInt; aDayOfMonth: NativeInt = 1;
      TheHours: NativeInt = 0; TheMinutes: NativeInt = 0; TheSeconds: NativeInt = 0;
      TheMilliseconds: NativeInt = 0);
  end;
  TJSDate = class(TJSObject,IJSDate)// external name 'Date'(TJSFunction)
  protected
    function _getDate: NativeInt;
    function _getFullYear: NativeInt;
    function _getHours: NativeInt;
    function _getMilliseconds: NativeInt;
    function _getMinutes: NativeInt;
    function _getMonth: NativeInt;
    function _getSeconds: NativeInt;
    function _getYear: NativeInt;
    function _getTime: NativeInt;
    function _getUTCDate: NativeInt;
    function _getUTCFullYear: NativeInt;
    function _getUTCHours: NativeInt;
    function _getUTCMilliseconds: NativeInt;
    function _getUTCMinutes: NativeInt;
    function _getUTCMonth: NativeInt;
    function _getUTCSeconds: NativeInt;
    procedure _setDate(const AValue: NativeInt);
    procedure _setFullYear(const AValue: NativeInt);
    procedure _setHours(const AValue: NativeInt);
    procedure _setMilliseconds(const AValue: NativeInt);
    procedure _setMinutes(const AValue: NativeInt);
    procedure _setMonth(const AValue: NativeInt);
    procedure _setSeconds(const AValue: NativeInt);
    procedure _setYear(const AValue: NativeInt);
    procedure _setTime(const AValue: NativeInt);
    procedure _setUTCDate(const AValue: NativeInt);
    procedure _setUTCFullYear(const AValue: NativeInt);
    procedure _setUTCHours(const AValue: NativeInt);
    procedure _setUTCMilliseconds(const AValue: NativeInt);
    procedure _setUTCMinutes(const AValue: NativeInt);
    procedure _setUTCMonth(const AValue: NativeInt);
    procedure _setUTCSeconds(const AValue: NativeInt);
  public
    constructor New; reintroduce;
    constructor New(const MilliSecsSince1970: NativeInt); // milliseconds since 1 January 1970 00:00:00 UTC, with leap seconds ignored
    constructor New(const aDateString: String); // RFC 2822, ISO8601
    constructor New(aYear: NativeInt; aMonth: NativeInt; aDayOfMonth: NativeInt = 1;
      TheHours: NativeInt = 0; TheMinutes: NativeInt = 0; TheSeconds: NativeInt = 0;
      TheMilliseconds: NativeInt = 0);
    class function now: NativeInt; // current date and time in milliseconds since 1 January 1970 00:00:00 UTC, with leap seconds ignored
    class function parse(const aDateString: string): NativeInt; // format depends on browser
    class function UTC(aYear: NativeInt; aMonth: NativeInt = 0; aDayOfMonth: NativeInt = 1;
      TheHours: NativeInt = 0; TheMinutes: NativeInt = 0; TheSeconds: NativeInt = 0;
      TheMilliseconds: NativeInt = 0): NativeInt;
    function getDay: NativeInt;
    function getTimezoneOffset: NativeInt;
    function getUTCDay: NativeInt; // day of the week
    function toDateString: string; // human readable date, without time
    function toISOString: string; // ISO 8601 Extended Format
    function toJSON: string;
    function toGMTString: string; // in GMT timezone
    function toLocaleDateString: string; overload; // date in locale timezone, no time
    function toLocaleDateString(const aLocale : string) : string; overload; // date in locale timezone, no time
    function toLocaleDateString(const aLocale : string; aOptions : TJSObject) : string; overload; // date in locale timezone, no time
    function toLocaleString: string; reintroduce; // date and time in locale timezone
    function toLocaleTimeString: string; // time in locale timezone, no date
    function toTimeString: string; // time human readable, no date
    function toUTCString: string; // date and time using UTC timezone
    property Year           : NativeInt read _getYear            write _setYear;
    property Time           : NativeInt read _getTime            write _setTime; // milliseconds since 1 January 1970 00:00:00 UTC, with leap seconds ignored
    property FullYear       : NativeInt read _getFullYear        write _setFullYear;
    property UTCDate        : NativeInt read _getUTCDate         write _setUTCDate; // day of month
    property UTCFullYear    : NativeInt read _getUTCFullYear     write _setUTCFullYear;
    property UTCHours       : NativeInt read _getUTCHours        write _setUTCHours;
    property UTCMilliseconds: NativeInt read _getUTCMilliseconds write _setUTCMilliseconds;
    property UTCMinutes     : NativeInt read _getUTCMinutes      write _setUTCMinutes;
    property UTCMonth       : NativeInt read _getUTCMonth        write _setUTCMonth;
    property UTCSeconds     : NativeInt read _getUTCSeconds      write _setUTCSeconds;
    property Month          : NativeInt read _getMonth           write _setMonth;
    property Date           : NativeInt read _getDate            write _setDate; // day of the month, starting at 1
    property Hours          : NativeInt read _getHours           write _setHours;
    property Minutes        : NativeInt read _getMinutes         write _setMinutes;
    property Seconds        : NativeInt read _getSeconds         write _setSeconds;
    property Milliseconds   : NativeInt read _getMilliseconds    write _setMilliseconds;
*)

implementation

end.

