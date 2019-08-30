rtl.module("System",[],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.LineEnding = "\n";
  this.sLineBreak = $mod.LineEnding;
  this.MaxSmallint = 32767;
  this.MinSmallint = -32768;
  this.MaxShortInt = 127;
  this.MinShortInt = -128;
  this.MaxByte = 0xFF;
  this.MaxWord = 0xFFFF;
  this.MaxLongint = 0x7fffffff;
  this.MaxCardinal = 0xffffffff;
  this.Maxint = 2147483647;
  this.IsMultiThread = false;
  $mod.$rtti.$inherited("Real",rtl.double,{});
  $mod.$rtti.$inherited("Extended",rtl.double,{});
  $mod.$rtti.$inherited("TDateTime",rtl.double,{});
  $mod.$rtti.$inherited("TTime",$mod.$rtti["TDateTime"],{});
  $mod.$rtti.$inherited("TDate",$mod.$rtti["TDateTime"],{});
  $mod.$rtti.$inherited("Int64",rtl.nativeint,{});
  $mod.$rtti.$inherited("UInt64",rtl.nativeuint,{});
  $mod.$rtti.$inherited("QWord",rtl.nativeuint,{});
  $mod.$rtti.$inherited("Single",rtl.double,{});
  $mod.$rtti.$inherited("Comp",rtl.nativeint,{});
  $mod.$rtti.$inherited("UnicodeString",rtl.string,{});
  $mod.$rtti.$inherited("WideString",rtl.string,{});
  this.TTextLineBreakStyle = {"0": "tlbsLF", tlbsLF: 0, "1": "tlbsCRLF", tlbsCRLF: 1, "2": "tlbsCR", tlbsCR: 2};
  $mod.$rtti.$Enum("TTextLineBreakStyle",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TTextLineBreakStyle});
  this.TGuid = function (s) {
    if (s) {
      this.D1 = s.D1;
      this.D2 = s.D2;
      this.D3 = s.D3;
      this.D4 = s.D4.slice(0);
    } else {
      this.D1 = 0;
      this.D2 = 0;
      this.D3 = 0;
      this.D4 = rtl.arraySetLength(null,0,8);
    };
    this.$equal = function (b) {
      return (this.D1 === b.D1) && ((this.D2 === b.D2) && ((this.D3 === b.D3) && rtl.arrayEq(this.D4,b.D4)));
    };
  };
  $mod.$rtti.$StaticArray("TGuid.D4$a",{dims: [8], eltype: rtl.byte});
  $mod.$rtti.$Record("TGuid",{}).addFields("D1",rtl.longword,"D2",rtl.word,"D3",rtl.word,"D4",$mod.$rtti["TGuid.D4$a"]);
  $mod.$rtti.$inherited("TGUIDString",rtl.string,{});
  $mod.$rtti.$Class("TObject");
  $mod.$rtti.$ClassRef("TClass",{instancetype: $mod.$rtti["TObject"]});
  rtl.createClass($mod,"TObject",null,function () {
    this.$init = function () {
    };
    this.$final = function () {
    };
    this.Create = function () {
    };
    this.Destroy = function () {
    };
    this.Free = function () {
      this.$destroy("Destroy");
    };
    this.ClassType = function () {
      return this;
    };
    this.ClassNameIs = function (Name) {
      var Result = false;
      Result = $impl.SameText(Name,this.$classname);
      return Result;
    };
    this.InheritsFrom = function (aClass) {
      return (aClass!=null) && ((this==aClass) || aClass.isPrototypeOf(this));
    };
    this.AfterConstruction = function () {
    };
    this.BeforeDestruction = function () {
    };
    this.GetInterface = function (iid, obj) {
      var Result = false;
      var i = iid.$intf;
      if (i){
        i = rtl.getIntfG(this,i.$guid,2);
        if (i){
          obj.set(i);
          return true;
        }
      };
      Result = this.GetInterfaceByStr(rtl.guidrToStr(iid),obj);
      return Result;
    };
    this.GetInterface$1 = function (iidstr, obj) {
      var Result = false;
      Result = this.GetInterfaceByStr(iidstr,obj);
      return Result;
    };
    this.GetInterfaceByStr = function (iidstr, obj) {
      var Result = false;
      if ($mod.IObjectInstance.$equal(rtl.createTGUID(iidstr))) {
        obj.set(this);
        return true;
      };
      var i = rtl.getIntfG(this,iidstr,2);
      obj.set(i);
      return i!==null;
      Result = false;
      return Result;
    };
    this.GetInterfaceWeak = function (iid, obj) {
      var Result = false;
      Result = this.GetInterface(iid,obj);
      if (Result){
        var o = obj.get();
        if (o.$kind==='com'){
          o._Release();
        }
      };
      return Result;
    };
    this.Equals = function (Obj) {
      var Result = false;
      Result = Obj === this;
      return Result;
    };
    this.ToString = function () {
      var Result = "";
      Result = this.$classname;
      return Result;
    };
  });
  this.S_OK = 0;
  this.S_FALSE = 1;
  this.E_NOINTERFACE = -2147467262;
  this.E_UNEXPECTED = -2147418113;
  this.E_NOTIMPL = -2147467263;
  rtl.createInterface($mod,"IUnknown","{00000000-0000-0000-C000-000000000046}",["QueryInterface","_AddRef","_Release"],null,function () {
    this.$kind = "com";
    var $r = this.$rtti;
    $r.addMethod("QueryInterface",1,[["iid",$mod.$rtti["TGuid"],2],["obj",null,4]],rtl.longint);
    $r.addMethod("_AddRef",1,null,rtl.longint);
    $r.addMethod("_Release",1,null,rtl.longint);
  });
  rtl.createInterface($mod,"IInvokable","{88387EF6-BCEE-3E17-9E85-5D491ED4FC10}",[],$mod.IUnknown,function () {
  });
  rtl.createInterface($mod,"IEnumerator","{ECEC7568-4E50-30C9-A2F0-439342DE2ADB}",["GetCurrent","MoveNext","Reset"],$mod.IUnknown,function () {
    var $r = this.$rtti;
    $r.addMethod("GetCurrent",1,null,$mod.$rtti["TObject"]);
    $r.addMethod("MoveNext",1,null,rtl.boolean);
    $r.addMethod("Reset",0,null);
    $r.addProperty("Current",1,$mod.$rtti["TObject"],"GetCurrent","");
  });
  rtl.createInterface($mod,"IEnumerable","{9791C368-4E51-3424-A3CE-D4911D54F385}",["GetEnumerator"],$mod.IUnknown,function () {
    var $r = this.$rtti;
    $r.addMethod("GetEnumerator",1,null,$mod.$rtti["IEnumerator"]);
  });
  rtl.createClass($mod,"TInterfacedObject",$mod.TObject,function () {
    this.$init = function () {
      $mod.TObject.$init.call(this);
      this.fRefCount = 0;
    };
    this.QueryInterface = function (iid, obj) {
      var Result = 0;
      if (this.GetInterface(iid,obj)) {
        Result = 0}
       else Result = -2147467262;
      return Result;
    };
    this._AddRef = function () {
      var Result = 0;
      this.fRefCount += 1;
      Result = this.fRefCount;
      return Result;
    };
    this._Release = function () {
      var Result = 0;
      this.fRefCount -= 1;
      Result = this.fRefCount;
      if (this.fRefCount === 0) this.$destroy("Destroy");
      return Result;
    };
    this.BeforeDestruction = function () {
      if (this.fRefCount !== 0) rtl.raiseE('EHeapMemoryError');
    };
    rtl.addIntf(this,$mod.IUnknown);
  });
  $mod.$rtti.$ClassRef("TInterfacedClass",{instancetype: $mod.$rtti["TInterfacedObject"]});
  rtl.createClass($mod,"TAggregatedObject",$mod.TObject,function () {
    this.$init = function () {
      $mod.TObject.$init.call(this);
      this.fController = null;
    };
    this.GetController = function () {
      var Result = null;
      var $ok = false;
      try {
        Result = rtl.setIntfL(Result,this.fController);
        $ok = true;
      } finally {
        if (!$ok) rtl._Release(Result);
      };
      return Result;
    };
    this.QueryInterface = function (iid, obj) {
      var Result = 0;
      Result = this.fController.QueryInterface(iid,obj);
      return Result;
    };
    this._AddRef = function () {
      var Result = 0;
      Result = this.fController._AddRef();
      return Result;
    };
    this._Release = function () {
      var Result = 0;
      Result = this.fController._Release();
      return Result;
    };
    this.Create$1 = function (aController) {
      $mod.TObject.Create.call(this);
      this.fController = aController;
    };
  });
  rtl.createClass($mod,"TContainedObject",$mod.TAggregatedObject,function () {
    this.QueryInterface = function (iid, obj) {
      var Result = 0;
      if (this.GetInterface(iid,obj)) {
        Result = 0}
       else Result = -2147467262;
      return Result;
    };
    rtl.addIntf(this,$mod.IUnknown);
  });
  this.IObjectInstance = new $mod.TGuid({D1: 0xD91C9AF4, D2: 0x3C93, D3: 0x420F, D4: [0xA3,0x03,0xBF,0x5B,0xA8,0x2B,0xFD,0x23]});
  this.IsConsole = false;
  this.FirstDotAtFileNameStartIsExtension = false;
  $mod.$rtti.$ProcVar("TOnParamCount",{procsig: rtl.newTIProcSig(null,rtl.longint)});
  $mod.$rtti.$ProcVar("TOnParamStr",{procsig: rtl.newTIProcSig([["Index",rtl.longint]],rtl.string)});
  this.OnParamCount = null;
  this.OnParamStr = null;
  this.ParamCount = function () {
    var Result = 0;
    if ($mod.OnParamCount != null) {
      Result = $mod.OnParamCount()}
     else Result = 0;
    return Result;
  };
  this.ParamStr = function (Index) {
    var Result = "";
    if ($mod.OnParamStr != null) {
      Result = $mod.OnParamStr(Index)}
     else if (Index === 0) {
      Result = "js"}
     else Result = "";
    return Result;
  };
  this.Frac = function (A) {
    return A % 1;
  };
  this.Odd = function (A) {
    return A&1 != 0;
  };
  this.Random = function (Range) {
    return Math.floor(Math.random()*Range);
  };
  this.Sqr = function (A) {
    return A*A;
  };
  this.Sqr$1 = function (A) {
    return A*A;
  };
  this.Trunc = function (A) {
    if (!Math.trunc) {
      Math.trunc = function(v) {
        v = +v;
        if (!isFinite(v)) return v;
        return (v - v % 1) || (v < 0 ? -0 : v === 0 ? v : 0);
      };
    }
    $mod.Trunc = Math.trunc;
    return Math.trunc(A);
  };
  this.DefaultTextLineBreakStyle = $mod.TTextLineBreakStyle.tlbsLF;
  this.Int = function (A) {
    var Result = 0.0;
    Result = $mod.Trunc(A);
    return Result;
  };
  this.Copy = function (S, Index, Size) {
    if (Index<1) Index = 1;
    return (Size>0) ? S.substring(Index-1,Index+Size-1) : "";
  };
  this.Copy$1 = function (S, Index) {
    if (Index<1) Index = 1;
    return S.substr(Index-1);
  };
  this.Delete = function (S, Index, Size) {
    var h = "";
    if (((Index < 1) || (Index > S.get().length)) || (Size <= 0)) return;
    h = S.get();
    S.set($mod.Copy(h,1,Index - 1) + $mod.Copy$1(h,Index + Size));
  };
  this.Pos = function (Search, InString) {
    return InString.indexOf(Search)+1;
  };
  this.Pos$1 = function (Search, InString, StartAt) {
    return InString.indexOf(Search,StartAt-1)+1;
  };
  this.Insert = function (Insertion, Target, Index) {
    var t = "";
    if (Insertion === "") return;
    t = Target.get();
    if (Index < 1) {
      Target.set(Insertion + t)}
     else if (Index > t.length) {
      Target.set(t + Insertion)}
     else Target.set(($mod.Copy(t,1,Index - 1) + Insertion) + $mod.Copy(t,Index,t.length));
  };
  this.upcase = function (c) {
    return c.toUpperCase();
  };
  this.val = function (S, NI, Code) {
    var x = 0.0;
    Code.set(0);
    x = Number(S);
    if (isNaN(x)) {
      var $tmp1 = $mod.Copy(S,1,1);
      if ($tmp1 === "$") {
        x = Number("0x" + $mod.Copy$1(S,2))}
       else if ($tmp1 === "&") {
        x = Number("0o" + $mod.Copy$1(S,2))}
       else if ($tmp1 === "%") {
        x = Number("0b" + $mod.Copy$1(S,2))}
       else {
        Code.set(1);
        return;
      };
    };
    if (isNaN(x) || (x !== $mod.Int(x))) {
      Code.set(1)}
     else NI.set($mod.Trunc(x));
  };
  this.val$1 = function (S, NI, Code) {
    var x = 0.0;
    Code.set(0);
    x = Number(S);
    if ((isNaN(x) || (x !== $mod.Int(x))) || (x < 0)) {
      Code.set(1)}
     else NI.set($mod.Trunc(x));
  };
  this.val$2 = function (S, SI, Code) {
    var X = 0.0;
    Code.set(0);
    X = Number(S);
    if (isNaN(X) || (X !== $mod.Int(X))) {
      Code.set(1)}
     else if ((X < -128) || (X > 127)) {
      Code.set(2)}
     else SI.set($mod.Trunc(X));
  };
  this.val$3 = function (S, B, Code) {
    var x = 0.0;
    Code.set(0);
    x = Number(S);
    if (isNaN(x) || (x !== $mod.Int(x))) {
      Code.set(1)}
     else if ((x < 0) || (x > 255)) {
      Code.set(2)}
     else B.set($mod.Trunc(x));
  };
  this.val$4 = function (S, SI, Code) {
    var x = 0.0;
    Code.set(0);
    x = Number(S);
    if (isNaN(x) || (x !== $mod.Int(x))) {
      Code.set(1)}
     else if ((x < -32768) || (x > 32767)) {
      Code.set(2)}
     else SI.set($mod.Trunc(x));
  };
  this.val$5 = function (S, W, Code) {
    var x = 0.0;
    Code.set(0);
    x = Number(S);
    if (isNaN(x)) {
      Code.set(1)}
     else if ((x < 0) || (x > 65535)) {
      Code.set(2)}
     else W.set($mod.Trunc(x));
  };
  this.val$6 = function (S, I, Code) {
    var x = 0.0;
    Code.set(0);
    x = Number(S);
    if (isNaN(x)) {
      Code.set(1)}
     else if (x > 2147483647) {
      Code.set(2)}
     else I.set($mod.Trunc(x));
  };
  this.val$7 = function (S, C, Code) {
    var x = 0.0;
    Code.set(0);
    x = Number(S);
    if (isNaN(x) || (x !== $mod.Int(x))) {
      Code.set(1)}
     else if ((x < 0) || (x > 4294967295)) {
      Code.set(2)}
     else C.set($mod.Trunc(x));
  };
  this.val$8 = function (S, d, Code) {
    var x = 0.0;
    x = Number(S);
    if (isNaN(x)) {
      Code.set(1)}
     else {
      Code.set(0);
      d.set(x);
    };
  };
  this.StringOfChar = function (c, l) {
    var Result = "";
    var i = 0;
    if ((l>0) && c.repeat) return c.repeat(l);
    Result = "";
    for (var $l1 = 1, $end2 = l; $l1 <= $end2; $l1++) {
      i = $l1;
      Result = Result + c;
    };
    return Result;
  };
  this.Write = function () {
    var i = 0;
    for (var $l1 = 0, $end2 = rtl.length(arguments) - 1; $l1 <= $end2; $l1++) {
      i = $l1;
      if ($impl.WriteCallBack != null) {
        $impl.WriteCallBack(arguments[i],false)}
       else $impl.WriteBuf = $impl.WriteBuf + ("" + arguments[i]);
    };
  };
  this.Writeln = function () {
    var i = 0;
    var l = 0;
    var s = "";
    l = rtl.length(arguments) - 1;
    if ($impl.WriteCallBack != null) {
      for (var $l1 = 0, $end2 = l; $l1 <= $end2; $l1++) {
        i = $l1;
        $impl.WriteCallBack(arguments[i],i === l);
      };
    } else {
      s = $impl.WriteBuf;
      for (var $l3 = 0, $end4 = l; $l3 <= $end4; $l3++) {
        i = $l3;
        s = s + ("" + arguments[i]);
      };
      console.log(s);
      $impl.WriteBuf = "";
    };
  };
  $mod.$rtti.$ProcVar("TConsoleHandler",{procsig: rtl.newTIProcSig([["S",rtl.jsvalue],["NewLine",rtl.boolean]])});
  this.SetWriteCallBack = function (H) {
    var Result = null;
    Result = $impl.WriteCallBack;
    $impl.WriteCallBack = H;
    return Result;
  };
  this.Assigned = function (V) {
    return (V!=undefined) && (V!=null) && (!rtl.isArray(V) || (V.length > 0));
  };
  this.StrictEqual = function (A, B) {
    return A === B;
  };
  this.StrictInequal = function (A, B) {
    return A !== B;
  };
  $mod.$init = function () {
    rtl.exitcode = 0;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.SameText = function (s1, s2) {
    return s1.toLowerCase() == s2.toLowerCase();
  };
  $impl.WriteBuf = "";
  $impl.WriteCallBack = null;
});
rtl.module("RTLConsts",["System"],function () {
  "use strict";
  var $mod = this;
  this.SArgumentMissing = 'Missing argument in format "%s"';
  this.SInvalidFormat = 'Invalid format specifier : "%s"';
  this.SInvalidArgIndex = 'Invalid argument index in format: "%s"';
  this.SListCapacityError = "List capacity (%s) exceeded.";
  this.SListCountError = "List count (%s) out of bounds.";
  this.SListIndexError = "List index (%s) out of bounds";
  this.SSortedListError = "Operation not allowed on sorted list";
  this.SDuplicateString = "String list does not allow duplicates";
  this.SErrFindNeedsSortedList = "Cannot use find on unsorted list";
  this.SInvalidName = 'Invalid component name: "%s"';
  this.SInvalidBoolean = '"%s" is not a valid boolean.';
  this.SDuplicateName = 'Duplicate component name: "%s"';
  this.SErrInvalidDate = 'Invalid date: "%s"';
  this.SErrInvalidTimeFormat = 'Invalid time format: "%s"';
  this.SInvalidDateFormat = 'Invalid date format: "%s"';
  this.SCantReadPropertyS = 'Cannot read property "%s"';
  this.SCantWritePropertyS = 'Cannot write property "%s"';
  this.SErrPropertyNotFound = 'Unknown property: "%s"';
  this.SIndexedPropertyNeedsParams = 'Indexed property "%s" needs parameters';
  this.SErrInvalidInteger = 'Invalid integer value: "%s"';
  this.SErrInvalidFloat = 'Invalid floating-point value: "%s"';
  this.SInvalidDateTime = "Invalid date-time value: %s";
  this.SInvalidCurrency = "Invalid currency value: %s";
  this.SErrInvalidDayOfWeek = "%d is not a valid day of the week";
  this.SErrInvalidTimeStamp = 'Invalid date\/timestamp : "%s"';
  this.SErrInvalidDateWeek = "%d %d %d is not a valid dateweek";
  this.SErrInvalidDayOfYear = "Year %d does not have a day number %d";
  this.SErrInvalidDateMonthWeek = "Year %d, month %d, Week %d and day %d is not a valid date.";
  this.SErrInvalidDayOfWeekInMonth = "Year %d Month %d NDow %d DOW %d is not a valid date";
  this.SInvalidJulianDate = "%f Julian cannot be represented as a DateTime";
  this.SErrInvalidHourMinuteSecMsec = "%d:%d:%d.%d is not a valid time specification";
  this.SInvalidGUID = '"%s" is not a valid GUID value';
});
rtl.module("Types",["System"],function () {
  "use strict";
  var $mod = this;
  this.TDirection = {"0": "FromBeginning", FromBeginning: 0, "1": "FromEnd", FromEnd: 1};
  $mod.$rtti.$Enum("TDirection",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TDirection});
  $mod.$rtti.$DynArray("TBooleanDynArray",{eltype: rtl.boolean});
  $mod.$rtti.$DynArray("TIntegerDynArray",{eltype: rtl.longint});
  $mod.$rtti.$DynArray("TNativeIntDynArray",{eltype: rtl.nativeint});
  $mod.$rtti.$DynArray("TStringDynArray",{eltype: rtl.string});
  $mod.$rtti.$DynArray("TDoubleDynArray",{eltype: rtl.double});
  $mod.$rtti.$DynArray("TJSValueDynArray",{eltype: rtl.jsvalue});
  this.TDuplicates = {"0": "dupIgnore", dupIgnore: 0, "1": "dupAccept", dupAccept: 1, "2": "dupError", dupError: 2};
  $mod.$rtti.$Enum("TDuplicates",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TDuplicates});
  $mod.$rtti.$MethodVar("TListCallback",{procsig: rtl.newTIProcSig([["data",rtl.jsvalue],["arg",rtl.jsvalue]]), methodkind: 0});
  $mod.$rtti.$ProcVar("TListStaticCallback",{procsig: rtl.newTIProcSig([["data",rtl.jsvalue],["arg",rtl.jsvalue]])});
  this.TSize = function (s) {
    if (s) {
      this.cx = s.cx;
      this.cy = s.cy;
    } else {
      this.cx = 0;
      this.cy = 0;
    };
    this.$equal = function (b) {
      return (this.cx === b.cx) && (this.cy === b.cy);
    };
  };
  $mod.$rtti.$Record("TSize",{}).addFields("cx",rtl.longint,"cy",rtl.longint);
  this.TPoint = function (s) {
    if (s) {
      this.x = s.x;
      this.y = s.y;
    } else {
      this.x = 0;
      this.y = 0;
    };
    this.$equal = function (b) {
      return (this.x === b.x) && (this.y === b.y);
    };
  };
  $mod.$rtti.$Record("TPoint",{}).addFields("x",rtl.longint,"y",rtl.longint);
  this.TRect = function (s) {
    if (s) {
      this.Left = s.Left;
      this.Top = s.Top;
      this.Right = s.Right;
      this.Bottom = s.Bottom;
    } else {
      this.Left = 0;
      this.Top = 0;
      this.Right = 0;
      this.Bottom = 0;
    };
    this.$equal = function (b) {
      return (this.Left === b.Left) && ((this.Top === b.Top) && ((this.Right === b.Right) && (this.Bottom === b.Bottom)));
    };
  };
  $mod.$rtti.$Record("TRect",{}).addFields("Left",rtl.longint,"Top",rtl.longint,"Right",rtl.longint,"Bottom",rtl.longint);
  this.EqualRect = function (r1, r2) {
    var Result = false;
    Result = (((r1.Left === r2.Left) && (r1.Right === r2.Right)) && (r1.Top === r2.Top)) && (r1.Bottom === r2.Bottom);
    return Result;
  };
  this.Rect = function (Left, Top, Right, Bottom) {
    var Result = new $mod.TRect();
    Result.Left = Left;
    Result.Top = Top;
    Result.Right = Right;
    Result.Bottom = Bottom;
    return Result;
  };
  this.Bounds = function (ALeft, ATop, AWidth, AHeight) {
    var Result = new $mod.TRect();
    Result.Left = ALeft;
    Result.Top = ATop;
    Result.Right = ALeft + AWidth;
    Result.Bottom = ATop + AHeight;
    return Result;
  };
  this.Point = function (x, y) {
    var Result = new $mod.TPoint();
    Result.x = x;
    Result.y = y;
    return Result;
  };
  this.PtInRect = function (aRect, p) {
    var Result = false;
    Result = (((p.y >= aRect.Top) && (p.y < aRect.Bottom)) && (p.x >= aRect.Left)) && (p.x < aRect.Right);
    return Result;
  };
  this.IntersectRect = function (aRect, R1, R2) {
    var Result = false;
    var lRect = new $mod.TRect();
    lRect = new $mod.TRect(R1);
    if (R2.Left > R1.Left) lRect.Left = R2.Left;
    if (R2.Top > R1.Top) lRect.Top = R2.Top;
    if (R2.Right < R1.Right) lRect.Right = R2.Right;
    if (R2.Bottom < R1.Bottom) lRect.Bottom = R2.Bottom;
    if ($mod.IsRectEmpty(lRect)) {
      aRect.set(new $mod.TRect($mod.Rect(0,0,0,0)));
      Result = false;
    } else {
      Result = true;
      aRect.set(new $mod.TRect(lRect));
    };
    return Result;
  };
  this.UnionRect = function (aRect, R1, R2) {
    var Result = false;
    var lRect = new $mod.TRect();
    lRect = new $mod.TRect(R1);
    if (R2.Left < R1.Left) lRect.Left = R2.Left;
    if (R2.Top < R1.Top) lRect.Top = R2.Top;
    if (R2.Right > R1.Right) lRect.Right = R2.Right;
    if (R2.Bottom > R1.Bottom) lRect.Bottom = R2.Bottom;
    if ($mod.IsRectEmpty(lRect)) {
      aRect.set(new $mod.TRect($mod.Rect(0,0,0,0)));
      Result = false;
    } else {
      aRect.set(new $mod.TRect(lRect));
      Result = true;
    };
    return Result;
  };
  this.IsRectEmpty = function (aRect) {
    var Result = false;
    Result = (aRect.Right <= aRect.Left) || (aRect.Bottom <= aRect.Top);
    return Result;
  };
  this.OffsetRect = function (aRect, DX, DY) {
    var Result = false;
    var $with1 = aRect.get();
    $with1.Left += DX;
    $with1.Top += DY;
    $with1.Right += DX;
    $with1.Bottom += DY;
    Result = true;
    return Result;
  };
  this.CenterPoint = function (aRect) {
    var Result = new $mod.TPoint();
    function Avg(a, b) {
      var Result = 0;
      if (a < b) {
        Result = a + ((b - a) >>> 1)}
       else Result = b + ((a - b) >>> 1);
      return Result;
    };
    Result.x = Avg(aRect.Left,aRect.Right);
    Result.y = Avg(aRect.Top,aRect.Bottom);
    return Result;
  };
  this.InflateRect = function (aRect, dx, dy) {
    var Result = false;
    var $with1 = aRect.get();
    $with1.Left -= dx;
    $with1.Top -= dy;
    $with1.Right += dx;
    $with1.Bottom += dy;
    Result = true;
    return Result;
  };
  this.Size = function (AWidth, AHeight) {
    var Result = new $mod.TSize();
    Result.cx = AWidth;
    Result.cy = AHeight;
    return Result;
  };
  this.Size$1 = function (aRect) {
    var Result = new $mod.TSize();
    Result.cx = aRect.Right - aRect.Left;
    Result.cy = aRect.Bottom - aRect.Top;
    return Result;
  };
});
rtl.module("JS",["System","Types"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"EJS",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FMessage = "";
    };
    this.Create$1 = function (Msg) {
      this.FMessage = Msg;
    };
  });
  $mod.$rtti.$DynArray("TJSObjectDynArray",{eltype: $mod.$rtti["TJSObject"]});
  $mod.$rtti.$DynArray("TJSObjectDynArrayArray",{eltype: $mod.$rtti["TJSObjectDynArray"]});
  $mod.$rtti.$DynArray("TJSStringDynArray",{eltype: rtl.string});
  this.TLocaleCompareOptions = function (s) {
    if (s) {
      this.localematched = s.localematched;
      this.usage = s.usage;
      this.sensitivity = s.sensitivity;
      this.ignorePunctuation = s.ignorePunctuation;
      this.numeric = s.numeric;
      this.caseFirst = s.caseFirst;
    } else {
      this.localematched = "";
      this.usage = "";
      this.sensitivity = "";
      this.ignorePunctuation = false;
      this.numeric = false;
      this.caseFirst = "";
    };
    this.$equal = function (b) {
      return (this.localematched === b.localematched) && ((this.usage === b.usage) && ((this.sensitivity === b.sensitivity) && ((this.ignorePunctuation === b.ignorePunctuation) && ((this.numeric === b.numeric) && (this.caseFirst === b.caseFirst)))));
    };
  };
  $mod.$rtti.$Record("TLocaleCompareOptions",{}).addFields("localematched",rtl.string,"usage",rtl.string,"sensitivity",rtl.string,"ignorePunctuation",rtl.boolean,"numeric",rtl.boolean,"caseFirst",rtl.string);
  $mod.$rtti.$ProcVar("TReplaceCallBack",{procsig: rtl.newTIProcSig(null,rtl.string,2)});
  $mod.$rtti.$RefToProcVar("TJSArrayEvent",{procsig: rtl.newTIProcSig([["element",rtl.jsvalue],["index",rtl.nativeint],["anArray",$mod.$rtti["TJSArray"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSArrayMapEvent",{procsig: rtl.newTIProcSig([["element",rtl.jsvalue],["index",rtl.nativeint],["anArray",$mod.$rtti["TJSArray"]]],rtl.jsvalue)});
  $mod.$rtti.$RefToProcVar("TJSArrayReduceEvent",{procsig: rtl.newTIProcSig([["accumulator",rtl.jsvalue],["currentValue",rtl.jsvalue],["currentIndex",rtl.nativeint],["anArray",$mod.$rtti["TJSArray"]]],rtl.jsvalue)});
  $mod.$rtti.$RefToProcVar("TJSArrayCompareEvent",{procsig: rtl.newTIProcSig([["a",rtl.jsvalue],["b",rtl.jsvalue]],rtl.nativeint)});
  $mod.$rtti.$ProcVar("TJSTypedArrayCallBack",{procsig: rtl.newTIProcSig([["element",rtl.jsvalue],["index",rtl.nativeint],["anArray",$mod.$rtti["TJSTypedArray"]]],rtl.boolean)});
  $mod.$rtti.$MethodVar("TJSTypedArrayEvent",{procsig: rtl.newTIProcSig([["element",rtl.jsvalue],["index",rtl.nativeint],["anArray",$mod.$rtti["TJSTypedArray"]]],rtl.boolean), methodkind: 1});
  $mod.$rtti.$ProcVar("TJSTypedArrayMapCallBack",{procsig: rtl.newTIProcSig([["element",rtl.jsvalue],["index",rtl.nativeint],["anArray",$mod.$rtti["TJSTypedArray"]]],rtl.jsvalue)});
  $mod.$rtti.$MethodVar("TJSTypedArrayMapEvent",{procsig: rtl.newTIProcSig([["element",rtl.jsvalue],["index",rtl.nativeint],["anArray",$mod.$rtti["TJSTypedArray"]]],rtl.jsvalue), methodkind: 1});
  $mod.$rtti.$ProcVar("TJSTypedArrayReduceCallBack",{procsig: rtl.newTIProcSig([["accumulator",rtl.jsvalue],["currentValue",rtl.jsvalue],["currentIndex",rtl.nativeint],["anArray",$mod.$rtti["TJSTypedArray"]]],rtl.jsvalue)});
  $mod.$rtti.$ProcVar("TJSTypedArrayCompareCallBack",{procsig: rtl.newTIProcSig([["a",rtl.jsvalue],["b",rtl.jsvalue]],rtl.nativeint)});
  $mod.$rtti.$RefToProcVar("TJSPromiseResolver",{procsig: rtl.newTIProcSig([["aValue",rtl.jsvalue]],rtl.jsvalue)});
  $mod.$rtti.$RefToProcVar("TJSPromiseExecutor",{procsig: rtl.newTIProcSig([["resolve",$mod.$rtti["TJSPromiseResolver"]],["reject",$mod.$rtti["TJSPromiseResolver"]]])});
  $mod.$rtti.$RefToProcVar("TJSPromiseFinallyHandler",{procsig: rtl.newTIProcSig(null)});
  $mod.$rtti.$DynArray("TJSPromiseArray",{eltype: $mod.$rtti["TJSPromise"]});
  this.New = function (aElements) {
    var Result = null;
    var L = 0;
    var I = 0;
    var S = "";
    L = rtl.length(aElements);
    if ((L % 2) === 1) throw $mod.EJS.$create("Create$1",["Number of arguments must be even"]);
    I = 0;
    while (I < L) {
      if (!rtl.isString(aElements[I])) {
        S = String(I);
        throw $mod.EJS.$create("Create$1",[("Argument " + S) + " must be a string."]);
      };
      I += 2;
    };
    I = 0;
    Result = new Object();
    while (I < L) {
      S = "" + aElements[I];
      Result[S] = aElements[I + 1];
      I += 2;
    };
    return Result;
  };
  this.JSDelete = function (Obj, PropName) {
    return delete Obj[PropName];
  };
  this.hasValue = function (v) {
    if(v){ return true; } else { return false; };
  };
  this.isBoolean = function (v) {
    return typeof(v) == 'boolean';
  };
  this.isCallback = function (v) {
    return rtl.isObject(v) && rtl.isObject(v.scope) && (rtl.isString(v.fn) || rtl.isFunction(v.fn));
  };
  this.isChar = function (v) {
    return (typeof(v)!="string") && (v.length==1);
  };
  this.isClass = function (v) {
    return (typeof(v)=="object") && (v!=null) && (v.$class == v);
  };
  this.isClassInstance = function (v) {
    return (typeof(v)=="object") && (v!=null) && (v.$class == Object.getPrototypeOf(v));
  };
  this.isInteger = function (v) {
    return Math.floor(v)===v;
  };
  this.isNull = function (v) {
    return v === null;
  };
  this.isRecord = function (v) {
    return (typeof(v)=="function") && (typeof(v.$create) == "function");
  };
  this.isUndefined = function (v) {
    return v == undefined;
  };
  this.isDefined = function (v) {
    return !(v == undefined);
  };
  this.isUTF16Char = function (v) {
    if (typeof(v)!="string") return false;
    if ((v.length==0) || (v.length>2)) return false;
    var code = v.charCodeAt(0);
    if (code < 0xD800){
      if (v.length == 1) return true;
    } else if (code <= 0xDBFF){
      if (v.length==2){
        code = v.charCodeAt(1);
        if (code >= 0xDC00 && code <= 0xDFFF) return true;
      };
    };
    return false;
  };
  this.jsInstanceOf = function (aFunction, aFunctionWithPrototype) {
    return aFunction instanceof aFunctionWithPrototype;
  };
  this.toNumber = function (v) {
    return v-0;
  };
  this.toInteger = function (v) {
    var Result = 0;
    if ($mod.isInteger(v)) {
      Result = Math.floor(v)}
     else Result = 0;
    return Result;
  };
  this.toObject = function (Value) {
    var Result = null;
    if (rtl.isObject(Value)) {
      Result = rtl.getObject(Value)}
     else Result = null;
    return Result;
  };
  this.toArray = function (Value) {
    var Result = null;
    if (rtl.isArray(Value)) {
      Result = rtl.getObject(Value)}
     else Result = null;
    return Result;
  };
  this.toBoolean = function (Value) {
    var Result = false;
    if ($mod.isBoolean(Value)) {
      Result = !(Value == false)}
     else Result = false;
    return Result;
  };
  this.ToString = function (Value) {
    var Result = "";
    if (rtl.isString(Value)) {
      Result = "" + Value}
     else Result = "";
    return Result;
  };
  this.TJSValueType = {"0": "jvtNull", jvtNull: 0, "1": "jvtBoolean", jvtBoolean: 1, "2": "jvtInteger", jvtInteger: 2, "3": "jvtFloat", jvtFloat: 3, "4": "jvtString", jvtString: 4, "5": "jvtObject", jvtObject: 5, "6": "jvtArray", jvtArray: 6};
  $mod.$rtti.$Enum("TJSValueType",{minvalue: 0, maxvalue: 6, ordtype: 1, enumtype: this.TJSValueType});
  this.GetValueType = function (JS) {
    var Result = 0;
    var t = "";
    if ($mod.isNull(JS)) {
      Result = $mod.TJSValueType.jvtNull}
     else {
      t = typeof(JS);
      if (t === "string") {
        Result = $mod.TJSValueType.jvtString}
       else if (t === "boolean") {
        Result = $mod.TJSValueType.jvtBoolean}
       else if (t === "object") {
        if (rtl.isArray(JS)) {
          Result = $mod.TJSValueType.jvtArray}
         else Result = $mod.TJSValueType.jvtObject;
      } else if (t === "number") if ($mod.isInteger(JS)) {
        Result = $mod.TJSValueType.jvtInteger}
       else Result = $mod.TJSValueType.jvtFloat;
    };
    return Result;
  };
});
rtl.module("SysUtils",["System","RTLConsts","JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.FreeAndNil = function (Obj) {
    var o = null;
    o = Obj.get();
    if (o === null) return;
    Obj.set(null);
    o.$destroy("Destroy");
  };
  $mod.$rtti.$ProcVar("TProcedure",{procsig: rtl.newTIProcSig(null)});
  this.FloatRecDigits = 19;
  this.TFloatRec = function (s) {
    if (s) {
      this.Exponent = s.Exponent;
      this.Negative = s.Negative;
      this.Digits = s.Digits.slice(0);
    } else {
      this.Exponent = 0;
      this.Negative = false;
      this.Digits = rtl.arraySetLength(null,"",19);
    };
    this.$equal = function (b) {
      return (this.Exponent === b.Exponent) && ((this.Negative === b.Negative) && rtl.arrayEq(this.Digits,b.Digits));
    };
  };
  $mod.$rtti.$StaticArray("TFloatRec.Digits$a",{dims: [19], eltype: rtl.char});
  $mod.$rtti.$Record("TFloatRec",{}).addFields("Exponent",rtl.longint,"Negative",rtl.boolean,"Digits",$mod.$rtti["TFloatRec.Digits$a"]);
  this.TEndian = {"0": "Little", Little: 0, "1": "Big", Big: 1};
  $mod.$rtti.$Enum("TEndian",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TEndian});
  $mod.$rtti.$StaticArray("TByteArray",{dims: [32768], eltype: rtl.byte});
  $mod.$rtti.$StaticArray("TWordArray",{dims: [16384], eltype: rtl.word});
  $mod.$rtti.$DynArray("TBytes",{eltype: rtl.byte});
  $mod.$rtti.$DynArray("TStringArray",{eltype: rtl.string});
  $mod.$rtti.$StaticArray("TMonthNameArray",{dims: [12], eltype: rtl.string});
  $mod.$rtti.$StaticArray("TDayTable",{dims: [12], eltype: rtl.word});
  $mod.$rtti.$StaticArray("TWeekNameArray",{dims: [7], eltype: rtl.string});
  $mod.$rtti.$StaticArray("TDayNames",{dims: [7], eltype: rtl.string});
  rtl.createClass($mod,"Exception",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.fMessage = "";
      this.fHelpContext = 0;
    };
    this.Create$1 = function (Msg) {
      this.fMessage = Msg;
    };
    this.CreateFmt = function (Msg, Args) {
      this.Create$1($mod.Format(Msg,Args));
    };
    this.CreateHelp = function (Msg, AHelpContext) {
      this.Create$1(Msg);
      this.fHelpContext = AHelpContext;
    };
    this.CreateFmtHelp = function (Msg, Args, AHelpContext) {
      this.Create$1($mod.Format(Msg,Args));
      this.fHelpContext = AHelpContext;
    };
    this.ToString = function () {
      var Result = "";
      Result = (this.$classname + ": ") + this.fMessage;
      return Result;
    };
  });
  $mod.$rtti.$ClassRef("ExceptClass",{instancetype: $mod.$rtti["Exception"]});
  rtl.createClass($mod,"EExternal",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EMathError",$mod.EExternal,function () {
  });
  rtl.createClass($mod,"EInvalidOp",$mod.EMathError,function () {
  });
  rtl.createClass($mod,"EZeroDivide",$mod.EMathError,function () {
  });
  rtl.createClass($mod,"EOverflow",$mod.EMathError,function () {
  });
  rtl.createClass($mod,"EUnderflow",$mod.EMathError,function () {
  });
  rtl.createClass($mod,"EAbort",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EInvalidCast",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EAssertionFailed",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EObjectCheck",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EConvertError",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EFormatError",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EIntError",$mod.EExternal,function () {
  });
  rtl.createClass($mod,"EDivByZero",$mod.EIntError,function () {
  });
  rtl.createClass($mod,"ERangeError",$mod.EIntError,function () {
  });
  rtl.createClass($mod,"EIntOverflow",$mod.EIntError,function () {
  });
  rtl.createClass($mod,"EInOutError",$mod.Exception,function () {
    this.$init = function () {
      $mod.Exception.$init.call(this);
      this.ErrorCode = 0;
    };
  });
  rtl.createClass($mod,"EHeapMemoryError",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EExternalException",$mod.EExternal,function () {
  });
  rtl.createClass($mod,"EInvalidPointer",$mod.EHeapMemoryError,function () {
  });
  rtl.createClass($mod,"EOutOfMemory",$mod.EHeapMemoryError,function () {
  });
  rtl.createClass($mod,"EVariantError",$mod.Exception,function () {
    this.$init = function () {
      $mod.Exception.$init.call(this);
      this.ErrCode = 0;
    };
    this.CreateCode = function (Code) {
      this.ErrCode = Code;
    };
  });
  rtl.createClass($mod,"EAccessViolation",$mod.EExternal,function () {
  });
  rtl.createClass($mod,"EBusError",$mod.EAccessViolation,function () {
  });
  rtl.createClass($mod,"EPrivilege",$mod.EExternal,function () {
  });
  rtl.createClass($mod,"EStackOverflow",$mod.EExternal,function () {
  });
  rtl.createClass($mod,"EControlC",$mod.EExternal,function () {
  });
  rtl.createClass($mod,"EAbstractError",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EPropReadOnly",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EPropWriteOnly",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EIntfCastError",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EInvalidContainer",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EInvalidInsert",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EPackageError",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EOSError",$mod.Exception,function () {
    this.$init = function () {
      $mod.Exception.$init.call(this);
      this.ErrorCode = 0;
    };
  });
  rtl.createClass($mod,"ESafecallException",$mod.Exception,function () {
  });
  rtl.createClass($mod,"ENoThreadSupport",$mod.Exception,function () {
  });
  rtl.createClass($mod,"ENoWideStringSupport",$mod.Exception,function () {
  });
  rtl.createClass($mod,"ENotImplemented",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EArgumentException",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EArgumentOutOfRangeException",$mod.EArgumentException,function () {
  });
  rtl.createClass($mod,"EArgumentNilException",$mod.EArgumentException,function () {
  });
  rtl.createClass($mod,"EPathTooLongException",$mod.Exception,function () {
  });
  rtl.createClass($mod,"ENotSupportedException",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EDirectoryNotFoundException",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EFileNotFoundException",$mod.Exception,function () {
  });
  rtl.createClass($mod,"EPathNotFoundException",$mod.Exception,function () {
  });
  rtl.createClass($mod,"ENoConstructException",$mod.Exception,function () {
  });
  this.EmptyStr = "";
  this.EmptyWideStr = "";
  this.HexDisplayPrefix = "$";
  this.LeadBytes = {};
  this.CharInSet = function (Ch, CSet) {
    var Result = false;
    var I = 0;
    Result = false;
    I = rtl.length(CSet) - 1;
    while (!Result && (I >= 0)) {
      Result = Ch === CSet[I];
      I -= 1;
    };
    return Result;
  };
  this.LeftStr = function (S, Count) {
    return (Count>0) ? S.substr(0,Count) : "";
  };
  this.RightStr = function (S, Count) {
    var l = S.length;
    return (Count<1) ? "" : ( Count>=l ? S : S.substr(l-Count));
  };
  this.Trim = function (S) {
    return S.trim();
  };
  this.TrimLeft = function (S) {
    return S.replace(/^[\s\uFEFF\xA0\x00-\x1f]+/,'');
  };
  this.TrimRight = function (S) {
    return S.replace(/[\s\uFEFF\xA0\x00-\x1f]+$/,'');
  };
  this.UpperCase = function (s) {
    return s.toUpperCase();
  };
  this.LowerCase = function (s) {
    return s.toLowerCase();
  };
  this.CompareStr = function (s1, s2) {
    var l1 = s1.length;
    var l2 = s2.length;
    if (l1<=l2){
      var s = s2.substr(0,l1);
      if (s1<s){ return -1;
      } else if (s1>s){ return 1;
      } else { return l1<l2 ? -1 : 0; };
    } else {
      var s = s1.substr(0,l2);
      if (s<s2){ return -1;
      } else { return 1; };
    };
  };
  this.SameStr = function (s1, s2) {
    return s1 == s2;
  };
  this.CompareText = function (s1, s2) {
    var l1 = s1.toLowerCase();
    var l2 = s2.toLowerCase();
    if (l1>l2){ return 1;
    } else if (l1<l2){ return -1;
    } else { return 0; };
  };
  this.SameText = function (s1, s2) {
    return s1.toLowerCase() == s2.toLowerCase();
  };
  this.AnsiCompareText = function (s1, s2) {
    return s1.localeCompare(s2);
  };
  this.AnsiSameText = function (s1, s2) {
    return s1.localeCompare(s2) == 0;
  };
  this.AnsiCompareStr = function (s1, s2) {
    var Result = 0;
    Result = $mod.CompareText(s1,s2);
    return Result;
  };
  this.AppendStr = function (Dest, S) {
    Dest.set(Dest.get() + S);
  };
  this.Format = function (Fmt, Args) {
    var Result = "";
    var ChPos = 0;
    var OldPos = 0;
    var ArgPos = 0;
    var DoArg = 0;
    var Len = 0;
    var Hs = "";
    var ToAdd = "";
    var Index = 0;
    var Width = 0;
    var Prec = 0;
    var Left = false;
    var Fchar = "";
    var vq = 0;
    function ReadFormat() {
      var Result = "";
      var Value = 0;
      function ReadInteger() {
        var Code = 0;
        var ArgN = 0;
        if (Value !== -1) return;
        OldPos = ChPos;
        while (((ChPos <= Len) && (Fmt.charAt(ChPos - 1) <= "9")) && (Fmt.charAt(ChPos - 1) >= "0")) ChPos += 1;
        if (ChPos > Len) $impl.DoFormatError(1,Fmt);
        if (Fmt.charAt(ChPos - 1) === "*") {
          if (Index === -1) {
            ArgN = ArgPos}
           else {
            ArgN = Index;
            Index += 1;
          };
          if ((ChPos > OldPos) || (ArgN > (rtl.length(Args) - 1))) $impl.DoFormatError(1,Fmt);
          ArgPos = ArgN + 1;
          if (rtl.isNumber(Args[ArgN]) && pas.JS.isInteger(Args[ArgN])) {
            Value = Math.floor(Args[ArgN])}
           else $impl.DoFormatError(1,Fmt);
          ChPos += 1;
        } else {
          if (OldPos < ChPos) {
            pas.System.val(pas.System.Copy(Fmt,OldPos,ChPos - OldPos),{get: function () {
                return Value;
              }, set: function (v) {
                Value = v;
              }},{get: function () {
                return Code;
              }, set: function (v) {
                Code = v;
              }});
            if (Code > 0) $impl.DoFormatError(1,Fmt);
          } else Value = -1;
        };
      };
      function ReadIndex() {
        if (Fmt.charAt(ChPos - 1) !== ":") {
          ReadInteger()}
         else Value = 0;
        if (Fmt.charAt(ChPos - 1) === ":") {
          if (Value === -1) $impl.DoFormatError(2,Fmt);
          Index = Value;
          Value = -1;
          ChPos += 1;
        };
      };
      function ReadLeft() {
        if (Fmt.charAt(ChPos - 1) === "-") {
          Left = true;
          ChPos += 1;
        } else Left = false;
      };
      function ReadWidth() {
        ReadInteger();
        if (Value !== -1) {
          Width = Value;
          Value = -1;
        };
      };
      function ReadPrec() {
        if (Fmt.charAt(ChPos - 1) === ".") {
          ChPos += 1;
          ReadInteger();
          if (Value === -1) Value = 0;
          Prec = Value;
        };
      };
      Index = -1;
      Width = -1;
      Prec = -1;
      Value = -1;
      ChPos += 1;
      if (Fmt.charAt(ChPos - 1) === "%") {
        Result = "%";
        return Result;
      };
      ReadIndex();
      ReadLeft();
      ReadWidth();
      ReadPrec();
      Result = pas.System.upcase(Fmt.charAt(ChPos - 1));
      return Result;
    };
    function Checkarg(AT, err) {
      var Result = false;
      Result = false;
      if (Index === -1) {
        DoArg = ArgPos}
       else DoArg = Index;
      ArgPos = DoArg + 1;
      if ((DoArg > (rtl.length(Args) - 1)) || (pas.JS.GetValueType(Args[DoArg]) !== AT)) {
        if (err) $impl.DoFormatError(3,Fmt);
        ArgPos -= 1;
        return Result;
      };
      Result = true;
      return Result;
    };
    Result = "";
    Len = Fmt.length;
    ChPos = 1;
    OldPos = 1;
    ArgPos = 0;
    while (ChPos <= Len) {
      while ((ChPos <= Len) && (Fmt.charAt(ChPos - 1) !== "%")) ChPos += 1;
      if (ChPos > OldPos) Result = Result + pas.System.Copy(Fmt,OldPos,ChPos - OldPos);
      if (ChPos < Len) {
        Fchar = ReadFormat();
        var $tmp1 = Fchar;
        if ($tmp1 === "D") {
          Checkarg(pas.JS.TJSValueType.jvtInteger,true);
          ToAdd = $mod.IntToStr(Math.floor(Args[DoArg]));
          Width = Math.abs(Width);
          Index = Prec - ToAdd.length;
          if (ToAdd.charAt(0) !== "-") {
            ToAdd = pas.System.StringOfChar("0",Index) + ToAdd}
           else pas.System.Insert(pas.System.StringOfChar("0",Index + 1),{get: function () {
              return ToAdd;
            }, set: function (v) {
              ToAdd = v;
            }},2);
        } else if ($tmp1 === "U") {
          Checkarg(pas.JS.TJSValueType.jvtInteger,true);
          if (Math.floor(Args[DoArg]) < 0) $impl.DoFormatError(3,Fmt);
          ToAdd = $mod.IntToStr(Math.floor(Args[DoArg]));
          Width = Math.abs(Width);
          Index = Prec - ToAdd.length;
          ToAdd = pas.System.StringOfChar("0",Index) + ToAdd;
        } else if ($tmp1 === "E") {
          if (Checkarg(pas.JS.TJSValueType.jvtFloat,false) || Checkarg(pas.JS.TJSValueType.jvtInteger,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),$mod.TFloatFormat.ffFixed,9999,Prec);
        } else if ($tmp1 === "F") {
          if (Checkarg(pas.JS.TJSValueType.jvtFloat,false) || Checkarg(pas.JS.TJSValueType.jvtInteger,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),$mod.TFloatFormat.ffFixed,9999,Prec);
        } else if ($tmp1 === "G") {
          if (Checkarg(pas.JS.TJSValueType.jvtFloat,false) || Checkarg(pas.JS.TJSValueType.jvtInteger,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),$mod.TFloatFormat.ffGeneral,Prec,3);
        } else if ($tmp1 === "N") {
          if (Checkarg(pas.JS.TJSValueType.jvtFloat,false) || Checkarg(pas.JS.TJSValueType.jvtInteger,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),$mod.TFloatFormat.ffNumber,9999,Prec);
        } else if ($tmp1 === "M") {
          if (Checkarg(pas.JS.TJSValueType.jvtFloat,false) || Checkarg(pas.JS.TJSValueType.jvtInteger,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),$mod.TFloatFormat.ffCurrency,9999,Prec);
        } else if ($tmp1 === "S") {
          Checkarg(pas.JS.TJSValueType.jvtString,true);
          Hs = "" + Args[DoArg];
          Index = Hs.length;
          if ((Prec !== -1) && (Index > Prec)) Index = Prec;
          ToAdd = pas.System.Copy(Hs,1,Index);
        } else if ($tmp1 === "P") {
          Checkarg(pas.JS.TJSValueType.jvtInteger,true);
          ToAdd = $mod.IntToHex(Math.floor(Args[DoArg]),31);
        } else if ($tmp1 === "X") {
          Checkarg(pas.JS.TJSValueType.jvtInteger,true);
          vq = Math.floor(Args[DoArg]);
          Index = 31;
          if (Prec > Index) {
            ToAdd = $mod.IntToHex(vq,Index)}
           else {
            Index = 1;
            while (((1 << (Index * 4)) <= vq) && (Index < 16)) Index += 1;
            if (Index > Prec) Prec = Index;
            ToAdd = $mod.IntToHex(vq,Prec);
          };
        } else if ($tmp1 === "%") ToAdd = "%";
        if (Width !== -1) if (ToAdd.length < Width) if (!Left) {
          ToAdd = pas.System.StringOfChar(" ",Width - ToAdd.length) + ToAdd}
         else ToAdd = ToAdd + pas.System.StringOfChar(" ",Width - ToAdd.length);
        Result = Result + ToAdd;
      };
      ChPos += 1;
      OldPos = ChPos;
    };
    return Result;
  };
  this.LocaleCompare = function (s1, s2, locales) {
    return s1.localeCompare(s2,locales) == 0;
  };
  this.NormalizeStr = function (S, Norm) {
    return S.normalize(Norm);
  };
  var Alpha = rtl.createSet(null,65,90,null,97,122,95);
  var AlphaNum = rtl.unionSet(Alpha,rtl.createSet(null,48,57));
  var Dot = ".";
  this.IsValidIdent = function (Ident, AllowDots, StrictDots) {
    var Result = false;
    var First = false;
    var I = 0;
    var Len = 0;
    Len = Ident.length;
    if (Len < 1) return false;
    First = true;
    Result = false;
    I = 1;
    while (I <= Len) {
      if (First) {
        if (!(Ident.charCodeAt(I - 1) in Alpha)) return Result;
        First = false;
      } else if (AllowDots && (Ident.charAt(I - 1) === Dot)) {
        if (StrictDots) {
          if (I >= Len) return Result;
          First = true;
        };
      } else if (!(Ident.charCodeAt(I - 1) in AlphaNum)) return Result;
      I = I + 1;
    };
    Result = true;
    return Result;
  };
  this.TStringReplaceFlag = {"0": "rfReplaceAll", rfReplaceAll: 0, "1": "rfIgnoreCase", rfIgnoreCase: 1};
  $mod.$rtti.$Enum("TStringReplaceFlag",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TStringReplaceFlag});
  $mod.$rtti.$Set("TStringReplaceFlags",{comptype: $mod.$rtti["TStringReplaceFlag"]});
  this.StringReplace = function (aOriginal, aSearch, aReplace, Flags) {
    var Result = "";
    var REFlags = "";
    var REString = "";
    REFlags = "";
    if ($mod.TStringReplaceFlag.rfReplaceAll in Flags) REFlags = "g";
    if ($mod.TStringReplaceFlag.rfIgnoreCase in Flags) REFlags = REFlags + "i";
    REString = aSearch.replace(new RegExp($impl.RESpecials,"g"),"\\$1");
    Result = aOriginal.replace(new RegExp(REString,REFlags),aReplace);
    return Result;
  };
  this.QuoteString = function (aOriginal, AQuote) {
    var Result = "";
    Result = (AQuote + $mod.StringReplace(aOriginal,AQuote,AQuote + AQuote,rtl.createSet($mod.TStringReplaceFlag.rfReplaceAll))) + AQuote;
    return Result;
  };
  this.QuotedStr = function (s, QuoteChar) {
    var Result = "";
    Result = $mod.QuoteString(s,QuoteChar);
    return Result;
  };
  this.DeQuoteString = function (aQuoted, AQuote) {
    var Result = "";
    var i = 0;
    Result = aQuoted;
    if (Result.substr(0,1) !== AQuote) return Result;
    Result = Result.slice(1);
    i = 1;
    while (i <= Result.length) {
      if (Result.charAt(i - 1) === AQuote) {
        if ((i === Result.length) || (Result.charAt((i + 1) - 1) !== AQuote)) {
          Result = Result.slice(0,i - 1);
          return Result;
        } else Result = Result.slice(0,i - 1) + Result.slice(i);
      } else i += 1;
    };
    return Result;
  };
  this.IsDelimiter = function (Delimiters, S, Index) {
    var Result = false;
    Result = false;
    if ((Index > 0) && (Index <= S.length)) Result = pas.System.Pos(S.charAt(Index - 1),Delimiters) !== 0;
    return Result;
  };
  this.AdjustLineBreaks = function (S) {
    var Result = "";
    Result = $mod.AdjustLineBreaks$1(S,pas.System.DefaultTextLineBreakStyle);
    return Result;
  };
  this.AdjustLineBreaks$1 = function (S, Style) {
    var Result = "";
    var I = 0;
    var L = 0;
    var Res = "";
    function Add(C) {
      Res = Res + C;
    };
    I = 0;
    L = S.length;
    Result = "";
    while (I <= L) {
      var $tmp1 = S.charAt(I - 1);
      if ($tmp1 === "\n") {
        if (Style in rtl.createSet(pas.System.TTextLineBreakStyle.tlbsCRLF,pas.System.TTextLineBreakStyle.tlbsCR)) Add("\r");
        if (Style === pas.System.TTextLineBreakStyle.tlbsCRLF) Add("\n");
        I += 1;
      } else if ($tmp1 === "\r") {
        if (Style === pas.System.TTextLineBreakStyle.tlbsCRLF) Add("\r");
        Add("\n");
        I += 1;
        if (S.charAt(I - 1) === "\n") I += 1;
      } else {
        Add(S.charAt(I - 1));
        I += 1;
      };
    };
    Result = Res;
    return Result;
  };
  var Quotes = rtl.createSet(39,34);
  this.WrapText = function (Line, BreakStr, BreakChars, MaxCol) {
    var Result = "";
    var L = "";
    var C = "";
    var LQ = "";
    var BC = "";
    var P = 0;
    var BLen = 0;
    var Len = 0;
    var HB = false;
    var IBC = false;
    Result = "";
    L = Line;
    BLen = BreakStr.length;
    if (BLen > 0) {
      BC = BreakStr.charAt(0)}
     else BC = "\x00";
    Len = L.length;
    while (Len > 0) {
      P = 1;
      LQ = "\x00";
      HB = false;
      IBC = false;
      while (((P <= Len) && ((P <= MaxCol) || !IBC)) && ((LQ !== "\x00") || !HB)) {
        C = L.charAt(P - 1);
        if (C === LQ) {
          LQ = "\x00"}
         else if (C.charCodeAt() in Quotes) LQ = C;
        if (LQ !== "\x00") {
          P += 1}
         else {
          HB = (C === BC) && (BreakStr === pas.System.Copy(L,P,BLen));
          if (HB) {
            P += BLen}
           else {
            if (P >= MaxCol) IBC = $mod.CharInSet(C,BreakChars);
            P += 1;
          };
        };
      };
      Result = Result + pas.System.Copy(L,1,P - 1);
      pas.System.Delete({get: function () {
          return L;
        }, set: function (v) {
          L = v;
        }},1,P - 1);
      Len = L.length;
      if ((Len > 0) && !HB) Result = Result + BreakStr;
    };
    return Result;
  };
  this.WrapText$1 = function (Line, MaxCol) {
    var Result = "";
    Result = $mod.WrapText(Line,pas.System.sLineBreak,[" ","-","\t"],MaxCol);
    return Result;
  };
  this.IntToStr = function (Value) {
    var Result = "";
    Result = "" + Value;
    return Result;
  };
  this.TryStrToInt = function (S, res) {
    var Result = false;
    var NI = 0;
    Result = $mod.TryStrToInt$1(S,{get: function () {
        return NI;
      }, set: function (v) {
        NI = v;
      }});
    if (Result) res.set(NI);
    return Result;
  };
  this.TryStrToInt$1 = function (S, res) {
    var Result = false;
    var Radix = 10;
    var N = "";
    var J = undefined;
    N = S;
    var $tmp1 = pas.System.Copy(N,1,1);
    if ($tmp1 === "$") {
      Radix = 16}
     else if ($tmp1 === "&") {
      Radix = 8}
     else if ($tmp1 === "%") Radix = 2;
    if (Radix !== 10) pas.System.Delete({get: function () {
        return N;
      }, set: function (v) {
        N = v;
      }},1,1);
    J = parseInt(N,Radix);
    Result = !isNaN(J);
    if (Result) res.set(Math.floor(J));
    return Result;
  };
  this.StrToIntDef = function (S, aDef) {
    var Result = 0;
    var R = 0;
    if ($mod.TryStrToInt$1(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }})) {
      Result = R}
     else Result = aDef;
    return Result;
  };
  this.StrToIntDef$1 = function (S, aDef) {
    var Result = 0;
    var R = 0;
    if ($mod.TryStrToInt$1(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }})) {
      Result = R}
     else Result = aDef;
    return Result;
  };
  this.StrToInt = function (S) {
    var Result = 0;
    var R = 0;
    if (!$mod.TryStrToInt$1(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SErrInvalidInteger,[S]]);
    Result = R;
    return Result;
  };
  this.StrToNativeInt = function (S) {
    var Result = 0;
    if (!$mod.TryStrToInt$1(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SErrInvalidInteger,[S]]);
    return Result;
  };
  this.StrToInt64 = function (S) {
    var Result = 0;
    var N = 0;
    if (!$mod.TryStrToInt$1(S,{get: function () {
        return N;
      }, set: function (v) {
        N = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SErrInvalidInteger,[S]]);
    Result = N;
    return Result;
  };
  this.StrToInt64Def = function (S, ADefault) {
    var Result = 0;
    if ($mod.TryStrToInt64(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = ADefault;
    return Result;
  };
  this.TryStrToInt64 = function (S, res) {
    var Result = false;
    var R = 0;
    Result = $mod.TryStrToInt$1(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }});
    if (Result) res.set(R);
    return Result;
  };
  this.StrToQWord = function (S) {
    var Result = 0;
    var N = 0;
    if (!$mod.TryStrToInt$1(S,{get: function () {
        return N;
      }, set: function (v) {
        N = v;
      }}) || (N < 0)) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SErrInvalidInteger,[S]]);
    Result = N;
    return Result;
  };
  this.StrToQWordDef = function (S, ADefault) {
    var Result = 0;
    if (!$mod.TryStrToQWord(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = ADefault;
    return Result;
  };
  this.TryStrToQWord = function (S, res) {
    var Result = false;
    var R = 0;
    Result = $mod.TryStrToInt$1(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }}) && (R >= 0);
    if (Result) res.set(R);
    return Result;
  };
  this.StrToUInt64 = function (S) {
    var Result = 0;
    var N = 0;
    if (!$mod.TryStrToInt$1(S,{get: function () {
        return N;
      }, set: function (v) {
        N = v;
      }}) || (N < 0)) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SErrInvalidInteger,[S]]);
    Result = N;
    return Result;
  };
  this.StrToUInt64Def = function (S, ADefault) {
    var Result = 0;
    if (!$mod.TryStrToUInt64(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = ADefault;
    return Result;
  };
  this.TryStrToUInt64 = function (S, res) {
    var Result = false;
    var R = 0;
    Result = $mod.TryStrToInt$1(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }}) && (R >= 0);
    if (Result) res.set(R);
    return Result;
  };
  this.StrToDWord = function (S) {
    var Result = 0;
    if (!$mod.TryStrToDWord(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SErrInvalidInteger,[S]]);
    return Result;
  };
  this.StrToDWordDef = function (S, ADefault) {
    var Result = 0;
    if (!$mod.TryStrToDWord(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = ADefault;
    return Result;
  };
  this.TryStrToDWord = function (S, res) {
    var Result = false;
    var R = 0;
    Result = ($mod.TryStrToInt$1(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }}) && (R >= 0)) && (R <= 0xFFFFFFFF);
    if (Result) res.set(R);
    return Result;
  };
  var HexDigits = "0123456789ABCDEF";
  this.IntToHex = function (Value, Digits) {
    var Result = "";
    if (Digits === 0) Digits = 1;
    Result = "";
    while (Value > 0) {
      Result = HexDigits.charAt(((Value & 15) + 1) - 1) + Result;
      Value = Value >>> 4;
    };
    while (Result.length < Digits) Result = "0" + Result;
    return Result;
  };
  this.MaxCurrency = 450359962737.0495;
  this.MinCurrency = -450359962737.0496;
  this.TFloatFormat = {"0": "ffFixed", ffFixed: 0, "1": "ffGeneral", ffGeneral: 1, "2": "ffExponent", ffExponent: 2, "3": "ffNumber", ffNumber: 3, "4": "ffCurrency", ffCurrency: 4};
  $mod.$rtti.$Enum("TFloatFormat",{minvalue: 0, maxvalue: 4, ordtype: 1, enumtype: this.TFloatFormat});
  var Rounds = "123456789:";
  this.FloatToDecimal = function (Value, Precision, Decimals) {
    var Result = new $mod.TFloatRec();
    var Buffer = "";
    var InfNan = "";
    var OutPos = 0;
    var error = 0;
    var N = 0;
    var L = 0;
    var C = 0;
    var GotNonZeroBeforeDot = false;
    var BeforeDot = false;
    Result.Negative = false;
    Result.Exponent = 0;
    for (C = 0; C <= 19; C++) Result.Digits[C] = "0";
    if (Value === 0) return Result;
    Buffer=Value.toPrecision(21); // Double precision;
    N = 1;
    L = Buffer.length;
    while (Buffer.charAt(N - 1) === " ") N += 1;
    Result.Negative = Buffer.charAt(N - 1) === "-";
    if (Result.Negative) {
      N += 1}
     else if (Buffer.charAt(N - 1) === "+") N += 1;
    if (L >= (N + 2)) {
      InfNan = pas.System.Copy(Buffer,N,3);
      if (InfNan === "Inf") {
        Result.Digits[0] = "\x00";
        Result.Exponent = 32767;
        return Result;
      };
      if (InfNan === "Nan") {
        Result.Digits[0] = "\x00";
        Result.Exponent = -32768;
        return Result;
      };
    };
    OutPos = 0;
    Result.Exponent = 0;
    BeforeDot = true;
    GotNonZeroBeforeDot = false;
    while ((L >= N) && (Buffer.charAt(N - 1) !== "E")) {
      if (Buffer.charAt(N - 1) === ".") {
        BeforeDot = false}
       else {
        if (BeforeDot) {
          Result.Exponent += 1;
          Result.Digits[OutPos] = Buffer.charAt(N - 1);
          if (Buffer.charAt(N - 1) !== "0") GotNonZeroBeforeDot = true;
        } else Result.Digits[OutPos] = Buffer.charAt(N - 1);
        OutPos += 1;
      };
      N += 1;
    };
    N += 1;
    if (N <= L) {
      pas.System.val$6(pas.System.Copy(Buffer,N,(L - N) + 1),{get: function () {
          return C;
        }, set: function (v) {
          C = v;
        }},{get: function () {
          return error;
        }, set: function (v) {
          error = v;
        }});
      Result.Exponent += C;
    };
    N = OutPos;
    L = 19;
    while (N < L) {
      Result.Digits[N] = "0";
      N += 1;
    };
    if ((Decimals + Result.Exponent) < Precision) {
      N = Decimals + Result.Exponent}
     else N = Precision;
    if (N >= L) N = L - 1;
    if (N === 0) {
      if (Result.Digits[0] >= "5") {
        Result.Digits[0] = "1";
        Result.Digits[1] = "\x00";
        Result.Exponent += 1;
      } else Result.Digits[0] = "\x00";
    } else if (N > 0) {
      if (Result.Digits[N] >= "5") {
        do {
          Result.Digits[N] = "\x00";
          N -= 1;
          Result.Digits[N] = Rounds.charAt(($mod.StrToInt(Result.Digits[N]) + 1) - 1);
        } while (!((N === 0) || (Result.Digits[N] < ":")));
        if (Result.Digits[0] === ":") {
          Result.Digits[0] = "1";
          Result.Exponent += 1;
        };
      } else {
        Result.Digits[N] = "0";
        while ((N > -1) && (Result.Digits[N] === "0")) {
          Result.Digits[N] = "\x00";
          N -= 1;
        };
      };
    } else Result.Digits[0] = "\x00";
    if ((Result.Digits[0] === "\x00") && !GotNonZeroBeforeDot) {
      Result.Exponent = 0;
      Result.Negative = false;
    };
    return Result;
  };
  this.FloatToStr = function (Value) {
    var Result = "";
    Result = $mod.FloatToStrF(Value,$mod.TFloatFormat.ffGeneral,15,0);
    return Result;
  };
  this.FloatToStrF = function (Value, format, Precision, Digits) {
    var Result = "";
    var DS = "";
    DS = $mod.DecimalSeparator;
    var $tmp1 = format;
    if ($tmp1 === $mod.TFloatFormat.ffGeneral) {
      Result = $impl.FormatGeneralFloat(Value,Precision,DS)}
     else if ($tmp1 === $mod.TFloatFormat.ffExponent) {
      Result = $impl.FormatExponentFloat(Value,Precision,Digits,DS)}
     else if ($tmp1 === $mod.TFloatFormat.ffFixed) {
      Result = $impl.FormatFixedFloat(Value,Digits,DS)}
     else if ($tmp1 === $mod.TFloatFormat.ffNumber) {
      Result = $impl.FormatNumberFloat(Value,Digits,DS,$mod.ThousandSeparator)}
     else if ($tmp1 === $mod.TFloatFormat.ffCurrency) Result = $impl.FormatNumberCurrency(Value * 10000,Digits,DS,$mod.ThousandSeparator);
    if (((format !== $mod.TFloatFormat.ffCurrency) && (Result.length > 1)) && (Result.charAt(0) === "-")) $impl.RemoveLeadingNegativeSign({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},DS);
    return Result;
  };
  this.TryStrToFloat = function (S, res) {
    var Result = false;
    var J = undefined;
    var N = "";
    N = S;
    if ($mod.ThousandSeparator !== "") N = $mod.StringReplace(N,$mod.ThousandSeparator,"",rtl.createSet($mod.TStringReplaceFlag.rfReplaceAll));
    if ($mod.DecimalSeparator !== ".") N = $mod.StringReplace(N,$mod.DecimalSeparator,".",{});
    J = parseFloat(N);
    Result = !isNaN(J);
    if (Result) res.set(rtl.getNumber(J));
    return Result;
  };
  this.StrToFloatDef = function (S, aDef) {
    var Result = 0.0;
    if (!$mod.TryStrToFloat(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = aDef;
    return Result;
  };
  this.StrToFloat = function (S) {
    var Result = 0.0;
    if (!$mod.TryStrToFloat(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SErrInvalidFloat,[S]]);
    return Result;
  };
  var MaxPrecision = 18;
  this.FormatFloat = function (Fmt, aValue) {
    var Result = "";
    var E = 0.0;
    var FV = new $mod.TFloatRec();
    var Section = "";
    var SectionLength = 0;
    var ThousandSep = false;
    var IsScientific = false;
    var DecimalPos = 0;
    var FirstDigit = 0;
    var LastDigit = 0;
    var RequestedDigits = 0;
    var ExpSize = 0;
    var Available = 0;
    var Current = 0;
    var PadZeroes = 0;
    var DistToDecimal = 0;
    function InitVars() {
      E = aValue;
      Section = "";
      SectionLength = 0;
      ThousandSep = false;
      IsScientific = false;
      DecimalPos = 0;
      FirstDigit = 2147483647;
      LastDigit = 0;
      RequestedDigits = 0;
      ExpSize = 0;
      Available = -1;
    };
    function ToResult(AChar) {
      Result = Result + AChar;
    };
    function AddToResult(AStr) {
      Result = Result + AStr;
    };
    function WriteDigit(ADigit) {
      if (ADigit === "\x00") return;
      DistToDecimal -= 1;
      if (DistToDecimal === -1) {
        AddToResult($mod.DecimalSeparator);
        ToResult(ADigit);
      } else {
        ToResult(ADigit);
        if ((ThousandSep && ((DistToDecimal % 3) === 0)) && (DistToDecimal > 1)) AddToResult($mod.ThousandSeparator);
      };
    };
    function GetDigit() {
      var Result = "";
      Result = "\x00";
      if (Current <= Available) {
        Result = FV.Digits[Current];
        Current += 1;
      } else if (DistToDecimal <= LastDigit) {
        DistToDecimal -= 1}
       else Result = "0";
      return Result;
    };
    function CopyDigit() {
      if (PadZeroes === 0) {
        WriteDigit(GetDigit())}
       else if (PadZeroes < 0) {
        PadZeroes += 1;
        if (DistToDecimal <= FirstDigit) {
          WriteDigit("0")}
         else DistToDecimal -= 1;
      } else {
        while (PadZeroes > 0) {
          WriteDigit(GetDigit());
          PadZeroes -= 1;
        };
        WriteDigit(GetDigit());
      };
    };
    function GetSections(SP) {
      var Result = 0;
      var FL = 0;
      var i = 0;
      var C = "";
      var Q = "";
      var inQuote = false;
      Result = 1;
      SP.get()[1] = -1;
      SP.get()[2] = -1;
      SP.get()[3] = -1;
      inQuote = false;
      Q = "\x00";
      i = 1;
      FL = Fmt.length;
      while (i <= FL) {
        C = Fmt.charAt(i - 1);
        var $tmp1 = C;
        if ($tmp1 === ";") {
          if (!inQuote) {
            if (Result > 3) throw $mod.Exception.$create("Create$1",["Invalid float format"]);
            SP.get()[Result] = i + 1;
            Result += 1;
          };
        } else if (($tmp1 === '"') || ($tmp1 === "'")) {
          if (inQuote) {
            inQuote = C !== Q}
           else {
            inQuote = true;
            Q = C;
          };
        };
        i += 1;
      };
      if (SP.get()[Result] === -1) SP.get()[Result] = FL + 1;
      return Result;
    };
    function AnalyzeFormat() {
      var I = 0;
      var Len = 0;
      var Q = "";
      var C = "";
      var InQuote = false;
      Len = Section.length;
      I = 1;
      InQuote = false;
      Q = "\x00";
      while (I <= Len) {
        C = Section.charAt(I - 1);
        if (C.charCodeAt() in rtl.createSet(34,39)) {
          if (InQuote) {
            InQuote = C !== Q}
           else {
            InQuote = true;
            Q = C;
          };
        } else if (!InQuote) {
          var $tmp1 = C;
          if ($tmp1 === ".") {
            if (DecimalPos === 0) DecimalPos = RequestedDigits + 1}
           else if ($tmp1 === ",") {
            ThousandSep = $mod.ThousandSeparator !== "\x00"}
           else if (($tmp1 === "e") || ($tmp1 === "E")) {
            I += 1;
            if (I < Len) {
              C = Section.charAt(I - 1);
              IsScientific = C.charCodeAt() in rtl.createSet(45,43);
              if (IsScientific) while ((I < Len) && (Section.charAt((I + 1) - 1) === "0")) {
                ExpSize += 1;
                I += 1;
              };
              if (ExpSize > 4) ExpSize = 4;
            };
          } else if ($tmp1 === "#") {
            RequestedDigits += 1}
           else if ($tmp1 === "0") {
            if (RequestedDigits < FirstDigit) FirstDigit = RequestedDigits + 1;
            RequestedDigits += 1;
            LastDigit = RequestedDigits + 1;
          };
        };
        I += 1;
      };
      if (DecimalPos === 0) DecimalPos = RequestedDigits + 1;
      LastDigit = DecimalPos - LastDigit;
      if (LastDigit > 0) LastDigit = 0;
      FirstDigit = DecimalPos - FirstDigit;
      if (FirstDigit < 0) FirstDigit = 0;
    };
    function ValueOutSideScope() {
      var Result = false;
      Result = (((FV.Exponent >= 18) && !IsScientific) || (FV.Exponent === 0x7FF)) || (FV.Exponent === 0x800);
      return Result;
    };
    function CalcRunVars() {
      var D = 0;
      var P = 0;
      if (IsScientific) {
        P = RequestedDigits;
        D = 9999;
      } else {
        P = 18;
        D = (RequestedDigits - DecimalPos) + 1;
      };
      FV = new $mod.TFloatRec($mod.FloatToDecimal(aValue,P,D));
      DistToDecimal = DecimalPos - 1;
      if (IsScientific) {
        PadZeroes = 0}
       else {
        PadZeroes = FV.Exponent - (DecimalPos - 1);
        if (PadZeroes >= 0) DistToDecimal = FV.Exponent;
      };
      Available = -1;
      while ((Available < 18) && (FV.Digits[Available + 1] !== "\x00")) Available += 1;
    };
    function FormatExponent(ASign, aExponent) {
      var Result = "";
      Result = $mod.IntToStr(aExponent);
      Result = pas.System.StringOfChar("0",ExpSize - Result.length) + Result;
      if (aExponent < 0) {
        Result = "-" + Result}
       else if ((aExponent > 0) && (ASign === "+")) Result = ASign + Result;
      return Result;
    };
    var I = 0;
    var S = 0;
    var C = "";
    var Q = "";
    var PA = [];
    var InLiteral = false;
    PA = rtl.arraySetLength(PA,0,4);
    Result = "";
    InitVars();
    if (E > 0) {
      S = 1}
     else if (E < 0) {
      S = 2}
     else S = 3;
    PA[0] = 0;
    I = GetSections({get: function () {
        return PA;
      }, set: function (v) {
        PA = v;
      }});
    if ((I < S) || ((PA[S] - PA[S - 1]) === 0)) S = 1;
    SectionLength = (PA[S] - PA[S - 1]) - 1;
    Section = pas.System.Copy(Fmt,PA[S - 1] + 1,SectionLength);
    Section = rtl.strSetLength(Section,SectionLength);
    AnalyzeFormat();
    CalcRunVars();
    if ((SectionLength === 0) || ValueOutSideScope()) {
      Section=E.toPrecision(15);
      Result = Section;
    };
    I = 1;
    Current = 0;
    Q = " ";
    InLiteral = false;
    if (FV.Negative && (S === 1)) ToResult("-");
    while (I <= SectionLength) {
      C = Section.charAt(I - 1);
      if (C.charCodeAt() in rtl.createSet(34,39)) {
        if (InLiteral) {
          InLiteral = C !== Q}
         else {
          InLiteral = true;
          Q = C;
        };
      } else if (InLiteral) {
        ToResult(C)}
       else {
        var $tmp1 = C;
        if (($tmp1 === "0") || ($tmp1 === "#")) {
          CopyDigit()}
         else if (($tmp1 === ".") || ($tmp1 === ",")) {}
        else if (($tmp1 === "e") || ($tmp1 === "E")) {
          ToResult(C);
          I += 1;
          if (I <= Section.length) {
            C = Section.charAt(I - 1);
            if (C.charCodeAt() in rtl.createSet(43,45)) {
              AddToResult(FormatExponent(C,(FV.Exponent - DecimalPos) + 1));
              while ((I < SectionLength) && (Section.charAt((I + 1) - 1) === "0")) I += 1;
            };
          };
        } else {
          ToResult(C);
        };
      };
      I += 1;
    };
    return Result;
  };
  this.TrueBoolStrs = [];
  this.FalseBoolStrs = [];
  this.StrToBool = function (S) {
    var Result = false;
    if (!$mod.TryStrToBool(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SInvalidBoolean,[S]]);
    return Result;
  };
  this.BoolToStr = function (B, UseBoolStrs) {
    var Result = "";
    if (UseBoolStrs) {
      $impl.CheckBoolStrs();
      if (B) {
        Result = $mod.TrueBoolStrs[0]}
       else Result = $mod.FalseBoolStrs[0];
    } else if (B) {
      Result = "-1"}
     else Result = "0";
    return Result;
  };
  this.BoolToStr$1 = function (B, TrueS, FalseS) {
    var Result = "";
    if (B) {
      Result = TrueS}
     else Result = FalseS;
    return Result;
  };
  this.StrToBoolDef = function (S, Default) {
    var Result = false;
    if (!$mod.TryStrToBool(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = Default;
    return Result;
  };
  this.TryStrToBool = function (S, Value) {
    var Result = false;
    var Temp = "";
    var I = 0;
    var D = 0.0;
    var Code = 0;
    Temp = $mod.UpperCase(S);
    pas.System.val$8(Temp,{get: function () {
        return D;
      }, set: function (v) {
        D = v;
      }},{get: function () {
        return Code;
      }, set: function (v) {
        Code = v;
      }});
    Result = true;
    if (Code === 0) {
      Value.set(D !== 0.0)}
     else {
      $impl.CheckBoolStrs();
      for (var $l1 = 0, $end2 = rtl.length($mod.TrueBoolStrs) - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        if (Temp === $mod.UpperCase($mod.TrueBoolStrs[I])) {
          Value.set(true);
          return Result;
        };
      };
      for (var $l3 = 0, $end4 = rtl.length($mod.FalseBoolStrs) - 1; $l3 <= $end4; $l3++) {
        I = $l3;
        if (Temp === $mod.UpperCase($mod.FalseBoolStrs[I])) {
          Value.set(false);
          return Result;
        };
      };
      Result = false;
    };
    return Result;
  };
  this.ConfigExtension = ".cfg";
  this.SysConfigDir = "";
  $mod.$rtti.$ProcVar("TOnGetEnvironmentVariable",{procsig: rtl.newTIProcSig([["EnvVar",rtl.string,2]],rtl.string)});
  $mod.$rtti.$ProcVar("TOnGetEnvironmentString",{procsig: rtl.newTIProcSig([["Index",rtl.longint]],rtl.string)});
  $mod.$rtti.$ProcVar("TOnGetEnvironmentVariableCount",{procsig: rtl.newTIProcSig(null,rtl.longint)});
  this.OnGetEnvironmentVariable = null;
  this.OnGetEnvironmentString = null;
  this.OnGetEnvironmentVariableCount = null;
  this.GetEnvironmentVariable = function (EnvVar) {
    var Result = "";
    if ($mod.OnGetEnvironmentVariable != null) {
      Result = $mod.OnGetEnvironmentVariable(EnvVar)}
     else Result = "";
    return Result;
  };
  this.GetEnvironmentVariableCount = function () {
    var Result = 0;
    if ($mod.OnGetEnvironmentVariableCount != null) {
      Result = $mod.OnGetEnvironmentVariableCount()}
     else Result = 0;
    return Result;
  };
  this.GetEnvironmentString = function (Index) {
    var Result = "";
    if ($mod.OnGetEnvironmentString != null) {
      Result = $mod.OnGetEnvironmentString(Index)}
     else Result = "";
    return Result;
  };
  this.ShowException = function (ExceptObject, ExceptAddr) {
    var S = "";
    S = "Application raised an exception " + ExceptObject.$classname;
    if ($mod.Exception.isPrototypeOf(ExceptObject)) S = (S + " : ") + ExceptObject.fMessage;
    window.alert(S);
    if (ExceptAddr === null) ;
  };
  this.Abort = function () {
    throw $mod.EAbort.$create("Create$1",[$impl.SAbortError]);
  };
  this.TEventType = {"0": "etCustom", etCustom: 0, "1": "etInfo", etInfo: 1, "2": "etWarning", etWarning: 2, "3": "etError", etError: 3, "4": "etDebug", etDebug: 4};
  $mod.$rtti.$Enum("TEventType",{minvalue: 0, maxvalue: 4, ordtype: 1, enumtype: this.TEventType});
  $mod.$rtti.$Set("TEventTypes",{comptype: $mod.$rtti["TEventType"]});
  this.TSystemTime = function (s) {
    if (s) {
      this.Year = s.Year;
      this.Month = s.Month;
      this.Day = s.Day;
      this.DayOfWeek = s.DayOfWeek;
      this.Hour = s.Hour;
      this.Minute = s.Minute;
      this.Second = s.Second;
      this.MilliSecond = s.MilliSecond;
    } else {
      this.Year = 0;
      this.Month = 0;
      this.Day = 0;
      this.DayOfWeek = 0;
      this.Hour = 0;
      this.Minute = 0;
      this.Second = 0;
      this.MilliSecond = 0;
    };
    this.$equal = function (b) {
      return (this.Year === b.Year) && ((this.Month === b.Month) && ((this.Day === b.Day) && ((this.DayOfWeek === b.DayOfWeek) && ((this.Hour === b.Hour) && ((this.Minute === b.Minute) && ((this.Second === b.Second) && (this.MilliSecond === b.MilliSecond)))))));
    };
  };
  $mod.$rtti.$Record("TSystemTime",{}).addFields("Year",rtl.word,"Month",rtl.word,"Day",rtl.word,"DayOfWeek",rtl.word,"Hour",rtl.word,"Minute",rtl.word,"Second",rtl.word,"MilliSecond",rtl.word);
  this.TTimeStamp = function (s) {
    if (s) {
      this.Time = s.Time;
      this.Date = s.Date;
    } else {
      this.Time = 0;
      this.Date = 0;
    };
    this.$equal = function (b) {
      return (this.Time === b.Time) && (this.Date === b.Date);
    };
  };
  $mod.$rtti.$Record("TTimeStamp",{}).addFields("Time",rtl.longint,"Date",rtl.longint);
  this.TimeSeparator = ":";
  this.DateSeparator = "-";
  this.ShortDateFormat = "yyyy-mm-dd";
  this.LongDateFormat = "ddd, yyyy-mm-dd";
  this.ShortTimeFormat = "hh:nn";
  this.LongTimeFormat = "hh:nn:ss";
  this.DecimalSeparator = ".";
  this.ThousandSeparator = "";
  this.TimeAMString = "AM";
  this.TimePMString = "PM";
  this.HoursPerDay = 24;
  this.MinsPerHour = 60;
  this.SecsPerMin = 60;
  this.MSecsPerSec = 1000;
  this.MinsPerDay = 24 * 60;
  this.SecsPerDay = 1440 * 60;
  this.MSecsPerDay = 86400 * 1000;
  this.MaxDateTime = 2958465.99999999;
  this.MinDateTime = -693593.99999999;
  this.JulianEpoch = -2415018.5;
  this.UnixEpoch = -2415018.5 + 2440587.5;
  this.DateDelta = 693594;
  this.UnixDateDelta = 25569;
  this.MonthDays = [[31,28,31,30,31,30,31,31,30,31,30,31],[31,29,31,30,31,30,31,31,30,31,30,31]];
  this.ShortMonthNames = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  this.LongMonthNames = ["January","February","March","April","May","June","July","August","September","October","November","December"];
  this.ShortDayNames = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
  this.LongDayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  rtl.createClass($mod,"TFormatSettings",pas.System.TObject,function () {
    this.GetCurrencyDecimals = function () {
      var Result = 0;
      Result = $mod.CurrencyDecimals;
      return Result;
    };
    this.GetCurrencyFormat = function () {
      var Result = 0;
      Result = $mod.CurrencyFormat;
      return Result;
    };
    this.GetCurrencyString = function () {
      var Result = "";
      Result = $mod.CurrencyString;
      return Result;
    };
    this.GetDateSeparator = function () {
      var Result = "";
      Result = $mod.DateSeparator;
      return Result;
    };
    this.GetDecimalSeparator = function () {
      var Result = "";
      Result = $mod.DecimalSeparator;
      return Result;
    };
    this.GetLongDateFormat = function () {
      var Result = "";
      Result = $mod.LongDateFormat;
      return Result;
    };
    this.GetLongDayNames = function () {
      var Result = rtl.arraySetLength(null,"",7);
      Result = $mod.LongDayNames.slice(0);
      return Result;
    };
    this.GetLongMonthNames = function () {
      var Result = rtl.arraySetLength(null,"",12);
      Result = $mod.LongMonthNames.slice(0);
      return Result;
    };
    this.GetLongTimeFormat = function () {
      var Result = "";
      Result = $mod.LongTimeFormat;
      return Result;
    };
    this.GetNegCurrFormat = function () {
      var Result = 0;
      Result = $mod.NegCurrFormat;
      return Result;
    };
    this.GetShortDateFormat = function () {
      var Result = "";
      Result = $mod.ShortDateFormat;
      return Result;
    };
    this.GetShortDayNames = function () {
      var Result = rtl.arraySetLength(null,"",7);
      Result = $mod.ShortDayNames.slice(0);
      return Result;
    };
    this.GetShortMonthNames = function () {
      var Result = rtl.arraySetLength(null,"",12);
      Result = $mod.ShortMonthNames.slice(0);
      return Result;
    };
    this.GetShortTimeFormat = function () {
      var Result = "";
      Result = $mod.ShortTimeFormat;
      return Result;
    };
    this.GetThousandSeparator = function () {
      var Result = "";
      Result = $mod.ThousandSeparator;
      return Result;
    };
    this.GetTimeAMString = function () {
      var Result = "";
      Result = $mod.TimeAMString;
      return Result;
    };
    this.GetTimePMString = function () {
      var Result = "";
      Result = $mod.TimePMString;
      return Result;
    };
    this.GetTimeSeparator = function () {
      var Result = "";
      Result = $mod.TimeSeparator;
      return Result;
    };
    this.SetCurrencyFormat = function (AValue) {
      $mod.CurrencyFormat = AValue;
    };
    this.SetCurrencyString = function (AValue) {
      $mod.CurrencyString = AValue;
    };
    this.SetDateSeparator = function (Value) {
      $mod.DateSeparator = Value;
    };
    this.SetDecimalSeparator = function (Value) {
      $mod.DecimalSeparator = Value;
    };
    this.SetLongDateFormat = function (Value) {
      $mod.LongDateFormat = Value;
    };
    this.SetLongDayNames = function (AValue) {
      $mod.LongDayNames = AValue.slice(0);
    };
    this.SetLongMonthNames = function (AValue) {
      $mod.LongMonthNames = AValue.slice(0);
    };
    this.SetLongTimeFormat = function (Value) {
      $mod.LongTimeFormat = Value;
    };
    this.SetNegCurrFormat = function (AValue) {
      $mod.NegCurrFormat = AValue;
    };
    this.SetShortDateFormat = function (Value) {
      $mod.ShortDateFormat = Value;
    };
    this.SetShortDayNames = function (AValue) {
      $mod.ShortDayNames = AValue.slice(0);
    };
    this.SetShortMonthNames = function (AValue) {
      $mod.ShortMonthNames = AValue.slice(0);
    };
    this.SetShortTimeFormat = function (Value) {
      $mod.ShortTimeFormat = Value;
    };
    this.SetCurrencyDecimals = function (AValue) {
      $mod.CurrencyDecimals = AValue;
    };
    this.SetThousandSeparator = function (Value) {
      $mod.ThousandSeparator = Value;
    };
    this.SetTimeAMString = function (Value) {
      $mod.TimeAMString = Value;
    };
    this.SetTimePMString = function (Value) {
      $mod.TimePMString = Value;
    };
    this.SetTimeSeparator = function (Value) {
      $mod.TimeSeparator = Value;
    };
  });
  this.FormatSettings = null;
  this.TwoDigitYearCenturyWindow = 50;
  this.DateTimeToJSDate = function (aDateTime) {
    var Result = null;
    var Y = 0;
    var M = 0;
    var D = 0;
    var h = 0;
    var n = 0;
    var s = 0;
    var z = 0;
    $mod.DecodeDate(pas.System.Trunc(aDateTime),{get: function () {
        return Y;
      }, set: function (v) {
        Y = v;
      }},{get: function () {
        return M;
      }, set: function (v) {
        M = v;
      }},{get: function () {
        return D;
      }, set: function (v) {
        D = v;
      }});
    $mod.DecodeTime(pas.System.Frac(aDateTime),{get: function () {
        return h;
      }, set: function (v) {
        h = v;
      }},{get: function () {
        return n;
      }, set: function (v) {
        n = v;
      }},{get: function () {
        return s;
      }, set: function (v) {
        s = v;
      }},{get: function () {
        return z;
      }, set: function (v) {
        z = v;
      }});
    Result = new Date(Y,M,D,h,n,s,z);
    return Result;
  };
  this.JSDateToDateTime = function (aDate) {
    var Result = 0.0;
    Result = $mod.EncodeDate(aDate.getFullYear(),aDate.getMonth() + 1,aDate.getDate()) + $mod.EncodeTime(aDate.getHours(),aDate.getMinutes(),aDate.getSeconds(),aDate.getMilliseconds());
    return Result;
  };
  this.DateTimeToTimeStamp = function (DateTime) {
    var Result = new $mod.TTimeStamp();
    var D = 0.0;
    D = DateTime * 86400000;
    if (D < 0) {
      D = D - 0.5}
     else D = D + 0.5;
    Result.Time = pas.System.Trunc(Math.abs(pas.System.Trunc(D)) % 86400000);
    Result.Date = 693594 + Math.floor(pas.System.Trunc(D) / 86400000);
    return Result;
  };
  this.TimeStampToDateTime = function (TimeStamp) {
    var Result = 0.0;
    Result = $mod.ComposeDateTime(TimeStamp.Date - 693594,TimeStamp.Time / 86400000);
    return Result;
  };
  this.MSecsToTimeStamp = function (MSecs) {
    var Result = new $mod.TTimeStamp();
    Result.Date = pas.System.Trunc(MSecs / 86400000);
    MSecs = MSecs - (Result.Date * 86400000);
    Result.Time = Math.round(MSecs);
    return Result;
  };
  this.TimeStampToMSecs = function (TimeStamp) {
    var Result = 0;
    Result = TimeStamp.Time + (TimeStamp.Date * 86400000);
    return Result;
  };
  this.TryEncodeDate = function (Year, Month, Day, date) {
    var Result = false;
    var c = 0;
    var ya = 0;
    Result = (((((Year > 0) && (Year < 10000)) && (Month >= 1)) && (Month <= 12)) && (Day > 0)) && (Day <= $mod.MonthDays[+$mod.IsLeapYear(Year)][Month - 1]);
    if (Result) {
      if (Month > 2) {
        Month -= 3}
       else {
        Month += 9;
        Year -= 1;
      };
      c = Math.floor(Year / 100);
      ya = Year - (100 * c);
      date.set(((((146097 * c) >>> 2) + ((1461 * ya) >>> 2)) + Math.floor(((153 * Month) + 2) / 5)) + Day);
      date.set(date.get() - 693900);
    };
    return Result;
  };
  this.TryEncodeTime = function (Hour, Min, Sec, MSec, Time) {
    var Result = false;
    Result = (((Hour < 24) && (Min < 60)) && (Sec < 60)) && (MSec < 1000);
    if (Result) Time.set(((((Hour * 3600000) + (Min * 60000)) + (Sec * 1000)) + MSec) / 86400000);
    return Result;
  };
  this.EncodeDate = function (Year, Month, Day) {
    var Result = 0.0;
    if (!$mod.TryEncodeDate(Year,Month,Day,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",["%s-%s-%s is not a valid date specification",[$mod.IntToStr(Year),$mod.IntToStr(Month),$mod.IntToStr(Day)]]);
    return Result;
  };
  this.EncodeTime = function (Hour, Minute, Second, MilliSecond) {
    var Result = 0.0;
    if (!$mod.TryEncodeTime(Hour,Minute,Second,MilliSecond,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",["%s:%s:%s.%s is not a valid time specification",[$mod.IntToStr(Hour),$mod.IntToStr(Minute),$mod.IntToStr(Second),$mod.IntToStr(MilliSecond)]]);
    return Result;
  };
  this.ComposeDateTime = function (date, Time) {
    var Result = 0.0;
    if (date < 0) {
      Result = pas.System.Trunc(date) - Math.abs(pas.System.Frac(Time))}
     else Result = pas.System.Trunc(date) + Math.abs(pas.System.Frac(Time));
    return Result;
  };
  this.DecodeDate = function (date, Year, Month, Day) {
    var ly = 0;
    var ld = 0;
    var lm = 0;
    var j = 0;
    if (date <= -693594) {
      Year.set(0);
      Month.set(0);
      Day.set(0);
    } else {
      if (date > 0) {
        date = date + (1 / (86400000 * 2))}
       else date = date - (1 / (86400000 * 2));
      if (date > $mod.MaxDateTime) date = $mod.MaxDateTime;
      j = ((pas.System.Trunc(date) + 693900) << 2) - 1;
      ly = Math.floor(j / 146097);
      j = j - (146097 * ly);
      ld = j >>> 2;
      j = Math.floor(((ld << 2) + 3) / 1461);
      ld = (((ld << 2) + 7) - (1461 * j)) >>> 2;
      lm = Math.floor(((5 * ld) - 3) / 153);
      ld = Math.floor((((5 * ld) + 2) - (153 * lm)) / 5);
      ly = (100 * ly) + j;
      if (lm < 10) {
        lm += 3}
       else {
        lm -= 9;
        ly += 1;
      };
      Year.set(ly);
      Month.set(lm);
      Day.set(ld);
    };
  };
  this.DecodeDateFully = function (DateTime, Year, Month, Day, DOW) {
    var Result = false;
    $mod.DecodeDate(DateTime,Year,Month,Day);
    DOW.set($mod.DayOfWeek(DateTime));
    Result = $mod.IsLeapYear(Year.get());
    return Result;
  };
  this.DecodeTime = function (Time, Hour, Minute, Second, MilliSecond) {
    var l = 0;
    l = $mod.DateTimeToTimeStamp(Time).Time;
    Hour.set(Math.floor(l / 3600000));
    l = l % 3600000;
    Minute.set(Math.floor(l / 60000));
    l = l % 60000;
    Second.set(Math.floor(l / 1000));
    l = l % 1000;
    MilliSecond.set(l);
  };
  this.DateTimeToSystemTime = function (DateTime, SystemTime) {
    $mod.DecodeDateFully(DateTime,{p: SystemTime.get(), get: function () {
        return this.p.Year;
      }, set: function (v) {
        this.p.Year = v;
      }},{p: SystemTime.get(), get: function () {
        return this.p.Month;
      }, set: function (v) {
        this.p.Month = v;
      }},{p: SystemTime.get(), get: function () {
        return this.p.Day;
      }, set: function (v) {
        this.p.Day = v;
      }},{p: SystemTime.get(), get: function () {
        return this.p.DayOfWeek;
      }, set: function (v) {
        this.p.DayOfWeek = v;
      }});
    $mod.DecodeTime(DateTime,{p: SystemTime.get(), get: function () {
        return this.p.Hour;
      }, set: function (v) {
        this.p.Hour = v;
      }},{p: SystemTime.get(), get: function () {
        return this.p.Minute;
      }, set: function (v) {
        this.p.Minute = v;
      }},{p: SystemTime.get(), get: function () {
        return this.p.Second;
      }, set: function (v) {
        this.p.Second = v;
      }},{p: SystemTime.get(), get: function () {
        return this.p.MilliSecond;
      }, set: function (v) {
        this.p.MilliSecond = v;
      }});
    SystemTime.get().DayOfWeek -= 1;
  };
  this.SystemTimeToDateTime = function (SystemTime) {
    var Result = 0.0;
    Result = $mod.ComposeDateTime($impl.DoEncodeDate(SystemTime.Year,SystemTime.Month,SystemTime.Day),$impl.DoEncodeTime(SystemTime.Hour,SystemTime.Minute,SystemTime.Second,SystemTime.MilliSecond));
    return Result;
  };
  this.DayOfWeek = function (DateTime) {
    var Result = 0;
    Result = 1 + ((pas.System.Trunc(DateTime) - 1) % 7);
    if (Result <= 0) Result += 7;
    return Result;
  };
  this.Date = function () {
    var Result = 0.0;
    Result = pas.System.Trunc($mod.Now());
    return Result;
  };
  this.Time = function () {
    var Result = 0.0;
    Result = $mod.Now() - $mod.Date();
    return Result;
  };
  this.Now = function () {
    var Result = 0.0;
    Result = $mod.JSDateToDateTime(new Date());
    return Result;
  };
  this.IncMonth = function (DateTime, NumberOfMonths) {
    var Result = 0.0;
    var Year = 0;
    var Month = 0;
    var Day = 0;
    $mod.DecodeDate(DateTime,{get: function () {
        return Year;
      }, set: function (v) {
        Year = v;
      }},{get: function () {
        return Month;
      }, set: function (v) {
        Month = v;
      }},{get: function () {
        return Day;
      }, set: function (v) {
        Day = v;
      }});
    $mod.IncAMonth({get: function () {
        return Year;
      }, set: function (v) {
        Year = v;
      }},{get: function () {
        return Month;
      }, set: function (v) {
        Month = v;
      }},{get: function () {
        return Day;
      }, set: function (v) {
        Day = v;
      }},NumberOfMonths);
    Result = $mod.ComposeDateTime($impl.DoEncodeDate(Year,Month,Day),DateTime);
    return Result;
  };
  this.IncAMonth = function (Year, Month, Day, NumberOfMonths) {
    var TempMonth = 0;
    var S = 0;
    if (NumberOfMonths >= 0) {
      S = 1}
     else S = -1;
    Year.set(Year.get() + Math.floor(NumberOfMonths / 12));
    TempMonth = (Month.get() + (NumberOfMonths % 12)) - 1;
    if ((TempMonth > 11) || (TempMonth < 0)) {
      TempMonth -= S * 12;
      Year.set(Year.get() + S);
    };
    Month.set(TempMonth + 1);
    if (Day.get() > $mod.MonthDays[+$mod.IsLeapYear(Year.get())][Month.get() - 1]) Day.set($mod.MonthDays[+$mod.IsLeapYear(Year.get())][Month.get() - 1]);
  };
  this.IsLeapYear = function (Year) {
    var Result = false;
    Result = ((Year % 4) === 0) && (((Year % 100) !== 0) || ((Year % 400) === 0));
    return Result;
  };
  this.DateToStr = function (date) {
    var Result = "";
    Result = $mod.FormatDateTime("ddddd",date);
    return Result;
  };
  this.TimeToStr = function (Time) {
    var Result = "";
    Result = $mod.FormatDateTime("tt",Time);
    return Result;
  };
  this.DateTimeToStr = function (DateTime, ForceTimeIfZero) {
    var Result = "";
    Result = $mod.FormatDateTime($impl.DateTimeToStrFormat[+ForceTimeIfZero],DateTime);
    return Result;
  };
  this.StrToDate = function (S) {
    var Result = 0.0;
    Result = $mod.StrToDate$2(S,$mod.ShortDateFormat,"\x00");
    return Result;
  };
  this.StrToDate$1 = function (S, separator) {
    var Result = 0.0;
    Result = $mod.StrToDate$2(S,$mod.ShortDateFormat,separator);
    return Result;
  };
  this.StrToDate$2 = function (S, useformat, separator) {
    var Result = 0.0;
    var MSg = "";
    Result = $impl.IntStrToDate({get: function () {
        return MSg;
      }, set: function (v) {
        MSg = v;
      }},S,useformat,separator);
    if (MSg !== "") throw $mod.EConvertError.$create("Create$1",[MSg]);
    return Result;
  };
  this.StrToTime = function (S) {
    var Result = 0.0;
    Result = $mod.StrToTime$1(S,$mod.TimeSeparator);
    return Result;
  };
  this.StrToTime$1 = function (S, separator) {
    var Result = 0.0;
    var Msg = "";
    Result = $impl.IntStrToTime({get: function () {
        return Msg;
      }, set: function (v) {
        Msg = v;
      }},S,S.length,separator);
    if (Msg !== "") throw $mod.EConvertError.$create("Create$1",[Msg]);
    return Result;
  };
  this.StrToDateTime = function (S) {
    var Result = 0.0;
    var TimeStr = "";
    var DateStr = "";
    var PartsFound = 0;
    PartsFound = $impl.SplitDateTimeStr(S,{get: function () {
        return DateStr;
      }, set: function (v) {
        DateStr = v;
      }},{get: function () {
        return TimeStr;
      }, set: function (v) {
        TimeStr = v;
      }});
    var $tmp1 = PartsFound;
    if ($tmp1 === 0) {
      Result = $mod.StrToDate("")}
     else if ($tmp1 === 1) {
      if (DateStr.length > 0) {
        Result = $mod.StrToDate$2(DateStr,$mod.ShortDateFormat,$mod.DateSeparator)}
       else Result = $mod.StrToTime(TimeStr)}
     else if ($tmp1 === 2) Result = $mod.ComposeDateTime($mod.StrToDate$2(DateStr,$mod.ShortDateFormat,$mod.DateSeparator),$mod.StrToTime(TimeStr));
    return Result;
  };
  this.FormatDateTime = function (FormatStr, DateTime) {
    var Result = "";
    function StoreStr(APos, Len) {
      Result = Result + pas.System.Copy(FormatStr,APos,Len);
    };
    function StoreString(AStr) {
      Result = Result + AStr;
    };
    function StoreInt(Value, Digits) {
      var S = "";
      S = $mod.IntToStr(Value);
      while (S.length < Digits) S = "0" + S;
      StoreString(S);
    };
    var Year = 0;
    var Month = 0;
    var Day = 0;
    var DayOfWeek = 0;
    var Hour = 0;
    var Minute = 0;
    var Second = 0;
    var MilliSecond = 0;
    function StoreFormat(FormatStr, Nesting, TimeFlag) {
      var Token = "";
      var lastformattoken = "";
      var prevlasttoken = "";
      var Count = 0;
      var Clock12 = false;
      var tmp = 0;
      var isInterval = false;
      var P = 0;
      var FormatCurrent = 0;
      var FormatEnd = 0;
      if (Nesting > 1) return;
      FormatCurrent = 1;
      FormatEnd = FormatStr.length;
      Clock12 = false;
      isInterval = false;
      P = 1;
      while (P <= FormatEnd) {
        Token = FormatStr.charAt(P - 1);
        var $tmp1 = Token;
        if (($tmp1 === "'") || ($tmp1 === '"')) {
          P += 1;
          while ((P < FormatEnd) && (FormatStr.charAt(P - 1) !== Token)) P += 1;
        } else if (($tmp1 === "A") || ($tmp1 === "a")) {
          if ((($mod.CompareText(pas.System.Copy(FormatStr,P,3),"A\/P") === 0) || ($mod.CompareText(pas.System.Copy(FormatStr,P,4),"AMPM") === 0)) || ($mod.CompareText(pas.System.Copy(FormatStr,P,5),"AM\/PM") === 0)) {
            Clock12 = true;
            break;
          };
        };
        P += 1;
      };
      Token = "ÿ";
      lastformattoken = " ";
      prevlasttoken = "H";
      while (FormatCurrent <= FormatEnd) {
        Token = $mod.UpperCase(FormatStr.charAt(FormatCurrent - 1)).charAt(0);
        Count = 1;
        P = FormatCurrent + 1;
        var $tmp2 = Token;
        if (($tmp2 === "'") || ($tmp2 === '"')) {
          while ((P < FormatEnd) && (FormatStr.charAt(P - 1) !== Token)) P += 1;
          P += 1;
          Count = P - FormatCurrent;
          StoreStr(FormatCurrent + 1,Count - 2);
        } else if ($tmp2 === "A") {
          if ($mod.CompareText(pas.System.Copy(FormatStr,FormatCurrent,4),"AMPM") === 0) {
            Count = 4;
            if (Hour < 12) {
              StoreString($mod.TimeAMString)}
             else StoreString($mod.TimePMString);
          } else if ($mod.CompareText(pas.System.Copy(FormatStr,FormatCurrent,5),"AM\/PM") === 0) {
            Count = 5;
            if (Hour < 12) {
              StoreStr(FormatCurrent,2)}
             else StoreStr(FormatCurrent + 3,2);
          } else if ($mod.CompareText(pas.System.Copy(FormatStr,FormatCurrent,3),"A\/P") === 0) {
            Count = 3;
            if (Hour < 12) {
              StoreStr(FormatCurrent,1)}
             else StoreStr(FormatCurrent + 2,1);
          } else throw $mod.EConvertError.$create("Create$1",["Illegal character in format string"]);
        } else if ($tmp2 === "\/") {
          StoreString($mod.DateSeparator);
        } else if ($tmp2 === ":") {
          StoreString($mod.TimeSeparator)}
         else if ((((((((((($tmp2 === " ") || ($tmp2 === "C")) || ($tmp2 === "D")) || ($tmp2 === "H")) || ($tmp2 === "M")) || ($tmp2 === "N")) || ($tmp2 === "S")) || ($tmp2 === "T")) || ($tmp2 === "Y")) || ($tmp2 === "Z")) || ($tmp2 === "F")) {
          while ((P <= FormatEnd) && ($mod.UpperCase(FormatStr.charAt(P - 1)) === Token)) P += 1;
          Count = P - FormatCurrent;
          var $tmp3 = Token;
          if ($tmp3 === " ") {
            StoreStr(FormatCurrent,Count)}
           else if ($tmp3 === "Y") {
            if (Count > 2) {
              StoreInt(Year,4)}
             else StoreInt(Year % 100,2);
          } else if ($tmp3 === "M") {
            if (isInterval && ((prevlasttoken === "H") || TimeFlag)) {
              StoreInt(Minute + ((Hour + (pas.System.Trunc(Math.abs(DateTime)) * 24)) * 60),0)}
             else if ((lastformattoken === "H") || TimeFlag) {
              if (Count === 1) {
                StoreInt(Minute,0)}
               else StoreInt(Minute,2);
            } else {
              var $tmp4 = Count;
              if ($tmp4 === 1) {
                StoreInt(Month,0)}
               else if ($tmp4 === 2) {
                StoreInt(Month,2)}
               else if ($tmp4 === 3) {
                StoreString($mod.ShortMonthNames[Month - 1])}
               else {
                StoreString($mod.LongMonthNames[Month - 1]);
              };
            };
          } else if ($tmp3 === "D") {
            var $tmp5 = Count;
            if ($tmp5 === 1) {
              StoreInt(Day,0)}
             else if ($tmp5 === 2) {
              StoreInt(Day,2)}
             else if ($tmp5 === 3) {
              StoreString($mod.ShortDayNames[DayOfWeek])}
             else if ($tmp5 === 4) {
              StoreString($mod.LongDayNames[DayOfWeek])}
             else if ($tmp5 === 5) {
              StoreFormat($mod.ShortDateFormat,Nesting + 1,false)}
             else {
              StoreFormat($mod.LongDateFormat,Nesting + 1,false);
            };
          } else if ($tmp3 === "H") {
            if (isInterval) {
              StoreInt(Hour + (pas.System.Trunc(Math.abs(DateTime)) * 24),0)}
             else if (Clock12) {
              tmp = Hour % 12;
              if (tmp === 0) tmp = 12;
              if (Count === 1) {
                StoreInt(tmp,0)}
               else StoreInt(tmp,2);
            } else {
              if (Count === 1) {
                StoreInt(Hour,0)}
               else StoreInt(Hour,2);
            }}
           else if ($tmp3 === "N") {
            if (isInterval) {
              StoreInt(Minute + ((Hour + (pas.System.Trunc(Math.abs(DateTime)) * 24)) * 60),0)}
             else if (Count === 1) {
              StoreInt(Minute,0)}
             else StoreInt(Minute,2)}
           else if ($tmp3 === "S") {
            if (isInterval) {
              StoreInt(Second + ((Minute + ((Hour + (pas.System.Trunc(Math.abs(DateTime)) * 24)) * 60)) * 60),0)}
             else if (Count === 1) {
              StoreInt(Second,0)}
             else StoreInt(Second,2)}
           else if ($tmp3 === "Z") {
            if (Count === 1) {
              StoreInt(MilliSecond,0)}
             else StoreInt(MilliSecond,3)}
           else if ($tmp3 === "T") {
            if (Count === 1) {
              StoreFormat($mod.ShortTimeFormat,Nesting + 1,true)}
             else StoreFormat($mod.LongTimeFormat,Nesting + 1,true)}
           else if ($tmp3 === "C") {
            StoreFormat($mod.ShortDateFormat,Nesting + 1,false);
            if (((Hour !== 0) || (Minute !== 0)) || (Second !== 0)) {
              StoreString(" ");
              StoreFormat($mod.LongTimeFormat,Nesting + 1,true);
            };
          } else if ($tmp3 === "F") {
            StoreFormat($mod.ShortDateFormat,Nesting + 1,false);
            StoreString(" ");
            StoreFormat($mod.LongTimeFormat,Nesting + 1,true);
          };
          prevlasttoken = lastformattoken;
          lastformattoken = Token;
        } else {
          StoreString(Token);
        };
        FormatCurrent += Count;
      };
    };
    $mod.DecodeDateFully(DateTime,{get: function () {
        return Year;
      }, set: function (v) {
        Year = v;
      }},{get: function () {
        return Month;
      }, set: function (v) {
        Month = v;
      }},{get: function () {
        return Day;
      }, set: function (v) {
        Day = v;
      }},{get: function () {
        return DayOfWeek;
      }, set: function (v) {
        DayOfWeek = v;
      }});
    $mod.DecodeTime(DateTime,{get: function () {
        return Hour;
      }, set: function (v) {
        Hour = v;
      }},{get: function () {
        return Minute;
      }, set: function (v) {
        Minute = v;
      }},{get: function () {
        return Second;
      }, set: function (v) {
        Second = v;
      }},{get: function () {
        return MilliSecond;
      }, set: function (v) {
        MilliSecond = v;
      }});
    if (FormatStr !== "") {
      StoreFormat(FormatStr,0,false)}
     else StoreFormat("C",0,false);
    return Result;
  };
  this.TryStrToDate = function (S, Value) {
    var Result = false;
    Result = $mod.TryStrToDate$2(S,Value,$mod.ShortDateFormat,"\x00");
    return Result;
  };
  this.TryStrToDate$1 = function (S, Value, separator) {
    var Result = false;
    Result = $mod.TryStrToDate$2(S,Value,$mod.ShortDateFormat,separator);
    return Result;
  };
  this.TryStrToDate$2 = function (S, Value, useformat, separator) {
    var Result = false;
    var Msg = "";
    Result = S.length !== 0;
    if (Result) {
      Value.set($impl.IntStrToDate({get: function () {
          return Msg;
        }, set: function (v) {
          Msg = v;
        }},S,useformat,separator));
      Result = Msg === "";
    };
    return Result;
  };
  this.TryStrToTime = function (S, Value) {
    var Result = false;
    Result = $mod.TryStrToTime$1(S,Value,"\x00");
    return Result;
  };
  this.TryStrToTime$1 = function (S, Value, separator) {
    var Result = false;
    var Msg = "";
    Result = S.length !== 0;
    if (Result) {
      Value.set($impl.IntStrToTime({get: function () {
          return Msg;
        }, set: function (v) {
          Msg = v;
        }},S,S.length,separator));
      Result = Msg === "";
    };
    return Result;
  };
  this.TryStrToDateTime = function (S, Value) {
    var Result = false;
    var I = 0;
    var dtdate = 0.0;
    var dttime = 0.0;
    Result = false;
    I = pas.System.Pos($mod.TimeSeparator,S);
    if (I > 0) {
      while ((I > 0) && (S.charAt(I - 1) !== " ")) I -= 1;
      if (I > 0) {
        if (!$mod.TryStrToDate(pas.System.Copy(S,1,I - 1),{get: function () {
            return dtdate;
          }, set: function (v) {
            dtdate = v;
          }})) return Result;
        if (!$mod.TryStrToTime(pas.System.Copy(S,I + 1,S.length - I),{get: function () {
            return dttime;
          }, set: function (v) {
            dttime = v;
          }})) return Result;
        Value.set($mod.ComposeDateTime(dtdate,dttime));
        Result = true;
      } else Result = $mod.TryStrToTime(S,Value);
    } else Result = $mod.TryStrToDate(S,Value);
    return Result;
  };
  this.StrToDateDef = function (S, Defvalue) {
    var Result = 0.0;
    Result = $mod.StrToDateDef$1(S,Defvalue,"\x00");
    return Result;
  };
  this.StrToDateDef$1 = function (S, Defvalue, separator) {
    var Result = 0.0;
    if (!$mod.TryStrToDate$1(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},separator)) Result = Defvalue;
    return Result;
  };
  this.StrToTimeDef = function (S, Defvalue) {
    var Result = 0.0;
    Result = $mod.StrToTimeDef$1(S,Defvalue,"\x00");
    return Result;
  };
  this.StrToTimeDef$1 = function (S, Defvalue, separator) {
    var Result = 0.0;
    if (!$mod.TryStrToTime$1(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},separator)) Result = Defvalue;
    return Result;
  };
  this.StrToDateTimeDef = function (S, Defvalue) {
    var Result = 0.0;
    if (!$mod.TryStrToDateTime(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = Defvalue;
    return Result;
  };
  this.CurrentYear = function () {
    var Result = 0;
    Result = (new Date()).getFullYear();
    return Result;
  };
  this.ReplaceTime = function (dati, NewTime) {
    dati.set($mod.ComposeDateTime(dati.get(),NewTime));
  };
  this.ReplaceDate = function (DateTime, NewDate) {
    var tmp = 0.0;
    tmp = NewDate;
    $mod.ReplaceTime({get: function () {
        return tmp;
      }, set: function (v) {
        tmp = v;
      }},DateTime.get());
    DateTime.set(tmp);
  };
  this.FloatToDateTime = function (Value) {
    var Result = 0.0;
    if ((Value < $mod.MinDateTime) || (Value > $mod.MaxDateTime)) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SInvalidDateTime,[$mod.FloatToStr(Value)]]);
    Result = Value;
    return Result;
  };
  this.CurrencyFormat = 0;
  this.NegCurrFormat = 0;
  this.CurrencyDecimals = 2;
  this.CurrencyString = "$";
  this.FloattoCurr = function (Value) {
    var Result = 0;
    if (!$mod.TryFloatToCurr(Value,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SInvalidCurrency,[$mod.FloatToStr(Value)]]);
    return Result;
  };
  this.TryFloatToCurr = function (Value, AResult) {
    var Result = false;
    Result = ((Value * 10000) >= $mod.MinCurrency) && ((Value * 10000) <= $mod.MaxCurrency);
    if (Result) AResult.set(Math.floor(Value * 10000));
    return Result;
  };
  this.CurrToStr = function (Value) {
    var Result = "";
    Result = $mod.FloatToStrF(Value / 10000,$mod.TFloatFormat.ffGeneral,-1,0);
    return Result;
  };
  this.StrToCurr = function (S) {
    var Result = 0;
    if (!$mod.TryStrToCurr(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SInvalidCurrency,[S]]);
    return Result;
  };
  this.TryStrToCurr = function (S, Value) {
    var Result = false;
    var D = 0.0;
    Result = $mod.TryStrToFloat(S,{get: function () {
        return D;
      }, set: function (v) {
        D = v;
      }});
    if (Result) Value.set(Math.floor(D * 10000));
    return Result;
  };
  this.StrToCurrDef = function (S, Default) {
    var Result = 0;
    var R = 0;
    if ($mod.TryStrToCurr(S,{get: function () {
        return R;
      }, set: function (v) {
        R = v;
      }})) {
      Result = R}
     else Result = Default;
    return Result;
  };
  this.GUID_NULL = new pas.System.TGuid({D1: 0x00000000, D2: 0x0000, D3: 0x0000, D4: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]});
  this.Supports = function (Instance, AClass, Obj) {
    var Result = false;
    Result = ((Instance !== null) && (Instance.QueryInterface(pas.System.IObjectInstance,Obj) === 0)) && Obj.get().$class.InheritsFrom(AClass);
    return Result;
  };
  this.Supports$1 = function (Instance, IID, Intf) {
    var Result = false;
    Result = (Instance !== null) && (Instance.QueryInterface(IID,Intf) === 0);
    return Result;
  };
  this.Supports$2 = function (Instance, IID, Intf) {
    var Result = false;
    Result = (Instance !== null) && Instance.GetInterface(IID,Intf);
    return Result;
  };
  this.Supports$3 = function (Instance, IID, Intf) {
    var Result = false;
    Result = (Instance !== null) && Instance.GetInterfaceByStr(IID,Intf);
    return Result;
  };
  this.Supports$4 = function (Instance, AClass) {
    var Result = false;
    var Temp = null;
    Result = $mod.Supports(Instance,AClass,{get: function () {
        return Temp;
      }, set: function (v) {
        Temp = v;
      }});
    return Result;
  };
  this.Supports$5 = function (Instance, IID) {
    var Result = false;
    var Temp = null;
    try {
      Result = $mod.Supports$1(Instance,IID,{get: function () {
          return Temp;
        }, set: function (v) {
          Temp = v;
        }});
    } finally {
      rtl._Release(Temp);
    };
    return Result;
  };
  this.Supports$6 = function (Instance, IID) {
    var Result = false;
    var Temp = null;
    Result = $mod.Supports$2(Instance,IID,{get: function () {
        return Temp;
      }, set: function (v) {
        Temp = v;
      }});
    if (Temp && Temp.$kind==='com') Temp._Release();
    return Result;
  };
  this.Supports$7 = function (Instance, IID) {
    var Result = false;
    var Temp = null;
    Result = $mod.Supports$3(Instance,IID,{get: function () {
        return Temp;
      }, set: function (v) {
        Temp = v;
      }});
    if (Temp && Temp.$kind==='com') Temp._Release();
    return Result;
  };
  this.Supports$8 = function (AClass, IID) {
    var Result = false;
    var maps = undefined;
    if (AClass === null) return false;
    maps = AClass["$intfmaps"];
    if (!maps) return false;
    if (rtl.getObject(maps)[$mod.GUIDToString(IID)]) return true;
    Result = false;
    return Result;
  };
  this.Supports$9 = function (AClass, IID) {
    var Result = false;
    var maps = undefined;
    if (AClass === null) return false;
    maps = AClass["$intfmaps"];
    if (!maps) return false;
    if (rtl.getObject(maps)[$mod.UpperCase(IID)]) return true;
    Result = false;
    return Result;
  };
  this.TryStringToGUID = function (s, Guid) {
    var Result = false;
    var re = null;
    if (s.length !== 38) return false;
    re = new RegExp("^\\{[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\\}$");
    Result = re.test(s);
    if (!Result) {
      Guid.get().D1 = 0;
      return Result;
    };
    rtl.strToGUIDR(s,Guid.get());
    Result = true;
    return Result;
  };
  this.StringToGUID = function (S) {
    var Result = new pas.System.TGuid();
    if (!$mod.TryStringToGUID(S,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SInvalidGUID,[S]]);
    return Result;
  };
  this.GUIDToString = function (guid) {
    var Result = "";
    Result = rtl.guidrToStr(guid);
    return Result;
  };
  this.IsEqualGUID = function (guid1, guid2) {
    var Result = false;
    var i = 0;
    if (((guid1.D1 !== guid2.D1) || (guid1.D2 !== guid2.D2)) || (guid1.D3 !== guid2.D3)) return false;
    for (i = 0; i <= 7; i++) if (guid1.D4[i] !== guid2.D4[i]) return false;
    Result = true;
    return Result;
  };
  this.GuidCase = function (guid, List) {
    var Result = 0;
    for (var $l1 = rtl.length(List) - 1; $l1 >= 0; $l1--) {
      Result = $l1;
      if ($mod.IsEqualGUID(guid,List[Result])) return Result;
    };
    Result = -1;
    return Result;
  };
  $mod.$init = function () {
    $mod.FormatSettings = $mod.TFormatSettings.$create("Create");
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.SAbortError = "Operation aborted";
  $impl.CheckBoolStrs = function () {
    if (rtl.length($mod.TrueBoolStrs) === 0) {
      $mod.TrueBoolStrs = rtl.arraySetLength($mod.TrueBoolStrs,"",1);
      $mod.TrueBoolStrs[0] = "True";
    };
    if (rtl.length($mod.FalseBoolStrs) === 0) {
      $mod.FalseBoolStrs = rtl.arraySetLength($mod.FalseBoolStrs,"",1);
      $mod.FalseBoolStrs[0] = "False";
    };
  };
  $impl.feInvalidFormat = 1;
  $impl.feMissingArgument = 2;
  $impl.feInvalidArgIndex = 3;
  $impl.DoFormatError = function (ErrCode, fmt) {
    var $tmp1 = ErrCode;
    if ($tmp1 === 1) {
      throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SInvalidFormat,[fmt]])}
     else if ($tmp1 === 2) {
      throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SArgumentMissing,[fmt]])}
     else if ($tmp1 === 3) throw $mod.EConvertError.$create("CreateFmt",[pas.RTLConsts.SInvalidArgIndex,[fmt]]);
  };
  $impl.maxdigits = 15;
  $impl.ReplaceDecimalSep = function (S, DS) {
    var Result = "";
    var P = 0;
    P = pas.System.Pos(".",S);
    if (P > 0) {
      Result = (pas.System.Copy(S,1,P - 1) + DS) + pas.System.Copy(S,P + 1,S.length - P)}
     else Result = S;
    return Result;
  };
  $impl.FormatGeneralFloat = function (Value, Precision, DS) {
    var Result = "";
    var P = 0;
    var PE = 0;
    var Q = 0;
    var Exponent = 0;
    if ((Precision === -1) || (Precision > 15)) Precision = 15;
    Result = rtl.floatToStr(Value,Precision + 7);
    Result = $mod.TrimLeft(Result);
    P = pas.System.Pos(".",Result);
    if (P === 0) return Result;
    PE = pas.System.Pos("E",Result);
    if (PE === 0) {
      Result = $impl.ReplaceDecimalSep(Result,DS);
      return Result;
    };
    Q = PE + 2;
    Exponent = 0;
    while (Q <= Result.length) {
      Exponent = ((Exponent * 10) + Result.charCodeAt(Q - 1)) - "0".charCodeAt();
      Q += 1;
    };
    if (Result.charAt((PE + 1) - 1) === "-") Exponent = -Exponent;
    if (((P + Exponent) < PE) && (Exponent > -6)) {
      Result = rtl.strSetLength(Result,PE - 1);
      if (Exponent >= 0) {
        for (var $l1 = 0, $end2 = Exponent - 1; $l1 <= $end2; $l1++) {
          Q = $l1;
          Result = rtl.setCharAt(Result,P - 1,Result.charAt((P + 1) - 1));
          P += 1;
        };
        Result = rtl.setCharAt(Result,P - 1,".");
        P = 1;
        if (Result.charAt(P - 1) === "-") P += 1;
        while (((Result.charAt(P - 1) === "0") && (P < Result.length)) && (pas.System.Copy(Result,P + 1,DS.length) !== DS)) pas.System.Delete({get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},P,1);
      } else {
        pas.System.Insert(pas.System.Copy("00000",1,-Exponent),{get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},P - 1);
        Result = rtl.setCharAt(Result,(P - Exponent) - 1,Result.charAt(((P - Exponent) - 1) - 1));
        Result = rtl.setCharAt(Result,P - 1,".");
        if (Exponent !== -1) Result = rtl.setCharAt(Result,((P - Exponent) - 1) - 1,"0");
      };
      Q = Result.length;
      while ((Q > 0) && (Result.charAt(Q - 1) === "0")) Q -= 1;
      if (Result.charAt(Q - 1) === ".") Q -= 1;
      if ((Q === 0) || ((Q === 1) && (Result.charAt(0) === "-"))) {
        Result = "0"}
       else Result = rtl.strSetLength(Result,Q);
    } else {
      while (Result.charAt((PE - 1) - 1) === "0") {
        pas.System.Delete({get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},PE - 1,1);
        PE -= 1;
      };
      if (Result.charAt((PE - 1) - 1) === DS) {
        pas.System.Delete({get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},PE - 1,1);
        PE -= 1;
      };
      if (Result.charAt((PE + 1) - 1) === "+") {
        pas.System.Delete({get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},PE + 1,1)}
       else PE += 1;
      while (Result.charAt((PE + 1) - 1) === "0") pas.System.Delete({get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }},PE + 1,1);
    };
    Result = $impl.ReplaceDecimalSep(Result,DS);
    return Result;
  };
  $impl.FormatExponentFloat = function (Value, Precision, Digits, DS) {
    var Result = "";
    var P = 0;
    DS = $mod.DecimalSeparator;
    if ((Precision === -1) || (Precision > 15)) Precision = 15;
    Result = rtl.floatToStr(Value,Precision + 7);
    while (Result.charAt(0) === " ") pas.System.Delete({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},1,1);
    P = pas.System.Pos("E",Result);
    if (P === 0) {
      Result = $impl.ReplaceDecimalSep(Result,DS);
      return Result;
    };
    P += 2;
    if (Digits > 4) Digits = 4;
    Digits = ((Result.length - P) - Digits) + 1;
    if (Digits < 0) {
      pas.System.Insert(pas.System.Copy("0000",1,-Digits),{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }},P)}
     else while ((Digits > 0) && (Result.charAt(P - 1) === "0")) {
      pas.System.Delete({get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }},P,1);
      if (P > Result.length) {
        pas.System.Delete({get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},P - 2,2);
        break;
      };
      Digits -= 1;
    };
    Result = $impl.ReplaceDecimalSep(Result,DS);
    return Result;
  };
  $impl.FormatFixedFloat = function (Value, Digits, DS) {
    var Result = "";
    if (Digits === -1) {
      Digits = 2}
     else if (Digits > 18) Digits = 18;
    Result = rtl.floatToStr(Value,0,Digits);
    if ((Result !== "") && (Result.charAt(0) === " ")) pas.System.Delete({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},1,1);
    Result = $impl.ReplaceDecimalSep(Result,DS);
    return Result;
  };
  $impl.FormatNumberFloat = function (Value, Digits, DS, TS) {
    var Result = "";
    var P = 0;
    if (Digits === -1) {
      Digits = 2}
     else if (Digits > 15) Digits = 15;
    Result = rtl.floatToStr(Value,0,Digits);
    if ((Result !== "") && (Result.charAt(0) === " ")) pas.System.Delete({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},1,1);
    P = pas.System.Pos(".",Result);
    Result = $impl.ReplaceDecimalSep(Result,DS);
    P -= 3;
    if ((TS !== "") && (TS !== "\x00")) while (P > 1) {
      if (Result.charAt((P - 1) - 1) !== "-") pas.System.Insert(TS,{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }},P);
      P -= 3;
    };
    return Result;
  };
  $impl.RemoveLeadingNegativeSign = function (AValue, DS) {
    var Result = false;
    var i = 0;
    var TS = "";
    var StartPos = 0;
    Result = false;
    StartPos = 2;
    TS = $mod.ThousandSeparator;
    for (var $l1 = StartPos, $end2 = AValue.get().length; $l1 <= $end2; $l1++) {
      i = $l1;
      Result = (AValue.get().charCodeAt(i - 1) in rtl.createSet(48,DS.charCodeAt(),69,43)) || (AValue.get().charAt(i - 1) === TS);
      if (!Result) break;
    };
    if (Result && (AValue.get().charAt(0) === "-")) pas.System.Delete(AValue,1,1);
    return Result;
  };
  $impl.FormatNumberCurrency = function (Value, Digits, DS, TS) {
    var Result = "";
    var Negative = false;
    var P = 0;
    if (Digits === -1) {
      Digits = $mod.CurrencyDecimals}
     else if (Digits > 18) Digits = 18;
    Result = rtl.floatToStr(Value / 10000,0,Digits);
    Negative = Result.charAt(0) === "-";
    if (Negative) pas.System.Delete({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},1,1);
    P = pas.System.Pos(".",Result);
    if (TS !== "") {
      if (P !== 0) {
        Result = $impl.ReplaceDecimalSep(Result,DS)}
       else P = Result.length + 1;
      P -= 3;
      while (P > 1) {
        pas.System.Insert(TS,{get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},P);
        P -= 3;
      };
    };
    if (Negative) $impl.RemoveLeadingNegativeSign({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},DS);
    if (!Negative) {
      var $tmp1 = $mod.CurrencyFormat;
      if ($tmp1 === 0) {
        Result = $mod.CurrencyString + Result}
       else if ($tmp1 === 1) {
        Result = Result + $mod.CurrencyString}
       else if ($tmp1 === 2) {
        Result = ($mod.CurrencyString + " ") + Result}
       else if ($tmp1 === 3) Result = (Result + " ") + $mod.CurrencyString;
    } else {
      var $tmp2 = $mod.NegCurrFormat;
      if ($tmp2 === 0) {
        Result = (("(" + $mod.CurrencyString) + Result) + ")"}
       else if ($tmp2 === 1) {
        Result = ("-" + $mod.CurrencyString) + Result}
       else if ($tmp2 === 2) {
        Result = ($mod.CurrencyString + "-") + Result}
       else if ($tmp2 === 3) {
        Result = ($mod.CurrencyString + Result) + "-"}
       else if ($tmp2 === 4) {
        Result = (("(" + Result) + $mod.CurrencyString) + ")"}
       else if ($tmp2 === 5) {
        Result = ("-" + Result) + $mod.CurrencyString}
       else if ($tmp2 === 6) {
        Result = (Result + "-") + $mod.CurrencyString}
       else if ($tmp2 === 7) {
        Result = (Result + $mod.CurrencyString) + "-"}
       else if ($tmp2 === 8) {
        Result = (("-" + Result) + " ") + $mod.CurrencyString}
       else if ($tmp2 === 9) {
        Result = (("-" + $mod.CurrencyString) + " ") + Result}
       else if ($tmp2 === 10) {
        Result = ((Result + " ") + $mod.CurrencyString) + "-"}
       else if ($tmp2 === 11) {
        Result = (($mod.CurrencyString + " ") + Result) + "-"}
       else if ($tmp2 === 12) {
        Result = (($mod.CurrencyString + " ") + "-") + Result}
       else if ($tmp2 === 13) {
        Result = ((Result + "-") + " ") + $mod.CurrencyString}
       else if ($tmp2 === 14) {
        Result = ((("(" + $mod.CurrencyString) + " ") + Result) + ")"}
       else if ($tmp2 === 15) Result = ((("(" + Result) + " ") + $mod.CurrencyString) + ")";
    };
    return Result;
  };
  $impl.RESpecials = "([\\[\\]\\(\\)\\\\\\.\\*])";
  $impl.DoEncodeDate = function (Year, Month, Day) {
    var Result = 0;
    var D = 0.0;
    if ($mod.TryEncodeDate(Year,Month,Day,{get: function () {
        return D;
      }, set: function (v) {
        D = v;
      }})) {
      Result = pas.System.Trunc(D)}
     else Result = 0;
    return Result;
  };
  $impl.DoEncodeTime = function (Hour, Minute, Second, MilliSecond) {
    var Result = 0.0;
    if (!$mod.TryEncodeTime(Hour,Minute,Second,MilliSecond,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) Result = 0;
    return Result;
  };
  $impl.DateTimeToStrFormat = ["c","f"];
  var WhiteSpace = " \b\t\n\f\r";
  var Digits = "0123456789";
  $impl.IntStrToDate = function (ErrorMsg, S, useformat, separator) {
    var Result = 0.0;
    function FixErrorMsg(errmarg) {
      ErrorMsg.set($mod.Format(pas.RTLConsts.SInvalidDateFormat,[errmarg]));
    };
    var df = "";
    var d = 0;
    var m = 0;
    var y = 0;
    var ly = 0;
    var ld = 0;
    var lm = 0;
    var n = 0;
    var i = 0;
    var len = 0;
    var c = 0;
    var dp = 0;
    var mp = 0;
    var yp = 0;
    var which = 0;
    var s1 = "";
    var values = [];
    var YearMoreThenTwoDigits = false;
    values = rtl.arraySetLength(values,0,4);
    Result = 0;
    len = S.length;
    ErrorMsg.set("");
    while ((len > 0) && (pas.System.Pos(S.charAt(len - 1),WhiteSpace) > 0)) len -= 1;
    if (len === 0) {
      FixErrorMsg(S);
      return Result;
    };
    YearMoreThenTwoDigits = false;
    if (separator === "\x00") if ($mod.DateSeparator !== "\x00") {
      separator = $mod.DateSeparator}
     else separator = "-";
    df = $mod.UpperCase(useformat);
    yp = 0;
    mp = 0;
    dp = 0;
    which = 0;
    i = 0;
    while ((i < df.length) && (which < 3)) {
      i += 1;
      var $tmp1 = df.charAt(i - 1);
      if ($tmp1 === "Y") {
        if (yp === 0) {
          which += 1;
          yp = which;
        }}
       else if ($tmp1 === "M") {
        if (mp === 0) {
          which += 1;
          mp = which;
        }}
       else if ($tmp1 === "D") if (dp === 0) {
        which += 1;
        dp = which;
      };
    };
    for (i = 1; i <= 3; i++) values[i] = 0;
    s1 = "";
    n = 0;
    for (var $l2 = 1, $end3 = len; $l2 <= $end3; $l2++) {
      i = $l2;
      if (pas.System.Pos(S.charAt(i - 1),Digits) > 0) s1 = s1 + S.charAt(i - 1);
      if ((separator !== " ") && (S.charAt(i - 1) === " ")) continue;
      if ((S.charAt(i - 1) === separator) || ((i === len) && (pas.System.Pos(S.charAt(i - 1),Digits) > 0))) {
        n += 1;
        if (n > 3) {
          FixErrorMsg(S);
          return Result;
        };
        if ((n === yp) && (s1.length > 2)) YearMoreThenTwoDigits = true;
        pas.System.val$6(s1,{a: n, p: values, get: function () {
            return this.p[this.a];
          }, set: function (v) {
            this.p[this.a] = v;
          }},{get: function () {
            return c;
          }, set: function (v) {
            c = v;
          }});
        if (c !== 0) {
          FixErrorMsg(S);
          return Result;
        };
        s1 = "";
      } else if (pas.System.Pos(S.charAt(i - 1),Digits) === 0) {
        FixErrorMsg(S);
        return Result;
      };
    };
    if ((which < 3) && (n > which)) {
      FixErrorMsg(S);
      return Result;
    };
    $mod.DecodeDate($mod.Date(),{get: function () {
        return ly;
      }, set: function (v) {
        ly = v;
      }},{get: function () {
        return lm;
      }, set: function (v) {
        lm = v;
      }},{get: function () {
        return ld;
      }, set: function (v) {
        ld = v;
      }});
    if (n === 3) {
      y = values[yp];
      m = values[mp];
      d = values[dp];
    } else {
      y = ly;
      if (n < 2) {
        d = values[1];
        m = lm;
      } else if (dp < mp) {
        d = values[1];
        m = values[2];
      } else {
        d = values[2];
        m = values[1];
      };
    };
    if (((y >= 0) && (y < 100)) && !YearMoreThenTwoDigits) {
      ly = ly - $mod.TwoDigitYearCenturyWindow;
      y += Math.floor(ly / 100) * 100;
      if (($mod.TwoDigitYearCenturyWindow > 0) && (y < ly)) y += 100;
    };
    if (!$mod.TryEncodeDate(y,m,d,{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) ErrorMsg.set(pas.RTLConsts.SErrInvalidDate);
    return Result;
  };
  var AMPM_None = 0;
  var AMPM_AM = 1;
  var AMPM_PM = 2;
  var tiHour = 0;
  var tiMin = 1;
  var tiSec = 2;
  var tiMSec = 3;
  var Digits$1 = "0123456789";
  $impl.IntStrToTime = function (ErrorMsg, S, Len, separator) {
    var Result = 0.0;
    var AmPm = 0;
    var TimeValues = [];
    function SplitElements(TimeValues, AmPm) {
      var Result = false;
      var Cur = 0;
      var Offset = 0;
      var ElemLen = 0;
      var Err = 0;
      var TimeIndex = 0;
      var FirstSignificantDigit = 0;
      var Value = 0;
      var DigitPending = false;
      var MSecPending = false;
      var AmPmStr = "";
      var CurChar = "";
      var I = 0;
      var allowedchars = "";
      Result = false;
      AmPm.set(0);
      MSecPending = false;
      TimeIndex = 0;
      for (I = 0; I <= 3; I++) TimeValues.get()[I] = 0;
      Cur = 1;
      while ((Cur < Len) && (S.charAt(Cur - 1) === " ")) Cur += 1;
      Offset = Cur;
      if (((Cur > (Len - 1)) || (S.charAt(Cur - 1) === separator)) || (S.charAt(Cur - 1) === $mod.DecimalSeparator)) {
        return Result;
      };
      DigitPending = pas.System.Pos(S.charAt(Cur - 1),Digits$1) > 0;
      while (Cur <= Len) {
        CurChar = S.charAt(Cur - 1);
        if (pas.System.Pos(CurChar,Digits$1) > 0) {
          if (!DigitPending || (TimeIndex > 3)) {
            return Result;
          };
          Offset = Cur;
          if (CurChar !== "0") {
            FirstSignificantDigit = Offset}
           else FirstSignificantDigit = -1;
          while ((Cur < Len) && (pas.System.Pos(S.charAt((Cur + 1) - 1),Digits$1) > 0)) {
            if ((FirstSignificantDigit === -1) && (S.charAt(Cur - 1) !== "0")) FirstSignificantDigit = Cur;
            Cur += 1;
          };
          if (FirstSignificantDigit === -1) FirstSignificantDigit = Cur;
          ElemLen = (1 + Cur) - FirstSignificantDigit;
          if ((ElemLen <= 2) || ((ElemLen <= 3) && (TimeIndex === 3))) {
            pas.System.val$6(pas.System.Copy(S,FirstSignificantDigit,ElemLen),{get: function () {
                return Value;
              }, set: function (v) {
                Value = v;
              }},{get: function () {
                return Err;
              }, set: function (v) {
                Err = v;
              }});
            TimeValues.get()[TimeIndex] = Value;
            TimeIndex += 1;
            DigitPending = false;
          } else {
            return Result;
          };
        } else if (CurChar === " ") {}
        else if (CurChar === separator) {
          if (DigitPending || (TimeIndex > 2)) {
            return Result;
          };
          DigitPending = true;
          MSecPending = false;
        } else if (CurChar === $mod.DecimalSeparator) {
          if ((DigitPending || MSecPending) || (TimeIndex !== 3)) {
            return Result;
          };
          DigitPending = true;
          MSecPending = true;
        } else {
          if ((AmPm.get() !== 0) || DigitPending) {
            return Result;
          };
          Offset = Cur;
          allowedchars = $mod.DecimalSeparator + " ";
          if (separator !== "\x00") allowedchars = allowedchars + separator;
          while (((Cur < (Len - 1)) && (pas.System.Pos(S.charAt((Cur + 1) - 1),allowedchars) === 0)) && (pas.System.Pos(S.charAt((Cur + 1) - 1),Digits$1) === 0)) Cur += 1;
          ElemLen = (1 + Cur) - Offset;
          AmPmStr = pas.System.Copy(S,1 + Offset,ElemLen);
          if ($mod.CompareText(AmPmStr,$mod.TimeAMString) === 0) {
            AmPm.set(1)}
           else if ($mod.CompareText(AmPmStr,$mod.TimePMString) === 0) {
            AmPm.set(2)}
           else if ($mod.CompareText(AmPmStr,"AM") === 0) {
            AmPm.set(1)}
           else if ($mod.CompareText(AmPmStr,"PM") === 0) {
            AmPm.set(2)}
           else {
            return Result;
          };
          if (TimeIndex === 0) {
            DigitPending = true;
          } else {
            TimeIndex = 3 + 1;
            DigitPending = false;
          };
        };
        Cur += 1;
      };
      if (((TimeIndex === 0) || ((AmPm.get() !== 0) && ((TimeValues.get()[0] > 12) || (TimeValues.get()[0] === 0)))) || DigitPending) return Result;
      Result = true;
      return Result;
    };
    TimeValues = rtl.arraySetLength(TimeValues,0,4);
    if (separator === "\x00") if ($mod.TimeSeparator !== "\x00") {
      separator = $mod.TimeSeparator}
     else separator = ":";
    AmPm = 0;
    if (!SplitElements({get: function () {
        return TimeValues;
      }, set: function (v) {
        TimeValues = v;
      }},{get: function () {
        return AmPm;
      }, set: function (v) {
        AmPm = v;
      }})) {
      ErrorMsg.set($mod.Format(pas.RTLConsts.SErrInvalidTimeFormat,[S]));
      return Result;
    };
    if ((AmPm === 2) && (TimeValues[0] !== 12)) {
      TimeValues[0] += 12}
     else if ((AmPm === 1) && (TimeValues[0] === 12)) TimeValues[0] = 0;
    if (!$mod.TryEncodeTime(TimeValues[0],TimeValues[1],TimeValues[2],TimeValues[3],{get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }})) ErrorMsg.set($mod.Format(pas.RTLConsts.SErrInvalidTimeFormat,[S]));
    return Result;
  };
  var WhiteSpace$1 = "\t\n\r ";
  $impl.SplitDateTimeStr = function (DateTimeStr, DateStr, TimeStr) {
    var Result = 0;
    var p = 0;
    var DummyDT = 0.0;
    Result = 0;
    DateStr.set("");
    TimeStr.set("");
    DateTimeStr = $mod.Trim(DateTimeStr);
    if (DateTimeStr.length === 0) return Result;
    if ((($mod.DateSeparator === " ") && ($mod.TimeSeparator === " ")) && (pas.System.Pos(" ",DateTimeStr) > 0)) {
      DateStr.set(DateTimeStr);
      return 1;
    };
    p = 1;
    if ($mod.DateSeparator !== " ") {
      while ((p < DateTimeStr.length) && !(pas.System.Pos(DateTimeStr.charAt((p + 1) - 1),WhiteSpace$1) > 0)) p += 1;
    } else {
      p = pas.System.Pos($mod.TimeSeparator,DateTimeStr);
      if (p !== 0) do {
        p -= 1;
      } while (!((p === 0) || (pas.System.Pos(DateTimeStr.charAt(p - 1),WhiteSpace$1) > 0)));
    };
    if (p === 0) p = DateTimeStr.length;
    DateStr.set(pas.System.Copy(DateTimeStr,1,p));
    TimeStr.set($mod.Trim(pas.System.Copy(DateTimeStr,p + 1,100)));
    if (TimeStr.get().length !== 0) {
      Result = 2}
     else {
      Result = 1;
      if ((($mod.DateSeparator !== $mod.TimeSeparator) && (pas.System.Pos($mod.TimeSeparator,DateStr.get()) > 0)) || (($mod.DateSeparator === $mod.TimeSeparator) && !$mod.TryStrToDate(DateStr.get(),{get: function () {
          return DummyDT;
        }, set: function (v) {
          DummyDT = v;
        }}))) {
        TimeStr.set(DateStr.get());
        DateStr.set("");
      };
    };
    return Result;
  };
});
rtl.module("Classes",["System","RTLConsts","Types","SysUtils"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $mod.$rtti.$MethodVar("TNotifyEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]]]), methodkind: 0});
  this.TFPObservedOperation = {"0": "ooChange", ooChange: 0, "1": "ooFree", ooFree: 1, "2": "ooAddItem", ooAddItem: 2, "3": "ooDeleteItem", ooDeleteItem: 3, "4": "ooCustom", ooCustom: 4};
  $mod.$rtti.$Enum("TFPObservedOperation",{minvalue: 0, maxvalue: 4, ordtype: 1, enumtype: this.TFPObservedOperation});
  rtl.createClass($mod,"EListError",pas.SysUtils.Exception,function () {
  });
  rtl.createClass($mod,"EStringListError",$mod.EListError,function () {
  });
  rtl.createClass($mod,"EComponentError",pas.SysUtils.Exception,function () {
  });
  this.TListAssignOp = {"0": "laCopy", laCopy: 0, "1": "laAnd", laAnd: 1, "2": "laOr", laOr: 2, "3": "laXor", laXor: 3, "4": "laSrcUnique", laSrcUnique: 4, "5": "laDestUnique", laDestUnique: 5};
  $mod.$rtti.$Enum("TListAssignOp",{minvalue: 0, maxvalue: 5, ordtype: 1, enumtype: this.TListAssignOp});
  $mod.$rtti.$ProcVar("TListSortCompare",{procsig: rtl.newTIProcSig([["Item1",rtl.jsvalue],["Item2",rtl.jsvalue]],rtl.longint)});
  this.TAlignment = {"0": "taLeftJustify", taLeftJustify: 0, "1": "taRightJustify", taRightJustify: 1, "2": "taCenter", taCenter: 2};
  $mod.$rtti.$Enum("TAlignment",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TAlignment});
  $mod.$rtti.$Class("TFPList");
  rtl.createClass($mod,"TFPListEnumerator",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FList = null;
      this.FPosition = 0;
    };
    this.$final = function () {
      this.FList = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function (AList) {
      pas.System.TObject.Create.call(this);
      this.FList = AList;
      this.FPosition = -1;
    };
    this.GetCurrent = function () {
      var Result = undefined;
      Result = this.FList.Get(this.FPosition);
      return Result;
    };
    this.MoveNext = function () {
      var Result = false;
      this.FPosition += 1;
      Result = this.FPosition < this.FList.FCount;
      return Result;
    };
  });
  rtl.createClass($mod,"TFPList",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FList = [];
      this.FCount = 0;
      this.FCapacity = 0;
    };
    this.$final = function () {
      this.FList = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.CopyMove = function (aList) {
      var r = 0;
      this.Clear();
      for (var $l1 = 0, $end2 = aList.FCount - 1; $l1 <= $end2; $l1++) {
        r = $l1;
        this.Add(aList.Get(r));
      };
    };
    this.MergeMove = function (aList) {
      var r = 0;
      for (var $l1 = 0, $end2 = aList.FCount - 1; $l1 <= $end2; $l1++) {
        r = $l1;
        if (this.IndexOf(aList.Get(r)) < 0) this.Add(aList.Get(r));
      };
    };
    this.DoCopy = function (ListA, ListB) {
      if (ListB != null) {
        this.CopyMove(ListB)}
       else this.CopyMove(ListA);
    };
    this.DoSrcUnique = function (ListA, ListB) {
      var r = 0;
      if (ListB != null) {
        this.Clear();
        for (var $l1 = 0, $end2 = ListA.FCount - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (ListB.IndexOf(ListA.Get(r)) < 0) this.Add(ListA.Get(r));
        };
      } else {
        for (var $l3 = this.FCount - 1; $l3 >= 0; $l3--) {
          r = $l3;
          if (ListA.IndexOf(this.Get(r)) >= 0) this.Delete(r);
        };
      };
    };
    this.DoAnd = function (ListA, ListB) {
      var r = 0;
      if (ListB != null) {
        this.Clear();
        for (var $l1 = 0, $end2 = ListA.FCount - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (ListB.IndexOf(ListA.Get(r)) >= 0) this.Add(ListA.Get(r));
        };
      } else {
        for (var $l3 = this.FCount - 1; $l3 >= 0; $l3--) {
          r = $l3;
          if (ListA.IndexOf(this.Get(r)) < 0) this.Delete(r);
        };
      };
    };
    this.DoDestUnique = function (ListA, ListB) {
      var Self = this;
      function MoveElements(Src, Dest) {
        var r = 0;
        Self.Clear();
        for (var $l1 = 0, $end2 = Src.FCount - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (Dest.IndexOf(Src.Get(r)) < 0) Self.Add(Src.Get(r));
        };
      };
      var Dest = null;
      if (ListB != null) {
        MoveElements(ListB,ListA)}
       else Dest = $mod.TFPList.$create("Create");
      try {
        Dest.CopyMove(Self);
        MoveElements(ListA,Dest);
      } finally {
        Dest.$destroy("Destroy");
      };
    };
    this.DoOr = function (ListA, ListB) {
      if (ListB != null) {
        this.CopyMove(ListA);
        this.MergeMove(ListB);
      } else this.MergeMove(ListA);
    };
    this.DoXOr = function (ListA, ListB) {
      var r = 0;
      var l = null;
      if (ListB != null) {
        this.Clear();
        for (var $l1 = 0, $end2 = ListA.FCount - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (ListB.IndexOf(ListA.Get(r)) < 0) this.Add(ListA.Get(r));
        };
        for (var $l3 = 0, $end4 = ListB.FCount - 1; $l3 <= $end4; $l3++) {
          r = $l3;
          if (ListA.IndexOf(ListB.Get(r)) < 0) this.Add(ListB.Get(r));
        };
      } else {
        l = $mod.TFPList.$create("Create");
        try {
          l.CopyMove(this);
          for (var $l5 = this.FCount - 1; $l5 >= 0; $l5--) {
            r = $l5;
            if (ListA.IndexOf(this.Get(r)) >= 0) this.Delete(r);
          };
          for (var $l6 = 0, $end7 = ListA.FCount - 1; $l6 <= $end7; $l6++) {
            r = $l6;
            if (l.IndexOf(ListA.Get(r)) < 0) this.Add(ListA.Get(r));
          };
        } finally {
          l.$destroy("Destroy");
        };
      };
    };
    this.Get = function (Index) {
      var Result = undefined;
      if ((Index < 0) || (Index >= this.FCount)) this.RaiseIndexError(Index);
      Result = this.FList[Index];
      return Result;
    };
    this.Put = function (Index, Item) {
      if ((Index < 0) || (Index >= this.FCount)) this.RaiseIndexError(Index);
      this.FList[Index] = Item;
    };
    this.SetCapacity = function (NewCapacity) {
      if (NewCapacity < this.FCount) this.$class.Error(pas.RTLConsts.SListCapacityError,"" + NewCapacity);
      if (NewCapacity === this.FCapacity) return;
      this.FList = rtl.arraySetLength(this.FList,undefined,NewCapacity);
      this.FCapacity = NewCapacity;
    };
    this.SetCount = function (NewCount) {
      if (NewCount < 0) this.$class.Error(pas.RTLConsts.SListCountError,"" + NewCount);
      if (NewCount > this.FCount) {
        if (NewCount > this.FCapacity) this.SetCapacity(NewCount);
      };
      this.FCount = NewCount;
    };
    this.RaiseIndexError = function (Index) {
      this.$class.Error(pas.RTLConsts.SListIndexError,"" + Index);
    };
    this.Destroy = function () {
      this.Clear();
      pas.System.TObject.Destroy.call(this);
    };
    this.AddList = function (AList) {
      var I = 0;
      if (this.FCapacity < (this.FCount + AList.FCount)) this.SetCapacity(this.FCount + AList.FCount);
      for (var $l1 = 0, $end2 = AList.FCount - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        this.Add(AList.Get(I));
      };
    };
    this.Add = function (Item) {
      var Result = 0;
      if (this.FCount === this.FCapacity) this.Expand();
      this.FList[this.FCount] = Item;
      Result = this.FCount;
      this.FCount += 1;
      return Result;
    };
    this.Clear = function () {
      if (rtl.length(this.FList) > 0) {
        this.SetCount(0);
        this.SetCapacity(0);
      };
    };
    this.Delete = function (Index) {
      if ((Index < 0) || (Index >= this.FCount)) this.$class.Error(pas.RTLConsts.SListIndexError,"" + Index);
      this.FCount = this.FCount - 1;
      this.FList.splice(Index,1);
      this.FCapacity -= 1;
    };
    this.Error = function (Msg, Data) {
      throw $mod.EListError.$create("CreateFmt",[Msg,[Data]]);
    };
    this.Exchange = function (Index1, Index2) {
      var Temp = undefined;
      if ((Index1 >= this.FCount) || (Index1 < 0)) this.$class.Error(pas.RTLConsts.SListIndexError,"" + Index1);
      if ((Index2 >= this.FCount) || (Index2 < 0)) this.$class.Error(pas.RTLConsts.SListIndexError,"" + Index2);
      Temp = this.FList[Index1];
      this.FList[Index1] = this.FList[Index2];
      this.FList[Index2] = Temp;
    };
    this.Expand = function () {
      var Result = null;
      var IncSize = 0;
      if (this.FCount < this.FCapacity) return this;
      IncSize = 4;
      if (this.FCapacity > 3) IncSize = IncSize + 4;
      if (this.FCapacity > 8) IncSize = IncSize + 8;
      if (this.FCapacity > 127) IncSize += this.FCapacity >>> 2;
      this.SetCapacity(this.FCapacity + IncSize);
      Result = this;
      return Result;
    };
    this.Extract = function (Item) {
      var Result = undefined;
      var i = 0;
      i = this.IndexOf(Item);
      if (i >= 0) {
        Result = Item;
        this.Delete(i);
      } else Result = null;
      return Result;
    };
    this.First = function () {
      var Result = undefined;
      if (this.FCount === 0) {
        Result = null}
       else Result = this.Get(0);
      return Result;
    };
    this.GetEnumerator = function () {
      var Result = null;
      Result = $mod.TFPListEnumerator.$create("Create$1",[this]);
      return Result;
    };
    this.IndexOf = function (Item) {
      var Result = 0;
      var C = 0;
      Result = 0;
      C = this.FCount;
      while ((Result < C) && (this.FList[Result] != Item)) Result += 1;
      if (Result >= C) Result = -1;
      return Result;
    };
    this.IndexOfItem = function (Item, Direction) {
      var Result = 0;
      if (Direction === pas.Types.TDirection.FromBeginning) {
        Result = this.IndexOf(Item)}
       else {
        Result = this.FCount - 1;
        while ((Result >= 0) && (this.FList[Result] != Item)) Result = Result - 1;
      };
      return Result;
    };
    this.Insert = function (Index, Item) {
      if ((Index < 0) || (Index > this.FCount)) this.$class.Error(pas.RTLConsts.SListIndexError,"" + Index);
      this.FList.splice(Index,0,Item);
      this.FCapacity += 1;
      this.FCount += 1;
    };
    this.Last = function () {
      var Result = undefined;
      if (this.FCount === 0) {
        Result = null}
       else Result = this.Get(this.FCount - 1);
      return Result;
    };
    this.Move = function (CurIndex, NewIndex) {
      var Temp = undefined;
      if ((CurIndex < 0) || (CurIndex > (this.FCount - 1))) this.$class.Error(pas.RTLConsts.SListIndexError,"" + CurIndex);
      if ((NewIndex < 0) || (NewIndex > (this.FCount - 1))) this.$class.Error(pas.RTLConsts.SListIndexError,"" + NewIndex);
      if (CurIndex === NewIndex) return;
      Temp = this.FList[CurIndex];
      this.FList.splice(CurIndex,1);
      this.FList.splice(NewIndex,0,Temp);
    };
    this.Assign = function (ListA, AOperator, ListB) {
      var $tmp1 = AOperator;
      if ($tmp1 === $mod.TListAssignOp.laCopy) {
        this.DoCopy(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laSrcUnique) {
        this.DoSrcUnique(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laAnd) {
        this.DoAnd(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laDestUnique) {
        this.DoDestUnique(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laOr) {
        this.DoOr(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laXor) this.DoXOr(ListA,ListB);
    };
    this.Remove = function (Item) {
      var Result = 0;
      Result = this.IndexOf(Item);
      if (Result !== -1) this.Delete(Result);
      return Result;
    };
    this.Pack = function () {
      var Dst = 0;
      var i = 0;
      var V = undefined;
      Dst = 0;
      for (var $l1 = 0, $end2 = this.FCount - 1; $l1 <= $end2; $l1++) {
        i = $l1;
        V = this.FList[i];
        if (!pas.System.Assigned(V)) continue;
        this.FList[Dst] = V;
        Dst += 1;
      };
    };
    this.Sort = function (Compare) {
      if (!(rtl.length(this.FList) > 0) || (this.FCount < 2)) return;
      $impl.QuickSort(this.FList,0,this.FCount - 1,Compare);
    };
    this.ForEachCall = function (proc2call, arg) {
      var i = 0;
      var v = undefined;
      for (var $l1 = 0, $end2 = this.FCount - 1; $l1 <= $end2; $l1++) {
        i = $l1;
        v = this.FList[i];
        if (pas.System.Assigned(v)) proc2call(v,arg);
      };
    };
    this.ForEachCall$1 = function (proc2call, arg) {
      var i = 0;
      var v = undefined;
      for (var $l1 = 0, $end2 = this.FCount - 1; $l1 <= $end2; $l1++) {
        i = $l1;
        v = this.FList[i];
        if (pas.System.Assigned(v)) proc2call(v,arg);
      };
    };
  });
  this.TListNotification = {"0": "lnAdded", lnAdded: 0, "1": "lnExtracted", lnExtracted: 1, "2": "lnDeleted", lnDeleted: 2};
  $mod.$rtti.$Enum("TListNotification",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TListNotification});
  $mod.$rtti.$Class("TList");
  rtl.createClass($mod,"TListEnumerator",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FList = null;
      this.FPosition = 0;
    };
    this.$final = function () {
      this.FList = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function (AList) {
      pas.System.TObject.Create.call(this);
      this.FList = AList;
      this.FPosition = -1;
    };
    this.GetCurrent = function () {
      var Result = undefined;
      Result = this.FList.Get(this.FPosition);
      return Result;
    };
    this.MoveNext = function () {
      var Result = false;
      this.FPosition += 1;
      Result = this.FPosition < this.FList.GetCount();
      return Result;
    };
  });
  rtl.createClass($mod,"TList",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FList = null;
    };
    this.$final = function () {
      this.FList = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.CopyMove = function (aList) {
      var r = 0;
      this.Clear();
      for (var $l1 = 0, $end2 = aList.GetCount() - 1; $l1 <= $end2; $l1++) {
        r = $l1;
        this.Add(aList.Get(r));
      };
    };
    this.MergeMove = function (aList) {
      var r = 0;
      for (var $l1 = 0, $end2 = aList.GetCount() - 1; $l1 <= $end2; $l1++) {
        r = $l1;
        if (this.IndexOf(aList.Get(r)) < 0) this.Add(aList.Get(r));
      };
    };
    this.DoCopy = function (ListA, ListB) {
      if (ListB != null) {
        this.CopyMove(ListB)}
       else this.CopyMove(ListA);
    };
    this.DoSrcUnique = function (ListA, ListB) {
      var r = 0;
      if (ListB != null) {
        this.Clear();
        for (var $l1 = 0, $end2 = ListA.GetCount() - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (ListB.IndexOf(ListA.Get(r)) < 0) this.Add(ListA.Get(r));
        };
      } else {
        for (var $l3 = this.GetCount() - 1; $l3 >= 0; $l3--) {
          r = $l3;
          if (ListA.IndexOf(this.Get(r)) >= 0) this.Delete(r);
        };
      };
    };
    this.DoAnd = function (ListA, ListB) {
      var r = 0;
      if (ListB != null) {
        this.Clear();
        for (var $l1 = 0, $end2 = ListA.GetCount() - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (ListB.IndexOf(ListA.Get(r)) >= 0) this.Add(ListA.Get(r));
        };
      } else {
        for (var $l3 = this.GetCount() - 1; $l3 >= 0; $l3--) {
          r = $l3;
          if (ListA.IndexOf(this.Get(r)) < 0) this.Delete(r);
        };
      };
    };
    this.DoDestUnique = function (ListA, ListB) {
      var Self = this;
      function MoveElements(Src, Dest) {
        var r = 0;
        Self.Clear();
        for (var $l1 = 0, $end2 = Src.GetCount() - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (Dest.IndexOf(Src.Get(r)) < 0) Self.Add(Src.Get(r));
        };
      };
      var Dest = null;
      if (ListB != null) {
        MoveElements(ListB,ListA)}
       else try {
        Dest = $mod.TList.$create("Create$1");
        Dest.CopyMove(Self);
        MoveElements(ListA,Dest);
      } finally {
        Dest.$destroy("Destroy");
      };
    };
    this.DoOr = function (ListA, ListB) {
      if (ListB != null) {
        this.CopyMove(ListA);
        this.MergeMove(ListB);
      } else this.MergeMove(ListA);
    };
    this.DoXOr = function (ListA, ListB) {
      var r = 0;
      var l = null;
      if (ListB != null) {
        this.Clear();
        for (var $l1 = 0, $end2 = ListA.GetCount() - 1; $l1 <= $end2; $l1++) {
          r = $l1;
          if (ListB.IndexOf(ListA.Get(r)) < 0) this.Add(ListA.Get(r));
        };
        for (var $l3 = 0, $end4 = ListB.GetCount() - 1; $l3 <= $end4; $l3++) {
          r = $l3;
          if (ListA.IndexOf(ListB.Get(r)) < 0) this.Add(ListB.Get(r));
        };
      } else try {
        l = $mod.TList.$create("Create$1");
        l.CopyMove(this);
        for (var $l5 = this.GetCount() - 1; $l5 >= 0; $l5--) {
          r = $l5;
          if (ListA.IndexOf(this.Get(r)) >= 0) this.Delete(r);
        };
        for (var $l6 = 0, $end7 = ListA.GetCount() - 1; $l6 <= $end7; $l6++) {
          r = $l6;
          if (l.IndexOf(ListA.Get(r)) < 0) this.Add(ListA.Get(r));
        };
      } finally {
        l.$destroy("Destroy");
      };
    };
    this.Get = function (Index) {
      var Result = undefined;
      Result = this.FList.Get(Index);
      return Result;
    };
    this.Put = function (Index, Item) {
      var V = undefined;
      V = this.Get(Index);
      this.FList.Put(Index,Item);
      if (pas.System.Assigned(V)) this.Notify(V,$mod.TListNotification.lnDeleted);
      if (pas.System.Assigned(Item)) this.Notify(Item,$mod.TListNotification.lnAdded);
    };
    this.Notify = function (aValue, Action) {
      if (pas.System.Assigned(aValue)) ;
      if (Action === $mod.TListNotification.lnExtracted) ;
    };
    this.SetCapacity = function (NewCapacity) {
      this.FList.SetCapacity(NewCapacity);
    };
    this.GetCapacity = function () {
      var Result = 0;
      Result = this.FList.FCapacity;
      return Result;
    };
    this.SetCount = function (NewCount) {
      if (NewCount < this.FList.FCount) {
        while (this.FList.FCount > NewCount) this.Delete(this.FList.FCount - 1)}
       else this.FList.SetCount(NewCount);
    };
    this.GetCount = function () {
      var Result = 0;
      Result = this.FList.FCount;
      return Result;
    };
    this.GetList = function () {
      var Result = [];
      Result = this.FList.FList;
      return Result;
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FList = $mod.TFPList.$create("Create");
    };
    this.Destroy = function () {
      if (this.FList != null) this.Clear();
      pas.SysUtils.FreeAndNil({p: this, get: function () {
          return this.p.FList;
        }, set: function (v) {
          this.p.FList = v;
        }});
    };
    this.AddList = function (AList) {
      var I = 0;
      this.FList.AddList(AList.FList);
      for (var $l1 = 0, $end2 = AList.GetCount() - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        if (pas.System.Assigned(AList.Get(I))) this.Notify(AList.Get(I),$mod.TListNotification.lnAdded);
      };
    };
    this.Add = function (Item) {
      var Result = 0;
      Result = this.FList.Add(Item);
      if (pas.System.Assigned(Item)) this.Notify(Item,$mod.TListNotification.lnAdded);
      return Result;
    };
    this.Clear = function () {
      while (this.FList.FCount > 0) this.Delete(this.GetCount() - 1);
    };
    this.Delete = function (Index) {
      var V = undefined;
      V = this.FList.Get(Index);
      this.FList.Delete(Index);
      if (pas.System.Assigned(V)) this.Notify(V,$mod.TListNotification.lnDeleted);
    };
    this.Error = function (Msg, Data) {
      throw $mod.EListError.$create("CreateFmt",[Msg,[Data]]);
    };
    this.Exchange = function (Index1, Index2) {
      this.FList.Exchange(Index1,Index2);
    };
    this.Expand = function () {
      var Result = null;
      this.FList.Expand();
      Result = this;
      return Result;
    };
    this.Extract = function (Item) {
      var Result = undefined;
      var c = 0;
      c = this.FList.FCount;
      Result = this.FList.Extract(Item);
      if (c !== this.FList.FCount) this.Notify(Result,$mod.TListNotification.lnExtracted);
      return Result;
    };
    this.First = function () {
      var Result = undefined;
      Result = this.FList.First();
      return Result;
    };
    this.GetEnumerator = function () {
      var Result = null;
      Result = $mod.TListEnumerator.$create("Create$1",[this]);
      return Result;
    };
    this.IndexOf = function (Item) {
      var Result = 0;
      Result = this.FList.IndexOf(Item);
      return Result;
    };
    this.Insert = function (Index, Item) {
      this.FList.Insert(Index,Item);
      if (pas.System.Assigned(Item)) this.Notify(Item,$mod.TListNotification.lnAdded);
    };
    this.Last = function () {
      var Result = undefined;
      Result = this.FList.Last();
      return Result;
    };
    this.Move = function (CurIndex, NewIndex) {
      this.FList.Move(CurIndex,NewIndex);
    };
    this.Assign = function (ListA, AOperator, ListB) {
      var $tmp1 = AOperator;
      if ($tmp1 === $mod.TListAssignOp.laCopy) {
        this.DoCopy(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laSrcUnique) {
        this.DoSrcUnique(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laAnd) {
        this.DoAnd(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laDestUnique) {
        this.DoDestUnique(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laOr) {
        this.DoOr(ListA,ListB)}
       else if ($tmp1 === $mod.TListAssignOp.laXor) this.DoXOr(ListA,ListB);
    };
    this.Remove = function (Item) {
      var Result = 0;
      Result = this.IndexOf(Item);
      if (Result !== -1) this.Delete(Result);
      return Result;
    };
    this.Pack = function () {
      this.FList.Pack();
    };
    this.Sort = function (Compare) {
      this.FList.Sort(Compare);
    };
  });
  rtl.createClass($mod,"TPersistent",pas.System.TObject,function () {
    this.AssignError = function (Source) {
      var SourceName = "";
      if (Source !== null) {
        SourceName = Source.$classname}
       else SourceName = "Nil";
      throw pas.SysUtils.EConvertError.$create("Create$1",[((("Cannot assign a " + SourceName) + " to a ") + this.$classname) + "."]);
    };
    this.AssignTo = function (Dest) {
      Dest.AssignError(this);
    };
    this.GetOwner = function () {
      var Result = null;
      Result = null;
      return Result;
    };
    this.Assign = function (Source) {
      if (Source !== null) {
        Source.AssignTo(this)}
       else this.AssignError(null);
    };
    this.GetNamePath = function () {
      var Result = "";
      var OwnerName = "";
      var TheOwner = null;
      Result = this.$classname;
      TheOwner = this.GetOwner();
      if (TheOwner !== null) {
        OwnerName = TheOwner.GetNamePath();
        if (OwnerName !== "") Result = (OwnerName + ".") + Result;
      };
      return Result;
    };
  });
  $mod.$rtti.$ClassRef("TPersistentClass",{instancetype: $mod.$rtti["TPersistent"]});
  rtl.createClass($mod,"TInterfacedPersistent",$mod.TPersistent,function () {
    this.$init = function () {
      $mod.TPersistent.$init.call(this);
      this.FOwnerInterface = null;
    };
    this.$final = function () {
      this.FOwnerInterface = undefined;
      $mod.TPersistent.$final.call(this);
    };
    this._AddRef = function () {
      var Result = 0;
      Result = -1;
      if (this.FOwnerInterface != null) Result = this.FOwnerInterface._AddRef();
      return Result;
    };
    this._Release = function () {
      var Result = 0;
      Result = -1;
      if (this.FOwnerInterface != null) Result = this.FOwnerInterface._Release();
      return Result;
    };
    this.QueryInterface = function (IID, Obj) {
      var Result = 0;
      Result = -2147467262;
      if (this.GetInterface(IID,Obj)) Result = 0;
      return Result;
    };
    this.AfterConstruction = function () {
      try {
        pas.System.TObject.AfterConstruction.call(this);
        if (this.GetOwner() !== null) this.GetOwner().GetInterface(rtl.getIntfGUIDR(pas.System.IUnknown),{p: this, get: function () {
            return this.p.FOwnerInterface;
          }, set: function (v) {
            this.p.FOwnerInterface = v;
          }});
      } finally {
        rtl._Release(this.FOwnerInterface);
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  $mod.$rtti.$Class("TStrings");
  rtl.createClass($mod,"TStringsEnumerator",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FStrings = null;
      this.FPosition = 0;
    };
    this.$final = function () {
      this.FStrings = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function (AStrings) {
      pas.System.TObject.Create.call(this);
      this.FStrings = AStrings;
      this.FPosition = -1;
    };
    this.GetCurrent = function () {
      var Result = "";
      Result = this.FStrings.Get(this.FPosition);
      return Result;
    };
    this.MoveNext = function () {
      var Result = false;
      this.FPosition += 1;
      Result = this.FPosition < this.FStrings.GetCount();
      return Result;
    };
  });
  rtl.createClass($mod,"TStrings",$mod.TPersistent,function () {
    this.$init = function () {
      $mod.TPersistent.$init.call(this);
      this.FSpecialCharsInited = false;
      this.FAlwaysQuote = false;
      this.FQuoteChar = "";
      this.FDelimiter = "";
      this.FNameValueSeparator = "";
      this.FUpdateCount = 0;
      this.FLBS = 0;
      this.FSkipLastLineBreak = false;
      this.FStrictDelimiter = false;
      this.FLineBreak = "";
    };
    this.GetCommaText = function () {
      var Result = "";
      var C1 = "";
      var C2 = "";
      var FSD = false;
      this.CheckSpecialChars();
      FSD = this.FStrictDelimiter;
      C1 = this.GetDelimiter();
      C2 = this.GetQuoteChar();
      this.SetDelimiter(",");
      this.SetQuoteChar('"');
      this.FStrictDelimiter = false;
      try {
        Result = this.GetDelimitedText();
      } finally {
        this.SetDelimiter(C1);
        this.SetQuoteChar(C2);
        this.FStrictDelimiter = FSD;
      };
      return Result;
    };
    this.GetName = function (Index) {
      var Result = "";
      var V = "";
      this.GetNameValue(Index,{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }},{get: function () {
          return V;
        }, set: function (v) {
          V = v;
        }});
      return Result;
    };
    this.GetValue = function (Name) {
      var Result = "";
      var L = 0;
      var N = "";
      Result = "";
      L = this.IndexOfName(Name);
      if (L !== -1) this.GetNameValue(L,{get: function () {
          return N;
        }, set: function (v) {
          N = v;
        }},{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }});
      return Result;
    };
    this.GetLBS = function () {
      var Result = 0;
      this.CheckSpecialChars();
      Result = this.FLBS;
      return Result;
    };
    this.SetLBS = function (AValue) {
      this.CheckSpecialChars();
      this.FLBS = AValue;
    };
    this.SetCommaText = function (Value) {
      var C1 = "";
      var C2 = "";
      this.CheckSpecialChars();
      C1 = this.GetDelimiter();
      C2 = this.GetQuoteChar();
      this.SetDelimiter(",");
      this.SetQuoteChar('"');
      try {
        this.SetDelimitedText(Value);
      } finally {
        this.SetDelimiter(C1);
        this.SetQuoteChar(C2);
      };
    };
    this.SetValue = function (Name, Value) {
      var L = 0;
      this.CheckSpecialChars();
      L = this.IndexOfName(Name);
      if (L === -1) {
        this.Add((Name + this.FNameValueSeparator) + Value)}
       else this.Put(L,(Name + this.FNameValueSeparator) + Value);
    };
    this.SetDelimiter = function (c) {
      this.CheckSpecialChars();
      this.FDelimiter = c;
    };
    this.SetQuoteChar = function (c) {
      this.CheckSpecialChars();
      this.FQuoteChar = c;
    };
    this.SetNameValueSeparator = function (c) {
      this.CheckSpecialChars();
      this.FNameValueSeparator = c;
    };
    this.DoSetTextStr = function (Value, DoClear) {
      var S = "";
      var P = 0;
      try {
        this.BeginUpdate();
        if (DoClear) this.Clear();
        P = 1;
        while (this.GetNextLinebreak(Value,{get: function () {
            return S;
          }, set: function (v) {
            S = v;
          }},{get: function () {
            return P;
          }, set: function (v) {
            P = v;
          }})) this.Add(S);
      } finally {
        this.EndUpdate();
      };
    };
    this.GetDelimiter = function () {
      var Result = "";
      this.CheckSpecialChars();
      Result = this.FDelimiter;
      return Result;
    };
    this.GetNameValueSeparator = function () {
      var Result = "";
      this.CheckSpecialChars();
      Result = this.FNameValueSeparator;
      return Result;
    };
    this.GetQuoteChar = function () {
      var Result = "";
      this.CheckSpecialChars();
      Result = this.FQuoteChar;
      return Result;
    };
    this.GetLineBreak = function () {
      var Result = "";
      this.CheckSpecialChars();
      Result = this.FLineBreak;
      return Result;
    };
    this.SetLineBreak = function (S) {
      this.CheckSpecialChars();
      this.FLineBreak = S;
    };
    this.GetSkipLastLineBreak = function () {
      var Result = false;
      this.CheckSpecialChars();
      Result = this.FSkipLastLineBreak;
      return Result;
    };
    this.SetSkipLastLineBreak = function (AValue) {
      this.CheckSpecialChars();
      this.FSkipLastLineBreak = AValue;
    };
    this.Error = function (Msg, Data) {
      throw $mod.EStringListError.$create("CreateFmt",[Msg,[pas.SysUtils.IntToStr(Data)]]);
    };
    this.GetCapacity = function () {
      var Result = 0;
      Result = this.GetCount();
      return Result;
    };
    this.GetObject = function (Index) {
      var Result = null;
      if (Index === 0) ;
      Result = null;
      return Result;
    };
    this.GetTextStr = function () {
      var Result = "";
      var I = 0;
      var S = "";
      var NL = "";
      this.CheckSpecialChars();
      if (this.FLineBreak !== pas.System.sLineBreak) {
        NL = this.FLineBreak}
       else {
        var $tmp1 = this.FLBS;
        if ($tmp1 === pas.System.TTextLineBreakStyle.tlbsLF) {
          NL = "\n"}
         else if ($tmp1 === pas.System.TTextLineBreakStyle.tlbsCRLF) {
          NL = "\r\n"}
         else if ($tmp1 === pas.System.TTextLineBreakStyle.tlbsCR) NL = "\r";
      };
      Result = "";
      for (var $l2 = 0, $end3 = this.GetCount() - 1; $l2 <= $end3; $l2++) {
        I = $l2;
        S = this.Get(I);
        Result = Result + S;
        if ((I < (this.GetCount() - 1)) || !this.GetSkipLastLineBreak()) Result = Result + NL;
      };
      return Result;
    };
    this.Put = function (Index, S) {
      var Obj = null;
      Obj = this.GetObject(Index);
      this.Delete(Index);
      this.InsertObject(Index,S,Obj);
    };
    this.PutObject = function (Index, AObject) {
      if (Index === 0) return;
      if (AObject === null) return;
    };
    this.SetCapacity = function (NewCapacity) {
      if (NewCapacity === 0) ;
    };
    this.SetTextStr = function (Value) {
      this.CheckSpecialChars();
      this.DoSetTextStr(Value,true);
    };
    this.SetUpdateState = function (Updating) {
      if (Updating) ;
    };
    this.DoCompareText = function (s1, s2) {
      var Result = 0;
      Result = pas.SysUtils.CompareText(s1,s2);
      return Result;
    };
    this.GetDelimitedText = function () {
      var Result = "";
      var I = 0;
      var RE = "";
      var S = "";
      var doQuote = false;
      this.CheckSpecialChars();
      Result = "";
      RE = (this.GetQuoteChar() + "|") + this.GetDelimiter();
      if (!this.FStrictDelimiter) RE = " |" + RE;
      RE = ("\/" + RE) + "\/";
      for (var $l1 = 0, $end2 = this.GetCount() - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        S = this.Get(I);
        doQuote = this.FAlwaysQuote || (S.search(RE) === -1);
        if (doQuote) {
          Result = Result + pas.SysUtils.QuoteString(S,this.GetQuoteChar())}
         else Result = Result + S;
        if (I < (this.GetCount() - 1)) Result = Result + this.GetDelimiter();
      };
      if ((Result.length === 0) && (this.GetCount() === 1)) Result = this.GetQuoteChar() + this.GetQuoteChar();
      return Result;
    };
    this.SetDelimitedText = function (AValue) {
      var i = 0;
      var j = 0;
      var aNotFirst = false;
      this.CheckSpecialChars();
      this.BeginUpdate();
      i = 1;
      j = 1;
      aNotFirst = false;
      try {
        this.Clear();
        if (this.FStrictDelimiter) {
          while (i <= AValue.length) {
            if ((aNotFirst && (i <= AValue.length)) && (AValue.charAt(i - 1) === this.FDelimiter)) i += 1;
            if (i <= AValue.length) {
              if (AValue.charAt(i - 1) === this.FQuoteChar) {
                j = i + 1;
                while ((j <= AValue.length) && ((AValue.charAt(j - 1) !== this.FQuoteChar) || (((j + 1) <= AValue.length) && (AValue.charAt((j + 1) - 1) === this.FQuoteChar)))) {
                  if ((j <= AValue.length) && (AValue.charAt(j - 1) === this.FQuoteChar)) {
                    j += 2}
                   else j += 1;
                };
                this.Add(pas.SysUtils.StringReplace(pas.System.Copy(AValue,i + 1,(j - i) - 1),this.FQuoteChar + this.FQuoteChar,this.FQuoteChar,rtl.createSet(pas.SysUtils.TStringReplaceFlag.rfReplaceAll)));
                i = j + 1;
              } else {
                j = i;
                while ((j <= AValue.length) && (AValue.charAt(j - 1) !== this.FDelimiter)) j += 1;
                this.Add(pas.System.Copy(AValue,i,j - i));
                i = j;
              };
            } else {
              if (aNotFirst) this.Add("");
            };
            aNotFirst = true;
          };
        } else {
          while (i <= AValue.length) {
            if ((aNotFirst && (i <= AValue.length)) && (AValue.charAt(i - 1) === this.FDelimiter)) i += 1;
            while ((i <= AValue.length) && (AValue.charCodeAt(i - 1) <= " ".charCodeAt())) i += 1;
            if (i <= AValue.length) {
              if (AValue.charAt(i - 1) === this.FQuoteChar) {
                j = i + 1;
                while ((j <= AValue.length) && ((AValue.charAt(j - 1) !== this.FQuoteChar) || (((j + 1) <= AValue.length) && (AValue.charAt((j + 1) - 1) === this.FQuoteChar)))) {
                  if ((j <= AValue.length) && (AValue.charAt(j - 1) === this.FQuoteChar)) {
                    j += 2}
                   else j += 1;
                };
                this.Add(pas.SysUtils.StringReplace(pas.System.Copy(AValue,i + 1,(j - i) - 1),this.FQuoteChar + this.FQuoteChar,this.FQuoteChar,rtl.createSet(pas.SysUtils.TStringReplaceFlag.rfReplaceAll)));
                i = j + 1;
              } else {
                j = i;
                while (((j <= AValue.length) && (AValue.charCodeAt(j - 1) > " ".charCodeAt())) && (AValue.charAt(j - 1) !== this.FDelimiter)) j += 1;
                this.Add(pas.System.Copy(AValue,i,j - i));
                i = j;
              };
            } else {
              if (aNotFirst) this.Add("");
            };
            while ((i <= AValue.length) && (AValue.charCodeAt(i - 1) <= " ".charCodeAt())) i += 1;
            aNotFirst = true;
          };
        };
      } finally {
        this.EndUpdate();
      };
    };
    this.GetValueFromIndex = function (Index) {
      var Result = "";
      var N = "";
      this.GetNameValue(Index,{get: function () {
          return N;
        }, set: function (v) {
          N = v;
        }},{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }});
      return Result;
    };
    this.SetValueFromIndex = function (Index, Value) {
      if (Value === "") {
        this.Delete(Index)}
       else {
        if (Index < 0) Index = this.Add("");
        this.CheckSpecialChars();
        this.Put(Index,(this.GetName(Index) + this.FNameValueSeparator) + Value);
      };
    };
    this.CheckSpecialChars = function () {
      if (!this.FSpecialCharsInited) {
        this.FQuoteChar = '"';
        this.FDelimiter = ",";
        this.FNameValueSeparator = "=";
        this.FLBS = pas.System.DefaultTextLineBreakStyle;
        this.FSpecialCharsInited = true;
        this.FLineBreak = pas.System.sLineBreak;
      };
    };
    this.GetNextLinebreak = function (Value, S, P) {
      var Result = false;
      var PP = 0;
      S.set("");
      Result = false;
      if ((Value.length - P.get()) < 0) return Result;
      PP = Value.indexOf(this.GetLineBreak(),P.get() - 1) + 1;
      if (PP < 1) PP = Value.length + 1;
      S.set(pas.System.Copy(Value,P.get(),PP - P.get()));
      P.set(PP + this.GetLineBreak().length);
      Result = true;
      return Result;
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FAlwaysQuote = false;
    };
    this.Destroy = function () {
      pas.System.TObject.Destroy.call(this);
    };
    this.Add = function (S) {
      var Result = 0;
      Result = this.GetCount();
      this.Insert(this.GetCount(),S);
      return Result;
    };
    this.AddObject = function (S, AObject) {
      var Result = 0;
      Result = this.Add(S);
      this.PutObject(Result,AObject);
      return Result;
    };
    this.Append = function (S) {
      this.Add(S);
    };
    this.AddStrings = function (TheStrings) {
      var Runner = 0;
      for (var $l1 = 0, $end2 = TheStrings.GetCount() - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        this.AddObject(TheStrings.Get(Runner),TheStrings.GetObject(Runner));
      };
    };
    this.AddStrings$1 = function (TheStrings, ClearFirst) {
      this.BeginUpdate();
      try {
        if (ClearFirst) this.Clear();
        this.AddStrings(TheStrings);
      } finally {
        this.EndUpdate();
      };
    };
    this.AddStrings$2 = function (TheStrings) {
      var Runner = 0;
      if (((this.GetCount() + (rtl.length(TheStrings) - 1)) + 1) > this.GetCapacity()) this.SetCapacity((this.GetCount() + (rtl.length(TheStrings) - 1)) + 1);
      for (var $l1 = 0, $end2 = rtl.length(TheStrings) - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        this.Add(TheStrings[Runner]);
      };
    };
    this.AddStrings$3 = function (TheStrings, ClearFirst) {
      this.BeginUpdate();
      try {
        if (ClearFirst) this.Clear();
        this.AddStrings$2(TheStrings);
      } finally {
        this.EndUpdate();
      };
    };
    this.AddPair = function (AName, AValue) {
      var Result = null;
      Result = this.AddPair$1(AName,AValue,null);
      return Result;
    };
    this.AddPair$1 = function (AName, AValue, AObject) {
      var Result = null;
      Result = this;
      this.AddObject((AName + this.GetNameValueSeparator()) + AValue,AObject);
      return Result;
    };
    this.AddText = function (S) {
      this.CheckSpecialChars();
      this.DoSetTextStr(S,false);
    };
    this.Assign = function (Source) {
      var S = null;
      if ($mod.TStrings.isPrototypeOf(Source)) {
        S = Source;
        this.BeginUpdate();
        try {
          this.Clear();
          this.FSpecialCharsInited = S.FSpecialCharsInited;
          this.FQuoteChar = S.FQuoteChar;
          this.FDelimiter = S.FDelimiter;
          this.FNameValueSeparator = S.FNameValueSeparator;
          this.FLBS = S.FLBS;
          this.FLineBreak = S.FLineBreak;
          this.AddStrings(S);
        } finally {
          this.EndUpdate();
        };
      } else $mod.TPersistent.Assign.call(this,Source);
    };
    this.BeginUpdate = function () {
      if (this.FUpdateCount === 0) this.SetUpdateState(true);
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) this.FUpdateCount -= 1;
      if (this.FUpdateCount === 0) this.SetUpdateState(false);
    };
    this.Equals = function (Obj) {
      var Result = false;
      if ($mod.TStrings.isPrototypeOf(Obj)) {
        Result = this.Equals$2(Obj)}
       else Result = pas.System.TObject.Equals.call(this,Obj);
      return Result;
    };
    this.Equals$2 = function (TheStrings) {
      var Result = false;
      var Runner = 0;
      var Nr = 0;
      Result = false;
      Nr = this.GetCount();
      if (Nr !== TheStrings.GetCount()) return Result;
      for (var $l1 = 0, $end2 = Nr - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        if (this.Get(Runner) !== TheStrings.Get(Runner)) return Result;
      };
      Result = true;
      return Result;
    };
    this.Exchange = function (Index1, Index2) {
      var Obj = null;
      var Str = "";
      this.BeginUpdate();
      try {
        Obj = this.GetObject(Index1);
        Str = this.Get(Index1);
        this.PutObject(Index1,this.GetObject(Index2));
        this.Put(Index1,this.Get(Index2));
        this.PutObject(Index2,Obj);
        this.Put(Index2,Str);
      } finally {
        this.EndUpdate();
      };
    };
    this.GetEnumerator = function () {
      var Result = null;
      Result = $mod.TStringsEnumerator.$create("Create$1",[this]);
      return Result;
    };
    this.IndexOf = function (S) {
      var Result = 0;
      Result = 0;
      while ((Result < this.GetCount()) && (this.DoCompareText(this.Get(Result),S) !== 0)) Result = Result + 1;
      if (Result === this.GetCount()) Result = -1;
      return Result;
    };
    this.IndexOfName = function (Name) {
      var Result = 0;
      var len = 0;
      var S = "";
      this.CheckSpecialChars();
      Result = 0;
      while (Result < this.GetCount()) {
        S = this.Get(Result);
        len = pas.System.Pos(this.FNameValueSeparator,S) - 1;
        if ((len >= 0) && (this.DoCompareText(Name,pas.System.Copy(S,1,len)) === 0)) return Result;
        Result += 1;
      };
      Result = -1;
      return Result;
    };
    this.IndexOfObject = function (AObject) {
      var Result = 0;
      Result = 0;
      while ((Result < this.GetCount()) && (this.GetObject(Result) !== AObject)) Result = Result + 1;
      if (Result === this.GetCount()) Result = -1;
      return Result;
    };
    this.InsertObject = function (Index, S, AObject) {
      this.Insert(Index,S);
      this.PutObject(Index,AObject);
    };
    this.Move = function (CurIndex, NewIndex) {
      var Obj = null;
      var Str = "";
      this.BeginUpdate();
      try {
        Obj = this.GetObject(CurIndex);
        Str = this.Get(CurIndex);
        this.PutObject(CurIndex,null);
        this.Delete(CurIndex);
        this.InsertObject(NewIndex,Str,Obj);
      } finally {
        this.EndUpdate();
      };
    };
    this.GetNameValue = function (Index, AName, AValue) {
      var L = 0;
      this.CheckSpecialChars();
      AValue.set(this.Get(Index));
      L = pas.System.Pos(this.FNameValueSeparator,AValue.get());
      if (L !== 0) {
        AName.set(pas.System.Copy(AValue.get(),1,L - 1));
        AValue.set(pas.System.Copy(AValue.get(),L + 1,AValue.get().length - L));
      } else AName.set("");
    };
    this.ExtractName = function (S) {
      var Result = "";
      var L = 0;
      this.CheckSpecialChars();
      L = pas.System.Pos(this.FNameValueSeparator,S);
      if (L !== 0) {
        Result = pas.System.Copy(S,1,L - 1)}
       else Result = "";
      return Result;
    };
  });
  this.TStringItem = function (s) {
    if (s) {
      this.FString = s.FString;
      this.FObject = s.FObject;
    } else {
      this.FString = "";
      this.FObject = null;
    };
    this.$equal = function (b) {
      return (this.FString === b.FString) && (this.FObject === b.FObject);
    };
  };
  $mod.$rtti.$Record("TStringItem",{}).addFields("FString",rtl.string,"FObject",pas.System.$rtti["TObject"]);
  $mod.$rtti.$DynArray("TStringItemArray",{eltype: $mod.$rtti["TStringItem"]});
  $mod.$rtti.$Class("TStringList");
  $mod.$rtti.$ProcVar("TStringListSortCompare",{procsig: rtl.newTIProcSig([["List",$mod.$rtti["TStringList"]],["Index1",rtl.longint],["Index2",rtl.longint]],rtl.longint)});
  this.TStringsSortStyle = {"0": "sslNone", sslNone: 0, "1": "sslUser", sslUser: 1, "2": "sslAuto", sslAuto: 2};
  $mod.$rtti.$Enum("TStringsSortStyle",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TStringsSortStyle});
  $mod.$rtti.$Set("TStringsSortStyles",{comptype: $mod.$rtti["TStringsSortStyle"]});
  rtl.createClass($mod,"TStringList",$mod.TStrings,function () {
    this.$init = function () {
      $mod.TStrings.$init.call(this);
      this.FList = [];
      this.FCount = 0;
      this.FOnChange = null;
      this.FOnChanging = null;
      this.FDuplicates = 0;
      this.FCaseSensitive = false;
      this.FForceSort = false;
      this.FOwnsObjects = false;
      this.FSortStyle = 0;
    };
    this.$final = function () {
      this.FList = undefined;
      this.FOnChange = undefined;
      this.FOnChanging = undefined;
      $mod.TStrings.$final.call(this);
    };
    this.ExchangeItemsInt = function (Index1, Index2) {
      var S = "";
      var O = null;
      S = this.FList[Index1].FString;
      O = this.FList[Index1].FObject;
      this.FList[Index1].FString = this.FList[Index2].FString;
      this.FList[Index1].FObject = this.FList[Index2].FObject;
      this.FList[Index2].FString = S;
      this.FList[Index2].FObject = O;
    };
    this.GetSorted = function () {
      var Result = false;
      Result = this.FSortStyle in rtl.createSet($mod.TStringsSortStyle.sslUser,$mod.TStringsSortStyle.sslAuto);
      return Result;
    };
    this.Grow = function () {
      var NC = 0;
      NC = this.GetCapacity();
      if (NC >= 256) {
        NC = NC + Math.floor(NC / 4)}
       else if (NC === 0) {
        NC = 4}
       else NC = NC * 4;
      this.SetCapacity(NC);
    };
    this.InternalClear = function (FromIndex, ClearOnly) {
      var I = 0;
      if (FromIndex < this.FCount) {
        if (this.FOwnsObjects) {
          for (var $l1 = FromIndex, $end2 = this.FCount - 1; $l1 <= $end2; $l1++) {
            I = $l1;
            this.FList[I].FString = "";
            pas.SysUtils.FreeAndNil({p: this.FList[I], get: function () {
                return this.p.FObject;
              }, set: function (v) {
                this.p.FObject = v;
              }});
          };
        } else {
          for (var $l3 = FromIndex, $end4 = this.FCount - 1; $l3 <= $end4; $l3++) {
            I = $l3;
            this.FList[I].FString = "";
          };
        };
        this.FCount = FromIndex;
      };
      if (!ClearOnly) this.SetCapacity(0);
    };
    this.QuickSort = function (L, R, CompareFn) {
      var Pivot = 0;
      var vL = 0;
      var vR = 0;
      if ((R - L) <= 1) {
        if (L < R) if (CompareFn(this,L,R) > 0) this.ExchangeItems(L,R);
        return;
      };
      vL = L;
      vR = R;
      Pivot = L + pas.System.Random(R - L);
      while (vL < vR) {
        while ((vL < Pivot) && (CompareFn(this,vL,Pivot) <= 0)) vL += 1;
        while ((vR > Pivot) && (CompareFn(this,vR,Pivot) > 0)) vR -= 1;
        this.ExchangeItems(vL,vR);
        if (Pivot === vL) {
          Pivot = vR}
         else if (Pivot === vR) Pivot = vL;
      };
      if ((Pivot - 1) >= L) this.QuickSort(L,Pivot - 1,CompareFn);
      if ((Pivot + 1) <= R) this.QuickSort(Pivot + 1,R,CompareFn);
    };
    this.SetSorted = function (Value) {
      if (Value) {
        this.SetSortStyle($mod.TStringsSortStyle.sslAuto)}
       else this.SetSortStyle($mod.TStringsSortStyle.sslNone);
    };
    this.SetCaseSensitive = function (b) {
      if (b === this.FCaseSensitive) return;
      this.FCaseSensitive = b;
      if (this.FSortStyle === $mod.TStringsSortStyle.sslAuto) {
        this.FForceSort = true;
        try {
          this.Sort();
        } finally {
          this.FForceSort = false;
        };
      };
    };
    this.SetSortStyle = function (AValue) {
      if (this.FSortStyle === AValue) return;
      if (AValue === $mod.TStringsSortStyle.sslAuto) this.Sort();
      this.FSortStyle = AValue;
    };
    this.CheckIndex = function (AIndex) {
      if ((AIndex < 0) || (AIndex >= this.FCount)) this.Error(pas.RTLConsts.SListIndexError,AIndex);
    };
    this.ExchangeItems = function (Index1, Index2) {
      this.ExchangeItemsInt(Index1,Index2);
    };
    this.Changed = function () {
      if (this.FUpdateCount === 0) {
        if (this.FOnChange != null) this.FOnChange(this);
      };
    };
    this.Changing = function () {
      if (this.FUpdateCount === 0) if (this.FOnChanging != null) this.FOnChanging(this);
    };
    this.Get = function (Index) {
      var Result = "";
      this.CheckIndex(Index);
      Result = this.FList[Index].FString;
      return Result;
    };
    this.GetCapacity = function () {
      var Result = 0;
      Result = rtl.length(this.FList);
      return Result;
    };
    this.GetCount = function () {
      var Result = 0;
      Result = this.FCount;
      return Result;
    };
    this.GetObject = function (Index) {
      var Result = null;
      this.CheckIndex(Index);
      Result = this.FList[Index].FObject;
      return Result;
    };
    this.Put = function (Index, S) {
      if (this.GetSorted()) this.Error(pas.RTLConsts.SSortedListError,0);
      this.CheckIndex(Index);
      this.Changing();
      this.FList[Index].FString = S;
      this.Changed();
    };
    this.PutObject = function (Index, AObject) {
      this.CheckIndex(Index);
      this.Changing();
      this.FList[Index].FObject = AObject;
      this.Changed();
    };
    this.SetCapacity = function (NewCapacity) {
      if (NewCapacity < 0) this.Error(pas.RTLConsts.SListCapacityError,NewCapacity);
      if (NewCapacity !== this.GetCapacity()) this.FList = rtl.arraySetLength(this.FList,$mod.TStringItem,NewCapacity);
    };
    this.SetUpdateState = function (Updating) {
      if (Updating) {
        this.Changing()}
       else this.Changed();
    };
    this.InsertItem = function (Index, S) {
      this.InsertItem$1(Index,S,null);
    };
    this.InsertItem$1 = function (Index, S, O) {
      var It = new $mod.TStringItem();
      this.Changing();
      if (this.FCount === this.GetCapacity()) this.Grow();
      It.FString = S;
      It.FObject = O;
      this.FList.splice(Index,0,It);
      this.FCount += 1;
      this.Changed();
    };
    this.DoCompareText = function (s1, s2) {
      var Result = 0;
      if (this.FCaseSensitive) {
        Result = pas.SysUtils.CompareStr(s1,s2)}
       else Result = pas.SysUtils.CompareText(s1,s2);
      return Result;
    };
    this.CompareStrings = function (s1, s2) {
      var Result = 0;
      Result = this.DoCompareText(s1,s2);
      return Result;
    };
    this.Destroy = function () {
      this.InternalClear(0,false);
      $mod.TStrings.Destroy.call(this);
    };
    this.Add = function (S) {
      var Result = 0;
      if (!(this.FSortStyle === $mod.TStringsSortStyle.sslAuto)) {
        Result = this.FCount}
       else if (this.Find(S,{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }})) {
        var $tmp1 = this.FDuplicates;
        if ($tmp1 === pas.Types.TDuplicates.dupIgnore) {
          return Result}
         else if ($tmp1 === pas.Types.TDuplicates.dupError) this.Error(pas.RTLConsts.SDuplicateString,0);
      };
      this.InsertItem(Result,S);
      return Result;
    };
    this.Clear = function () {
      if (this.FCount === 0) return;
      this.Changing();
      this.InternalClear(0,false);
      this.Changed();
    };
    this.Delete = function (Index) {
      this.CheckIndex(Index);
      this.Changing();
      if (this.FOwnsObjects) pas.SysUtils.FreeAndNil({p: this.FList[Index], get: function () {
          return this.p.FObject;
        }, set: function (v) {
          this.p.FObject = v;
        }});
      this.FList.splice(Index,1);
      this.FList[this.GetCount() - 1].FString = "";
      this.FList[this.GetCount() - 1].FObject = null;
      this.FCount -= 1;
      this.Changed();
    };
    this.Exchange = function (Index1, Index2) {
      this.CheckIndex(Index1);
      this.CheckIndex(Index2);
      this.Changing();
      this.ExchangeItemsInt(Index1,Index2);
      this.Changed();
    };
    this.Find = function (S, Index) {
      var Result = false;
      var L = 0;
      var R = 0;
      var I = 0;
      var CompareRes = 0;
      Result = false;
      Index.set(-1);
      if (!this.GetSorted()) throw $mod.EListError.$create("Create$1",[pas.RTLConsts.SErrFindNeedsSortedList]);
      L = 0;
      R = this.GetCount() - 1;
      while (L <= R) {
        I = L + Math.floor((R - L) / 2);
        CompareRes = this.DoCompareText(S,this.FList[I].FString);
        if (CompareRes > 0) {
          L = I + 1}
         else {
          R = I - 1;
          if (CompareRes === 0) {
            Result = true;
            if (this.FDuplicates !== pas.Types.TDuplicates.dupAccept) L = I;
          };
        };
      };
      Index.set(L);
      return Result;
    };
    this.IndexOf = function (S) {
      var Result = 0;
      if (!this.GetSorted()) {
        Result = $mod.TStrings.IndexOf.call(this,S)}
       else if (!this.Find(S,{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }})) Result = -1;
      return Result;
    };
    this.Insert = function (Index, S) {
      if (this.FSortStyle === $mod.TStringsSortStyle.sslAuto) {
        this.Error(pas.RTLConsts.SSortedListError,0)}
       else {
        if ((Index < 0) || (Index > this.FCount)) this.Error(pas.RTLConsts.SListIndexError,Index);
        this.InsertItem(Index,S);
      };
    };
    this.Sort = function () {
      this.CustomSort($impl.StringListAnsiCompare);
    };
    this.CustomSort = function (CompareFn) {
      if ((this.FForceSort || !(this.FSortStyle === $mod.TStringsSortStyle.sslAuto)) && (this.FCount > 1)) {
        this.Changing();
        this.QuickSort(0,this.FCount - 1,CompareFn);
        this.Changed();
      };
    };
  });
  $mod.$rtti.$Class("TCollection");
  rtl.createClass($mod,"TCollectionItem",$mod.TPersistent,function () {
    this.$init = function () {
      $mod.TPersistent.$init.call(this);
      this.FCollection = null;
      this.FID = 0;
      this.FUpdateCount = 0;
    };
    this.$final = function () {
      this.FCollection = undefined;
      $mod.TPersistent.$final.call(this);
    };
    this.GetIndex = function () {
      var Result = 0;
      if (this.FCollection !== null) {
        Result = this.FCollection.FItems.IndexOf(this)}
       else Result = -1;
      return Result;
    };
    this.SetCollection = function (Value) {
      if (Value !== this.FCollection) {
        if (this.FCollection !== null) this.FCollection.RemoveItem(this);
        if (Value !== null) Value.InsertItem(this);
      };
    };
    this.Changed = function (AllItems) {
      if ((this.FCollection !== null) && (this.FCollection.FUpdateCount === 0)) {
        if (AllItems) {
          this.FCollection.Update(null)}
         else this.FCollection.Update(this);
      };
    };
    this.GetOwner = function () {
      var Result = null;
      Result = this.FCollection;
      return Result;
    };
    this.GetDisplayName = function () {
      var Result = "";
      Result = this.$classname;
      return Result;
    };
    this.SetIndex = function (Value) {
      var Temp = 0;
      Temp = this.GetIndex();
      if ((Temp > -1) && (Temp !== Value)) {
        this.FCollection.FItems.Move(Temp,Value);
        this.Changed(true);
      };
    };
    this.SetDisplayName = function (Value) {
      this.Changed(false);
      if (Value === "") ;
    };
    this.Create$1 = function (ACollection) {
      pas.System.TObject.Create.call(this);
      this.SetCollection(ACollection);
    };
    this.Destroy = function () {
      this.SetCollection(null);
      pas.System.TObject.Destroy.call(this);
    };
    this.GetNamePath = function () {
      var Result = "";
      if (this.FCollection !== null) {
        Result = ((this.FCollection.GetNamePath() + "[") + pas.SysUtils.IntToStr(this.GetIndex())) + "]"}
       else Result = this.$classname;
      return Result;
    };
  });
  rtl.createClass($mod,"TCollectionEnumerator",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FCollection = null;
      this.FPosition = 0;
    };
    this.$final = function () {
      this.FCollection = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function (ACollection) {
      pas.System.TObject.Create.call(this);
      this.FCollection = ACollection;
      this.FPosition = -1;
    };
    this.GetCurrent = function () {
      var Result = null;
      Result = this.FCollection.GetItem(this.FPosition);
      return Result;
    };
    this.MoveNext = function () {
      var Result = false;
      this.FPosition += 1;
      Result = this.FPosition < this.FCollection.GetCount();
      return Result;
    };
  });
  $mod.$rtti.$ClassRef("TCollectionItemClass",{instancetype: $mod.$rtti["TCollectionItem"]});
  this.TCollectionNotification = {"0": "cnAdded", cnAdded: 0, "1": "cnExtracting", cnExtracting: 1, "2": "cnDeleting", cnDeleting: 2};
  $mod.$rtti.$Enum("TCollectionNotification",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TCollectionNotification});
  $mod.$rtti.$ProcVar("TCollectionSortCompare",{procsig: rtl.newTIProcSig([["Item1",$mod.$rtti["TCollectionItem"]],["Item2",$mod.$rtti["TCollectionItem"]]],rtl.longint)});
  rtl.createClass($mod,"TCollection",$mod.TPersistent,function () {
    this.$init = function () {
      $mod.TPersistent.$init.call(this);
      this.FItemClass = null;
      this.FItems = null;
      this.FUpdateCount = 0;
      this.FNextID = 0;
      this.FPropName = "";
    };
    this.$final = function () {
      this.FItemClass = undefined;
      this.FItems = undefined;
      $mod.TPersistent.$final.call(this);
    };
    this.GetCount = function () {
      var Result = 0;
      Result = this.FItems.FCount;
      return Result;
    };
    this.GetPropName = function () {
      var Result = "";
      Result = this.FPropName;
      this.SetPropName();
      Result = this.FPropName;
      return Result;
    };
    this.InsertItem = function (Item) {
      if (!this.FItemClass.isPrototypeOf(Item)) return;
      this.FItems.Add(Item);
      Item.FCollection = this;
      Item.FID = this.FNextID;
      this.FNextID += 1;
      this.SetItemName(Item);
      this.Notify(Item,$mod.TCollectionNotification.cnAdded);
      this.Changed();
    };
    this.RemoveItem = function (Item) {
      var I = 0;
      this.Notify(Item,$mod.TCollectionNotification.cnExtracting);
      I = this.FItems.IndexOfItem(Item,pas.Types.TDirection.FromEnd);
      if (I !== -1) this.FItems.Delete(I);
      Item.FCollection = null;
      this.Changed();
    };
    this.DoClear = function () {
      var Item = null;
      while (this.FItems.FCount > 0) {
        Item = rtl.getObject(this.FItems.Last());
        if (Item != null) Item.$destroy("Destroy");
      };
    };
    this.GetAttrCount = function () {
      var Result = 0;
      Result = 0;
      return Result;
    };
    this.GetAttr = function (Index) {
      var Result = "";
      Result = "";
      if (Index === 0) ;
      return Result;
    };
    this.GetItemAttr = function (Index, ItemIndex) {
      var Result = "";
      Result = rtl.getObject(this.FItems.Get(ItemIndex)).GetDisplayName();
      if (Index === 0) ;
      return Result;
    };
    this.Changed = function () {
      if (this.FUpdateCount === 0) this.Update(null);
    };
    this.GetItem = function (Index) {
      var Result = null;
      Result = rtl.getObject(this.FItems.Get(Index));
      return Result;
    };
    this.SetItem = function (Index, Value) {
      rtl.getObject(this.FItems.Get(Index)).Assign(Value);
    };
    this.SetItemName = function (Item) {
      if (Item === null) ;
    };
    this.SetPropName = function () {
      this.FPropName = "";
    };
    this.Update = function (Item) {
      if (Item === null) ;
    };
    this.Notify = function (Item, Action) {
      if (Item === null) ;
      if (Action === $mod.TCollectionNotification.cnAdded) ;
    };
    this.Create$1 = function (AItemClass) {
      pas.System.TObject.Create.call(this);
      this.FItemClass = AItemClass;
      this.FItems = $mod.TFPList.$create("Create");
    };
    this.Destroy = function () {
      this.FUpdateCount = 1;
      try {
        this.DoClear();
      } finally {
        this.FUpdateCount = 0;
      };
      if (this.FItems != null) this.FItems.$destroy("Destroy");
      pas.System.TObject.Destroy.call(this);
    };
    this.Owner = function () {
      var Result = null;
      Result = this.GetOwner();
      return Result;
    };
    this.Add = function () {
      var Result = null;
      Result = this.FItemClass.$create("Create$1",[this]);
      return Result;
    };
    this.Assign = function (Source) {
      var I = 0;
      if ($mod.TCollection.isPrototypeOf(Source)) {
        this.Clear();
        for (var $l1 = 0, $end2 = Source.GetCount() - 1; $l1 <= $end2; $l1++) {
          I = $l1;
          this.Add().Assign(Source.GetItem(I));
        };
        return;
      } else $mod.TPersistent.Assign.call(this,Source);
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.Clear = function () {
      if (this.FItems.FCount === 0) return;
      this.BeginUpdate();
      try {
        this.DoClear();
      } finally {
        this.EndUpdate();
      };
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) this.FUpdateCount -= 1;
      if (this.FUpdateCount === 0) this.Changed();
    };
    this.Delete = function (Index) {
      var Item = null;
      Item = rtl.getObject(this.FItems.Get(Index));
      this.Notify(Item,$mod.TCollectionNotification.cnDeleting);
      if (Item != null) Item.$destroy("Destroy");
    };
    this.GetEnumerator = function () {
      var Result = null;
      Result = $mod.TCollectionEnumerator.$create("Create$1",[this]);
      return Result;
    };
    this.GetNamePath = function () {
      var Result = "";
      var o = null;
      o = this.GetOwner();
      if ((o != null) && (this.GetPropName() !== "")) {
        Result = (o.GetNamePath() + ".") + this.GetPropName()}
       else Result = this.$classname;
      return Result;
    };
    this.Insert = function (Index) {
      var Result = null;
      Result = this.Add();
      Result.SetIndex(Index);
      return Result;
    };
    this.FindItemID = function (ID) {
      var Result = null;
      var I = 0;
      for (var $l1 = 0, $end2 = this.FItems.FCount - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        Result = rtl.getObject(this.FItems.Get(I));
        if (Result.FID === ID) return Result;
      };
      Result = null;
      return Result;
    };
    this.Exchange = function (Index1, index2) {
      this.FItems.Exchange(Index1,index2);
    };
    this.Sort = function (Compare) {
      this.BeginUpdate();
      try {
        this.FItems.Sort(Compare);
      } finally {
        this.EndUpdate();
      };
    };
  });
  rtl.createClass($mod,"TOwnedCollection",$mod.TCollection,function () {
    this.$init = function () {
      $mod.TCollection.$init.call(this);
      this.FOwner = null;
    };
    this.$final = function () {
      this.FOwner = undefined;
      $mod.TCollection.$final.call(this);
    };
    this.GetOwner = function () {
      var Result = null;
      Result = this.FOwner;
      return Result;
    };
    this.Create$2 = function (AOwner, AItemClass) {
      this.FOwner = AOwner;
      $mod.TCollection.Create$1.call(this,AItemClass);
    };
  });
  $mod.$rtti.$Class("TComponent");
  this.TOperation = {"0": "opInsert", opInsert: 0, "1": "opRemove", opRemove: 1};
  $mod.$rtti.$Enum("TOperation",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TOperation});
  this.TComponentStateItem = {"0": "csLoading", csLoading: 0, "1": "csReading", csReading: 1, "2": "csWriting", csWriting: 2, "3": "csDestroying", csDestroying: 3, "4": "csDesigning", csDesigning: 4, "5": "csAncestor", csAncestor: 5, "6": "csUpdating", csUpdating: 6, "7": "csFixups", csFixups: 7, "8": "csFreeNotification", csFreeNotification: 8, "9": "csInline", csInline: 9, "10": "csDesignInstance", csDesignInstance: 10};
  $mod.$rtti.$Enum("TComponentStateItem",{minvalue: 0, maxvalue: 10, ordtype: 1, enumtype: this.TComponentStateItem});
  $mod.$rtti.$Set("TComponentState",{comptype: $mod.$rtti["TComponentStateItem"]});
  this.TComponentStyleItem = {"0": "csInheritable", csInheritable: 0, "1": "csCheckPropAvail", csCheckPropAvail: 1, "2": "csSubComponent", csSubComponent: 2, "3": "csTransient", csTransient: 3};
  $mod.$rtti.$Enum("TComponentStyleItem",{minvalue: 0, maxvalue: 3, ordtype: 1, enumtype: this.TComponentStyleItem});
  $mod.$rtti.$Set("TComponentStyle",{comptype: $mod.$rtti["TComponentStyleItem"]});
  $mod.$rtti.$MethodVar("TGetChildProc",{procsig: rtl.newTIProcSig([["Child",$mod.$rtti["TComponent"]]]), methodkind: 0});
  rtl.createClass($mod,"TComponentEnumerator",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FComponent = null;
      this.FPosition = 0;
    };
    this.$final = function () {
      this.FComponent = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function (AComponent) {
      pas.System.TObject.Create.call(this);
      this.FComponent = AComponent;
      this.FPosition = -1;
    };
    this.GetCurrent = function () {
      var Result = null;
      Result = this.FComponent.GetComponent(this.FPosition);
      return Result;
    };
    this.MoveNext = function () {
      var Result = false;
      this.FPosition += 1;
      Result = this.FPosition < this.FComponent.GetComponentCount();
      return Result;
    };
  });
  rtl.createClass($mod,"TComponent",$mod.TPersistent,function () {
    this.$init = function () {
      $mod.TPersistent.$init.call(this);
      this.FOwner = null;
      this.FName = "";
      this.FTag = 0;
      this.FComponents = null;
      this.FFreeNotifies = null;
      this.FDesignInfo = 0;
      this.FComponentState = {};
      this.FComponentStyle = {};
    };
    this.$final = function () {
      this.FOwner = undefined;
      this.FComponents = undefined;
      this.FFreeNotifies = undefined;
      this.FComponentState = undefined;
      this.FComponentStyle = undefined;
      $mod.TPersistent.$final.call(this);
    };
    this.GetComponent = function (AIndex) {
      var Result = null;
      if (!(this.FComponents != null)) {
        Result = null}
       else Result = rtl.getObject(this.FComponents.Get(AIndex));
      return Result;
    };
    this.GetComponentCount = function () {
      var Result = 0;
      if (!(this.FComponents != null)) {
        Result = 0}
       else Result = this.FComponents.FCount;
      return Result;
    };
    this.GetComponentIndex = function () {
      var Result = 0;
      if ((this.FOwner != null) && (this.FOwner.FComponents != null)) {
        Result = this.FOwner.FComponents.IndexOf(this)}
       else Result = -1;
      return Result;
    };
    this.Insert = function (AComponent) {
      if (!(this.FComponents != null)) this.FComponents = $mod.TFPList.$create("Create");
      this.FComponents.Add(AComponent);
      AComponent.FOwner = this;
    };
    this.Remove = function (AComponent) {
      AComponent.FOwner = null;
      if (this.FComponents != null) {
        this.FComponents.Remove(AComponent);
        if (this.FComponents.FCount === 0) {
          this.FComponents.$destroy("Destroy");
          this.FComponents = null;
        };
      };
    };
    this.RemoveNotification = function (AComponent) {
      if (this.FFreeNotifies !== null) {
        this.FFreeNotifies.Remove(AComponent);
        if (this.FFreeNotifies.FCount === 0) {
          this.FFreeNotifies.$destroy("Destroy");
          this.FFreeNotifies = null;
          this.FComponentState = rtl.excludeSet(this.FComponentState,$mod.TComponentStateItem.csFreeNotification);
        };
      };
    };
    this.SetComponentIndex = function (Value) {
      var Temp = 0;
      var Count = 0;
      if (!(this.FOwner != null)) return;
      Temp = this.GetComponentIndex();
      if (Temp < 0) return;
      if (Value < 0) Value = 0;
      Count = this.FOwner.FComponents.FCount;
      if (Value >= Count) Value = Count - 1;
      if (Value !== Temp) {
        this.FOwner.FComponents.Delete(Temp);
        this.FOwner.FComponents.Insert(Value,this);
      };
    };
    this.ChangeName = function (NewName) {
      this.FName = NewName;
    };
    this.GetChildren = function (Proc, Root) {
      if (Proc === null) ;
      if (Root === null) ;
    };
    this.GetChildOwner = function () {
      var Result = null;
      Result = null;
      return Result;
    };
    this.GetChildParent = function () {
      var Result = null;
      Result = this;
      return Result;
    };
    this.GetOwner = function () {
      var Result = null;
      Result = this.FOwner;
      return Result;
    };
    this.Loaded = function () {
      this.FComponentState = rtl.excludeSet(this.FComponentState,$mod.TComponentStateItem.csLoading);
    };
    this.Loading = function () {
      this.FComponentState = rtl.includeSet(this.FComponentState,$mod.TComponentStateItem.csLoading);
    };
    this.Notification = function (AComponent, Operation) {
      var C = 0;
      if (Operation === $mod.TOperation.opRemove) this.RemoveFreeNotification(AComponent);
      if (!(this.FComponents != null)) return;
      C = this.FComponents.FCount - 1;
      while (C >= 0) {
        rtl.getObject(this.FComponents.Get(C)).Notification(AComponent,Operation);
        C -= 1;
        if (C >= this.FComponents.FCount) C = this.FComponents.FCount - 1;
      };
    };
    this.PaletteCreated = function () {
    };
    this.SetAncestor = function (Value) {
      var Runner = 0;
      if (Value) {
        this.FComponentState = rtl.includeSet(this.FComponentState,$mod.TComponentStateItem.csAncestor)}
       else this.FComponentState = rtl.excludeSet(this.FComponentState,$mod.TComponentStateItem.csAncestor);
      if (this.FComponents != null) for (var $l1 = 0, $end2 = this.FComponents.FCount - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        rtl.getObject(this.FComponents.Get(Runner)).SetAncestor(Value);
      };
    };
    this.SetDesigning = function (Value, SetChildren) {
      var Runner = 0;
      if (Value) {
        this.FComponentState = rtl.includeSet(this.FComponentState,$mod.TComponentStateItem.csDesigning)}
       else this.FComponentState = rtl.excludeSet(this.FComponentState,$mod.TComponentStateItem.csDesigning);
      if ((this.FComponents != null) && SetChildren) for (var $l1 = 0, $end2 = this.FComponents.FCount - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        rtl.getObject(this.FComponents.Get(Runner)).SetDesigning(Value,true);
      };
    };
    this.SetDesignInstance = function (Value) {
      if (Value) {
        this.FComponentState = rtl.includeSet(this.FComponentState,$mod.TComponentStateItem.csDesignInstance)}
       else this.FComponentState = rtl.excludeSet(this.FComponentState,$mod.TComponentStateItem.csDesignInstance);
    };
    this.SetInline = function (Value) {
      if (Value) {
        this.FComponentState = rtl.includeSet(this.FComponentState,$mod.TComponentStateItem.csInline)}
       else this.FComponentState = rtl.excludeSet(this.FComponentState,$mod.TComponentStateItem.csInline);
    };
    this.SetName = function (NewName) {
      if (this.FName === NewName) return;
      if ((NewName !== "") && !pas.SysUtils.IsValidIdent(NewName,false,false)) throw $mod.EComponentError.$create("CreateFmt",[pas.RTLConsts.SInvalidName,[NewName]]);
      if (this.FOwner != null) {
        this.FOwner.ValidateRename(this,this.FName,NewName)}
       else this.ValidateRename(null,this.FName,NewName);
      this.ChangeName(NewName);
    };
    this.SetChildOrder = function (Child, Order) {
      if (Child === null) ;
      if (Order === 0) ;
    };
    this.SetParentComponent = function (Value) {
      if (Value === null) ;
    };
    this.Updating = function () {
      this.FComponentState = rtl.includeSet(this.FComponentState,$mod.TComponentStateItem.csUpdating);
    };
    this.Updated = function () {
      this.FComponentState = rtl.excludeSet(this.FComponentState,$mod.TComponentStateItem.csUpdating);
    };
    this.ValidateRename = function (AComponent, CurName, NewName) {
      if ((((AComponent !== null) && (pas.SysUtils.CompareText(CurName,NewName) !== 0)) && (AComponent.FOwner === this)) && (this.FindComponent(NewName) !== null)) throw $mod.EComponentError.$create("CreateFmt",[pas.RTLConsts.SDuplicateName,[NewName]]);
      if (($mod.TComponentStateItem.csDesigning in this.FComponentState) && (this.FOwner !== null)) this.FOwner.ValidateRename(AComponent,CurName,NewName);
    };
    this.ValidateContainer = function (AComponent) {
      AComponent.ValidateInsert(this);
    };
    this.ValidateInsert = function (AComponent) {
      if (AComponent === null) ;
    };
    this._AddRef = function () {
      var Result = 0;
      Result = -1;
      return Result;
    };
    this._Release = function () {
      var Result = 0;
      Result = -1;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      this.FComponentStyle = rtl.createSet($mod.TComponentStyleItem.csInheritable);
      if (AOwner != null) AOwner.InsertComponent(this);
    };
    this.Destroy = function () {
      var I = 0;
      var C = null;
      this.Destroying();
      if (this.FFreeNotifies != null) {
        I = this.FFreeNotifies.FCount - 1;
        while (I >= 0) {
          C = rtl.getObject(this.FFreeNotifies.Get(I));
          this.FFreeNotifies.Delete(I);
          C.Notification(this,$mod.TOperation.opRemove);
          if (this.FFreeNotifies === null) {
            I = 0}
           else if (I > this.FFreeNotifies.FCount) I = this.FFreeNotifies.FCount;
          I -= 1;
        };
        pas.SysUtils.FreeAndNil({p: this, get: function () {
            return this.p.FFreeNotifies;
          }, set: function (v) {
            this.p.FFreeNotifies = v;
          }});
      };
      this.DestroyComponents();
      if (this.FOwner !== null) this.FOwner.RemoveComponent(this);
      pas.System.TObject.Destroy.call(this);
    };
    this.BeforeDestruction = function () {
      if (!($mod.TComponentStateItem.csDestroying in this.FComponentState)) this.Destroying();
    };
    this.DestroyComponents = function () {
      var acomponent = null;
      while (this.FComponents != null) {
        acomponent = rtl.getObject(this.FComponents.Last());
        this.Remove(acomponent);
        acomponent.$destroy("Destroy");
      };
    };
    this.Destroying = function () {
      var Runner = 0;
      if ($mod.TComponentStateItem.csDestroying in this.FComponentState) return;
      this.FComponentState = rtl.includeSet(this.FComponentState,$mod.TComponentStateItem.csDestroying);
      if (this.FComponents != null) for (var $l1 = 0, $end2 = this.FComponents.FCount - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        rtl.getObject(this.FComponents.Get(Runner)).Destroying();
      };
    };
    this.QueryInterface = function (IID, Obj) {
      var Result = 0;
      if (this.GetInterface(IID,Obj)) {
        Result = 0}
       else Result = -2147467262;
      return Result;
    };
    this.FindComponent = function (AName) {
      var Result = null;
      var I = 0;
      Result = null;
      if ((AName === "") || !(this.FComponents != null)) return Result;
      for (var $l1 = 0, $end2 = this.FComponents.FCount - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        if (pas.SysUtils.CompareText(rtl.getObject(this.FComponents.Get(I)).FName,AName) === 0) {
          Result = rtl.getObject(this.FComponents.Get(I));
          return Result;
        };
      };
      return Result;
    };
    this.FreeNotification = function (AComponent) {
      if ((this.FOwner !== null) && (AComponent === this.FOwner)) return;
      if (!(this.FFreeNotifies != null)) this.FFreeNotifies = $mod.TFPList.$create("Create");
      if (this.FFreeNotifies.IndexOf(AComponent) === -1) {
        this.FFreeNotifies.Add(AComponent);
        AComponent.FreeNotification(this);
      };
    };
    this.RemoveFreeNotification = function (AComponent) {
      this.RemoveNotification(AComponent);
      AComponent.RemoveNotification(this);
    };
    this.GetNamePath = function () {
      var Result = "";
      Result = this.FName;
      return Result;
    };
    this.GetParentComponent = function () {
      var Result = null;
      Result = null;
      return Result;
    };
    this.HasParent = function () {
      var Result = false;
      Result = false;
      return Result;
    };
    this.InsertComponent = function (AComponent) {
      AComponent.ValidateContainer(this);
      this.ValidateRename(AComponent,"",AComponent.FName);
      this.Insert(AComponent);
      if ($mod.TComponentStateItem.csDesigning in this.FComponentState) AComponent.SetDesigning(true,true);
      this.Notification(AComponent,$mod.TOperation.opInsert);
    };
    this.RemoveComponent = function (AComponent) {
      this.Notification(AComponent,$mod.TOperation.opRemove);
      this.Remove(AComponent);
      AComponent.SetDesigning(false,true);
      this.ValidateRename(AComponent,AComponent.FName,"");
    };
    this.SetSubComponent = function (ASubComponent) {
      if (ASubComponent) {
        this.FComponentStyle = rtl.includeSet(this.FComponentStyle,$mod.TComponentStyleItem.csSubComponent)}
       else this.FComponentStyle = rtl.excludeSet(this.FComponentStyle,$mod.TComponentStyleItem.csSubComponent);
    };
    this.GetEnumerator = function () {
      var Result = null;
      Result = $mod.TComponentEnumerator.$create("Create$1",[this]);
      return Result;
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Name",6,rtl.string,"FName","SetName");
    $r.addProperty("Tag",0,rtl.nativeint,"FTag","FTag");
  });
  $mod.$rtti.$ClassRef("TComponentClass",{instancetype: $mod.$rtti["TComponent"]});
  this.RegisterClass = function (AClass) {
    $impl.ClassList[AClass.$classname] = AClass;
  };
  this.GetClass = function (AClassName) {
    var Result = null;
    Result = null;
    if (AClassName === "") return Result;
    if (!$impl.ClassList.hasOwnProperty(AClassName)) return Result;
    Result = rtl.getObject($impl.ClassList[AClassName]);
    return Result;
  };
  $mod.$init = function () {
    $impl.ClassList = Object.create(null);
  };
},["JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.QuickSort = function (aList, L, R, Compare) {
    var I = 0;
    var J = 0;
    var P = undefined;
    var Q = undefined;
    do {
      I = L;
      J = R;
      P = aList[Math.floor((L + R) / 2)];
      do {
        while (Compare(P,aList[I]) > 0) I = I + 1;
        while (Compare(P,aList[J]) < 0) J = J - 1;
        if (I <= J) {
          Q = aList[I];
          aList[I] = aList[J];
          aList[J] = Q;
          I = I + 1;
          J = J - 1;
        };
      } while (!(I > J));
      if ((J - L) < (R - I)) {
        if (L < J) $impl.QuickSort(aList,L,J,Compare);
        L = I;
      } else {
        if (I < R) $impl.QuickSort(aList,I,R,Compare);
        R = J;
      };
    } while (!(L >= R));
  };
  $impl.StringListAnsiCompare = function (List, Index1, Index) {
    var Result = 0;
    Result = List.DoCompareText(List.FList[Index1].FString,List.FList[Index].FString);
    return Result;
  };
  $impl.ClassList = null;
});
rtl.module("Web",["System","Types","JS"],function () {
  "use strict";
  var $mod = this;
  $mod.$rtti.$RefToProcVar("TJSEventHandler",{procsig: rtl.newTIProcSig([["Event",$mod.$rtti["TEventListenerEvent"]]],rtl.boolean)});
  $mod.$rtti.$ProcVar("TJSNodeListCallBack",{procsig: rtl.newTIProcSig([["currentValue",$mod.$rtti["TJSNode"]],["currentIndex",rtl.nativeint],["list",$mod.$rtti["TJSNodeList"]]])});
  $mod.$rtti.$MethodVar("TJSNodeListEvent",{procsig: rtl.newTIProcSig([["currentValue",$mod.$rtti["TJSNode"]],["currentIndex",rtl.nativeint],["list",$mod.$rtti["TJSNodeList"]]]), methodkind: 0});
  $mod.$rtti.$ProcVar("TDOMTokenlistCallBack",{procsig: rtl.newTIProcSig([["Current",rtl.jsvalue],["currentIndex",rtl.nativeint],["list",$mod.$rtti["TJSDOMTokenList"]]])});
  this.TJSClientRect = function (s) {
    if (s) {
      this.left = s.left;
      this.top = s.top;
      this.right = s.right;
      this.bottom = s.bottom;
    } else {
      this.left = 0.0;
      this.top = 0.0;
      this.right = 0.0;
      this.bottom = 0.0;
    };
    this.$equal = function (b) {
      return (this.left === b.left) && ((this.top === b.top) && ((this.right === b.right) && (this.bottom === b.bottom)));
    };
  };
  $mod.$rtti.$Record("TJSClientRect",{}).addFields("left",rtl.double,"top",rtl.double,"right",rtl.double,"bottom",rtl.double);
  $mod.$rtti.$DynArray("TJSClientRectArray",{eltype: $mod.$rtti["TJSClientRect"]});
  this.TJSElementCreationOptions = function (s) {
    if (s) {
      this.named = s.named;
    } else {
      this.named = "";
    };
    this.$equal = function (b) {
      return this.named === b.named;
    };
  };
  $mod.$rtti.$Record("TJSElementCreationOptions",{}).addFields("named",rtl.string);
  this.TJSEventInit = function (s) {
    if (s) {
      this.bubbles = s.bubbles;
      this.cancelable = s.cancelable;
      this.scoped = s.scoped;
      this.composed = s.composed;
    } else {
      this.bubbles = false;
      this.cancelable = false;
      this.scoped = false;
      this.composed = false;
    };
    this.$equal = function (b) {
      return (this.bubbles === b.bubbles) && ((this.cancelable === b.cancelable) && ((this.scoped === b.scoped) && (this.composed === b.composed)));
    };
  };
  $mod.$rtti.$Record("TJSEventInit",{}).addFields("bubbles",rtl.boolean,"cancelable",rtl.boolean,"scoped",rtl.boolean,"composed",rtl.boolean);
  $mod.$rtti.$ProcVar("TJSNameSpaceMapperCallback",{procsig: rtl.newTIProcSig([["aNameSpace",rtl.string]],rtl.string)});
  $mod.$rtti.$RefToProcVar("TJSDataTransferItemCallBack",{procsig: rtl.newTIProcSig([["aData",rtl.string]])});
  $mod.$rtti.$RefToProcVar("TJSDragDropEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSDragEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("THTMLClickEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSMouseEvent"]]],rtl.boolean)});
  rtl.createClassExt($mod,"TJSAnimationEvent",Event,"",function () {
    this.$init = function () {
    };
    this.$final = function () {
    };
  });
  rtl.createClassExt($mod,"TJSLoadEvent",Event,"",function () {
    this.$init = function () {
    };
    this.$final = function () {
    };
  });
  rtl.createClassExt($mod,"TJsPageTransitionEvent",Event,"",function () {
    this.$init = function () {
    };
    this.$final = function () {
    };
  });
  $mod.$rtti.$RefToProcVar("TJSPageTransitionEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJsPageTransitionEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSHashChangeEventhandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSHashChangeEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSMouseWheelEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSWheelEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSMouseEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSMouseEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("THTMLAnimationEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSAnimationEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSErrorEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSErrorEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSFocusEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSKeyEventhandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSKeyboardEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSLoadEventhandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSLoadEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSPointerEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSPointerEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSUIEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSUIEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSPopStateEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSPopStateEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSStorageEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSStorageEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSProgressEventhandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSProgressEvent"]]],rtl.boolean)});
  $mod.$rtti.$RefToProcVar("TJSTouchEventHandler",{procsig: rtl.newTIProcSig([["aEvent",$mod.$rtti["TJSTouchEvent"]]],rtl.boolean)});
  rtl.createClass($mod,"TJSIDBTransactionMode",pas.System.TObject,function () {
    this.readonly = "readonly";
    this.readwrite = "readwrite";
    this.versionchange = "versionchange";
  });
  this.TJSIDBIndexParameters = function (s) {
    if (s) {
      this.unique = s.unique;
      this.multiEntry = s.multiEntry;
      this.locale = s.locale;
    } else {
      this.unique = false;
      this.multiEntry = false;
      this.locale = "";
    };
    this.$equal = function (b) {
      return (this.unique === b.unique) && ((this.multiEntry === b.multiEntry) && (this.locale === b.locale));
    };
  };
  $mod.$rtti.$Record("TJSIDBIndexParameters",{}).addFields("unique",rtl.boolean,"multiEntry",rtl.boolean,"locale",rtl.string);
  this.TJSCreateObjectStoreOptions = function (s) {
    if (s) {
      this.keyPath = s.keyPath;
      this.autoIncrement = s.autoIncrement;
    } else {
      this.keyPath = undefined;
      this.autoIncrement = false;
    };
    this.$equal = function (b) {
      return (this.keyPath === b.keyPath) && (this.autoIncrement === b.autoIncrement);
    };
  };
  $mod.$rtti.$Record("TJSCreateObjectStoreOptions",{}).addFields("keyPath",rtl.jsvalue,"autoIncrement",rtl.boolean);
  this.TJSPositionError = function (s) {
    if (s) {
      this.code = s.code;
      this.message = s.message;
    } else {
      this.code = 0;
      this.message = "";
    };
    this.$equal = function (b) {
      return (this.code === b.code) && (this.message === b.message);
    };
  };
  $mod.$rtti.$Record("TJSPositionError",{}).addFields("code",rtl.longint,"message",rtl.string);
  this.TJSPositionOptions = function (s) {
    if (s) {
      this.enableHighAccuracy = s.enableHighAccuracy;
      this.timeout = s.timeout;
      this.maximumAge = s.maximumAge;
    } else {
      this.enableHighAccuracy = false;
      this.timeout = 0;
      this.maximumAge = 0;
    };
    this.$equal = function (b) {
      return (this.enableHighAccuracy === b.enableHighAccuracy) && ((this.timeout === b.timeout) && (this.maximumAge === b.maximumAge));
    };
  };
  $mod.$rtti.$Record("TJSPositionOptions",{}).addFields("enableHighAccuracy",rtl.boolean,"timeout",rtl.longint,"maximumAge",rtl.longint);
  this.TJSCoordinates = function (s) {
    if (s) {
      this.latitude = s.latitude;
      this.longitude = s.longitude;
      this.altitude = s.altitude;
      this.accuracy = s.accuracy;
      this.altitudeAccuracy = s.altitudeAccuracy;
      this.heading = s.heading;
      this.speed = s.speed;
    } else {
      this.latitude = 0.0;
      this.longitude = 0.0;
      this.altitude = 0.0;
      this.accuracy = 0.0;
      this.altitudeAccuracy = 0.0;
      this.heading = 0.0;
      this.speed = 0.0;
    };
    this.$equal = function (b) {
      return (this.latitude === b.latitude) && ((this.longitude === b.longitude) && ((this.altitude === b.altitude) && ((this.accuracy === b.accuracy) && ((this.altitudeAccuracy === b.altitudeAccuracy) && ((this.heading === b.heading) && (this.speed === b.speed))))));
    };
  };
  $mod.$rtti.$Record("TJSCoordinates",{}).addFields("latitude",rtl.double,"longitude",rtl.double,"altitude",rtl.double,"accuracy",rtl.double,"altitudeAccuracy",rtl.double,"heading",rtl.double,"speed",rtl.double);
  this.TJSPosition = function (s) {
    if (s) {
      this.coords = new $mod.TJSCoordinates(s.coords);
      this.timestamp = s.timestamp;
    } else {
      this.coords = new $mod.TJSCoordinates();
      this.timestamp = "";
    };
    this.$equal = function (b) {
      return this.coords.$equal(b.coords) && (this.timestamp === b.timestamp);
    };
  };
  $mod.$rtti.$Record("TJSPosition",{}).addFields("coords",$mod.$rtti["TJSCoordinates"],"timestamp",rtl.string);
  $mod.$rtti.$ProcVar("TJSGeoLocationCallback",{procsig: rtl.newTIProcSig([["aPosition",$mod.$rtti["TJSPosition"]]])});
  $mod.$rtti.$MethodVar("TJSGeoLocationEvent",{procsig: rtl.newTIProcSig([["aPosition",$mod.$rtti["TJSPosition"]]]), methodkind: 0});
  $mod.$rtti.$ProcVar("TJSGeoLocationErrorCallback",{procsig: rtl.newTIProcSig([["aValue",$mod.$rtti["TJSPositionError"]]])});
  $mod.$rtti.$MethodVar("TJSGeoLocationErrorEvent",{procsig: rtl.newTIProcSig([["aValue",$mod.$rtti["TJSPositionError"]]]), methodkind: 0});
  this.TJSServiceWorkerContainerOptions = function (s) {
    if (s) {
      this.scope = s.scope;
    } else {
      this.scope = "";
    };
    this.$equal = function (b) {
      return this.scope === b.scope;
    };
  };
  $mod.$rtti.$Record("TJSServiceWorkerContainerOptions",{}).addFields("scope",rtl.string);
  $mod.$rtti.$RefToProcVar("TJSTimerCallBack",{procsig: rtl.newTIProcSig(null)});
  $mod.$rtti.$ProcVar("TFrameRequestCallback",{procsig: rtl.newTIProcSig([["aTime",rtl.double]])});
  $mod.$rtti.$DynArray("TJSWindowArray",{eltype: $mod.$rtti["TJSWindow"]});
  $mod.$rtti.$RefToProcVar("THTMLCanvasToBlobCallback",{procsig: rtl.newTIProcSig([["aBlob",$mod.$rtti["TJSBlob"]]],rtl.boolean)});
  this.TJSTextMetrics = function (s) {
    if (s) {
      this.width = s.width;
      this.actualBoundingBoxLeft = s.actualBoundingBoxLeft;
      this.actualBoundingBoxRight = s.actualBoundingBoxRight;
      this.fontBoundingBoxAscent = s.fontBoundingBoxAscent;
      this.fontBoundingBoxDescent = s.fontBoundingBoxDescent;
      this.actualBoundingBoxAscent = s.actualBoundingBoxAscent;
      this.actualBoundingBoxDescent = s.actualBoundingBoxDescent;
      this.emHeightAscent = s.emHeightAscent;
      this.emHeightDescent = s.emHeightDescent;
      this.hangingBaseline = s.hangingBaseline;
      this.alphabeticBaseline = s.alphabeticBaseline;
      this.ideographicBaseline = s.ideographicBaseline;
    } else {
      this.width = 0.0;
      this.actualBoundingBoxLeft = 0.0;
      this.actualBoundingBoxRight = 0.0;
      this.fontBoundingBoxAscent = 0.0;
      this.fontBoundingBoxDescent = 0.0;
      this.actualBoundingBoxAscent = 0.0;
      this.actualBoundingBoxDescent = 0.0;
      this.emHeightAscent = 0.0;
      this.emHeightDescent = 0.0;
      this.hangingBaseline = 0.0;
      this.alphabeticBaseline = 0.0;
      this.ideographicBaseline = 0.0;
    };
    this.$equal = function (b) {
      return (this.width === b.width) && ((this.actualBoundingBoxLeft === b.actualBoundingBoxLeft) && ((this.actualBoundingBoxRight === b.actualBoundingBoxRight) && ((this.fontBoundingBoxAscent === b.fontBoundingBoxAscent) && ((this.fontBoundingBoxDescent === b.fontBoundingBoxDescent) && ((this.actualBoundingBoxAscent === b.actualBoundingBoxAscent) && ((this.actualBoundingBoxDescent === b.actualBoundingBoxDescent) && ((this.emHeightAscent === b.emHeightAscent) && ((this.emHeightDescent === b.emHeightDescent) && ((this.hangingBaseline === b.hangingBaseline) && ((this.alphabeticBaseline === b.alphabeticBaseline) && (this.ideographicBaseline === b.ideographicBaseline)))))))))));
    };
  };
  $mod.$rtti.$Record("TJSTextMetrics",{}).addFields("width",rtl.double,"actualBoundingBoxLeft",rtl.double,"actualBoundingBoxRight",rtl.double,"fontBoundingBoxAscent",rtl.double,"fontBoundingBoxDescent",rtl.double,"actualBoundingBoxAscent",rtl.double,"actualBoundingBoxDescent",rtl.double,"emHeightAscent",rtl.double,"emHeightDescent",rtl.double,"hangingBaseline",rtl.double,"alphabeticBaseline",rtl.double,"ideographicBaseline",rtl.double);
  $mod.$rtti.$RefToProcVar("TJSOnReadyStateChangeHandler",{procsig: rtl.newTIProcSig(null)});
  this.TJSWheelEventInit = function (s) {
    if (s) {
      this.deltaX = s.deltaX;
      this.deltaY = s.deltaY;
      this.deltaZ = s.deltaZ;
      this.deltaMode = s.deltaMode;
    } else {
      this.deltaX = 0.0;
      this.deltaY = 0.0;
      this.deltaZ = 0.0;
      this.deltaMode = 0;
    };
    this.$equal = function (b) {
      return (this.deltaX === b.deltaX) && ((this.deltaY === b.deltaY) && ((this.deltaZ === b.deltaZ) && (this.deltaMode === b.deltaMode)));
    };
  };
  $mod.$rtti.$Record("TJSWheelEventInit",{}).addFields("deltaX",rtl.double,"deltaY",rtl.double,"deltaZ",rtl.double,"deltaMode",rtl.nativeint);
  rtl.createClass($mod,"TJSKeyNames",pas.System.TObject,function () {
    this.Alt = "Alt";
    this.AltGraph = "AltGraph";
    this.CapsLock = "CapsLock";
    this.Control = "Control";
    this.Fn = "Fn";
    this.FnLock = "FnLock";
    this.Hyper = "Hyper";
    this.Meta = "Meta";
    this.NumLock = "NumLock";
    this.ScrollLock = "ScrollLock";
    this.Shift = "Shift";
    this.Super = "Super";
    this.Symbol = "Symbol";
    this.SymbolLock = "SymbolLock";
    this.Enter = "Enter";
    this.Tab = "Tab";
    this.Space = " ";
    this.ArrowDown = "ArrowDown";
    this.ArrowLeft = "ArrowLeft";
    this.ArrowRight = "ArrowRight";
    this.ArrowUp = "ArrowUp";
    this._End = "End";
    this.Home = "Home";
    this.PageDown = "PageDown";
    this.PageUp = "PageUp";
    this.BackSpace = "Backspace";
    this.Clear = "Clear";
    this.Copy = "Copy";
    this.CrSel = "CrSel";
    this.Cut = "Cut";
    this.Delete = "Delete";
    this.EraseEof = "EraseEof";
    this.ExSel = "ExSel";
    this.Insert = "Insert";
    this.Paste = "Paste";
    this.Redo = "Redo";
    this.Undo = "Undo";
    this.Accept = "Accept";
    this.Again = "Again";
    this.Attn = "Attn";
    this.Cancel = "Cancel";
    this.ContextMenu = "Contextmenu";
    this.Escape = "Escape";
    this.Execute = "Execute";
    this.Find = "Find";
    this.Finish = "Finish";
    this.Help = "Help";
    this.Pause = "Pause";
    this.Play = "Play";
    this.Props = "Props";
    this.Select = "Select";
    this.ZoomIn = "ZoomIn";
    this.ZoomOut = "ZoomOut";
    this.BrightnessDown = "BrightnessDown";
    this.BrightnessUp = "BrightnessUp";
    this.Eject = "Eject";
    this.LogOff = "LogOff";
    this.Power = "Power";
    this.PowerOff = "PowerOff";
    this.PrintScreen = "PrintScreen";
    this.Hibernate = "Hibernate";
    this.Standby = "Standby";
    this.WakeUp = "WakeUp";
    this.AllCandidates = "AllCandidates";
    this.Alphanumeric = "Alphanumeric";
    this.CodeInput = "CodeInput";
    this.Compose = "Compose";
    this.Convert = "Convert";
    this.Dead = "Dead";
    this.FinalMode = "FinalMode";
    this.GroupFirst = "GroupFirst";
    this.GroupLast = "GroupLast";
    this.GroupNext = "GroupNext";
    this.GroupPrevious = "GroupPrevious";
    this.ModelChange = "ModelChange";
    this.NextCandidate = "NextCandidate";
    this.NonConvert = "NonConvert";
    this.PreviousCandidate = "PreviousCandidate";
    this.Process = "Process";
    this.SingleCandidate = "SingleCandidate";
    this.HangulMode = "HangulMode";
    this.HanjaMode = "HanjaMode";
    this.JunjaMode = "JunjaMode";
    this.Eisu = "Eisu";
    this.Hankaku = "Hankaku";
    this.Hiranga = "Hiranga";
    this.HirangaKatakana = "HirangaKatakana";
    this.KanaMode = "KanaMode";
    this.Katakana = "Katakana";
    this.Romaji = "Romaji";
    this.Zenkaku = "Zenkaku";
    this.ZenkakuHanaku = "ZenkakuHanaku";
    this.F1 = "F1";
    this.F2 = "F2";
    this.F3 = "F3";
    this.F4 = "F4";
    this.F5 = "F5";
    this.F6 = "F6";
    this.F7 = "F7";
    this.F8 = "F8";
    this.F9 = "F9";
    this.F10 = "F10";
    this.F11 = "F11";
    this.F12 = "F12";
    this.F13 = "F13";
    this.F14 = "F14";
    this.F15 = "F15";
    this.F16 = "F16";
    this.F17 = "F17";
    this.F18 = "F18";
    this.F19 = "F19";
    this.F20 = "F20";
    this.Soft1 = "Soft1";
    this.Soft2 = "Soft2";
    this.Soft3 = "Soft3";
    this.Soft4 = "Soft4";
    this.Decimal = "Decimal";
    this.Key11 = "Key11";
    this.Key12 = "Key12";
    this.Multiply = "Multiply";
    this.Add = "Add";
    this.NumClear = "Clear";
    this.Divide = "Divide";
    this.Subtract = "Subtract";
    this.Separator = "Separator";
    this.AppSwitch = "AppSwitch";
    this.Call = "Call";
    this.Camera = "Camera";
    this.CameraFocus = "CameraFocus";
    this.EndCall = "EndCall";
    this.GoBack = "GoBack";
    this.GoHome = "GoHome";
    this.HeadsetHook = "HeadsetHook";
    this.LastNumberRedial = "LastNumberRedial";
    this.Notification = "Notification";
    this.MannerMode = "MannerMode";
    this.VoiceDial = "VoiceDial";
  });
  this.TJSMutationRecord = function (s) {
    if (s) {
      this.type_ = s.type_;
      this.target = s.target;
      this.addedNodes = s.addedNodes;
      this.removedNodes = s.removedNodes;
      this.previousSibling = s.previousSibling;
      this.nextSibling = s.nextSibling;
      this.attributeName = s.attributeName;
      this.attributeNamespace = s.attributeNamespace;
      this.oldValue = s.oldValue;
    } else {
      this.type_ = "";
      this.target = null;
      this.addedNodes = null;
      this.removedNodes = null;
      this.previousSibling = null;
      this.nextSibling = null;
      this.attributeName = "";
      this.attributeNamespace = "";
      this.oldValue = "";
    };
    this.$equal = function (b) {
      return (this.type_ === b.type_) && ((this.target === b.target) && ((this.addedNodes === b.addedNodes) && ((this.removedNodes === b.removedNodes) && ((this.previousSibling === b.previousSibling) && ((this.nextSibling === b.nextSibling) && ((this.attributeName === b.attributeName) && ((this.attributeNamespace === b.attributeNamespace) && (this.oldValue === b.oldValue))))))));
    };
  };
  $mod.$rtti.$Record("TJSMutationRecord",{}).addFields("type_",rtl.string,"target",$mod.$rtti["TJSNode"],"addedNodes",$mod.$rtti["TJSNodeList"],"removedNodes",$mod.$rtti["TJSNodeList"],"previousSibling",$mod.$rtti["TJSNode"],"nextSibling",$mod.$rtti["TJSNode"],"attributeName",rtl.string,"attributeNamespace",rtl.string,"oldValue",rtl.string);
  $mod.$rtti.$DynArray("TJSMutationRecordArray",{eltype: $mod.$rtti["TJSMutationRecord"]});
  $mod.$rtti.$RefToProcVar("TJSMutationCallback",{procsig: rtl.newTIProcSig([["mutations",$mod.$rtti["TJSMutationRecordArray"]],["observer",$mod.$rtti["TJSMutationObserver"]]])});
  this.TJSMutationObserverInit = function (s) {
    if (s) {
      this.attributes = s.attributes;
      this.attributeOldValue = s.attributeOldValue;
      this.characterData = s.characterData;
      this.characterDataOldValue = s.characterDataOldValue;
      this.childList = s.childList;
      this.subTree = s.subTree;
      this.attributeFilter = s.attributeFilter;
    } else {
      this.attributes = false;
      this.attributeOldValue = false;
      this.characterData = false;
      this.characterDataOldValue = false;
      this.childList = false;
      this.subTree = false;
      this.attributeFilter = null;
    };
    this.$equal = function (b) {
      return (this.attributes === b.attributes) && ((this.attributeOldValue === b.attributeOldValue) && ((this.characterData === b.characterData) && ((this.characterDataOldValue === b.characterDataOldValue) && ((this.childList === b.childList) && ((this.subTree === b.subTree) && (this.attributeFilter === b.attributeFilter))))));
    };
  };
  $mod.$rtti.$Record("TJSMutationObserverInit",{}).addFields("attributes",rtl.boolean,"attributeOldValue",rtl.boolean,"characterData",rtl.boolean,"characterDataOldValue",rtl.boolean,"childList",rtl.boolean,"subTree",rtl.boolean,"attributeFilter",pas.JS.$rtti["TJSArray"]);
});
rtl.module("Math",["System","SysUtils"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.MinInteger = -0x10000000000000;
  this.MaxInteger = 0xfffffffffffff;
  this.MinDouble = 5.0e-324;
  this.MaxDouble = 1.7e+308;
  this.InRange = function (AValue, AMin, AMax) {
    return (AValue >= AMin) && (AValue <= AMax);
  };
  this.InRange$1 = function (AValue, AMin, AMax) {
    return (AValue >= AMin) && (AValue <= AMax);
  };
  this.EnsureRange = function (AValue, AMin, AMax) {
    if (AValue<AMin){ return AMin;
    } else if (AValue>AMax){ return AMax;
    } else return AValue;
  };
  this.EnsureRange$1 = function (AValue, AMin, AMax) {
    if (AValue<AMin){ return AMin;
    } else if (AValue>AMax){ return AMax;
    } else return AValue;
  };
  $mod.$rtti.$Int("TRoundToRange",{minvalue: -37, maxvalue: 37, ordtype: 0});
  this.RoundTo = function (AValue, Digits) {
    var Result = 0.0;
    var RV = 0.0;
    RV = $mod.IntPower(10,Digits);
    Result = Math.round(AValue / RV) * RV;
    return Result;
  };
  this.SimpleRoundTo = function (AValue, Digits) {
    var Result = 0.0;
    var RV = 0.0;
    RV = $mod.IntPower(10,-Digits);
    if (AValue < 0) {
      Result = pas.System.Int((AValue * RV) - 0.5) / RV}
     else Result = pas.System.Int((AValue * RV) + 0.5) / RV;
    return Result;
  };
  this.randg = function (mean, stddev) {
    var Result = 0.0;
    var U1 = 0.0;
    var S2 = 0.0;
    do {
      U1 = (2 * Math.random()) - 1;
      S2 = pas.System.Sqr$1(U1) + pas.System.Sqr$1((2 * Math.random()) - 1);
    } while (!(S2 < 1));
    Result = ((Math.sqrt((-2 * Math.log(S2)) / S2) * U1) * stddev) + mean;
    return Result;
  };
  this.RandomRange = function (aFrom, aTo) {
    var Result = 0;
    Result = pas.System.Random(Math.abs(aFrom - aTo)) + Math.min(aTo,aFrom);
    return Result;
  };
  this.RandomRange$1 = function (aFrom, aTo) {
    var Result = 0;
    var m = 0;
    if (aFrom < aTo) {
      m = aFrom}
     else m = aTo;
    Result = pas.System.Random(Math.abs(aFrom - aTo)) + m;
    return Result;
  };
  this.NegativeValue = -1;
  this.ZeroValue = 0;
  this.PositiveValue = 1;
  this.IsZero = function (d, Epsilon) {
    var Result = false;
    if (Epsilon === 0) Epsilon = 1E-12;
    Result = Math.abs(d) <= Epsilon;
    return Result;
  };
  this.IsZero$1 = function (d) {
    var Result = false;
    Result = Math.abs(d) <= 1E-12;
    return Result;
  };
  this.IsInfinite = function (d) {
    return (d==Infinity) || (d==-Infinity);
  };
  this.SameValue = function (A, B, Epsilon) {
    var Result = false;
    if (Epsilon === 0.0) Epsilon = Math.max(Math.min(Math.abs(A),Math.abs(B)) * 1E-12,1E-12);
    if (A > B) {
      Result = (A - B) <= Epsilon}
     else Result = (B - A) <= Epsilon;
    return Result;
  };
  this.LogN = function (A, Base) {
    var Result = 0.0;
    Result = Math.log(A) / Math.log(Base);
    return Result;
  };
  this.Ceil = function (A) {
    var Result = 0;
    Result = pas.System.Trunc(Math.ceil(A));
    return Result;
  };
  this.Floor = function (A) {
    var Result = 0;
    Result = pas.System.Trunc(Math.floor(A));
    return Result;
  };
  this.Ceil64 = function (A) {
    var Result = 0;
    Result = pas.System.Trunc(Math.ceil(A));
    return Result;
  };
  this.Floor64 = function (A) {
    var Result = 0;
    Result = pas.System.Trunc(Math.ceil(A));
    return Result;
  };
  this.ldexp = function (x, p) {
    var Result = 0.0;
    Result = x * $mod.IntPower(2.0,p);
    return Result;
  };
  this.Frexp = function (X, Mantissa, Exponent) {
    Exponent.set(0);
    if (X !== 0) if (Math.abs(X) < 0.5) {
      do {
        X = X * 2;
        Exponent.set(Exponent.get() - 1);
      } while (!(Math.abs(X) >= 0.5))}
     else while (Math.abs(X) >= 1) {
      X = X / 2;
      Exponent.set(Exponent.get() + 1);
    };
    Mantissa.set(X);
  };
  this.lnxp1 = function (x) {
    var Result = 0.0;
    var y = 0.0;
    if (x >= 4.0) {
      Result = Math.log(1.0 + x)}
     else {
      y = 1.0 + x;
      if (y === 1.0) {
        Result = x}
       else {
        Result = Math.log(y);
        if (y > 0.0) Result = Result + ((x - (y - 1.0)) / y);
      };
    };
    return Result;
  };
  this.IntPower = function (base, exponent) {
    var Result = 0.0;
    var i = 0;
    if ((base === 0.0) && (exponent === 0)) {
      Result = 1}
     else {
      i = Math.abs(exponent);
      Result = 1.0;
      while (i > 0) {
        while ((i & 1) === 0) {
          i = i >>> 1;
          base = pas.System.Sqr$1(base);
        };
        i = i - 1;
        Result = Result * base;
      };
      if (exponent < 0) Result = 1.0 / Result;
    };
    return Result;
  };
  this.DivMod = function (Dividend, Divisor, Result, Remainder) {
    if (Dividend < 0) {
      Dividend = -Dividend;
      Result.set(-Math.floor(Dividend / Divisor));
      Remainder.set(-(Dividend + (Result.get() * Divisor)));
    } else {
      Result.set(Math.floor(Dividend / Divisor));
      Remainder.set(Dividend - (Result.get() * Divisor));
    };
  };
  this.DivMod$1 = function (Dividend, Divisor, Result, Remainder) {
    if (Dividend < 0) {
      Dividend = -Dividend;
      Result.set(-Math.floor(Dividend / Divisor));
      Remainder.set(-(Dividend + (Result.get() * Divisor)));
    } else {
      Result.set(Math.floor(Dividend / Divisor));
      Remainder.set(Dividend - (Result.get() * Divisor));
    };
  };
  this.DivMod$2 = function (Dividend, Divisor, Result, Remainder) {
    Result.set(Math.floor(Dividend / Divisor));
    Remainder.set(Dividend - (Result.get() * Divisor));
  };
  this.DivMod$3 = function (Dividend, Divisor, Result, Remainder) {
    if (Dividend < 0) {
      Dividend = -Dividend;
      Result.set(-Math.floor(Dividend / Divisor));
      Remainder.set(-(Dividend + (Result.get() * Divisor)));
    } else {
      Result.set(Math.floor(Dividend / Divisor));
      Remainder.set(Dividend - (Result.get() * Divisor));
    };
  };
  this.DegToRad = function (deg) {
    var Result = 0.0;
    Result = deg * (Math.PI / 180.0);
    return Result;
  };
  this.RadToDeg = function (rad) {
    var Result = 0.0;
    Result = rad * (180.0 / Math.PI);
    return Result;
  };
  this.GradToRad = function (grad) {
    var Result = 0.0;
    Result = grad * (Math.PI / 200.0);
    return Result;
  };
  this.RadToGrad = function (rad) {
    var Result = 0.0;
    Result = rad * (200.0 / Math.PI);
    return Result;
  };
  this.DegToGrad = function (deg) {
    var Result = 0.0;
    Result = deg * (200.0 / 180.0);
    return Result;
  };
  this.GradToDeg = function (grad) {
    var Result = 0.0;
    Result = grad * (180.0 / 200.0);
    return Result;
  };
  this.CycleToRad = function (cycle) {
    var Result = 0.0;
    Result = (2 * Math.PI) * cycle;
    return Result;
  };
  this.RadToCycle = function (rad) {
    var Result = 0.0;
    Result = rad * (1 / (2 * Math.PI));
    return Result;
  };
  this.DegNormalize = function (deg) {
    var Result = 0.0;
    Result = deg - (pas.System.Int(deg / 360) * 360);
    if (Result < 0) Result = Result + 360;
    return Result;
  };
  this.Norm = function (data) {
    var Result = 0.0;
    Result = Math.sqrt($impl.sumofsquares(data));
    return Result;
  };
  this.Mean = function (data) {
    var Result = 0.0;
    var N = 0;
    N = rtl.length(data);
    if (N === 0) {
      Result = 0}
     else Result = $mod.Sum(data) / N;
    return Result;
  };
  this.Sum = function (data) {
    var Result = 0.0;
    var i = 0;
    var N = 0;
    N = rtl.length(data);
    Result = 0.0;
    for (var $l1 = 0, $end2 = N - 1; $l1 <= $end2; $l1++) {
      i = $l1;
      Result = Result + data[i];
    };
    return Result;
  };
  this.SumsAndSquares = function (data, Sum, SumOfSquares) {
    var i = 0;
    var n = 0;
    var t = 0.0;
    var s = 0.0;
    var ss = 0.0;
    n = rtl.length(data);
    ss = 0.0;
    s = 0.0;
    for (var $l1 = 0, $end2 = n - 1; $l1 <= $end2; $l1++) {
      i = $l1;
      t = data[i];
      ss = ss + pas.System.Sqr$1(t);
      s = s + t;
    };
    Sum.set(s);
    SumOfSquares.set(ss);
  };
  this.StdDev = function (data) {
    var Result = 0.0;
    Result = Math.sqrt($mod.Variance(data));
    return Result;
  };
  this.MeanAndStdDev = function (data, Mean, StdDev) {
    var I = 0;
    var N = 0;
    var M = 0.0;
    var S = 0.0;
    N = rtl.length(data);
    M = 0;
    S = 0;
    for (var $l1 = 0, $end2 = N - 1; $l1 <= $end2; $l1++) {
      I = $l1;
      M = M + data[I];
      S = S + pas.System.Sqr$1(data[I]);
    };
    M = M / N;
    S = S - (N * pas.System.Sqr$1(M));
    if (N > 1) {
      S = Math.sqrt(S / (N - 1))}
     else S = 0;
    Mean.set(M);
    StdDev.set(S);
  };
  this.Variance = function (data) {
    var Result = 0.0;
    var n = 0;
    n = rtl.length(data);
    if (n === 1) {
      Result = 0}
     else Result = $mod.TotalVariance(data) / (n - 1);
    return Result;
  };
  this.TotalVariance = function (data) {
    var Result = 0.0;
    var S = 0.0;
    var SS = 0.0;
    var N = 0;
    N = rtl.length(data);
    if (rtl.length(data) === 1) {
      Result = 0}
     else {
      $mod.SumsAndSquares(data,{get: function () {
          return S;
        }, set: function (v) {
          S = v;
        }},{get: function () {
          return SS;
        }, set: function (v) {
          SS = v;
        }});
      Result = SS - (pas.System.Sqr$1(S) / N);
    };
    return Result;
  };
  this.PopNStdDev = function (data) {
    var Result = 0.0;
    Result = Math.sqrt($mod.PopNVariance(data));
    return Result;
  };
  this.PopNVariance = function (data) {
    var Result = 0.0;
    var N = 0;
    N = rtl.length(data);
    if (N === 0) {
      Result = 0}
     else Result = $mod.TotalVariance(data) / N;
    return Result;
  };
  this.MomentSkewKurtosis = function (data, m1, m2, m3, m4, skew, kurtosis) {
    var i = 0;
    var N = 0;
    var deviation = 0.0;
    var deviation2 = 0.0;
    var reciprocalN = 0.0;
    var lm1 = 0.0;
    var lm2 = 0.0;
    var lm3 = 0.0;
    var lm4 = 0.0;
    var lskew = 0.0;
    var lkurtosis = 0.0;
    N = rtl.length(data);
    lm1 = 0;
    reciprocalN = 1 / N;
    for (var $l1 = 0, $end2 = N - 1; $l1 <= $end2; $l1++) {
      i = $l1;
      lm1 = lm1 + data[i];
    };
    lm1 = reciprocalN * lm1;
    lm2 = 0;
    lm3 = 0;
    lm4 = 0;
    for (var $l3 = 0, $end4 = N - 1; $l3 <= $end4; $l3++) {
      i = $l3;
      deviation = data[i] - lm1;
      deviation2 = deviation * deviation;
      lm2 = lm2 + deviation2;
      lm3 = lm3 + (deviation2 * deviation);
      lm4 = lm4 + (deviation2 * deviation2);
    };
    lm2 = reciprocalN * lm2;
    lm3 = reciprocalN * lm3;
    lm4 = reciprocalN * lm4;
    lskew = lm3 / (Math.sqrt(lm2) * lm2);
    lkurtosis = lm4 / (lm2 * lm2);
    m1.set(lm1);
    m2.set(lm2);
    m3.set(lm3);
    m4.set(lm4);
    skew.set(lskew);
    kurtosis.set(lkurtosis);
  };
  this.TPaymentTime = {"0": "ptEndOfPeriod", ptEndOfPeriod: 0, "1": "ptStartOfPeriod", ptStartOfPeriod: 1};
  $mod.$rtti.$Enum("TPaymentTime",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TPaymentTime});
  this.FutureValue = function (ARate, NPeriods, APayment, APresentValue, APaymentTime) {
    var Result = 0.0;
    var q = 0.0;
    var qn = 0.0;
    var factor = 0.0;
    if (ARate === 0) {
      Result = -APresentValue - (APayment * NPeriods)}
     else {
      q = 1.0 + ARate;
      qn = Math.pow(q,NPeriods);
      factor = (qn - 1) / (q - 1);
      if (APaymentTime === $mod.TPaymentTime.ptStartOfPeriod) factor = factor * q;
      Result = -((APresentValue * qn) + (APayment * factor));
    };
    return Result;
  };
  var DELTA = 0.001;
  var EPS = 1E-9;
  var MAXIT = 20;
  this.InterestRate = function (NPeriods, APayment, APresentValue, AFutureValue, APaymentTime) {
    var Result = 0.0;
    var r1 = 0.0;
    var r2 = 0.0;
    var dr = 0.0;
    var fv1 = 0.0;
    var fv2 = 0.0;
    var iteration = 0;
    iteration = 0;
    r1 = 0.05;
    do {
      r2 = r1 + 0.001;
      fv1 = $mod.FutureValue(r1,NPeriods,APayment,APresentValue,APaymentTime);
      fv2 = $mod.FutureValue(r2,NPeriods,APayment,APresentValue,APaymentTime);
      dr = ((AFutureValue - fv1) / (fv2 - fv1)) * 0.001;
      r1 = r1 + dr;
      iteration += 1;
    } while (!((Math.abs(dr) < 1.0E-9) || (iteration >= 20)));
    Result = r1;
    return Result;
  };
  this.NumberOfPeriods = function (ARate, APayment, APresentValue, AFutureValue, APaymentTime) {
    var Result = 0.0;
    var q = 0.0;
    var x1 = 0.0;
    var x2 = 0.0;
    if (ARate === 0) {
      Result = -(APresentValue + AFutureValue) / APayment}
     else {
      q = 1.0 + ARate;
      if (APaymentTime === $mod.TPaymentTime.ptStartOfPeriod) APayment = APayment * q;
      x1 = APayment - (AFutureValue * ARate);
      x2 = APayment + (APresentValue * ARate);
      if ((x2 === 0) || ((Math.sign(x1) * Math.sign(x2)) < 0)) {
        Result = Infinity}
       else {
        Result = Math.log(x1 / x2) / Math.log(q);
      };
    };
    return Result;
  };
  this.Payment = function (ARate, NPeriods, APresentValue, AFutureValue, APaymentTime) {
    var Result = 0.0;
    var q = 0.0;
    var qn = 0.0;
    var factor = 0.0;
    if (ARate === 0) {
      Result = -(AFutureValue + APresentValue) / NPeriods}
     else {
      q = 1.0 + ARate;
      qn = Math.pow(q,NPeriods);
      factor = (qn - 1) / (q - 1);
      if (APaymentTime === $mod.TPaymentTime.ptStartOfPeriod) factor = factor * q;
      Result = -(AFutureValue + (APresentValue * qn)) / factor;
    };
    return Result;
  };
  this.PresentValue = function (ARate, NPeriods, APayment, AFutureValue, APaymentTime) {
    var Result = 0.0;
    var q = 0.0;
    var qn = 0.0;
    var factor = 0.0;
    if (ARate === 0.0) {
      Result = -AFutureValue - (APayment * NPeriods)}
     else {
      q = 1.0 + ARate;
      qn = Math.pow(q,NPeriods);
      factor = (qn - 1) / (q - 1);
      if (APaymentTime === $mod.TPaymentTime.ptStartOfPeriod) factor = factor * q;
      Result = -(AFutureValue + (APayment * factor)) / qn;
    };
    return Result;
  };
  this.IfThen = function (val, ifTrue, ifFalse) {
    var Result = 0;
    if (val) {
      Result = ifTrue}
     else Result = ifFalse;
    return Result;
  };
  this.IfThen$1 = function (val, ifTrue, ifFalse) {
    var Result = 0.0;
    if (val) {
      Result = ifTrue}
     else Result = ifFalse;
    return Result;
  };
  $mod.$rtti.$Int("TValueRelationship",{minvalue: -1, maxvalue: 1, ordtype: 0});
  this.EqualsValue = 0;
  this.LessThanValue = -1;
  this.GreaterThanValue = 1;
  this.CompareValue = function (A, B) {
    var Result = 0;
    Result = 1;
    if (A === B) {
      Result = 0}
     else if (A < B) Result = -1;
    return Result;
  };
  this.CompareValue$1 = function (A, B) {
    var Result = 0;
    Result = 1;
    if (A === B) {
      Result = 0}
     else if (A < B) Result = -1;
    return Result;
  };
  this.CompareValue$2 = function (A, B) {
    var Result = 0;
    Result = 1;
    if (A === B) {
      Result = 0}
     else if (A < B) Result = -1;
    return Result;
  };
  this.CompareValue$3 = function (A, B, delta) {
    var Result = 0;
    Result = 1;
    if (Math.abs(A - B) <= delta) {
      Result = 0}
     else if (A < B) Result = -1;
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.DZeroResolution = 1E-12;
  $impl.sumofsquares = function (data) {
    var Result = 0.0;
    var i = 0;
    var N = 0;
    N = rtl.length(data);
    Result = 0.0;
    for (var $l1 = 0, $end2 = N - 1; $l1 <= $end2; $l1++) {
      i = $l1;
      Result = Result + pas.System.Sqr$1(data[i]);
    };
    return Result;
  };
});
rtl.module("Graphics",["System","Classes","SysUtils","Types","Web"],function () {
  "use strict";
  var $mod = this;
  $mod.$rtti.$Int("TFontCharSet",{minvalue: 0, maxvalue: 255, ordtype: 3});
  this.TFontStyle = {"0": "fsBold", fsBold: 0, "1": "fsItalic", fsItalic: 1, "2": "fsUnderline", fsUnderline: 2, "3": "fsStrikeOut", fsStrikeOut: 3};
  $mod.$rtti.$Enum("TFontStyle",{minvalue: 0, maxvalue: 3, ordtype: 1, enumtype: this.TFontStyle});
  $mod.$rtti.$Set("TFontStyles",{comptype: $mod.$rtti["TFontStyle"]});
  this.TTextLayout = {"0": "tlTop", tlTop: 0, "1": "tlCenter", tlCenter: 1, "2": "tlBottom", tlBottom: 2};
  $mod.$rtti.$Enum("TTextLayout",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TTextLayout});
  this.TPenStyle = {"0": "psSolid", psSolid: 0, "1": "psDash", psDash: 1, "2": "psDot", psDot: 2, "3": "psDashDot", psDashDot: 3, "4": "psDashDotDot", psDashDotDot: 4, "5": "psInsideFrame", psInsideFrame: 5, "6": "psPattern", psPattern: 6, "7": "psClear", psClear: 7};
  $mod.$rtti.$Enum("TPenStyle",{minvalue: 0, maxvalue: 7, ordtype: 1, enumtype: this.TPenStyle});
  $mod.$rtti.$Set("TPenStyleSet",{comptype: $mod.$rtti["TPenStyle"]});
  this.TBrushStyle = {"0": "bsSolid", bsSolid: 0, "1": "bsClear", bsClear: 1, "2": "bsHorizontal", bsHorizontal: 2, "3": "bsVertical", bsVertical: 3, "4": "bsFDiagonal", bsFDiagonal: 4, "5": "bsBDiagonal", bsBDiagonal: 5, "6": "bsCross", bsCross: 6, "7": "bsDiagCross", bsDiagCross: 7, "8": "bsImage", bsImage: 8, "9": "bsPattern", bsPattern: 9};
  $mod.$rtti.$Enum("TBrushStyle",{minvalue: 0, maxvalue: 9, ordtype: 1, enumtype: this.TBrushStyle});
  rtl.createClass($mod,"TFont",pas.Classes.TPersistent,function () {
    this.$init = function () {
      pas.Classes.TPersistent.$init.call(this);
      this.FCharSet = 0;
      this.FColor = 0;
      this.FName = "";
      this.FSize = 0;
      this.FStyle = {};
      this.FUpdateCount = 0;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FStyle = undefined;
      this.FOnChange = undefined;
      pas.Classes.TPersistent.$final.call(this);
    };
    this.GetHeight = function () {
      var Result = 0;
      Result = Math.round((this.FSize * 96) / 72);
      return Result;
    };
    this.SetCharSet = function (AValue) {
      if (this.FCharSet !== AValue) {
        this.FCharSet = AValue;
        this.Changed();
      };
    };
    this.SetColor = function (AValue) {
      if (this.FColor !== AValue) {
        this.FColor = AValue;
        this.Changed();
      };
    };
    this.SetHeight = function (AValue) {
      this.SetSize(Math.round((AValue * 72) / 96));
    };
    this.SetName = function (AValue) {
      if (this.FName !== AValue) {
        this.FName = AValue;
        this.Changed();
      };
    };
    this.SetSize = function (AValue) {
      if (this.FSize !== AValue) {
        this.FSize = AValue;
        this.Changed();
      };
    };
    this.SetStyle = function (AValue) {
      if (rtl.neSet(this.FStyle,AValue)) {
        this.FStyle = rtl.refSet(AValue);
        this.Changed();
      };
    };
    this.Changed = function () {
      if ((this.FUpdateCount === 0) && (this.FOnChange != null)) {
        this.FOnChange(this);
      };
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FColor = 0;
      this.FName = $mod.ffMonospace;
      this.FSize = 16;
      this.FStyle = {};
      this.FUpdateCount = 0;
    };
    this.Assign = function (Source) {
      var VFont = null;
      if ((Source != null) && $mod.TFont.isPrototypeOf(Source)) {
        this.BeginUpdate();
        try {
          VFont = Source;
          this.FCharSet = VFont.FCharSet;
          this.FColor = VFont.FColor;
          this.FName = VFont.FName;
          this.FSize = VFont.FSize;
          this.FStyle = rtl.refSet(VFont.FStyle);
        } finally {
          this.EndUpdate();
        };
      } else {
        pas.Classes.TPersistent.Assign.call(this,Source);
      };
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) {
        this.FUpdateCount -= 1;
        if (this.FUpdateCount === 0) {
          this.Changed();
        };
      };
    };
    this.IsEqual = function (AFont) {
      var Result = false;
      if (AFont != null) {
        if (((((this.FCharSet !== AFont.FCharSet) || (this.FColor !== AFont.FColor)) || (this.FName !== AFont.FName)) || (this.FSize !== AFont.FSize)) || rtl.neSet(this.FStyle,AFont.FStyle)) {
          Result = false;
        } else {
          Result = true;
        };
      } else {
        Result = false;
      };
      return Result;
    };
    this.TextExtent = function (AText) {
      var Result = new pas.Types.TSize();
      Result = new pas.Types.TSize($mod.JSMeasureText(AText,this.FName,this.FSize,0));
      return Result;
    };
    this.TextSize = function (AText, W, H) {
      var VSize = new pas.Types.TSize();
      VSize = new pas.Types.TSize(this.TextExtent(AText));
      H.set(VSize.cy);
      W.set(VSize.cx);
    };
    this.TextHeight = function (AText) {
      var Result = 0;
      Result = this.TextExtent(AText).cy;
      return Result;
    };
    this.TextWidth = function (AText) {
      var Result = 0;
      Result = this.TextExtent(AText).cx;
      return Result;
    };
    var $r = this.$rtti;
    $r.addProperty("CharSet",2,$mod.$rtti["TFontCharSet"],"FCharSet","SetCharSet");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Height",3,rtl.nativeint,"GetHeight","SetHeight");
    $r.addProperty("Name",2,rtl.string,"FName","SetName");
    $r.addProperty("Size",2,rtl.nativeint,"FSize","SetSize");
    $r.addProperty("Style",2,$mod.$rtti["TFontStyles"],"FStyle","SetStyle");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
  });
  rtl.createClass($mod,"TPen",pas.Classes.TPersistent,function () {
    this.$init = function () {
      pas.Classes.TPersistent.$init.call(this);
      this.FColor = 0;
      this.FStyle = 0;
      this.FWidth = 0;
      this.FUpdateCount = 0;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FOnChange = undefined;
      pas.Classes.TPersistent.$final.call(this);
    };
    this.SetColor = function (AValue) {
      if (this.FColor !== AValue) {
        this.FColor = AValue;
        this.Changed();
      };
    };
    this.SetStyle = function (AValue) {
      if (this.FStyle !== AValue) {
        this.FStyle = AValue;
        this.Changed();
      };
    };
    this.SetWidth = function (AValue) {
      if (this.FWidth !== AValue) {
        this.FWidth = AValue;
        this.Changed();
      };
    };
    this.Changed = function () {
      if ((this.FUpdateCount === 0) && (this.FOnChange != null)) {
        this.FOnChange(this);
      };
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FColor = 0;
      this.FStyle = $mod.TPenStyle.psSolid;
      this.FWidth = 1;
      this.FUpdateCount = 0;
    };
    this.Assign = function (Source) {
      var VPen = null;
      if ((Source != null) && $mod.TPen.isPrototypeOf(Source)) {
        this.BeginUpdate();
        try {
          VPen = Source;
          this.FColor = VPen.FColor;
          this.FStyle = VPen.FStyle;
          this.FWidth = VPen.FWidth;
        } finally {
          this.EndUpdate();
        };
      } else {
        pas.Classes.TPersistent.Assign.call(this,Source);
      };
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) {
        this.FUpdateCount -= 1;
        if (this.FUpdateCount === 0) {
          this.Changed();
        };
      };
    };
    var $r = this.$rtti;
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Style",2,$mod.$rtti["TPenStyle"],"FStyle","SetStyle");
    $r.addProperty("Width",2,rtl.nativeint,"FWidth","SetWidth");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
  });
  rtl.createClass($mod,"TBrush",pas.Classes.TPersistent,function () {
    this.$init = function () {
      pas.Classes.TPersistent.$init.call(this);
      this.FColor = 0;
      this.FStyle = 0;
      this.FUpdateCount = 0;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FOnChange = undefined;
      pas.Classes.TPersistent.$final.call(this);
    };
    this.SetColor = function (AValue) {
      if (this.FColor !== AValue) {
        this.FColor = AValue;
        this.Changed();
      };
    };
    this.SetStyle = function (AValue) {
      if (this.FStyle === AValue) {
        this.FStyle = AValue;
        this.Changed();
      };
    };
    this.Changed = function () {
      if ((this.FUpdateCount === 0) && (this.FOnChange != null)) {
        this.FOnChange(this);
      };
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FColor = 16777215;
      this.FStyle = $mod.TBrushStyle.bsSolid;
      this.FUpdateCount = 0;
    };
    this.Assign = function (Source) {
      var VBrush = null;
      if ((Source != null) && $mod.TBrush.isPrototypeOf(Source)) {
        this.BeginUpdate();
        try {
          VBrush = Source;
          this.FColor = VBrush.FColor;
          this.FStyle = VBrush.FStyle;
        } finally {
          this.EndUpdate();
        };
      } else {
        pas.Classes.TPersistent.Assign.call(this,Source);
      };
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) {
        this.FUpdateCount -= 1;
        if (this.FUpdateCount === 0) {
          this.Changed();
        };
      };
    };
    var $r = this.$rtti;
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Style",2,$mod.$rtti["TBrushStyle"],"FStyle","SetStyle");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
  });
  rtl.createClass($mod,"TPicture",pas.Classes.TPersistent,function () {
    this.$init = function () {
      pas.Classes.TPersistent.$init.call(this);
      this.FData = "";
      this.FUpdateCount = 0;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FOnChange = undefined;
      pas.Classes.TPersistent.$final.call(this);
    };
    this.SetData = function (AValue) {
      if (this.FData !== AValue) {
        this.FData = AValue;
        this.Changed();
      };
    };
    this.Changed = function () {
      if ((this.FUpdateCount === 0) && (this.FOnChange != null)) {
        this.FOnChange(this);
      };
    };
    this.Create$1 = function () {
      this.FData = "";
      this.FUpdateCount = 0;
      this.FOnChange = null;
    };
    this.Assign = function (Source) {
      var VPicture = null;
      if ((Source != null) && $mod.TPicture.isPrototypeOf(Source)) {
        this.BeginUpdate();
        try {
          VPicture = Source;
          this.FData = VPicture.FData;
        } finally {
          this.EndUpdate();
        };
      } else {
        pas.Classes.TPersistent.Assign.call(this,Source);
      };
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) {
        this.FUpdateCount -= 1;
        if (this.FUpdateCount === 0) {
          this.Changed();
        };
      };
    };
    this.IsEqual = function (APicture) {
      var Result = false;
      if (APicture != null) {
        if (this === APicture) {
          Result = true;
          return Result;
        };
        if (this.FData !== APicture.FData) {
          Result = false;
        } else {
          Result = true;
        };
      } else {
        Result = false;
      };
      return Result;
    };
    var $r = this.$rtti;
    $r.addProperty("Data",2,rtl.string,"FData","SetData");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
  });
  rtl.createClass($mod,"TCanvas",pas.Classes.TPersistent,function () {
    this.$init = function () {
      pas.Classes.TPersistent.$init.call(this);
      this.FBrush = null;
      this.FFont = null;
      this.FPen = null;
      this.FUpdateCount = 0;
      this.FOnChange = null;
      this.FCanvasElement = null;
      this.FContextElement = null;
    };
    this.$final = function () {
      this.FBrush = undefined;
      this.FFont = undefined;
      this.FPen = undefined;
      this.FOnChange = undefined;
      this.FCanvasElement = undefined;
      this.FContextElement = undefined;
      pas.Classes.TPersistent.$final.call(this);
    };
    this.PrepareStyle = function () {
      this.FContextElement.fillStyle = $mod.JSColor(this.FBrush.FColor);
      this.FContextElement.lineWidth = this.FPen.FWidth;
      this.FContextElement.strokeStyle = $mod.JSColor(this.FPen.FColor);
      var $tmp1 = this.FPen.FStyle;
      if ($tmp1 === $mod.TPenStyle.psDash) {
        this.FContextElement.setLineDash([8,2])}
       else if ($tmp1 === $mod.TPenStyle.psDot) {
        this.FContextElement.setLineDash([1,2])}
       else {
        this.FContextElement.setLineDash([]);
      };
    };
    this.PrepareText = function () {
      this.FContextElement.font = $mod.JSFont(this.FFont);
      this.FContextElement.fillStyle = $mod.JSColor(this.FFont.FColor);
      this.FContextElement.textBaseline = "hanging";
    };
    this.Changed = function () {
      if ((this.FUpdateCount === 0) && (this.FOnChange != null)) {
        this.FOnChange(this);
      };
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FCanvasElement = document.createElement("canvas");
      this.FContextElement = this.FCanvasElement.getContext("2d");
      this.FBrush = $mod.TBrush.$create("Create$1");
      this.FFont = $mod.TFont.$create("Create$1");
      this.FPen = $mod.TPen.$create("Create$1");
      this.FUpdateCount = 0;
    };
    this.Destroy = function () {
      this.FBrush.$destroy("Destroy");
      this.FFont.$destroy("Destroy");
      this.FPen.$destroy("Destroy");
      this.FBrush = null;
      this.FFont = null;
      this.FPen = null;
      pas.System.TObject.Destroy.call(this);
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) {
        this.FUpdateCount -= 1;
        if (this.FUpdateCount === 0) {
          this.Changed();
        };
      };
    };
    this.Clear = function () {
      this.FContextElement.clearRect(0,0,this.FCanvasElement.width,this.FCanvasElement.height);
    };
    this.FillRect = function (ARect) {
      this.FillRect$1(ARect.Left,ARect.Top,ARect.Bottom - ARect.Top,ARect.Right - ARect.Left);
    };
    this.FillRect$1 = function (ALeft, ATop, AWidth, AHeight) {
      this.PrepareStyle();
      if (this.FBrush.FStyle !== $mod.TBrushStyle.bsClear) {
        this.FContextElement.fillRect(ALeft,ATop,AWidth,AHeight);
      };
    };
    this.LineTo = function (X, Y) {
      this.PrepareStyle();
      this.FContextElement.lineTo(X,Y);
      if (this.FPen.FStyle !== $mod.TPenStyle.psClear) {
        this.FContextElement.stroke();
      };
    };
    this.MoveTo = function (X, Y) {
      this.FContextElement.beginPath();
      this.FContextElement.moveTo(X,Y);
    };
    this.Rectangle = function (ARect) {
      this.Rectangle$1(ARect.Left,ARect.Top,ARect.Bottom - ARect.Top,ARect.Right - ARect.Left);
    };
    this.Rectangle$1 = function (ALeft, ATop, AWidth, AHeight) {
      this.FContextElement.beginPath();
      this.PrepareStyle();
      this.FContextElement.rect(ALeft,ATop,AWidth,AHeight);
      if (this.FBrush.FStyle !== $mod.TBrushStyle.bsClear) {
        this.FContextElement.fill();
      };
      if (this.FPen.FStyle !== $mod.TPenStyle.psClear) {
        this.FContextElement.stroke();
      };
    };
    this.TextOut = function (X, Y, AText) {
      this.PrepareText();
      if (this.FPen.FStyle !== $mod.TPenStyle.psClear) {
        this.FContextElement.fillText(AText,X,Y);
      };
    };
    this.TextExtent = function (AText) {
      var Result = new pas.Types.TSize();
      Result = new pas.Types.TSize($mod.JSMeasureText(AText,this.FFont.FName,this.FFont.FSize,0));
      return Result;
    };
    this.TextHeight = function (AText) {
      var Result = 0;
      Result = this.TextExtent(AText).cy;
      return Result;
    };
    this.TextWidth = function (AText) {
      var Result = 0;
      Result = this.TextExtent(AText).cx;
      return Result;
    };
    var $r = this.$rtti;
    $r.addProperty("Brush",0,$mod.$rtti["TBrush"],"FBrush","FBrush");
    $r.addProperty("Font",0,$mod.$rtti["TFont"],"FFont","FFont");
    $r.addProperty("Pen",0,$mod.$rtti["TPen"],"FPen","FPen");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
  });
  this.clBlack = 0x0;
  this.clMaroon = 0x80;
  this.clGreen = 0x8000;
  this.clOlive = 0x8080;
  this.clNavy = 0x800000;
  this.clPurple = 0x800080;
  this.clTeal = 0x808000;
  this.clGray = 0x808080;
  this.clSilver = 0xC0C0C0;
  this.clRed = 0xFF;
  this.clLime = 0xFF00;
  this.clYellow = 0xFFFF;
  this.clBlue = 0xFF0000;
  this.clFuchsia = 0xFF00FF;
  this.clAqua = 0xFFFF00;
  this.clLtGray = 0xC0C0C0;
  this.clDkGray = 0x808080;
  this.clWhite = 0xFFFFFF;
  this.clMoneyGreen = 0xC0DCC0;
  this.clSkyBlue = 0xF0CAA6;
  this.clCream = 0xF0FBFF;
  this.clMedGray = 0xA4A0A0;
  this.clNone = 0x1FFFFFFF;
  this.clDefault = 0x20000000;
  this.clBase = 0x80000000;
  this.clScrollBar = 2147483648 + 0;
  this.clBackground = 2147483648 + 1;
  this.clActiveCaption = 2147483648 + 2;
  this.clInactiveCaption = 2147483648 + 3;
  this.clMenu = 2147483648 + 4;
  this.clWindow = 2147483648 + 5;
  this.clWindowFrame = 2147483648 + 6;
  this.clMenuText = 2147483648 + 7;
  this.clWindowText = 2147483648 + 8;
  this.clCaptionText = 2147483648 + 9;
  this.clActiveBorder = 2147483648 + 10;
  this.clInactiveBorder = 2147483648 + 11;
  this.clAppWorkspace = 2147483648 + 12;
  this.clHighlight = 2147483648 + 13;
  this.clHighlightText = 2147483648 + 14;
  this.clBtnFace = 2147483648 + 15;
  this.clBtnShadow = 2147483648 + 16;
  this.clGrayText = 2147483648 + 17;
  this.clBtnText = 2147483648 + 18;
  this.clInactiveCaptionText = 2147483648 + 19;
  this.clBtnHighlight = 2147483648 + 20;
  this.cl3DDkShadow = 2147483648 + 21;
  this.cl3DLight = 2147483648 + 22;
  this.clInfoText = 2147483648 + 23;
  this.clInfoBk = 2147483648 + 24;
  this.clColorDesktop = 2147483649;
  this.cl3DFace = 2147483663;
  this.cl3DShadow = 2147483664;
  this.cl3DHiLight = 2147483668;
  this.clBtnHiLight = 2147483668;
  this.clFirstSpecialColor = 2147483668;
  this.clMask = 16777215;
  this.clDontMask = 0;
  this.ffMonospace = "Consolas, monaco, monospace";
  this.ffSans = '"Arial Narrow", Arial, "Helvetica Condensed", Helvetica, sans-serif';
  this.ffTimes = '"Times New Roman", Times, serif';
  this.JSColor = function (AColor) {
    var Result = "";
    var R = 0;
    var G = 0;
    var B = 0;
    var $tmp1 = AColor;
    if ($tmp1 === 2147483648) {
      Result = "Scrollbar"}
     else if ($tmp1 === 2147483649) {
      Result = "Background"}
     else if ($tmp1 === 2147483650) {
      Result = "ActiveCaption"}
     else if ($tmp1 === 2147483651) {
      Result = "InactiveCaption"}
     else if ($tmp1 === 2147483652) {
      Result = "Menu"}
     else if ($tmp1 === 2147483653) {
      Result = "Window"}
     else if ($tmp1 === 2147483654) {
      Result = "WindowFrame"}
     else if ($tmp1 === 2147483655) {
      Result = "MenuText"}
     else if ($tmp1 === 2147483656) {
      Result = "WindowText"}
     else if ($tmp1 === 2147483657) {
      Result = "CaptionText"}
     else if ($tmp1 === 2147483658) {
      Result = "ActiveBorder"}
     else if ($tmp1 === 2147483659) {
      Result = "InactiveBorder"}
     else if ($tmp1 === 2147483660) {
      Result = "AppWorkspace"}
     else if ($tmp1 === 2147483661) {
      Result = "Highlight"}
     else if ($tmp1 === 2147483662) {
      Result = "HighlightText"}
     else if ($tmp1 === 2147483663) {
      Result = "ButtonFace"}
     else if ($tmp1 === 2147483664) {
      Result = "ButtonShadow"}
     else if ($tmp1 === 2147483665) {
      Result = "GrayText"}
     else if ($tmp1 === 2147483666) {
      Result = "ButtonText"}
     else if ($tmp1 === 2147483667) {
      Result = "InactiveCaptionText"}
     else if ($tmp1 === 2147483668) {
      Result = "ButtonHighlight"}
     else if ($tmp1 === 2147483669) {
      Result = "ThreeDDarkShadow"}
     else if ($tmp1 === 2147483670) {
      Result = "ThreeDHighlight"}
     else if ($tmp1 === 2147483671) {
      Result = "InfoText"}
     else if ($tmp1 === 2147483672) {
      Result = "InfoBackground"}
     else {
      R = AColor & 0xFF;
      G = (AColor >>> 8) & 0xFF;
      B = (AColor >>> 16) & 0xFF;
      Result = (("#" + pas.SysUtils.IntToHex(R,2)) + pas.SysUtils.IntToHex(G,2)) + pas.SysUtils.IntToHex(B,2);
    };
    return Result;
  };
  this.JSFont = function (AFont) {
    var Result = "";
    Result = "";
    if (AFont != null) {
      if ($mod.TFontStyle.fsBold in AFont.FStyle) {
        Result = Result + "bold ";
      };
      if ($mod.TFontStyle.fsItalic in AFont.FStyle) {
        Result = Result + "italic ";
      };
      Result = ((Result + pas.SysUtils.IntToStr(AFont.FSize)) + "px ") + AFont.FName;
    };
    return Result;
  };
  this.JSMeasureText = function (AText, AFontName, AFontSize, AFixedWidth) {
    var Result = new pas.Types.TSize();
    var VDiv = null;
    Result = new pas.Types.TSize(pas.Types.Size(0,0));
    if (AText !== "") {
      VDiv = document.createElement("div");
      VDiv.style.setProperty("font-family",AFontName);
      VDiv.style.setProperty("font-size",pas.SysUtils.IntToStr(AFontSize) + "px");
      VDiv.style.setProperty("overflow","scroll");
      if (AFixedWidth === 0) {
        VDiv.style.setProperty("display","inline-block");
        VDiv.style.setProperty("white-space","nowrap");
      } else {
        VDiv.style.setProperty("max-width",pas.SysUtils.IntToStr(AFixedWidth) + "px");
        VDiv.style.setProperty("width",pas.SysUtils.IntToStr(AFixedWidth) + "px");
      };
      VDiv.innerHTML = AText;
      document.body.appendChild(VDiv);
      Result = new pas.Types.TSize(pas.Types.Size(VDiv.scrollWidth,VDiv.scrollHeight));
      document.body.removeChild(VDiv);
    };
    return Result;
  };
});
rtl.module("Forms",["System","Classes","SysUtils","Types","JS","Web","Graphics","Controls"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.TFormType = {"0": "ftModalForm", ftModalForm: 0, "1": "ftWindow", ftWindow: 1};
  $mod.$rtti.$Enum("TFormType",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TFormType});
  this.TCloseAction = {"0": "caNone", caNone: 0, "1": "caHide", caHide: 1, "2": "caFree", caFree: 2};
  $mod.$rtti.$Enum("TCloseAction",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TCloseAction});
  $mod.$rtti.$MethodVar("TCloseEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["CloseAction",$mod.$rtti["TCloseAction"],1]]), methodkind: 0});
  $mod.$rtti.$MethodVar("TCloseQueryEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["CanClose",rtl.boolean,1]]), methodkind: 0});
  $mod.$rtti.$Int("TModalResult",{minvalue: -2147483648, maxvalue: 2147483647, ordtype: 4});
  $mod.$rtti.$RefToProcVar("TModalResultProc",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["ModalResult",$mod.$rtti["TModalResult"]]])});
  rtl.createClass($mod,"TCustomDataModule",pas.Controls.TControl,function () {
    this.$init = function () {
      pas.Controls.TControl.$init.call(this);
      this.FOldOrder = false;
      this.FOnCreate = null;
      this.FOnDestroy = null;
    };
    this.$final = function () {
      this.FOnCreate = undefined;
      this.FOnDestroy = undefined;
      pas.Controls.TControl.$final.call(this);
    };
    this.DoCreate = function () {
      if (this.FOnCreate != null) {
        this.FOnCreate(this);
      };
    };
    this.DoDestroy = function () {
      if (this.FOnDestroy != null) {
        this.FOnDestroy(this);
      };
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("visibility","hidden");
        $with1.style.setProperty("display","none");
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 150;
      Result.cy = 150;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.BeginUpdate();
      try {
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.AfterConstruction = function () {
      pas.System.TObject.AfterConstruction.call(this);
      $mod.Application().RegisterModule(this);
      this.Loaded();
      this.DoCreate();
    };
    this.BeforeDestruction = function () {
      pas.Classes.TComponent.BeforeDestruction.call(this);
      $mod.Application().UnRegisterModule(this);
      this.DoDestroy();
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TCustomFrame",pas.Controls.TCustomControl,function () {
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("outline","none");
        $with1.style.setProperty("overflow","auto");
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 320;
      Result.cy = 240;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.BeginUpdate();
      try {
        this.SetParentFont(false);
        this.SetParentShowHint(false);
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.AfterConstruction = function () {
      pas.System.TObject.AfterConstruction.call(this);
      this.Loaded();
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  $mod.$rtti.$ClassRef("TCustomFrameClass",{instancetype: $mod.$rtti["TCustomFrame"]});
  rtl.createClass($mod,"TCustomForm",pas.Controls.TCustomControl,function () {
    this.$init = function () {
      pas.Controls.TCustomControl.$init.call(this);
      this.FActiveControl = null;
      this.FAlphaBlend = false;
      this.FAlphaBlendValue = 0;
      this.FChildForm = null;
      this.FFormType = 0;
      this.FKeyPreview = false;
      this.FModalResult = 0;
      this.FModalResultProc = null;
      this.FOverlay = null;
      this.FOnActivate = null;
      this.FOnClose = null;
      this.FOnCloseQuery = null;
      this.FOnCreate = null;
      this.FOnDeactivate = null;
      this.FOnDestroy = null;
      this.FOnHide = null;
      this.FOnResize$1 = null;
      this.FOnScroll$1 = null;
      this.FOnShow = null;
    };
    this.$final = function () {
      this.FActiveControl = undefined;
      this.FChildForm = undefined;
      this.FModalResultProc = undefined;
      this.FOverlay = undefined;
      this.FOnActivate = undefined;
      this.FOnClose = undefined;
      this.FOnCloseQuery = undefined;
      this.FOnCreate = undefined;
      this.FOnDeactivate = undefined;
      this.FOnDestroy = undefined;
      this.FOnHide = undefined;
      this.FOnResize$1 = undefined;
      this.FOnScroll$1 = undefined;
      this.FOnShow = undefined;
      pas.Controls.TCustomControl.$final.call(this);
    };
    this.SetActiveControl = function (AValue) {
      if (this.FActiveControl !== AValue) {
        this.FActiveControl = AValue;
      };
    };
    this.SetAlphaBlend = function (AValue) {
      if (this.FAlphaBlend !== AValue) {
        this.FAlphaBlend = AValue;
        this.Changed();
      };
    };
    this.SetAlphaBlendValue = function (AValue) {
      if (this.FAlphaBlendValue !== AValue) {
        this.FAlphaBlendValue = AValue;
        this.Changed();
      };
    };
    this.SetModalResult = function (AValue) {
      if (this.FModalResult !== AValue) {
        this.FModalResult = AValue;
        if ((this.FModalResult !== 0) && (this.FModalResultProc != null)) {
          this.Close();
        };
      };
    };
    this.Activate = function () {
      if (this.FOnActivate != null) {
        this.FOnActivate(this);
      };
    };
    this.Deactivate = function () {
      if (this.FOnDeactivate != null) {
        this.FOnDeactivate(this);
      };
    };
    this.DoClose = function (CloseAction) {
      if (this.FOnDeactivate != null) {
        this.FOnDeactivate(this);
      };
    };
    this.DoCreate = function () {
      if (this.FOnCreate != null) {
        this.FOnCreate(this);
      };
    };
    this.DoDestroy = function () {
      if (this.FOnDestroy != null) {
        this.FOnDestroy(this);
      };
    };
    this.DoHide = function () {
      if (this.FOnHide != null) {
        this.FOnHide(this);
      };
    };
    this.DoResize = function () {
      pas.Controls.TControl.DoResize.call(this);
      if (this.FOnResize$1 != null) {
        this.FOnResize$1(this);
      };
    };
    this.DoShow = function () {
      if (this.FOnShow != null) {
        this.FOnShow(this);
      };
    };
    this.HandleEnter = function (AEvent) {
      var Result = false;
      var VControl = null;
      Result = pas.Controls.TWinControl.HandleEnter.call(this,AEvent);
      if ((this.FChildForm != null) && (this.FChildForm.FFormType === $mod.TFormType.ftModalForm)) {
        this.FChildForm.Show();
      } else {
        if (this.FActiveControl != null) {
          VControl = this.FActiveControl;
        } else {
          VControl = this.FindFocusControl(null,pas.Controls.TFocusSearchDirection.fsdFirst);
        };
        this.FocusControl(VControl);
        this.Activate();
      };
      return Result;
    };
    this.HandleExit = function (AEvent) {
      var Result = false;
      Result = pas.Controls.TWinControl.HandleExit.call(this,AEvent);
      this.Deactivate();
      return Result;
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("outline","none");
        if (this.FAlphaBlend) {
          $with1.style.setProperty("opacity",pas.SysUtils.FloatToStr(Math.floor(this.FAlphaBlendValue / 255)));
        } else {
          $with1.style.removeProperty("opacity");
        };
        $with1.style.setProperty("overflow","auto");
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 320;
      Result.cy = 240;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FActiveControl = null;
      this.FAlphaBlend = false;
      this.FAlphaBlendValue = 255;
      this.FChildForm = null;
      this.FFormType = $mod.TFormType.ftWindow;
      this.FKeyPreview = false;
      this.FModalResult = 0;
      this.FModalResultProc = null;
      this.FOverlay = null;
      this.BeginUpdate();
      try {
        this.SetColor(16777215);
        this.SetParentFont(false);
        this.SetParentShowHint(false);
        this.SetVisible(false);
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.Destroy = function () {
      this.FActiveControl = null;
      this.FChildForm = null;
      pas.Controls.TCustomControl.Destroy.call(this);
    };
    this.AfterConstruction = function () {
      pas.System.TObject.AfterConstruction.call(this);
      $mod.Application().UpdateMainForm(this);
      $mod.Application().RegisterModule(this);
      this.Loaded();
      this.DoCreate();
    };
    this.BeforeDestruction = function () {
      pas.Classes.TComponent.BeforeDestruction.call(this);
      $mod.Application().UnRegisterModule(this);
      this.DoDestroy();
    };
    this.Close = function () {
      var VAction = 0;
      var VIndex = 0;
      var VOwnerForm = null;
      var VModule = null;
      if (this.CloseQuery()) {
        VAction = $mod.TCloseAction.caHide;
        this.DoClose({get: function () {
            return VAction;
          }, set: function (v) {
            VAction = v;
          }});
        if (VAction !== $mod.TCloseAction.caNone) {
          if ($mod.Application().FMainForm === this) {
            $mod.Application().Terminate();
          } else {
            this.Hide();
            if (this.FFormType === $mod.TFormType.ftModalForm) {
              if ((this.FOwner != null) && $mod.TCustomForm.isPrototypeOf(this.FOwner)) {
                VOwnerForm = this.FOwner;
                VOwnerForm.FChildForm = null;
                if (VOwnerForm.FOverlay != null) {
                  VOwnerForm.FOverlay.$destroy("Destroy");
                  VOwnerForm.FOverlay = null;
                };
                VOwnerForm.Show();
              };
              if (this.FModalResultProc != null) {
                this.FModalResultProc(this,this.FModalResult);
              };
            } else {
              for (var $l1 = $mod.Application().GetModuleCount() - 1; $l1 >= 0; $l1--) {
                VIndex = $l1;
                VModule = $mod.Application().GetModule(VIndex);
                if ((((VModule != null) && VModule.FVisible) && (VModule !== this)) && VModule.$class.InheritsFrom($mod.TCustomForm)) {
                  VModule.Show();
                  return;
                };
              };
              if ($mod.Application().FMainForm != null) {
                $mod.Application().FMainForm.Show();
              };
            };
          };
        };
      };
    };
    this.CloseQuery = function () {
      var Result = false;
      Result = true;
      if (this.FOnCloseQuery != null) {
        this.FOnCloseQuery(this,{get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }});
      };
      return Result;
    };
    this.FocusControl = function (AControl) {
      if ((AControl != null) && AControl.CanSetFocus()) {
        AControl.SetFocus();
      };
    };
    this.Hide = function () {
      this.SetVisible(false);
      this.DoHide();
    };
    this.Loaded = function () {
      pas.Classes.TComponent.Loaded.call(this);
    };
    this.Resize = function () {
      var VHeight = 0;
      var VLeft = 0;
      var VTop = 0;
      var VWidth = 0;
      var VWindowHeight = 0;
      var VWindowWidth = 0;
      VWindowWidth = window.innerWidth;
      VWindowHeight = window.innerHeight;
      var $tmp1 = this.FFormType;
      if ($tmp1 === $mod.TFormType.ftModalForm) {
        VWidth = this.FWidth;
        VHeight = this.FHeight;
        VLeft = Math.floor((VWindowWidth - VWidth) / 2);
        VTop = Math.floor((VWindowHeight - VHeight) / 2);
        this.SetBounds(VLeft,VTop,VWidth,VHeight);
      } else if ($tmp1 === $mod.TFormType.ftWindow) {
        this.SetBounds(0,0,VWindowWidth,VWindowHeight);
      };
      this.DoResize();
    };
    this.Show = function () {
      $mod.Application().FActiveForm = this;
      $mod.Application().SetTitle(this.GetText());
      this.BeginUpdate();
      try {
        this.SetVisible(true);
        this.Resize();
      } finally {
        this.EndUpdate();
      };
      this.BringToFront();
      this.SetFocus();
      this.DoShow();
    };
    this.ShowModal = function (AModalResultProc) {
      var VForm = null;
      if (!(this.FOwner != null)) {
        throw new Error("Owner not found.");
      };
      if (!$mod.TCustomForm.isPrototypeOf(this.FOwner)) {
        throw new Error("Invalid owner.");
      };
      VForm = this.FOwner;
      if (VForm.FChildForm != null) {
        throw new Error("Modal form already exists.");
      };
      VForm.FChildForm = this;
      VForm.FOverlay = $impl.TOverlay.$create("Create$1",[VForm]);
      this.FFormType = $mod.TFormType.ftModalForm;
      this.FModalResult = 0;
      if (AModalResultProc != null) {
        this.FModalResultProc = AModalResultProc;
      } else {
        this.FModalResultProc = $impl.DefaultModalProc;
      };
      this.Show();
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  $mod.$rtti.$ClassRef("TCustomFormClass",{instancetype: $mod.$rtti["TCustomForm"]});
  rtl.createClass($mod,"TApplication",pas.Classes.TComponent,function () {
    this.$init = function () {
      pas.Classes.TComponent.$init.call(this);
      this.FModules = null;
      this.FActiveForm = null;
      this.FMainForm = null;
      this.FStopOnException = false;
      this.FTerminated = false;
      this.FTitle = "";
      this.FOnResize = null;
      this.FOnUnload = null;
    };
    this.$final = function () {
      this.FModules = undefined;
      this.FActiveForm = undefined;
      this.FMainForm = undefined;
      this.FOnResize = undefined;
      this.FOnUnload = undefined;
      pas.Classes.TComponent.$final.call(this);
    };
    this.GetApplicatioName = function () {
      var Result = "";
      Result = window.location.pathname;
      return Result;
    };
    this.GetModule = function (AIndex) {
      var Result = null;
      Result = rtl.getObject(this.FModules[AIndex]);
      return Result;
    };
    this.GetModuleCount = function () {
      var Result = 0;
      Result = this.FModules.length;
      return Result;
    };
    this.GetModuleIndex = function (AModule) {
      var Result = 0;
      Result = this.FModules.indexOf(AModule);
      return Result;
    };
    this.GetTitle = function () {
      var Result = "";
      Result = this.FTitle;
      return Result;
    };
    this.SetTitle = function (AValue) {
      if (this.FTitle !== AValue) {
        this.FTitle = AValue;
        document.title = this.FTitle;
      };
    };
    this.DoResize = function () {
      if (this.FOnResize != null) {
        this.FOnResize(this);
      };
    };
    this.DoUnload = function () {
      if (this.FOnUnload != null) {
        this.FOnUnload(this);
      };
    };
    this.LoadIcon = function () {
      var $with1 = document.head.appendChild(document.createElement("link"));
      $with1.setAttribute("rel","icon");
      $with1.setAttribute("type","image\/icon");
      $with1.setAttribute("href",this.GetApplicatioName().replace("html","ico"));
    };
    this.RegisterHandleEvents = function () {
      window.addEventListener("error",rtl.createCallback(this,"HandleError"));
      window.addEventListener("resize",rtl.createCallback(this,"HandleResize"));
      window.addEventListener("unload",rtl.createCallback(this,"HandleUnload"));
    };
    this.UnRegisterHandleEvents = function () {
      window.removeEventListener("error",rtl.createCallback(this,"HandleError"));
      window.removeEventListener("resize",rtl.createCallback(this,"HandleResize"));
      window.removeEventListener("unload",rtl.createCallback(this,"HandleUnload"));
    };
    var CLE = pas.System.LineEnding;
    var CError = (((("Error Message: %s " + CLE) + "Line Nro: %d ") + CLE) + "Column Nro: %d ") + CLE;
    this.HandleError = function (AEvent) {
      var Result = false;
      if (AEvent.message.toLowerCase().indexOf("script error",0) > -1) {
        window.alert("Script Error: See Browser Console for Detail");
      } else {
        window.alert(pas.SysUtils.Format(CError,[AEvent.message,AEvent.lineno,AEvent.colno]));
      };
      if (this.FStopOnException) {
        this.Terminate();
      };
      AEvent.stopPropagation();
      Result = false;
      return Result;
    };
    this.HandleResize = function (AEvent) {
      var Result = false;
      var VControl = null;
      var VIndex = 0;
      AEvent.stopPropagation();
      this.DoResize();
      Result = true;
      for (var $l1 = 0, $end2 = this.FModules.length - 1; $l1 <= $end2; $l1++) {
        VIndex = $l1;
        VControl = rtl.getObject(this.FModules[VIndex]);
        if (((VControl != null) && VControl.FVisible) && VControl.$class.InheritsFrom($mod.TCustomForm)) {
          VControl.Resize();
        };
      };
      return Result;
    };
    this.HandleUnload = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      Result = true;
      try {
        this.DoUnload();
      } finally {
        this.Terminate();
      };
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Classes.TComponent.Create$1.call(this,AOwner);
      this.FModules = new Array();
      this.FMainForm = null;
      this.FStopOnException = true;
      this.FTerminated = false;
      this.FTitle = "";
    };
    this.Destroy = function () {
      this.FModules.length = 0;
      pas.Classes.TComponent.Destroy.call(this);
    };
    this.CreateForm = function (AInstanceClass, AReference) {
      try {
        AReference.set(AInstanceClass.$create("Create$1",[this]));
      } catch ($e) {
        if (pas.SysUtils.Exception.isPrototypeOf($e)) {
          var E = $e;
          AReference.set(null);
        } else throw $e
      };
    };
    this.Initialize = function () {
    };
    this.Run = function () {
      this.RegisterHandleEvents();
      this.LoadIcon();
      if (this.FMainForm != null) {
        this.FMainForm.Show();
      };
    };
    this.Terminate = function () {
      var VModule = null;
      var VIndex = 0;
      if (!this.FTerminated) {
        this.UnRegisterHandleEvents();
        this.FTerminated = true;
        for (var $l1 = this.FModules.length - 1; $l1 >= 0; $l1--) {
          VIndex = $l1;
          VModule = rtl.getObject(this.FModules[VIndex]);
          if (VModule != null) {
            VModule.$destroy("Destroy");
            VModule = null;
          };
        };
      };
    };
    this.UpdateMainForm = function (AForm) {
      if (!(this.FMainForm != null)) {
        this.FMainForm = AForm;
        this.FActiveForm = AForm;
      };
    };
    this.RegisterModule = function (AModule) {
      if (AModule != null) {
        if (this.FModules.indexOf(AModule) === -1) {
          this.FModules.push(AModule);
          if (!document.body.contains(AModule.FHandleElement)) {
            document.body.appendChild(AModule.FHandleElement);
          };
        };
      };
    };
    this.UnRegisterModule = function (AModule) {
      var VIndex = 0;
      if (AModule != null) {
        VIndex = this.FModules.indexOf(AModule);
        if (VIndex >= 0) {
          this.FModules.splice(VIndex,1);
          if (document.body.contains(AModule.FHandleElement)) {
            document.body.removeChild(AModule.FHandleElement);
          };
        };
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  this.Application = function () {
    var Result = null;
    if (!($impl.VAppInstance != null)) {
      $impl.VAppInstance = $mod.TApplication.$create("Create$1",[null]);
    };
    Result = $impl.VAppInstance;
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.DefaultModalProc = function (Sender, ModalResult) {
    if (Sender != null) {
      Sender.$destroy("Destroy");
      Sender = null;
    };
  };
  $impl.VAppInstance = null;
  rtl.createClass($impl,"TOverlay",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FForm = null;
      this.FHandleElement = null;
    };
    this.$final = function () {
      this.FForm = undefined;
      this.FHandleElement = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function (AForm) {
      this.FForm = AForm;
      if (this.FForm != null) {
        this.FHandleElement = document.createElement("div");
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("left","0px");
        $with1.style.setProperty("top","0px");
        $with1.style.setProperty("height","100%");
        $with1.style.setProperty("width","100%");
        $with1.style.setProperty("background","rgba(0, 0, 0, 0.6)");
        $with1.style.setProperty("position","absolute");
        $with1.style.setProperty("overflow","hidden");
        this.FForm.FHandleElement.appendChild(this.FHandleElement);
      };
    };
    this.Destroy = function () {
      if (this.FForm != null) {
        this.FForm.FHandleElement.removeChild(this.FHandleElement);
      };
      pas.System.TObject.Destroy.call(this);
    };
  });
});
rtl.module("Controls",["System","Classes","SysUtils","Types","JS","Web","Math","Graphics"],function () {
  "use strict";
  var $mod = this;
  this.mrNone = 0;
  this.mrOk = 0 + 1;
  this.mrCancel = 0 + 2;
  this.mrAbort = 0 + 3;
  this.mrRetry = 0 + 4;
  this.mrIgnore = 0 + 5;
  this.mrYes = 0 + 6;
  this.mrNo = 0 + 7;
  this.mrAll = 0 + 8;
  this.mrNoToAll = 0 + 9;
  this.mrYesToAll = 0 + 10;
  this.mrClose = 0 + 11;
  this.mrLast = 11;
  this.ModalResultStr = ["mrNone","mrOk","mrCancel","mrAbort","mrRetry","mrIgnore","mrYes","mrNo","mrAll","mrNoToAll","mrYesToAll","mrClose"];
  this.crDefault = 0;
  this.crNone = -1;
  this.crArrow = -2;
  this.crCross = -3;
  this.crIBeam = -4;
  this.crSize = -22;
  this.crSizeNESW = -6;
  this.crSizeNS = -7;
  this.crSizeNWSE = -8;
  this.crSizeWE = -9;
  this.crSizeNW = -23;
  this.crSizeN = -24;
  this.crSizeNE = -25;
  this.crSizeW = -26;
  this.crSizeE = -27;
  this.crSizeSW = -28;
  this.crSizeS = -29;
  this.crSizeSE = -30;
  this.crUpArrow = -10;
  this.crHourGlass = -11;
  this.crDrag = -12;
  this.crNoDrop = -13;
  this.crHSplit = -14;
  this.crVSplit = -15;
  this.crMultiDrag = -16;
  this.crSQLWait = -17;
  this.crNo = -18;
  this.crAppStart = -19;
  this.crHelp = -20;
  this.crHandPoint = -21;
  $mod.$rtti.$Class("TWinControl");
  $mod.$rtti.$ClassRef("TWinControlClass",{instancetype: $mod.$rtti["TWinControl"]});
  $mod.$rtti.$Class("TControl");
  $mod.$rtti.$ClassRef("TControlClass",{instancetype: $mod.$rtti["TControl"]});
  this.TAlign = {"0": "alNone", alNone: 0, "1": "alTop", alTop: 1, "2": "alBottom", alBottom: 2, "3": "alLeft", alLeft: 3, "4": "alRight", alRight: 4, "5": "alClient", alClient: 5, "6": "alCustomd", alCustomd: 6};
  $mod.$rtti.$Enum("TAlign",{minvalue: 0, maxvalue: 6, ordtype: 1, enumtype: this.TAlign});
  $mod.$rtti.$Set("TAlignSet",{comptype: $mod.$rtti["TAlign"]});
  this.TBevelCut = {"0": "bvNone", bvNone: 0, "1": "bvLowered", bvLowered: 1, "2": "bvRaised", bvRaised: 2, "3": "bvSpace", bvSpace: 3};
  $mod.$rtti.$Enum("TBevelCut",{minvalue: 0, maxvalue: 3, ordtype: 1, enumtype: this.TBevelCut});
  this.TFormBorderStyle = {"0": "bsNone", bsNone: 0, "1": "bsSingle", bsSingle: 1, "2": "bsSizeable", bsSizeable: 2, "3": "bsDialog", bsDialog: 3, "4": "bsToolWindow", bsToolWindow: 4, "5": "bsSizeToolWin", bsSizeToolWin: 5};
  $mod.$rtti.$Enum("TFormBorderStyle",{minvalue: 0, maxvalue: 5, ordtype: 1, enumtype: this.TFormBorderStyle});
  $mod.$rtti.$Enum("TBorderStyle",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TFormBorderStyle});
  $mod.$rtti.$inherited("TCaption",rtl.string,{});
  $mod.$rtti.$Int("TCursor",{minvalue: -32768, maxvalue: 32767, ordtype: 2});
  rtl.createClass($mod,"TControlCanvas",pas.Graphics.TCanvas,function () {
    this.$init = function () {
      pas.Graphics.TCanvas.$init.call(this);
      this.FControl = null;
      this.FHeight = 0;
      this.FWidth = 0;
    };
    this.$final = function () {
      this.FControl = undefined;
      pas.Graphics.TCanvas.$final.call(this);
    };
    this.SetHeight = function (AValue) {
      if (this.FHeight !== AValue) {
        this.FHeight = AValue;
        this.FCanvasElement.height = this.FHeight;
      };
    };
    this.SetWidth = function (AValue) {
      if (this.FWidth !== AValue) {
        this.FWidth = AValue;
        this.FCanvasElement.width = this.FWidth;
      };
    };
    this.Create$2 = function (AControl) {
      pas.Graphics.TCanvas.Create$1.call(this);
      if (AControl != null) {
        this.SetHeight(AControl.FHeight);
        this.SetWidth(AControl.FWidth);
        this.FFont.Assign(AControl.FFont);
        this.FBrush.SetColor(AControl.FColor);
        this.FPen.SetColor(AControl.FFont.FColor);
        this.FControl = AControl;
        this.FControl.FHandleElement.insertBefore(this.FCanvasElement,AControl.FHandleElement.firstChild);
        this.FControl.Invalidate();
      };
    };
  });
  this.TShiftStateEnum = {"0": "ssShift", ssShift: 0, "1": "ssAlt", ssAlt: 1, "2": "ssCtrl", ssCtrl: 2, "3": "ssLeft", ssLeft: 3, "4": "ssRight", ssRight: 4, "5": "ssMIDdle", ssMIDdle: 5, "6": "ssDouble", ssDouble: 6};
  $mod.$rtti.$Enum("TShiftStateEnum",{minvalue: 0, maxvalue: 6, ordtype: 1, enumtype: this.TShiftStateEnum});
  $mod.$rtti.$Set("TShiftState",{comptype: $mod.$rtti["TShiftStateEnum"]});
  $mod.$rtti.$MethodVar("TKeyEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["Key",rtl.nativeint,1],["Shift",$mod.$rtti["TShiftState"]]]), methodkind: 0});
  $mod.$rtti.$MethodVar("TKeyPressEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["Key",rtl.char,1]]), methodkind: 0});
  this.TMouseButton = {"0": "mbLeft", mbLeft: 0, "1": "mbRight", mbRight: 1, "2": "mbMiddle", mbMiddle: 2};
  $mod.$rtti.$Enum("TMouseButton",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TMouseButton});
  $mod.$rtti.$MethodVar("TMouseEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["Button",$mod.$rtti["TMouseButton"]],["Shift",$mod.$rtti["TShiftState"]],["X",rtl.nativeint],["Y",rtl.nativeint]]), methodkind: 0});
  $mod.$rtti.$MethodVar("TMouseMoveEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["Shift",$mod.$rtti["TShiftState"]],["X",rtl.nativeint],["Y",rtl.nativeint]]), methodkind: 0});
  $mod.$rtti.$MethodVar("TMouseWheelEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["Shift",$mod.$rtti["TShiftState"]],["WheelDelta",rtl.nativeint],["MousePos",pas.Types.$rtti["TPoint"]],["Handled",rtl.boolean,1]]), methodkind: 0});
  this.TFocusSearchDirection = {"0": "fsdFirst", fsdFirst: 0, "1": "fsdLast", fsdLast: 1, "2": "fsdNext", fsdNext: 2, "3": "fsdPrev", fsdPrev: 3};
  $mod.$rtti.$Enum("TFocusSearchDirection",{minvalue: 0, maxvalue: 3, ordtype: 1, enumtype: this.TFocusSearchDirection});
  rtl.createClass($mod,"TControlBorderSpacing",pas.Classes.TPersistent,function () {
    this.$init = function () {
      pas.Classes.TPersistent.$init.call(this);
      this.FAround = 0;
      this.FBottom = 0;
      this.FLeft = 0;
      this.FRight = 0;
      this.FTop = 0;
      this.FUpdateCount = 0;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FOnChange = undefined;
      pas.Classes.TPersistent.$final.call(this);
    };
    this.SetAround = function (AValue) {
      if (this.FAround !== AValue) {
        this.FAround = AValue;
        this.Changed();
      };
    };
    this.SetBottom = function (AValue) {
      if (this.FBottom !== AValue) {
        this.FBottom = AValue;
        this.Changed();
      };
    };
    this.SetLeft = function (AValue) {
      if (this.FLeft !== AValue) {
        this.FLeft = AValue;
        this.Changed();
      };
    };
    this.SetRight = function (AValue) {
      if (this.FRight !== AValue) {
        this.FRight = AValue;
        this.Changed();
      };
    };
    this.SetTop = function (AValue) {
      if (this.FTop !== AValue) {
        this.FTop = AValue;
        this.Changed();
      };
    };
    this.Changed = function () {
      if ((this.FUpdateCount === 0) && (this.FOnChange != null)) {
        this.FOnChange(this);
      };
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FBottom = 0;
      this.FLeft = 0;
      this.FRight = 0;
      this.FTop = 0;
      this.FUpdateCount = 0;
    };
    this.Assign = function (Source) {
      var VSpacing = null;
      if ((Source != null) && $mod.TControlBorderSpacing.isPrototypeOf(Source)) {
        this.BeginUpdate();
        try {
          VSpacing = Source;
          this.FAround = VSpacing.FAround;
          this.FBottom = VSpacing.FBottom;
          this.FLeft = VSpacing.FLeft;
          this.FRight = VSpacing.FRight;
          this.FTop = VSpacing.FTop;
        } finally {
          this.EndUpdate();
        };
      } else {
        pas.Classes.TPersistent.Assign.call(this,Source);
      };
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) {
        this.FUpdateCount -= 1;
        if (this.FUpdateCount === 0) {
          this.Changed();
        };
      };
    };
  });
  rtl.createClass($mod,"TControl",pas.Classes.TComponent,function () {
    this.$init = function () {
      pas.Classes.TComponent.$init.call(this);
      this.FAlign = 0;
      this.FAutoSize = false;
      this.FBorderSpacing = null;
      this.FBorderStyle = $mod.TFormBorderStyle.bsNone;
      this.FCaption = "";
      this.FColor = 0;
      this.FControls = null;
      this.FCursor = 0;
      this.FEnabled = false;
      this.FFont = null;
      this.FHandleClass = "";
      this.FHandleElement = null;
      this.FHandleId = "";
      this.FHeight = 0;
      this.FHint = "";
      this.FLeft = 0;
      this.FParent = null;
      this.FParentColor = false;
      this.FParentFont = false;
      this.FParentShowHint = false;
      this.FShowHint = false;
      this.FTabOrder = 0;
      this.FTabStop = false;
      this.FTop = 0;
      this.FUpdateCount = 0;
      this.FVisible = false;
      this.FWidth = 0;
      this.FOnClick = null;
      this.FOnDblClick = null;
      this.FOnMouseDown = null;
      this.FOnMouseEnter = null;
      this.FOnMouseLeave = null;
      this.FOnMouseMove = null;
      this.FOnMouseUp = null;
      this.FOnMouseWheel = null;
      this.FOnResize = null;
      this.FOnScroll = null;
    };
    this.$final = function () {
      this.FBorderSpacing = undefined;
      this.FControls = undefined;
      this.FFont = undefined;
      this.FHandleElement = undefined;
      this.FParent = undefined;
      this.FOnClick = undefined;
      this.FOnDblClick = undefined;
      this.FOnMouseDown = undefined;
      this.FOnMouseEnter = undefined;
      this.FOnMouseLeave = undefined;
      this.FOnMouseMove = undefined;
      this.FOnMouseUp = undefined;
      this.FOnMouseWheel = undefined;
      this.FOnResize = undefined;
      this.FOnScroll = undefined;
      pas.Classes.TComponent.$final.call(this);
    };
    this.GetClientHeight = function () {
      var Result = 0;
      Result = this.GetClientRect().Bottom;
      return Result;
    };
    this.GetClientOrigin = function () {
      var Result = new pas.Types.TPoint();
      if (this.FParent != null) {
        Result = new pas.Types.TPoint(this.FParent.GetClientOrigin());
        Result.x += this.FLeft;
        Result.y += this.FTop;
      } else {
        throw new Error(pas.SysUtils.Format("Control '%s' has no parent window",[this.FName]));
      };
      return Result;
    };
    this.GetClientRect = function () {
      var Result = new pas.Types.TRect();
      Result = new pas.Types.TRect(pas.Types.Rect(0,0,this.FWidth,this.FHeight));
      return Result;
    };
    this.GetClientWidth = function () {
      var Result = 0;
      Result = this.GetClientRect().Right;
      return Result;
    };
    this.GetText = function () {
      var Result = "";
      Result = this.RealGetText();
      return Result;
    };
    this.SetAlign = function (AValue) {
      if (this.FAlign !== AValue) {
        this.FAlign = AValue;
        this.ReAlign();
      };
    };
    this.SetAutoSize = function (AValue) {
      if (this.FAutoSize !== AValue) {
        this.FAutoSize = AValue;
        if (this.FAutoSize) {
          this.AdjustSize();
        };
      };
    };
    this.SetBorderSpacing = function (AValue) {
      this.FBorderSpacing.Assign(AValue);
    };
    this.SetBorderStyle = function (AValue) {
      if (this.FBorderStyle !== AValue) {
        this.FBorderStyle = AValue;
        this.Changed();
      };
    };
    this.SetClientSize = function (AValue) {
      var VClient = new pas.Types.TRect();
      VClient = new pas.Types.TRect(this.GetClientRect());
      this.SetBounds(this.FLeft,this.FTop,(this.FWidth - VClient.Right) + AValue.x,(this.FHeight - VClient.Bottom) + AValue.y);
    };
    this.SetClientHeight = function (AValue) {
      this.SetClientSize(new pas.Types.TPoint(pas.Types.Point(this.GetClientWidth(),AValue)));
    };
    this.SetClientWidth = function (AValue) {
      this.SetClientSize(new pas.Types.TPoint(pas.Types.Point(AValue,this.GetClientHeight())));
    };
    this.SetColor = function (AValue) {
      if (this.FColor !== AValue) {
        this.FColor = AValue;
        this.FParentColor = false;
        this.ColorChanged(this);
      };
    };
    this.SetCursor = function (AValue) {
      if (this.FCursor !== AValue) {
        this.FCursor = AValue;
        this.Changed();
      };
    };
    this.SetEnabled = function (AValue) {
      if (this.FEnabled !== AValue) {
        this.FEnabled = AValue;
        this.Changed();
      };
    };
    this.SetFont = function (AValue) {
      if (!this.FFont.IsEqual(AValue)) {
        this.FFont.Assign(AValue);
      };
    };
    this.SetHandleClass = function (AValue) {
      if (this.FHandleClass !== AValue) {
        this.FHandleClass = AValue;
        this.Changed();
      };
    };
    this.SetHandleId = function (AValue) {
      if (this.FHandleId !== AValue) {
        this.FHandleId = AValue;
        this.Changed();
      };
    };
    this.SetHeight = function (AValue) {
      this.SetBounds(this.FLeft,this.FTop,this.FWidth,AValue);
    };
    this.SetHint = function (AValue) {
      if (this.FHint !== AValue) {
        this.FHint = AValue;
        this.Changed();
      };
    };
    this.SetLeft = function (AValue) {
      this.SetBounds(AValue,this.FTop,this.FWidth,this.FHeight);
    };
    this.SetParent = function (AValue) {
      if (this.FParent != null) {
        this.FParent.UnRegisterChild(this);
      };
      this.CheckNewParent(AValue);
      this.FParent = AValue;
      if (this.FParent != null) {
        this.FParent.RegisterChild(this);
        this.BeginUpdate();
        try {
          if (this.FParentColor) {
            this.FColor = this.FParent.FColor;
          };
          if (this.FParentFont) {
            this.FFont.Assign(this.FParent.FFont);
          };
          if (this.FParentShowHint) {
            this.FShowHint = this.FParent.FShowHint;
          };
        } finally {
          this.EndUpdate();
        };
      };
    };
    this.SetParentColor = function (AValue) {
      if (this.FParentColor !== AValue) {
        this.FParentColor = AValue;
        if (this.FParentColor && (this.FParent != null)) {
          this.FColor = this.FParent.FColor;
          this.Changed();
        };
      };
    };
    this.SetParentFont = function (AValue) {
      if (this.FParentFont !== AValue) {
        this.FParentFont = AValue;
        if ((this.FParentFont && (this.FParent != null)) && !this.FFont.IsEqual(this.FParent.FFont)) {
          this.FFont.Assign(this.FParent.FFont);
        };
      };
    };
    this.SetParentShowHint = function (AValue) {
      if (this.FParentShowHint !== AValue) {
        this.FParentShowHint = AValue;
        if (this.FParentShowHint && (this.FParent != null)) {
          this.FShowHint = this.FParent.FShowHint;
          this.Changed();
        };
      };
    };
    this.SetShowHint = function (AValue) {
      if (this.FShowHint !== AValue) {
        this.FShowHint = AValue;
        this.FParentShowHint = false;
        this.Changed();
      };
    };
    this.SetTabOrder = function (AValue) {
      if (this.FTabOrder !== AValue) {
        this.FTabOrder = AValue;
        if (this.FParent != null) {
          this.FParent.UpdateTabOrder(this);
        };
      };
    };
    this.SetTabStop = function (AValue) {
      if (this.FTabStop !== AValue) {
        this.FTabStop = AValue;
        this.Changed();
      };
    };
    this.SetText = function (AValue) {
      this.RealSetText(AValue);
    };
    this.SetTop = function (AValue) {
      this.SetBounds(this.FLeft,AValue,this.FWidth,this.FHeight);
    };
    this.SetVisible = function (AValue) {
      if (this.FVisible !== AValue) {
        this.FVisible = AValue;
        this.ReAlign();
      };
    };
    this.SetWidth = function (AValue) {
      this.SetBounds(this.FLeft,this.FTop,AValue,this.FHeight);
    };
    this.Click = function () {
      if (this.FOnClick != null) {
        this.FOnClick(this);
      };
    };
    this.DblClick = function () {
      if (this.FOnDblClick != null) {
        this.FOnDblClick(this);
      };
    };
    this.DoResize = function () {
      if (this.FOnScroll != null) {
        this.FOnScroll(this);
      };
    };
    this.DoScroll = function () {
      if (this.FOnScroll != null) {
        this.FOnScroll(this);
      };
    };
    this.MouseDown = function (Button, Shift, X, Y) {
      if (this.FOnMouseDown != null) {
        this.FOnMouseDown(this,Button,rtl.refSet(Shift),X,Y);
      };
    };
    this.MouseEnter = function () {
      if (this.FOnMouseEnter != null) {
        this.FOnMouseEnter(this);
      };
    };
    this.MouseLeave = function () {
      if (this.FOnMouseLeave != null) {
        this.FOnMouseLeave(this);
      };
    };
    this.MouseMove = function (Shift, X, Y) {
      if (this.FOnMouseMove != null) {
        this.FOnMouseMove(this,rtl.refSet(Shift),X,Y);
      };
    };
    this.MouseUp = function (Button, Shift, X, Y) {
      if (this.FOnMouseUp != null) {
        this.FOnMouseUp(this,Button,rtl.refSet(Shift),X,Y);
      };
    };
    this.MouseWeel = function (Shift, WheelDelta, MousePos, Handled) {
      if (this.FOnMouseWheel != null) {
        this.FOnMouseWheel(this,rtl.refSet(Shift),WheelDelta,new pas.Types.TPoint(MousePos),Handled);
      };
    };
    this.HandleClick = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.Click();
      Result = true;
      return Result;
    };
    this.HandleDblClick = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.DblClick();
      Result = true;
      return Result;
    };
    this.HandleMouseDown = function (AEvent) {
      var Result = false;
      var VButton = 0;
      var VOffSets = new pas.Types.TRect();
      var VShift = {};
      var X = 0;
      var Y = 0;
      VButton = $mod.ExtractMouseButton(AEvent);
      VOffSets = new pas.Types.TRect($mod.OffSets(this.FHandleElement));
      VShift = rtl.refSet($mod.ExtractShiftState$1(AEvent));
      X = pas.System.Trunc(AEvent.clientX - VOffSets.Left);
      Y = pas.System.Trunc(AEvent.clientY - VOffSets.Top);
      AEvent.stopPropagation();
      this.MouseDown(VButton,rtl.refSet(VShift),X,Y);
      Result = true;
      return Result;
    };
    this.HandleMouseEnter = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.MouseEnter();
      Result = true;
      return Result;
    };
    this.HandleMouseLeave = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.MouseLeave();
      Result = true;
      return Result;
    };
    this.HandleMouseMove = function (AEvent) {
      var Result = false;
      var VOffSets = new pas.Types.TRect();
      var VShift = {};
      var X = 0;
      var Y = 0;
      VOffSets = new pas.Types.TRect($mod.OffSets(this.FHandleElement));
      VShift = rtl.refSet($mod.ExtractShiftState$1(AEvent));
      X = pas.System.Trunc(AEvent.clientX - VOffSets.Left);
      Y = pas.System.Trunc(AEvent.clientY - VOffSets.Left);
      AEvent.stopPropagation();
      this.MouseMove(rtl.refSet(VShift),X,Y);
      Result = true;
      return Result;
    };
    this.HandleMouseUp = function (AEvent) {
      var Result = false;
      var VButton = 0;
      var VOffSets = new pas.Types.TRect();
      var VShift = {};
      var X = 0;
      var Y = 0;
      VButton = $mod.ExtractMouseButton(AEvent);
      VOffSets = new pas.Types.TRect($mod.OffSets(this.FHandleElement));
      VShift = rtl.refSet($mod.ExtractShiftState$1(AEvent));
      X = pas.System.Trunc(AEvent.clientX - VOffSets.Left);
      Y = pas.System.Trunc(AEvent.clientY - VOffSets.Top);
      AEvent.stopPropagation();
      this.MouseUp(VButton,rtl.refSet(VShift),X,Y);
      Result = true;
      return Result;
    };
    this.HandleMouseWheel = function (AEvent) {
      var Result = false;
      var VDelta = 0;
      var VHandled = false;
      var VMousePos = new pas.Types.TPoint();
      var VShift = {};
      var VOffSets = new pas.Types.TRect();
      VDelta = pas.System.Trunc(-AEvent.deltaY);
      VHandled = false;
      VOffSets = new pas.Types.TRect($mod.OffSets(this.FHandleElement));
      VMousePos = new pas.Types.TPoint(pas.Types.Point(VOffSets.Left,VOffSets.Top));
      VShift = rtl.refSet($mod.ExtractShiftState$1(AEvent));
      AEvent.stopPropagation();
      this.MouseWeel(rtl.refSet(VShift),VDelta,new pas.Types.TPoint(VMousePos),{get: function () {
          return VHandled;
        }, set: function (v) {
          VHandled = v;
        }});
      Result = true;
      return Result;
    };
    this.HandleResize = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.DoResize();
      Result = true;
      return Result;
    };
    this.HandleScroll = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.DoScroll();
      Result = true;
      return Result;
    };
    this.Changed = function () {
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        if (this.FHandleId !== "") {
          $with1.setAttribute("id",this.FHandleId);
        } else {
          $with1.removeAttribute("id");
        };
        if (this.FHandleClass !== "") {
          $with1.setAttribute("class",this.FHandleClass);
        } else {
          $with1.removeAttribute("class");
        };
        if ((this.FHandleClass === "") && (this.FHandleId === "")) {
          $with1.style.setProperty("color",pas.Graphics.JSColor(this.FFont.FColor));
          $with1.style.setProperty("font-family",this.FFont.FName);
          $with1.style.setProperty("font-size",pas.SysUtils.IntToStr(this.FFont.FSize) + "px");
          $with1.style.setProperty("font-style","normal");
          $with1.style.setProperty("font-weight",$mod.IfThen$3(pas.Graphics.TFontStyle.fsBold in this.FFont.FStyle,"bold","normal"));
          $with1.style.setProperty("text-decoration",$mod.IfThen$3(pas.Graphics.TFontStyle.fsUnderline in this.FFont.FStyle,"underline","normal"));
          if (this.FColor in rtl.createSet(536870912,536870911)) {
            $with1.style.removeProperty("background-color");
          } else {
            $with1.style.setProperty("background-color",pas.Graphics.JSColor(this.FColor));
          };
        };
        $with1.style.setProperty("left",pas.SysUtils.IntToStr(this.FLeft) + "px");
        $with1.style.setProperty("top",pas.SysUtils.IntToStr(this.FTop) + "px");
        $with1.style.setProperty("width",pas.SysUtils.IntToStr(this.FWidth) + "px");
        $with1.style.setProperty("height",pas.SysUtils.IntToStr(this.FHeight) + "px");
        $with1.style.setProperty("cursor",$mod.JSCursor(this.FCursor));
        if (this.FEnabled) {
          $with1.removeAttribute("disabled");
          $with1.style.removeProperty("opacity");
        } else {
          $with1.setAttribute("disabled","true");
          $with1.style.setProperty("opacity","0.5");
        };
        if (this.FVisible) {
          $with1.style.setProperty("visibility","visible");
          $with1.style.setProperty("display","block");
        } else {
          $with1.style.setProperty("visibility","hidden");
          $with1.style.setProperty("display","none");
        };
        if ((this.FHint !== "") && this.FShowHint) {
          $with1.setAttribute("title",this.FHint);
        } else {
          $with1.removeAttribute("title");
        };
        if (this.FBorderStyle === $mod.TFormBorderStyle.bsNone) {
          $with1.style.setProperty("border-style","none");
        } else {
          $with1.style.removeProperty("border-style");
        };
        $with1.setAttribute("tabindex",$mod.IfThen$3(this.FTabStop,"1","-1"));
        $with1.style.setProperty("position","absolute");
        $with1.style.setProperty("overflow","hidden");
        $with1.style.setProperty("-webkit-box-sizing","border-box");
        $with1.style.setProperty("-moz-box-sizing","border-box");
        $with1.style.setProperty("box-sizing","border-box");
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      throw new Error(pas.SysUtils.Format("%s.CreateHandleElement=nil",[this.$classname]));
      return Result;
    };
    this.RegisterHandleEvents = function () {
      var $with1 = this.FHandleElement;
      $with1.addEventListener("click",rtl.createCallback(this,"HandleClick"));
      $with1.addEventListener("dblclick",rtl.createCallback(this,"HandleDblClick"));
      $with1.addEventListener("mousedown",rtl.createCallback(this,"HandleMouseDown"));
      $with1.addEventListener("mouseenter",rtl.createCallback(this,"HandleMouseEnter"));
      $with1.addEventListener("mouseleave",rtl.createCallback(this,"HandleMouseLeave"));
      $with1.addEventListener("mousemove",rtl.createCallback(this,"HandleMouseMove"));
      $with1.addEventListener("mouseup",rtl.createCallback(this,"HandleMouseUp"));
      $with1.addEventListener("scroll",rtl.createCallback(this,"HandleScroll"));
      $with1.addEventListener("resize",rtl.createCallback(this,"HandleResize"));
      $with1.addEventListener("wheel",rtl.createCallback(this,"HandleMouseWheel"));
    };
    this.UnRegisterHandleEvents = function () {
      var $with1 = this.FHandleElement;
      $with1.removeEventListener("click",rtl.createCallback(this,"HandleClick"));
      $with1.removeEventListener("dblclick",rtl.createCallback(this,"HandleDblClick"));
      $with1.removeEventListener("mousedown",rtl.createCallback(this,"HandleMouseDown"));
      $with1.removeEventListener("mouseenter",rtl.createCallback(this,"HandleMouseEnter"));
      $with1.removeEventListener("mouseleave",rtl.createCallback(this,"HandleMouseLeave"));
      $with1.removeEventListener("mousemove",rtl.createCallback(this,"HandleMouseMove"));
      $with1.removeEventListener("mouseup",rtl.createCallback(this,"HandleMouseUp"));
      $with1.removeEventListener("scroll",rtl.createCallback(this,"HandleScroll"));
      $with1.removeEventListener("resize",rtl.createCallback(this,"HandleResize"));
      $with1.removeEventListener("wheel",rtl.createCallback(this,"HandleMouseWheel"));
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.CheckNewParent = function (AParent) {
      if ((AParent != null) && !AParent.CheckChildClassAllowed(this.$class.ClassType())) {
        throw new Error(pas.SysUtils.Format("Control of class '%s' can't have control of class '%s' as a child",[AParent.$class.ClassType(),this.$classname]));
      };
      if (pas.Forms.TCustomForm.isPrototypeOf(this) && pas.Forms.TCustomForm.isPrototypeOf(AParent)) {
        throw new Error('A "Form" can\'t have another "Form" as parent');
      };
      if (this === AParent) {
        throw new Error('A "Control" can\'t have itself as a Parent');
      };
    };
    this.RegisterChild = function (AControl) {
      var VIndex = 0;
      if (AControl != null) {
        VIndex = this.FControls.indexOf(AControl);
        if (VIndex < 0) {
          this.FControls.push(AControl);
          if (!this.FHandleElement.contains(AControl.FHandleElement)) {
            this.FHandleElement.appendChild(AControl.FHandleElement);
          };
          this.ReAlign();
          AControl.SetTabOrder(this.FControls.length);
        };
      };
    };
    this.UnRegisterChild = function (AControl) {
      var VIndex = 0;
      if (AControl != null) {
        VIndex = this.FControls.indexOf(AControl);
        if (VIndex >= 0) {
          this.FControls.splice(VIndex,1);
          if (this.FHandleElement.contains(AControl.FHandleElement)) {
            this.FHandleElement.removeChild(AControl.FHandleElement);
          };
          this.ReAlign();
          this.UpdateTabOrder(null);
        };
      };
    };
    this.AlignControls = function () {
      var VControl = null;
      var VSpacing = null;
      var VIndex = 0;
      var VLeft = 0;
      var VTop = 0;
      var VRight = 0;
      var VBotton = 0;
      var VWidth = 0;
      this.BeginUpdate();
      try {
        VLeft = 0;
        VTop = 0;
        VRight = this.FWidth;
        VBotton = this.FHeight;
        VWidth = this.FWidth;
        for (var $l1 = 0, $end2 = this.FControls.length - 1; $l1 <= $end2; $l1++) {
          VIndex = $l1;
          VControl = rtl.getObject(this.FControls[VIndex]);
          if (((VControl != null) && (VControl.FAlign === $mod.TAlign.alTop)) && VControl.FVisible) {
            VControl.BeginUpdate();
            try {
              VSpacing = VControl.FBorderSpacing;
              VControl.SetLeft((VLeft + VSpacing.FLeft) + VSpacing.FAround);
              VControl.SetTop((VTop + VSpacing.FTop) + VSpacing.FAround);
              VControl.SetWidth(((VWidth - VSpacing.FLeft) - VSpacing.FRight) - (VSpacing.FAround * 2));
              VControl.SetHeight(VControl.FHeight);
            } finally {
              VControl.EndUpdate();
            };
            VTop = (((VTop + VControl.FHeight) + VSpacing.FTop) + VSpacing.FBottom) + (VSpacing.FAround * 2);
          };
        };
        if (VTop < 0) {
          VTop = 0;
        };
        for (var $l3 = 0, $end4 = this.FControls.length - 1; $l3 <= $end4; $l3++) {
          VIndex = $l3;
          VControl = rtl.getObject(this.FControls[VIndex]);
          if (((VControl != null) && (VControl.FAlign === $mod.TAlign.alBottom)) && VControl.FVisible) {
            VControl.BeginUpdate();
            try {
              VSpacing = VControl.FBorderSpacing;
              VControl.SetLeft((VLeft + VSpacing.FLeft) + VSpacing.FAround);
              VControl.SetTop(((VBotton - VControl.FHeight) - VSpacing.FBottom) - VSpacing.FAround);
              VControl.SetWidth(((VWidth - VSpacing.FLeft) - VSpacing.FRight) - (VSpacing.FAround * 2));
              VControl.SetHeight(VControl.FHeight);
            } finally {
              VControl.EndUpdate();
            };
            VBotton = (((VBotton - VControl.FHeight) - VSpacing.FTop) - VSpacing.FBottom) - (VSpacing.FAround * 2);
          };
        };
        if (VBotton < 0) {
          VBotton = 0;
        };
        for (var $l5 = 0, $end6 = this.FControls.length - 1; $l5 <= $end6; $l5++) {
          VIndex = $l5;
          VControl = rtl.getObject(this.FControls[VIndex]);
          if (((VControl != null) && (VControl.FAlign === $mod.TAlign.alLeft)) && VControl.FVisible) {
            VControl.BeginUpdate();
            try {
              VSpacing = VControl.FBorderSpacing;
              VControl.SetLeft((VLeft + VSpacing.FLeft) + VSpacing.FAround);
              VControl.SetTop((VTop + VSpacing.FTop) + VSpacing.FAround);
              VControl.SetWidth(VControl.FWidth);
              VControl.SetHeight((((VBotton - VTop) - VSpacing.FTop) - VSpacing.FBottom) - (VSpacing.FAround * 2));
            } finally {
              VControl.EndUpdate();
            };
            VLeft = (((VLeft + VControl.FWidth) + VSpacing.FLeft) + VSpacing.FRight) + (VSpacing.FAround * 2);
          };
        };
        if (VLeft < 0) {
          VLeft = 0;
        };
        for (var $l7 = 0, $end8 = this.FControls.length - 1; $l7 <= $end8; $l7++) {
          VIndex = $l7;
          VControl = rtl.getObject(this.FControls[VIndex]);
          if (((VControl != null) && (VControl.FAlign === $mod.TAlign.alRight)) && VControl.FVisible) {
            VControl.BeginUpdate();
            try {
              VSpacing = VControl.FBorderSpacing;
              VControl.SetLeft(((VRight - VControl.FWidth) - VSpacing.FRight) - VSpacing.FAround);
              VControl.SetTop((VTop + VSpacing.FTop) + VSpacing.FAround);
              VControl.SetWidth(VControl.FWidth);
              VControl.SetHeight((((VBotton - VTop) - VSpacing.FTop) - VSpacing.FBottom) - (VSpacing.FAround * 2));
            } finally {
              VControl.EndUpdate();
            };
            VRight = (((VRight - VControl.FWidth) - VSpacing.FLeft) - VSpacing.FRight) - (VSpacing.FAround * 2);
          };
        };
        if (VRight < 0) {
          VRight = 0;
        };
        for (var $l9 = 0, $end10 = this.FControls.length - 1; $l9 <= $end10; $l9++) {
          VIndex = $l9;
          VControl = rtl.getObject(this.FControls[VIndex]);
          if (((VControl != null) && (VControl.FAlign === $mod.TAlign.alClient)) && VControl.FVisible) {
            VControl.BeginUpdate();
            try {
              VSpacing = VControl.FBorderSpacing;
              VControl.SetLeft((VLeft + VSpacing.FLeft) + VSpacing.FAround);
              VControl.SetTop((VTop + VSpacing.FTop) + VSpacing.FAround);
              VControl.SetWidth((((VRight - VLeft) - VSpacing.FLeft) - VSpacing.FRight) - (VSpacing.FAround * 2));
              VControl.SetHeight((((VBotton - VTop) - VSpacing.FTop) - VSpacing.FBottom) - (VSpacing.FAround * 2));
            } finally {
              VControl.EndUpdate();
            };
          };
        };
      } finally {
        this.EndUpdate();
      };
    };
    this.RealGetText = function () {
      var Result = "";
      Result = this.FCaption;
      return Result;
    };
    this.RealSetText = function (AValue) {
      if (this.FCaption !== AValue) {
        this.FCaption = AValue;
        this.Changed();
      };
    };
    this.BorderSpacingChanged = function (Sender) {
      if (this.FParent != null) {
        this.FParent.AlignControls();
      };
    };
    this.ColorChanged = function (Sender) {
      this.Changed();
    };
    this.FontChanged = function (Sender) {
      this.Changed();
    };
    this.TabOrderArray = function () {
      var Result = null;
      Result = this.FControls.slice(0).sort(rtl.createCallback(this,"CompareTabOrder"));
      return Result;
    };
    this.CompareTabOrder = function (A, B) {
      var Result = 0;
      if (((pas.System.Assigned(A) && pas.System.Assigned(B)) && rtl.isExt(A,$mod.TControl,1)) && rtl.isExt(B,$mod.TControl,1)) {
        Result = rtl.getObject(A).FTabOrder - rtl.getObject(B).FTabOrder;
      } else {
        Result = 0;
      };
      return Result;
    };
    this.UpdateTabOrder = function (AValue) {
      var VControl = null;
      var VArray = null;
      var VIndex = 0;
      if (AValue != null) {
        for (var $l1 = 0, $end2 = this.FControls.length - 1; $l1 <= $end2; $l1++) {
          VIndex = $l1;
          VControl = rtl.getObject(this.FControls[VIndex]);
          if (((VControl != null) && (VControl !== AValue)) && (VControl.FTabOrder >= AValue.FTabOrder)) {
            VControl.FTabOrder += 1;
          };
        };
      };
      VArray = this.TabOrderArray();
      try {
        for (var $l3 = 0, $end4 = VArray.length - 1; $l3 <= $end4; $l3++) {
          VIndex = $l3;
          VControl = rtl.getObject(VArray[VIndex]);
          if (VControl != null) {
            VControl.BeginUpdate();
            try {
              VControl.FTabOrder = VIndex;
            } finally {
              VControl.EndUpdate();
            };
          };
        };
      } finally {
        VArray.length = 0;
      };
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 75;
      Result.cy = 50;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Classes.TComponent.Create$1.call(this,AOwner);
      this.FHandleElement = this.CreateHandleElement();
      this.FHandleClass = "";
      this.FHandleId = "";
      this.RegisterHandleEvents();
      this.FControls = new Array();
      this.FBorderSpacing = $mod.TControlBorderSpacing.$create("Create$1");
      this.FBorderSpacing.FOnChange = rtl.createCallback(this,"BorderSpacingChanged");
      this.FBorderStyle = $mod.TFormBorderStyle.bsSingle;
      this.FFont = pas.Graphics.TFont.$create("Create$1");
      this.FFont.FOnChange = rtl.createCallback(this,"FontChanged");
      this.FAlign = $mod.TAlign.alNone;
      this.FAutoSize = false;
      this.FCaption = "";
      this.FColor = 536870912;
      this.FCursor = 0;
      this.FEnabled = true;
      this.FLeft = 0;
      this.FParent = null;
      this.FParentColor = false;
      this.FParentFont = true;
      this.FParentShowHint = true;
      this.FShowHint = false;
      this.FTabOrder = 0;
      this.FTabStop = true;
      this.FTop = 0;
      this.FUpdateCount = 0;
      this.FVisible = true;
    };
    this.Destroy = function () {
      this.DestroyComponents();
      this.UnRegisterHandleEvents();
      if (this.FParent != null) {
        this.FParent.UnRegisterChild(this);
      };
      this.FControls.length = 0;
      this.FBorderSpacing.$destroy("Destroy");
      this.FBorderSpacing = null;
      this.FFont.$destroy("Destroy");
      this.FFont = null;
      pas.Classes.TComponent.Destroy.call(this);
    };
    this.BeginUpdate = function () {
      this.FUpdateCount += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount > 0) {
        this.FUpdateCount -= 1;
        if (this.FUpdateCount === 0) {
          this.Changed();
        };
      };
    };
    this.AdjustSize = function () {
    };
    this.IsParentOf = function (AControl) {
      var Result = false;
      Result = false;
      while (AControl != null) {
        AControl = AControl.FParent;
        if (this === AControl) {
          Result = true;
          return Result;
        };
      };
      return Result;
    };
    this.IsUpdating = function () {
      var Result = false;
      Result = this.FUpdateCount > 0;
      return Result;
    };
    this.GetTopParent = function () {
      var Result = null;
      Result = this;
      while (Result.FParent != null) {
        Result = Result.FParent;
      };
      return Result;
    };
    this.HasParent = function () {
      var Result = false;
      Result = this.FParent !== null;
      return Result;
    };
    this.Invalidate = function () {
    };
    this.ReAlign = function () {
      this.AlignControls();
      if (this.FParent != null) {
        this.FParent.ReAlign();
      };
      this.Invalidate();
    };
    this.BringToFront = function () {
      var VParentElement = null;
      VParentElement = this.FHandleElement.parentElement;
      if (VParentElement != null) {
        VParentElement.removeChild(this.FHandleElement);
        VParentElement.appendChild(this.FHandleElement);
      };
    };
    this.SendToBack = function () {
      var VNode = null;
      var VParentElement = null;
      var VIndex = 0;
      VParentElement = this.FHandleElement.parentElement;
      if (VParentElement != null) {
        for (var $l1 = 0, $end2 = VParentElement.childNodes.length - 1; $l1 <= $end2; $l1++) {
          VIndex = $l1;
          VNode = VParentElement.childNodes.item(VIndex);
          if (!rtl.isExt(VNode,HTMLCanvasElement)) {
            VParentElement.removeChild(this.FHandleElement);
            VParentElement.insertBefore(this.FHandleElement,VParentElement.childNodes.item(VIndex));
            return;
          };
        };
      };
    };
    this.SetBounds = function (ALeft, ATop, AWidth, AHeight) {
      if ((((this.FLeft !== ALeft) || (this.FTop !== ATop)) || (this.FWidth !== AWidth)) || (this.FHeight !== AHeight)) {
        this.FLeft = ALeft;
        this.FTop = ATop;
        if (AWidth > 0) {
          this.FWidth = AWidth;
        } else {
          this.FWidth = 0;
        };
        if (AHeight > 0) {
          this.FHeight = AHeight;
        } else {
          this.FHeight = 0;
        };
        this.Changed();
        this.ReAlign();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Cursor",2,$mod.$rtti["TCursor"],"FCursor","SetCursor");
    $r.addProperty("Left",2,rtl.nativeint,"FLeft","SetLeft");
    $r.addProperty("Height",2,rtl.nativeint,"FHeight","SetHeight");
    $r.addProperty("Hint",2,rtl.string,"FHint","SetHint");
    $r.addProperty("Top",2,rtl.nativeint,"FTop","SetTop");
    $r.addProperty("Width",2,rtl.nativeint,"FWidth","SetWidth");
  });
  rtl.createClass($mod,"TWinControl",$mod.TControl,function () {
    this.$init = function () {
      $mod.TControl.$init.call(this);
      this.FOnEnter = null;
      this.FOnExit = null;
      this.FOnKeyDown = null;
      this.FOnKeyPress = null;
      this.FOnKeyUp = null;
    };
    this.$final = function () {
      this.FOnEnter = undefined;
      this.FOnExit = undefined;
      this.FOnKeyDown = undefined;
      this.FOnKeyPress = undefined;
      this.FOnKeyUp = undefined;
      $mod.TControl.$final.call(this);
    };
    this.GetControl = function (AIndex) {
      var Result = null;
      Result = rtl.getObject(this.FControls[AIndex]);
      return Result;
    };
    this.GetControlCount = function () {
      var Result = 0;
      Result = this.FControls.length;
      return Result;
    };
    this.GetControlIndex = function (AControl) {
      var Result = 0;
      Result = this.FControls.indexOf(AControl);
      return Result;
    };
    this.DoEnter = function () {
      if (this.FOnEnter != null) {
        this.FOnEnter(this);
      };
    };
    this.DoExit = function () {
      if (this.FOnExit != null) {
        this.FOnExit(this);
      };
    };
    this.KeyDown = function (Key, Shift) {
      if (this.FOnKeyDown != null) {
        this.FOnKeyDown(this,Key,rtl.refSet(Shift));
      };
    };
    this.KeyPress = function (Key) {
      if (this.FOnKeyPress != null) {
        this.FOnKeyPress(this,Key);
      };
    };
    this.KeyUp = function (Key, Shift) {
      if (this.FOnKeyUp != null) {
        this.FOnKeyUp(this,Key,rtl.refSet(Shift));
      };
    };
    this.HandleEnter = function (AEvent) {
      var Result = false;
      var VParent = null;
      VParent = this.FParent;
      while (VParent != null) {
        if (pas.Forms.TCustomForm.isPrototypeOf(VParent)) {
          VParent.SetActiveControl(this);
          break;
        };
        VParent = VParent.FParent;
      };
      AEvent.stopPropagation();
      this.DoEnter();
      Result = true;
      return Result;
    };
    this.HandleExit = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.DoExit();
      Result = true;
      return Result;
    };
    this.HandleKeyDown = function (AEvent) {
      var Result = false;
      var VControl = null;
      var VForm = null;
      var VKey = 0;
      var VParent = null;
      var VShift = {};
      VParent = this.FParent;
      while (VParent != null) {
        if (pas.Forms.TCustomForm.isPrototypeOf(VParent)) {
          VForm = VParent;
          if (VForm.FKeyPreview && VForm.HandleKeyDown(AEvent)) {
            Result = true;
            return Result;
          };
        };
        VParent = VParent.FParent;
      };
      VKey = $mod.ExtractKeyCode(AEvent);
      VShift = rtl.refSet($mod.ExtractShiftState(AEvent));
      AEvent.stopPropagation();
      this.KeyDown({get: function () {
          return VKey;
        }, set: function (v) {
          VKey = v;
        }},rtl.refSet(VShift));
      if (VKey === 0) {
        AEvent.preventDefault();
      } else {
        var $tmp1 = VKey;
        if ($tmp1 === 9) {
          if (this.FParent != null) {
            if ($mod.TShiftStateEnum.ssShift in VShift) {
              VControl = this.FParent.FindFocusControl(this,$mod.TFocusSearchDirection.fsdPrev);
              if (!(VControl != null)) {
                VControl = this.FParent.FindFocusControl(null,$mod.TFocusSearchDirection.fsdLast);
              };
            } else {
              VControl = this.FParent.FindFocusControl(this,$mod.TFocusSearchDirection.fsdNext);
              if (!(VControl != null)) {
                VControl = this.FParent.FindFocusControl(null,$mod.TFocusSearchDirection.fsdFirst);
              };
            };
            if ((VControl != null) && VControl.CanSetFocus()) {
              VControl.SetFocus();
            };
            AEvent.preventDefault();
          };
        };
      };
      Result = true;
      return Result;
    };
    this.HandleKeyUp = function (AEvent) {
      var Result = false;
      var VForm = null;
      var VKey = 0;
      var VParent = null;
      var VShift = {};
      VParent = this.FParent;
      while (VParent != null) {
        if (pas.Forms.TCustomForm.isPrototypeOf(VParent)) {
          VForm = VParent;
          if (VForm.FKeyPreview && VForm.HandleKeyUp(AEvent)) {
            Result = true;
            return Result;
          };
        };
        VParent = VParent.FParent;
      };
      VKey = $mod.ExtractKeyCode(AEvent);
      VShift = rtl.refSet($mod.ExtractShiftState(AEvent));
      AEvent.stopPropagation();
      this.KeyUp({get: function () {
          return VKey;
        }, set: function (v) {
          VKey = v;
        }},rtl.refSet(VShift));
      if (VKey === 0) {
        AEvent.preventDefault();
      };
      Result = true;
      return Result;
    };
    this.HandleKeyPress = function (AEvent) {
      var Result = false;
      var VForm = null;
      var VKey = "";
      var VParent = null;
      VParent = this.FParent;
      while (VParent != null) {
        if (pas.Forms.TCustomForm.isPrototypeOf(VParent)) {
          VForm = VParent;
          if (VForm.FKeyPreview && VForm.HandleKeyPress(AEvent)) {
            Result = true;
            return Result;
          };
        };
        VParent = VParent.FParent;
      };
      AEvent.stopPropagation();
      VKey = $mod.ExtractKeyChar(AEvent);
      if (VKey === "\x00") {
        AEvent.preventDefault();
      } else {
        this.KeyPress({get: function () {
            return VKey;
          }, set: function (v) {
            VKey = v;
          }});
        if (VKey === "\x00") {
          AEvent.preventDefault();
        };
      };
      Result = true;
      return Result;
    };
    this.RegisterHandleEvents = function () {
      $mod.TControl.RegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.addEventListener("focus",rtl.createCallback(this,"HandleEnter"));
      $with1.addEventListener("blur",rtl.createCallback(this,"HandleExit"));
      $with1.addEventListener("keydown",rtl.createCallback(this,"HandleKeyDown"));
      $with1.addEventListener("keypress",rtl.createCallback(this,"HandleKeyPress"));
      $with1.addEventListener("keyup",rtl.createCallback(this,"HandleKeyUp"));
    };
    this.UnRegisterHandleEvents = function () {
      $mod.TControl.UnRegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.removeEventListener("focus",rtl.createCallback(this,"HandleEnter"));
      $with1.removeEventListener("blur",rtl.createCallback(this,"HandleExit"));
      $with1.removeEventListener("keydown",rtl.createCallback(this,"HandleKeyDown"));
      $with1.removeEventListener("keypress",rtl.createCallback(this,"HandleKeyPress"));
      $with1.removeEventListener("keyup",rtl.createCallback(this,"HandleKeyUp"));
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = (AChildClass != null) && AChildClass.InheritsFrom($mod.TControl);
      return Result;
    };
    this.FindFocusControl = function (AStartControl, ADirection) {
      var Result = null;
      var VControl = null;
      var VArray = null;
      var VIndex = 0;
      var VTabOrder = 0;
      Result = null;
      VArray = this.TabOrderArray();
      if (VArray.length === 0) {
        return Result;
      };
      try {
        VTabOrder = VArray.indexOf(AStartControl);
        if (VTabOrder < 0) {
          if (ADirection in rtl.createSet($mod.TFocusSearchDirection.fsdFirst)) {
            VTabOrder = VArray.length - 1;
          } else {
            VTabOrder = 0;
          };
        };
        var $tmp1 = ADirection;
        if ($tmp1 === $mod.TFocusSearchDirection.fsdFirst) {
          VControl = rtl.getObject(VArray[0]);
          if (((((VControl != null) && $mod.TWinControl.isPrototypeOf(VControl)) && VControl.FEnabled) && VControl.FVisible) && VControl.FTabStop) {
            return VControl;
          };
        } else if ($tmp1 === $mod.TFocusSearchDirection.fsdLast) {
          VControl = rtl.getObject(VArray[VArray.length - 1]);
          if (((((VControl != null) && $mod.TWinControl.isPrototypeOf(VControl)) && VControl.FEnabled) && VControl.FVisible) && VControl.FTabStop) {
            return VControl;
          };
        } else if ($tmp1 === $mod.TFocusSearchDirection.fsdNext) {
          if (VTabOrder < (VArray.length - 1)) {
            for (var $l2 = VTabOrder + 1, $end3 = VArray.length - 1; $l2 <= $end3; $l2++) {
              VIndex = $l2;
              VControl = rtl.getObject(VArray[VIndex]);
              if (((((VControl != null) && $mod.TWinControl.isPrototypeOf(VControl)) && VControl.FEnabled) && VControl.FVisible) && VControl.FTabStop) {
                return VControl;
              };
            };
          };
        } else if ($tmp1 === $mod.TFocusSearchDirection.fsdPrev) {
          if (VTabOrder > 0) {
            for (var $l4 = VTabOrder - 1; $l4 >= 0; $l4--) {
              VIndex = $l4;
              VControl = rtl.getObject(VArray[VIndex]);
              if (((((VControl != null) && $mod.TWinControl.isPrototypeOf(VControl)) && VControl.FEnabled) && VControl.FVisible) && VControl.FTabStop) {
                return VControl;
              };
            };
          };
        };
      } finally {
        VArray.length = 0;
      };
      return Result;
    };
    this.Focused = function () {
      var Result = false;
      Result = this.FHandleElement === document.activeElement;
      return Result;
    };
    this.CanSetFocus = function () {
      var Result = false;
      var VControl = null;
      VControl = this;
      while (true) {
        if (!VControl.FVisible && VControl.FEnabled) {
          Result = false;
          return Result;
        };
        if (VControl.FParent != null) {
          VControl = VControl.FParent;
        } else {
          break;
        };
      };
      Result = (VControl != null) && pas.Forms.TCustomForm.isPrototypeOf(VControl);
      return Result;
    };
    this.SetFocus = function () {
      this.FHandleElement.focus();
    };
    this.ContainsControl = function (AControl) {
      var Result = false;
      Result = this.FControls.indexOf(AControl) > -1;
      return Result;
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TCustomControl",$mod.TWinControl,function () {
    this.$init = function () {
      $mod.TWinControl.$init.call(this);
      this.FCanvas = null;
      this.FOnPaint = null;
    };
    this.$final = function () {
      this.FCanvas = undefined;
      this.FOnPaint = undefined;
      $mod.TWinControl.$final.call(this);
    };
    this.GetCanvas = function () {
      var Result = null;
      if (!(this.FCanvas != null)) {
        this.FCanvas = $mod.TControlCanvas.$create("Create$2",[this]);
      };
      Result = this.FCanvas;
      return Result;
    };
    this.ColorChanged = function (Sender) {
      if (this.FCanvas != null) {
        this.FCanvas.FBrush.SetColor(this.FColor);
      };
      $mod.TControl.ColorChanged.call(this,Sender);
    };
    this.FontChanged = function (Sender) {
      if (this.FCanvas != null) {
        this.FCanvas.FFont.Assign(this.FFont);
      };
      $mod.TControl.FontChanged.call(this,Sender);
    };
    this.Paint = function () {
      if (this.FOnPaint != null) {
        this.FOnPaint(this);
      };
    };
    this.Destroy = function () {
      if (this.FCanvas != null) {
        this.FCanvas.$destroy("Destroy");
        this.FCanvas = null;
      };
      $mod.TControl.Destroy.call(this);
    };
    this.Invalidate = function () {
      $mod.TControl.Invalidate.call(this);
      this.Paint();
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  this.CompareString = function (A, B) {
    return A.localeCompare(B, undefined, { numeric: true, sensitivity: 'base' });
  };
  this.CompareValues = function (A, B) {
    var Result = 0;
    if ((typeof(A) === "string") && (typeof(B) === "string")) {
      Result = $mod.CompareString("" + A,"" + B);
    } else if ((typeof(A) === "number") && (typeof(B) === "number")) {
      Result = pas.Math.CompareValue$3(rtl.getNumber(A),rtl.getNumber(B),0.0);
    } else if ((typeof(A) === "boolean") && (typeof(B) === "boolean")) {
      if (!(A == false) === !(B == false)) {
        Result = 0;
      } else if (!(A == false)) {
        Result = 1;
      } else {
        Result = -1;
      };
    } else {
      Result = 0;
    };
    return Result;
  };
  this.IfThen = function (AExpression, AConsequence, AAlternative) {
    var Result = false;
    if (AExpression) {
      Result = AConsequence;
    } else {
      Result = AAlternative;
    };
    return Result;
  };
  this.IfThen$1 = function (AExpression, AConsequence, AAlternative) {
    var Result = 0.0;
    if (AExpression) {
      Result = AConsequence;
    } else {
      Result = AAlternative;
    };
    return Result;
  };
  this.IfThen$2 = function (AExpression, AConsequence, AAlternative) {
    var Result = 0;
    if (AExpression) {
      Result = AConsequence;
    } else {
      Result = AAlternative;
    };
    return Result;
  };
  this.IfThen$3 = function (AExpression, AConsequence, AAlternative) {
    var Result = "";
    if (AExpression) {
      Result = AConsequence;
    } else {
      Result = AAlternative;
    };
    return Result;
  };
  this.ScrollbarWidth = function () {
    var Result = 0;
    var VDiv = null;
    VDiv = document.createElement("div");
    VDiv.style.setProperty("with","100");
    VDiv.style.setProperty("height","100");
    VDiv.style.setProperty("position","absolute");
    VDiv.style.setProperty("top","-9999");
    VDiv.style.setProperty("overflow","scroll");
    VDiv.style.setProperty("-ms-overflow-style","scrollbar");
    document.body.appendChild(VDiv);
    Result = Math.round(VDiv.offsetWidth - VDiv.clientWidth);
    if (Result < 0) {
      Result = 0;
    };
    document.body.removeChild(VDiv);
    return Result;
  };
  this.OffSets = function (AElement) {
    var Result = new pas.Types.TRect();
    Result = new pas.Types.TRect(pas.Types.Rect(0,0,0,0));
    if (AElement != null) {
      var $with1 = AElement.getBoundingClientRect();
      Result.Left = pas.System.Trunc($with1.left + window.scrollX);
      Result.Top = pas.System.Trunc($with1.top + window.screenY);
    };
    return Result;
  };
  this.ExtractKeyCode = function (AEvent) {
    var Result = 0;
    var VLocation = 0;
    var VKey = "";
    VLocation = AEvent.location;
    VKey = pas.SysUtils.LowerCase(AEvent.key);
    Result = -1;
    var $tmp1 = VKey;
    if ($tmp1 === "backspace") {
      Result = 8}
     else if ($tmp1 === "tab") {
      Result = 9}
     else if ($tmp1 === "enter") {
      Result = 13}
     else if ($tmp1 === "shift") {
      Result = 16}
     else if ($tmp1 === "control") {
      Result = 17}
     else if ($tmp1 === "alt") {
      Result = 18}
     else if ($tmp1 === "altgraph") {
      Result = 18}
     else if ($tmp1 === "pause") {
      Result = 19}
     else if ($tmp1 === "capslock") {
      Result = 20}
     else if ($tmp1 === "escape") {
      Result = 27}
     else if ($tmp1 === "pageup") {
      Result = 33}
     else if ($tmp1 === "pagedown") {
      Result = 34}
     else if ($tmp1 === "end") {
      Result = 35}
     else if ($tmp1 === "home") {
      Result = 36}
     else if ($tmp1 === "arrowleft") {
      Result = 37}
     else if ($tmp1 === "arrowup") {
      Result = 38}
     else if ($tmp1 === "arrowright") {
      Result = 39}
     else if ($tmp1 === "arrowdown") {
      Result = 40}
     else if ($tmp1 === "insert") {
      Result = 45}
     else if ($tmp1 === "delete") {
      Result = 46}
     else if ($tmp1 === "f1") {
      Result = 112}
     else if ($tmp1 === "f2") {
      Result = 113}
     else if ($tmp1 === "f3") {
      Result = 114}
     else if ($tmp1 === "f4") {
      Result = 115}
     else if ($tmp1 === "f5") {
      Result = 116}
     else if ($tmp1 === "f6") {
      Result = 117}
     else if ($tmp1 === "f7") {
      Result = 118}
     else if ($tmp1 === "f8") {
      Result = 119}
     else if ($tmp1 === "f9") {
      Result = 120}
     else if ($tmp1 === "f10") {
      Result = 121}
     else if ($tmp1 === "f11") {
      Result = 122}
     else if ($tmp1 === "f12") {
      Result = 123}
     else if ($tmp1 === "f13") {
      Result = 124}
     else if ($tmp1 === "f14") {
      Result = 125}
     else if ($tmp1 === "f15") {
      Result = 126}
     else if ($tmp1 === "f16") {
      Result = 127}
     else if ($tmp1 === "f17") {
      Result = 128}
     else if ($tmp1 === "f18") {
      Result = 129}
     else if ($tmp1 === "f19") {
      Result = 130}
     else if ($tmp1 === "f20") {
      Result = 131}
     else if ($tmp1 === "numlock") {
      Result = 144}
     else if ($tmp1 === "scrolllock") Result = 145;
    if (VLocation === 3) {
      var $tmp2 = VKey;
      if ($tmp2 === "0") {
        Result = 96}
       else if ($tmp2 === "1") {
        Result = 97}
       else if ($tmp2 === "2") {
        Result = 98}
       else if ($tmp2 === "3") {
        Result = 99}
       else if ($tmp2 === "4") {
        Result = 100}
       else if ($tmp2 === "5") {
        Result = 101}
       else if ($tmp2 === "6") {
        Result = 102}
       else if ($tmp2 === "7") {
        Result = 103}
       else if ($tmp2 === "8") {
        Result = 104}
       else if ($tmp2 === "9") {
        Result = 105}
       else if ($tmp2 === "*") {
        Result = 106}
       else if ($tmp2 === "+") {
        Result = 107}
       else if ($tmp2 === "-") {
        Result = 109}
       else if ($tmp2 === ",") {
        Result = 110}
       else if ($tmp2 === "\/") {
        Result = 111}
       else if ($tmp2 === ".") Result = 194;
    } else {
      var $tmp3 = VKey;
      if ($tmp3 === "0") {
        Result = 48}
       else if ($tmp3 === "1") {
        Result = 49}
       else if ($tmp3 === "2") {
        Result = 50}
       else if ($tmp3 === "3") {
        Result = 51}
       else if ($tmp3 === "4") {
        Result = 52}
       else if ($tmp3 === "5") {
        Result = 53}
       else if ($tmp3 === "6") {
        Result = 54}
       else if ($tmp3 === "7") {
        Result = 55}
       else if ($tmp3 === "8") {
        Result = 56}
       else if ($tmp3 === "9") {
        Result = 57}
       else if ($tmp3 === "ç") {
        Result = 63}
       else if ($tmp3 === "a") {
        Result = 65}
       else if ($tmp3 === "b") {
        Result = 66}
       else if ($tmp3 === "c") {
        Result = 67}
       else if ($tmp3 === "d") {
        Result = 68}
       else if ($tmp3 === "e") {
        Result = 69}
       else if ($tmp3 === "f") {
        Result = 70}
       else if ($tmp3 === "g") {
        Result = 71}
       else if ($tmp3 === "h") {
        Result = 72}
       else if ($tmp3 === "i") {
        Result = 73}
       else if ($tmp3 === "j") {
        Result = 74}
       else if ($tmp3 === "k") {
        Result = 75}
       else if ($tmp3 === "l") {
        Result = 76}
       else if ($tmp3 === "m") {
        Result = 77}
       else if ($tmp3 === "n") {
        Result = 78}
       else if ($tmp3 === "o") {
        Result = 79}
       else if ($tmp3 === "p") {
        Result = 80}
       else if ($tmp3 === "q") {
        Result = 81}
       else if ($tmp3 === "r") {
        Result = 82}
       else if ($tmp3 === "s") {
        Result = 83}
       else if ($tmp3 === "t") {
        Result = 84}
       else if ($tmp3 === "u") {
        Result = 85}
       else if ($tmp3 === "v") {
        Result = 86}
       else if ($tmp3 === "w") {
        Result = 87}
       else if ($tmp3 === "x") {
        Result = 88}
       else if ($tmp3 === "y") {
        Result = 89}
       else if ($tmp3 === "z") {
        Result = 90}
       else if ($tmp3 === "=") {
        Result = 187}
       else if ($tmp3 === ",") {
        Result = 188}
       else if ($tmp3 === "-") {
        Result = 189}
       else if ($tmp3 === ".") {
        Result = 190}
       else if ($tmp3 === "'") {
        Result = 192}
       else if ($tmp3 === "\/") {
        Result = 193}
       else if ($tmp3 === "]") {
        Result = 220}
       else if ($tmp3 === "[") Result = 221;
    };
    return Result;
  };
  this.ExtractKeyChar = function (AEvent) {
    var Result = "";
    var VKey = "";
    VKey = pas.SysUtils.LowerCase(AEvent.key);
    Result = "\x00";
    if (VKey.length === 1) {
      Result = VKey.charAt(0);
    } else {
      var $tmp1 = VKey;
      if ($tmp1 === "backspace") {
        Result = "\b"}
       else if ($tmp1 === "tab") {
        Result = "\t"}
       else if ($tmp1 === "enter") {
        Result = "\r"}
       else if ($tmp1 === "escape") Result = "\x1B";
    };
    return Result;
  };
  this.ExtractShiftState = function (AEvent) {
    var Result = {};
    Result = {};
    if (AEvent.altKey) {
      Result = rtl.unionSet(Result,rtl.createSet($mod.TShiftStateEnum.ssAlt));
    };
    if (AEvent.ctrlKey) {
      Result = rtl.unionSet(Result,rtl.createSet($mod.TShiftStateEnum.ssCtrl));
    };
    if (AEvent.shiftKey) {
      Result = rtl.unionSet(Result,rtl.createSet($mod.TShiftStateEnum.ssShift));
    };
    return Result;
  };
  this.ExtractShiftState$1 = function (AEvent) {
    var Result = {};
    Result = {};
    if (AEvent.altKey) {
      Result = rtl.unionSet(Result,rtl.createSet($mod.TShiftStateEnum.ssAlt));
    };
    if (AEvent.ctrlKey) {
      Result = rtl.unionSet(Result,rtl.createSet($mod.TShiftStateEnum.ssCtrl));
    };
    if (AEvent.shiftKey) {
      Result = rtl.unionSet(Result,rtl.createSet($mod.TShiftStateEnum.ssShift));
    };
    return Result;
  };
  this.ExtractMouseButton = function (AEvent) {
    var Result = 0;
    var $tmp1 = AEvent.button;
    if ($tmp1 === 1) {
      Result = $mod.TMouseButton.mbMiddle}
     else if ($tmp1 === 2) {
      Result = $mod.TMouseButton.mbRight}
     else {
      Result = $mod.TMouseButton.mbMiddle;
    };
    return Result;
  };
  this.JSCursor = function (ACursor) {
    var Result = "";
    var $tmp1 = ACursor;
    if ($tmp1 === -1) {
      Result = "none"}
     else if ($tmp1 === -3) {
      Result = "crosshair"}
     else if ($tmp1 === -4) {
      Result = "text"}
     else if ($tmp1 === -22) {
      Result = "move"}
     else if ($tmp1 === -6) {
      Result = "nesw-resize"}
     else if ($tmp1 === -7) {
      Result = "ns-resize"}
     else if ($tmp1 === -8) {
      Result = "nwse-resize"}
     else if ($tmp1 === -9) {
      Result = "ew-resize"}
     else if ($tmp1 === -23) {
      Result = "nwse-resize"}
     else if ($tmp1 === -24) {
      Result = "ns-resize"}
     else if ($tmp1 === -25) {
      Result = "nesw-resize"}
     else if ($tmp1 === -26) {
      Result = "col-resize"}
     else if ($tmp1 === -27) {
      Result = "col-resize"}
     else if ($tmp1 === -28) {
      Result = "nesw-resize"}
     else if ($tmp1 === -29) {
      Result = "ns-resize"}
     else if ($tmp1 === -30) {
      Result = "nwse-resize"}
     else if ($tmp1 === -11) {
      Result = "wait"}
     else if ($tmp1 === -13) {
      Result = "no-drop"}
     else if ($tmp1 === -14) {
      Result = "col-resize"}
     else if ($tmp1 === -15) {
      Result = "row-resize"}
     else if ($tmp1 === -17) {
      Result = "progress"}
     else if ($tmp1 === -18) {
      Result = "not-allowed"}
     else if ($tmp1 === -19) {
      Result = "wait"}
     else if ($tmp1 === -20) {
      Result = "help"}
     else if ($tmp1 === -21) {
      Result = "pointer"}
     else {
      Result = "";
    };
    return Result;
  };
},["Forms"]);
rtl.module("WebExtra",["System","JS","Classes","SysUtils","Web"],function () {
  "use strict";
  var $mod = this;
});
rtl.module("StdCtrls",["System","Classes","SysUtils","Types","Web","WebExtra","Graphics","Controls","Forms"],function () {
  "use strict";
  var $mod = this;
  this.TEditCharCase = {"0": "ecNormal", ecNormal: 0, "1": "ecUppercase", ecUppercase: 1, "2": "ecLowerCase", ecLowerCase: 2};
  $mod.$rtti.$Enum("TEditCharCase",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TEditCharCase});
  rtl.createClass($mod,"TCustomComboBox",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FDropDownCount = 0;
      this.FItemHeight = 0;
      this.FItemIndex = 0;
      this.FItems = null;
      this.FOnChange = null;
      this.FSorted = false;
    };
    this.$final = function () {
      this.FItems = undefined;
      this.FOnChange = undefined;
      pas.Controls.TWinControl.$final.call(this);
    };
    this.SetDropDownCount = function (AValue) {
      if (this.FItemHeight !== AValue) {
        this.FItemHeight = AValue;
        this.Changed();
      };
    };
    this.SetItemHeight = function (AValue) {
      if (this.FDropDownCount === AValue) {
        this.FDropDownCount = AValue;
        this.Change();
      };
    };
    this.SetItemIndex = function (AValue) {
      if ((AValue > -1) && (AValue < this.FItems.GetCount())) {
        this.FItemIndex = AValue;
        this.Changed();
      };
    };
    this.SetItems = function (AValue) {
      this.FItems.Assign(AValue);
      this.Changed();
    };
    this.SetSorted = function (AValue) {
      if (this.FSorted !== AValue) {
        this.FSorted = AValue;
        this.UpdateSorted();
      };
    };
    this.Change = function () {
      if (this.FOnChange != null) {
        this.FOnChange(this);
      };
    };
    this.HandleChange = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.FItemIndex = this.FHandleElement.selectedIndex;
      this.Change();
      Result = true;
      return Result;
    };
    this.Changed = function () {
      var VIndex = 0;
      var VOptionElement = null;
      var VValue = "";
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        for (var $l1 = this.FHandleElement.length - 1; $l1 >= 0; $l1--) {
          VIndex = $l1;
          this.FHandleElement.remove(VIndex);
        };
        for (var $l2 = 0, $end3 = this.FItems.GetCount() - 1; $l2 <= $end3; $l2++) {
          VIndex = $l2;
          VValue = this.FItems.Get(VIndex);
          VOptionElement = document.createElement("option");
          VOptionElement.value = VValue;
          VOptionElement.text = VValue;
          VOptionElement.selected = VIndex === this.FItemIndex;
          this.FHandleElement.add(VOptionElement);
        };
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("select");
      return Result;
    };
    this.RegisterHandleEvents = function () {
      pas.Controls.TWinControl.RegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.addEventListener("change",rtl.createCallback(this,"HandleChange"));
    };
    this.UnRegisterHandleEvents = function () {
      pas.Controls.TWinControl.UnRegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.removeEventListener("change",rtl.createCallback(this,"HandleChange"));
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.RealGetText = function () {
      var Result = "";
      Result = this.FItems.Get(this.FItemIndex);
      return Result;
    };
    this.RealSetText = function (AValue) {
      var VIndex = 0;
      VIndex = this.FItems.IndexOf(AValue);
      if ((VIndex > -1) && (VIndex < this.FItems.GetCount())) {
        this.FItemIndex = VIndex;
        this.Changed();
      };
    };
    this.UpdateSorted = function () {
      var VText = "";
      VText = this.RealGetText();
      this.FItems.SetSorted(this.FSorted);
      this.SetText(VText);
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 100;
      Result.cy = 25;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FDropDownCount = 8;
      this.FItemHeight = 0;
      this.FItemIndex = -1;
      this.FItems = pas.Classes.TStringList.$create("Create$1");
      this.FSorted = false;
      this.BeginUpdate();
      try {
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.Destroy = function () {
      this.FItems.$destroy("Destroy");
      this.FItems = null;
      pas.Controls.TControl.Destroy.call(this);
    };
    this.AddItem = function (AItem, AObject) {
      this.FItems.AddObject(AItem,AObject);
      this.Changed();
    };
    this.Append = function (AItem) {
      this.FItems.Append(AItem);
      this.Changed();
    };
    this.Clear = function () {
      this.FItems.Clear();
      this.Changed();
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TCustomEdit",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FAlignment = 0;
      this.FCharCase = 0;
      this.FMaxLength = 0;
      this.FModified = false;
      this.FPasswordChar = "";
      this.FPattern = "";
      this.FReadOnly = false;
      this.FRequired = false;
      this.FSelLength = 0;
      this.FSelStart = 0;
      this.FText = "";
      this.FTextHint = "";
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FOnChange = undefined;
      pas.Controls.TWinControl.$final.call(this);
    };
    this.GetSelLength = function () {
      var Result = 0;
      if (this.FHandleElement != null) {
        var $with1 = this.FHandleElement;
        this.FSelLength = $with1.selectionEnd - $with1.selectionStart;
      };
      Result = this.FSelLength;
      return Result;
    };
    this.GetSelStart = function () {
      var Result = 0;
      if (this.FHandleElement != null) {
        var $with1 = this.FHandleElement;
        this.FSelLength = $with1.selectionStart;
      };
      Result = this.FSelLength;
      return Result;
    };
    this.GetSelText = function () {
      var Result = "";
      Result = pas.System.Copy(this.RealGetText(),this.FSelStart + 1,this.FSelLength);
      return Result;
    };
    this.SetAlignment = function (AValue) {
      if (this.FAlignment !== AValue) {
        this.FAlignment = AValue;
        this.Changed();
      };
    };
    this.SetCharCase = function (AValue) {
      if (this.FCharCase !== AValue) {
        this.FCharCase = AValue;
        this.Changed();
      };
    };
    this.SetMaxLength = function (AValue) {
      if (this.FMaxLength !== AValue) {
        this.FMaxLength = AValue;
        this.Changed();
      };
    };
    this.SetModified = function (AValue) {
      if (this.FModified !== AValue) {
        this.FModified = AValue;
      };
    };
    this.SetPasswordChar = function (AValue) {
      if (this.FPasswordChar !== AValue) {
        this.FPasswordChar = AValue;
        this.Changed();
      };
    };
    this.SetPattern = function (AValue) {
      if (this.FPattern !== AValue) {
        this.FPattern = AValue;
        this.Changed();
      };
    };
    this.SetReadOnly = function (AValue) {
      if (this.FReadOnly !== AValue) {
        this.FReadOnly = AValue;
        this.Changed();
      };
    };
    this.SetRequired = function (AValue) {
      if (this.FRequired !== AValue) {
        this.FRequired = AValue;
        this.Changed();
      };
    };
    this.SetSelLength = function (AValue) {
      if (AValue < 0) {
        AValue = 0;
      };
      if (this.FSelLength !== AValue) {
        this.FSelLength = AValue;
        this.Changed();
      };
    };
    this.SetSelStart = function (AValue) {
      if (this.FSelStart !== AValue) {
        this.FSelStart = AValue;
        this.Changed();
      };
    };
    this.SetSelText = function (AValue) {
      var VText = "";
      var VLength = 0;
      var VStart = 0;
      if (!this.FReadOnly) {
        VText = this.RealGetText();
        VLength = this.GetSelLength();
        VStart = this.GetSelStart();
        if (VLength === 0) {
          pas.System.Insert(AValue,{get: function () {
              return VText;
            }, set: function (v) {
              VText = v;
            }},VStart);
        } else {
          pas.System.Delete({get: function () {
              return VText;
            }, set: function (v) {
              VText = v;
            }},VStart + 1,VLength);
          pas.System.Insert(AValue,{get: function () {
              return VText;
            }, set: function (v) {
              VText = v;
            }},VStart + 1);
        };
        if (this.FMaxLength > 0) {
          VText = pas.System.Copy(VText,1,this.FMaxLength);
        };
        this.RealSetText(VText);
      };
    };
    this.SetTextHint = function (AValue) {
      if (this.FTextHint !== AValue) {
        this.FTextHint = AValue;
        this.Changed();
      };
    };
    this.Change = function () {
      if (this.FOnChange != null) {
        this.FOnChange(this);
      };
    };
    this.DoEnter = function () {
      pas.Controls.TWinControl.DoEnter.call(this);
      this.SelectAll();
    };
    this.DoInput = function (ANewValue) {
      if (ANewValue !== this.RealGetText()) {
        this.FText = ANewValue;
        this.FModified = true;
        this.Change();
      };
    };
    this.HandleInput = function (AEvent) {
      var Result = false;
      AEvent.stopPropagation();
      this.DoInput(this.FHandleElement.value);
      Result = true;
      return Result;
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        var $tmp2 = this.FAlignment;
        if ($tmp2 === pas.Classes.TAlignment.taRightJustify) {
          $with1.style.setProperty("text-align","right")}
         else if ($tmp2 === pas.Classes.TAlignment.taCenter) {
          $with1.style.setProperty("text-align","center")}
         else {
          $with1.style.removeProperty("text-align");
        };
        var $tmp3 = this.FCharCase;
        if ($tmp3 === $mod.TEditCharCase.ecLowerCase) {
          $with1.style.setProperty("text-transform","lowercase")}
         else if ($tmp3 === $mod.TEditCharCase.ecUppercase) {
          $with1.style.setProperty("text-transform","uppercase")}
         else {
          $with1.style.removeProperty("text-transform");
        };
        if (this.FMaxLength > 0) {
          $with1.maxLength = this.FMaxLength;
        } else {
          $with1.removeAttribute("maxlength");
        };
        if (this.FPattern !== "") {
          $with1.pattern = this.FPattern;
        } else {
          $with1.removeAttribute("pattern");
        };
        if (this.FTextHint !== "") {
          $with1.placeholder = this.FTextHint;
        } else {
          $with1.removeAttribute("placeholder");
        };
        $with1.readOnly = this.FReadOnly;
        $with1.required = this.FRequired;
        var $tmp4 = this.InputType();
        if ((((($tmp4 === "text") || ($tmp4 === "search")) || ($tmp4 === "URL")) || ($tmp4 === "tel")) || ($tmp4 === "password")) {
          $with1.setSelectionRange(this.FSelStart,this.FSelStart + this.FSelLength);
        };
        $with1.type = this.InputType();
        $with1.value = this.RealGetText();
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("input");
      return Result;
    };
    this.RegisterHandleEvents = function () {
      pas.Controls.TWinControl.RegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.addEventListener("input",rtl.createCallback(this,"HandleInput"));
    };
    this.UnRegisterHandleEvents = function () {
      pas.Controls.TWinControl.UnRegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.removeEventListener("input",rtl.createCallback(this,"HandleInput"));
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = pas.Controls.TWinControl.CheckChildClassAllowed.call(this,AChildClass);
      return Result;
    };
    this.RealGetText = function () {
      var Result = "";
      Result = this.FText;
      return Result;
    };
    this.RealSetText = function (AValue) {
      this.FText = AValue;
      this.FModified = false;
      this.Changed();
    };
    this.InputType = function () {
      var Result = "";
      Result = pas.Controls.IfThen$3(this.FPasswordChar !== "\x00","password","text");
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 80;
      Result.cy = 25;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FMaxLength = 0;
      this.FModified = false;
      this.FPasswordChar = "\x00";
      this.FPattern = "";
      this.FReadOnly = false;
      this.FTextHint = "";
      this.FText = "";
      this.BeginUpdate();
      try {
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.Clear = function () {
      this.FText = "";
      this.Changed();
    };
    this.SelectAll = function () {
      if (this.RealGetText() !== "") {
        this.BeginUpdate();
        try {
          this.SetSelStart(0);
          this.SetSelLength(this.RealGetText().length);
        } finally {
          this.EndUpdate();
        };
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TCustomMemo",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FAlignment = 0;
      this.FCharCase = 0;
      this.FLines = null;
      this.FMaxLength = 0;
      this.FModified = false;
      this.FReadOnly = false;
      this.FSelLength = 0;
      this.FSelStart = 0;
      this.FTextHint = "";
      this.FWantReturns = false;
      this.FWantTabs = false;
      this.FWordWrap = false;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FLines = undefined;
      this.FOnChange = undefined;
      pas.Controls.TWinControl.$final.call(this);
    };
    this.GetSelLength = function () {
      var Result = 0;
      if (this.FHandleElement != null) {
        var $with1 = this.FHandleElement;
        this.FSelLength = $with1.selectionEnd - $with1.selectionStart;
      };
      Result = this.FSelLength;
      return Result;
    };
    this.GetSelStart = function () {
      var Result = 0;
      if (this.FHandleElement != null) {
        var $with1 = this.FHandleElement;
        this.FSelLength = $with1.selectionStart;
      };
      Result = this.FSelLength;
      return Result;
    };
    this.GetSelText = function () {
      var Result = "";
      Result = pas.System.Copy(this.RealGetText(),this.FSelStart + 1,this.FSelLength);
      return Result;
    };
    this.SetAlignment = function (AValue) {
      if (this.FAlignment !== AValue) {
        this.FAlignment = AValue;
        this.Changed();
      };
    };
    this.SetCharCase = function (AValue) {
      if (this.FCharCase !== AValue) {
        this.FCharCase = AValue;
        this.Changed();
      };
    };
    this.SetLines = function (AValue) {
      this.FLines.Assign(AValue);
      this.Changed();
    };
    this.SetMaxLength = function (AValue) {
      if (this.FMaxLength !== AValue) {
        this.FMaxLength = AValue;
        this.Changed();
      };
    };
    this.SetModified = function (AValue) {
      if (this.FModified !== AValue) {
        this.FModified = AValue;
      };
    };
    this.SetReadOnly = function (AValue) {
      if (this.FReadOnly !== AValue) {
        this.FReadOnly = AValue;
        this.Changed();
      };
    };
    this.SetSelLength = function (AValue) {
      if (AValue < 0) {
        AValue = 0;
      };
      if (this.FSelLength !== AValue) {
        this.FSelLength = AValue;
        this.Changed();
      };
    };
    this.SetSelStart = function (AValue) {
      if (this.FSelStart !== AValue) {
        this.FSelStart = AValue;
        this.Changed();
      };
    };
    this.SetSelText = function (AValue) {
      var VText = "";
      var VLength = 0;
      var VStart = 0;
      if (!this.FReadOnly) {
        VText = this.RealGetText();
        VLength = this.GetSelLength();
        VStart = this.GetSelStart();
        if (VLength === 0) {
          pas.System.Insert(AValue,{get: function () {
              return VText;
            }, set: function (v) {
              VText = v;
            }},VStart);
        } else {
          pas.System.Delete({get: function () {
              return VText;
            }, set: function (v) {
              VText = v;
            }},VStart + 1,VLength);
          pas.System.Insert(AValue,{get: function () {
              return VText;
            }, set: function (v) {
              VText = v;
            }},VStart + 1);
        };
        if (this.FMaxLength > 0) {
          VText = pas.System.Copy(VText,1,this.FMaxLength);
        };
        this.RealSetText(VText);
      };
    };
    this.SetTextHint = function (AValue) {
      if (this.FTextHint !== AValue) {
        this.FTextHint = AValue;
      };
    };
    this.SetWantReturns = function (AValue) {
      if (this.FWantReturns !== AValue) {
        this.FWantReturns = AValue;
      };
    };
    this.SetWantTabs = function (AValue) {
      if (this.FWantTabs !== AValue) {
        this.FWantTabs = AValue;
      };
    };
    this.SetWordWrap = function (AValue) {
      if (this.FWordWrap !== AValue) {
        this.FWordWrap = AValue;
        this.Changed();
      };
    };
    this.Change = function () {
      if (this.FOnChange != null) {
        this.FOnChange(this);
      };
    };
    this.KeyDown = function (Key, Shift) {
      pas.Controls.TWinControl.KeyDown.call(this,Key,rtl.refSet(Shift));
      if (!this.FWantReturns && (Key.get() === 13)) {
        Key.set(0);
      };
    };
    this.HandleChange = function (AEvent) {
      var Result = false;
      var VNewText = "";
      var VOldText = "";
      AEvent.stopPropagation();
      VNewText = this.FHandleElement.value;
      VOldText = this.RealGetText();
      if (VNewText !== VOldText) {
        this.FLines.SetTextStr(VNewText);
        this.FModified = true;
        this.Change();
      };
      Result = true;
      return Result;
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        var $tmp2 = this.FAlignment;
        if ($tmp2 === pas.Classes.TAlignment.taRightJustify) {
          $with1.style.setProperty("text-align","right")}
         else if ($tmp2 === pas.Classes.TAlignment.taCenter) {
          $with1.style.setProperty("text-align","center")}
         else {
          $with1.style.removeProperty("text-align");
        };
        var $tmp3 = this.FCharCase;
        if ($tmp3 === $mod.TEditCharCase.ecLowerCase) {
          $with1.style.setProperty("text-transform","lowercase")}
         else if ($tmp3 === $mod.TEditCharCase.ecUppercase) {
          $with1.style.setProperty("text-transform","uppercase")}
         else {
          $with1.style.removeProperty("text-transform");
        };
        if (this.FMaxLength > 0) {
          $with1.maxLength = this.FMaxLength;
        } else {
          $with1.removeAttribute("maxlength");
        };
        if (this.FTextHint !== "") {
          $with1.placeholder = this.FTextHint;
        } else {
          $with1.removeAttribute("placeholder");
        };
        $with1.readOnly = this.FReadOnly;
        $with1.style.setProperty("resize","none");
        if (this.FWordWrap) {
          $with1.removeAttribute("wrap");
        } else {
          $with1.wrap = "off";
        };
        $with1.style.setProperty("overflow","auto");
        $with1.value = this.RealGetText();
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("textarea");
      return Result;
    };
    this.RegisterHandleEvents = function () {
      pas.Controls.TWinControl.RegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.addEventListener("input",rtl.createCallback(this,"HandleChange"));
    };
    this.UnRegisterHandleEvents = function () {
      pas.Controls.TWinControl.UnRegisterHandleEvents.call(this);
      var $with1 = this.FHandleElement;
      $with1.removeEventListener("input",rtl.createCallback(this,"HandleChange"));
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.RealGetText = function () {
      var Result = "";
      Result = this.FLines.GetTextStr();
      return Result;
    };
    this.RealSetText = function (AValue) {
      this.FLines.SetTextStr(AValue);
      this.FModified = false;
      this.Changed();
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 150;
      Result.cy = 90;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FLines = pas.Classes.TStringList.$create("Create$1");
      this.FMaxLength = 0;
      this.FModified = false;
      this.FReadOnly = false;
      this.FTextHint = "";
      this.FWantReturns = true;
      this.FWantTabs = false;
      this.FWordWrap = true;
      this.BeginUpdate();
      try {
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.Destroy = function () {
      this.FLines.$destroy("Destroy");
      this.FLines = null;
      pas.Controls.TControl.Destroy.call(this);
    };
    this.Append = function (AValue) {
      this.FLines.Append(AValue);
      this.Changed();
    };
    this.Clear = function () {
      this.FLines.Clear();
      this.Changed();
    };
    this.SelectAll = function () {
      if (this.RealGetText() !== "") {
        this.BeginUpdate();
        try {
          this.SetSelStart(0);
          this.SetSelLength(this.RealGetText().length);
        } finally {
          this.EndUpdate();
        };
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TCustomButton",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FCancel = false;
      this.FDefault = false;
      this.FModalResult = 0;
    };
    this.SetCancel = function (AValue) {
      if (this.FCancel !== AValue) {
        this.FCancel = AValue;
      };
    };
    this.SetDefault = function (AValue) {
      if (this.FDefault !== AValue) {
        this.FDefault = AValue;
      };
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("padding","0");
        $with1.innerHTML = this.GetText();
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("button");
      return Result;
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 80;
      Result.cy = 25;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FModalResult = 0;
      this.BeginUpdate();
      try {
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.AdjustSize = function () {
      var VSize = new pas.Types.TSize();
      pas.Controls.TControl.AdjustSize.call(this);
      VSize = new pas.Types.TSize(this.FFont.TextExtent(this.GetText()));
      this.SetBounds(this.FLeft,this.FTop,VSize.cx,VSize.cy);
    };
    this.Click = function () {
      var VParent = null;
      if (this.FModalResult !== 0) {
        VParent = this.FParent;
        while (VParent != null) {
          if (pas.Forms.TCustomForm.isPrototypeOf(VParent)) {
            VParent.SetModalResult(this.FModalResult);
            break;
          };
          VParent = VParent.FParent;
        };
      };
      pas.Controls.TControl.Click.call(this);
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  this.TCheckBoxState = {"0": "cbUnchecked", cbUnchecked: 0, "1": "cbChecked", cbChecked: 1};
  $mod.$rtti.$Enum("TCheckBoxState",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TCheckBoxState});
  $mod.$rtti.$Enum("TLeftRight",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TAlignment});
  rtl.createClass($mod,"TCustomCheckbox",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FAlignment = pas.Classes.TAlignment.taLeftJustify;
      this.FLabelElement = null;
      this.FMarkElement = null;
      this.FState = 0;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FLabelElement = undefined;
      this.FMarkElement = undefined;
      this.FOnChange = undefined;
      pas.Controls.TWinControl.$final.call(this);
    };
    this.GetChecked = function () {
      var Result = false;
      Result = this.GetState() === $mod.TCheckBoxState.cbChecked;
      return Result;
    };
    this.GetState = function () {
      var Result = 0;
      Result = this.FState;
      return Result;
    };
    this.SetAlignment = function (AValue) {
      if (this.FAlignment !== AValue) {
        this.FAlignment = AValue;
      };
    };
    this.SetChecked = function (AValue) {
      if (AValue) {
        this.SetState($mod.TCheckBoxState.cbChecked);
      } else {
        this.SetState($mod.TCheckBoxState.cbUnchecked);
      };
    };
    this.SetState = function (AValue) {
      if (this.FState !== AValue) {
        this.FState = AValue;
        this.Changed();
        this.DoOnChange();
      };
    };
    this.DoOnChange = function () {
      if (this.FOnChange != null) {
        this.FOnChange(this);
      };
    };
    this.HandleClick = function (AEvent) {
      var Result = false;
      this.SetChecked(this.FState !== $mod.TCheckBoxState.cbChecked);
      Result = pas.Controls.TControl.HandleClick.call(this,AEvent);
      return Result;
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("user-select","none");
        $with1.style.setProperty("-moz-user-select","none");
        $with1.style.setProperty("-ms-user-select","none");
        $with1.style.setProperty("-khtml-user-select","none");
        $with1.style.setProperty("-webkit-user-select","none");
        $with1.style.setProperty("display","flex");
        $with1.style.setProperty("align-items","center");
        var $with2 = this.FMarkElement;
        $with2.checked = this.FState === $mod.TCheckBoxState.cbChecked;
        $with2.type = "checkbox";
        var $with3 = this.FLabelElement;
        $with3.innerHTML = this.GetText();
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("span");
      return Result;
    };
    this.CreateMarkElement = function () {
      var Result = null;
      Result = this.FHandleElement.appendChild(document.createElement("input"));
      return Result;
    };
    this.CreateLabelElement = function () {
      var Result = null;
      Result = this.FHandleElement.appendChild(document.createElement("span"));
      return Result;
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 90;
      Result.cy = 23;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FMarkElement = this.CreateMarkElement();
      this.FLabelElement = this.CreateLabelElement();
      this.FAlignment = pas.Classes.TAlignment.taRightJustify;
      this.FState = $mod.TCheckBoxState.cbUnchecked;
      try {
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TCustomLabel",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FAlignment = 0;
      this.FContentElement = null;
      this.FFocusControl = null;
      this.FLayout = 0;
      this.FTransparent = false;
      this.FWordWrap = false;
    };
    this.$final = function () {
      this.FContentElement = undefined;
      this.FFocusControl = undefined;
      pas.Controls.TWinControl.$final.call(this);
    };
    this.SetAlignment = function (AValue) {
      if (this.FAlignment !== AValue) {
        this.FAlignment = AValue;
        this.Changed();
      };
    };
    this.SetLayout = function (AValue) {
      if (this.FLayout !== AValue) {
        this.FLayout = AValue;
        this.Changed();
      };
    };
    this.SetTransparent = function (AValue) {
      if (this.FTransparent !== AValue) {
        this.FTransparent = AValue;
        this.BeginUpdate();
        try {
          if (this.FTransparent) {
            this.SetColor(536870911);
          } else if (this.FColor === 536870911) {
            this.SetColor(2147483649);
          };
        } finally {
          this.EndUpdate();
        };
      };
    };
    this.SetWordWrap = function (AValue) {
      if (this.FWordWrap !== AValue) {
        this.FWordWrap = AValue;
        this.Changed();
      };
    };
    this.DoEnter = function () {
      pas.Controls.TWinControl.DoEnter.call(this);
      if ((this.FFocusControl != null) && this.FFocusControl.CanSetFocus()) {
        this.FFocusControl.SetFocus();
      };
    };
    this.Changed = function () {
      var VTr = null;
      var VTd = null;
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        if (this.FTransparent) {
          $with1.style.setProperty("background-color","transparent");
        };
        $with1.style.setProperty("outline","none");
        $with1.style.setProperty("user-select","none");
        $with1.style.setProperty("-moz-user-select","none");
        $with1.style.setProperty("-ms-user-select","none");
        $with1.style.setProperty("-khtml-user-select","none");
        $with1.style.setProperty("-webkit-user-select","none");
        var $with2 = this.FContentElement;
        $with2.innerHTML = "";
        $with2.style.setProperty("height","100%");
        $with2.style.setProperty("width","100%");
        $with2.style.setProperty("table-layout","fixed");
        VTr = this.FContentElement.appendChild(document.createElement("tr"));
        VTd = VTr.appendChild(document.createElement("td"));
        var $tmp3 = this.FAlignment;
        if ($tmp3 === pas.Classes.TAlignment.taCenter) {
          VTd.style.setProperty("text-align","center")}
         else if ($tmp3 === pas.Classes.TAlignment.taLeftJustify) {
          VTd.style.setProperty("text-align","left")}
         else if ($tmp3 === pas.Classes.TAlignment.taRightJustify) VTd.style.setProperty("text-align","right");
        var $tmp4 = this.FLayout;
        if ($tmp4 === pas.Graphics.TTextLayout.tlBottom) {
          VTd.style.setProperty("vertical-align","bottom")}
         else if ($tmp4 === pas.Graphics.TTextLayout.tlCenter) {
          VTd.style.setProperty("vertical-align","middle")}
         else if ($tmp4 === pas.Graphics.TTextLayout.tlTop) VTd.style.setProperty("vertical-align","top");
        if (this.FWordWrap) {
          VTd.style.setProperty("word-wrap","break-word");
        } else {
          VTd.style.removeProperty("word-wrap");
        };
        VTd.style.setProperty("overflow","hidden");
        VTd.style.setProperty("text-overflow","ellipsis");
        VTd.innerHTML = this.GetText();
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.CreateContentElement = function () {
      var Result = null;
      Result = this.FHandleElement.appendChild(document.createElement("table"));
      return Result;
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 65;
      Result.cy = 17;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FContentElement = this.CreateContentElement();
      this.FAlignment = pas.Classes.TAlignment.taLeftJustify;
      this.FFocusControl = null;
      this.FLayout = pas.Graphics.TTextLayout.tlTop;
      this.FTransparent = true;
      this.FWordWrap = false;
      this.BeginUpdate();
      try {
        this.SetTabStop(false);
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.AdjustSize = function () {
      var VSize = new pas.Types.TSize();
      pas.Controls.TControl.AdjustSize.call(this);
      VSize = new pas.Types.TSize(this.FFont.TextExtent(this.GetText()));
      this.SetBounds(this.FLeft,this.FTop,VSize.cx + 4,VSize.cy + 4);
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
});
rtl.module("ExtCtrls",["System","Classes","SysUtils","Types","Web","Graphics","Controls"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TCustomImage",pas.Controls.TCustomControl,function () {
    this.$init = function () {
      pas.Controls.TCustomControl.$init.call(this);
      this.FCenter = false;
      this.FPicture = null;
      this.FProportional = false;
      this.FStretch = false;
      this.FOnPictureChanged = null;
      this.FStretchInEnabled = false;
      this.FStretchOutEnabled = false;
      this.FTransparent = false;
    };
    this.$final = function () {
      this.FPicture = undefined;
      this.FOnPictureChanged = undefined;
      pas.Controls.TCustomControl.$final.call(this);
    };
    this.SetCenter = function (AValue) {
      if (this.FCenter !== AValue) {
        this.FCenter = AValue;
        this.PictureChanged(this);
      };
    };
    this.SetPicture = function (AValue) {
      if (!this.FPicture.IsEqual(AValue)) {
        this.FPicture.Assign(AValue);
      };
    };
    this.SetProportiona = function (AValue) {
      if (this.FProportional !== AValue) {
        this.FProportional = AValue;
        this.PictureChanged(this);
      };
    };
    this.SetStretch = function (AValue) {
      if (this.FStretch !== AValue) {
        this.FStretch = AValue;
        this.PictureChanged(this);
      };
    };
    this.SetStretchInEnabled = function (AValue) {
      if (this.FStretchInEnabled !== AValue) ;
      this.FStretchInEnabled = AValue;
      this.PictureChanged(this);
    };
    this.SetStretchOutEnabled = function (AValue) {
      if (this.FStretchOutEnabled !== AValue) {
        this.FStretchOutEnabled = AValue;
        this.PictureChanged(this);
      };
    };
    this.SetTransparent = function (AValue) {
      if (this.FTransparent === AValue) {
        this.FTransparent = AValue;
      };
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("outline","none");
        $with1.style.setProperty("background-image",this.FPicture.FData);
        $with1.style.setProperty("background-repeat","no-repeat");
        if (this.FCenter) {
          $with1.style.setProperty("background-position","center  center");
        } else {
          $with1.style.removeProperty("background-position");
        };
        if (this.FProportional) {
          $with1.style.setProperty("background-size","contain");
        } else if (this.FStretch) {
          if (this.FStretchInEnabled && this.FStretchOutEnabled) {
            $with1.style.setProperty("background-size","100% 100%");
          } else if (this.FStretchInEnabled) {
            $with1.style.setProperty("background-size","auto 100%");
          } else if (this.FStretchOutEnabled) {
            $with1.style.setProperty("background-size","100% auto");
          };
        } else {
          $with1.style.setProperty("background-size","auto");
        };
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.PictureChanged = function (Sender) {
      this.Changed();
      if (this.FOnPictureChanged != null) {
        this.FOnPictureChanged(this);
      };
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 90;
      Result.cy = 90;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FPicture = pas.Graphics.TPicture.$create("Create$1");
      this.FPicture.FOnChange = rtl.createCallback(this,"PictureChanged");
      this.FCenter = false;
      this.FProportional = false;
      this.FStretch = false;
      this.FStretchOutEnabled = true;
      this.FStretchInEnabled = true;
      this.FTransparent = false;
      this.BeginUpdate();
      try {
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  $mod.$rtti.$Int("TBevelWidth",{minvalue: 1, maxvalue: 2147483647, ordtype: 5});
  rtl.createClass($mod,"TCustomPanel",pas.Controls.TCustomControl,function () {
    this.$init = function () {
      pas.Controls.TCustomControl.$init.call(this);
      this.FAlignment = 0;
      this.FBevelColor = 0;
      this.FBevelInner = 0;
      this.FBevelOuter = 0;
      this.FBevelWidth = 0;
      this.FContentElement = null;
      this.FLayout = 0;
      this.FWordWrap = false;
    };
    this.$final = function () {
      this.FContentElement = undefined;
      pas.Controls.TCustomControl.$final.call(this);
    };
    this.SetAlignment = function (AValue) {
      if (this.FAlignment !== AValue) {
        this.FAlignment = AValue;
        this.Changed();
      };
    };
    this.SetBevelColor = function (AValue) {
      if (this.FBevelColor !== AValue) {
        this.FBevelColor = AValue;
        this.Changed();
      };
    };
    this.SetBevelInner = function (AValue) {
      if (this.FBevelInner !== AValue) {
        this.FBevelInner = AValue;
        this.Changed();
      };
    };
    this.SetBevelOuter = function (AValue) {
      if (this.FBevelOuter !== AValue) {
        this.FBevelOuter = AValue;
        this.Changed();
      };
    };
    this.SetBevelWidth = function (AValue) {
      if (this.FBevelWidth !== AValue) {
        this.FBevelWidth = AValue;
        this.Changed();
      };
    };
    this.SetLayout = function (AValue) {
      if (this.FLayout !== AValue) {
        this.FLayout = AValue;
        this.Changed();
      };
    };
    this.SetWordWrap = function (AValue) {
      if (this.FWordWrap !== AValue) {
        this.FWordWrap = AValue;
        this.Changed();
      };
    };
    this.Changed = function () {
      var VTopColor = 0;
      var VBottomColor = 0;
      var VTr = null;
      var VTd = null;
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        if (this.FBevelOuter === pas.Controls.TBevelCut.bvNone) {
          $with1.style.removeProperty("border-width");
          $with1.style.removeProperty("border-left-color");
          $with1.style.removeProperty("border-left-style");
          $with1.style.removeProperty("border-top-color");
          $with1.style.removeProperty("border-top-style");
          $with1.style.removeProperty("border-right-color");
          $with1.style.removeProperty("border-right-style");
          $with1.style.removeProperty("border-bottom-color");
          $with1.style.removeProperty("border-bottom-style");
        } else {
          if (this.FBevelColor === 536870912) {
            var $tmp2 = this.FBevelOuter;
            if ($tmp2 === pas.Controls.TBevelCut.bvLowered) {
              VTopColor = 8421504;
              VBottomColor = 16777215;
            } else if ($tmp2 === pas.Controls.TBevelCut.bvRaised) {
              VTopColor = 16777215;
              VBottomColor = 8421504;
            } else {
              VTopColor = this.FColor;
              VBottomColor = this.FColor;
            };
          } else {
            VTopColor = this.FBevelColor;
            VBottomColor = this.FBevelColor;
          };
          $with1.style.setProperty("border-width",pas.SysUtils.IntToStr(this.FBevelWidth) + "px");
          $with1.style.setProperty("border-style","solid");
          $with1.style.setProperty("border-left-color",pas.Graphics.JSColor(VTopColor));
          $with1.style.setProperty("border-top-color",pas.Graphics.JSColor(VTopColor));
          $with1.style.setProperty("border-right-color",pas.Graphics.JSColor(VBottomColor));
          $with1.style.setProperty("border-bottom-color",pas.Graphics.JSColor(VBottomColor));
        };
        $with1.style.setProperty("outline","none");
        $with1.style.setProperty("user-select","none");
        $with1.style.setProperty("-moz-user-select","none");
        $with1.style.setProperty("-ms-user-select","none");
        $with1.style.setProperty("-khtml-user-select","none");
        $with1.style.setProperty("-webkit-user-select","none");
        var $with3 = this.FContentElement;
        $with3.innerHTML = "";
        $with3.style.setProperty("height","100%");
        $with3.style.setProperty("width","100%");
        $with3.style.setProperty("table-layout","fixed");
        VTr = this.FContentElement.appendChild(document.createElement("tr"));
        VTd = VTr.appendChild(document.createElement("td"));
        var $tmp4 = this.FAlignment;
        if ($tmp4 === pas.Classes.TAlignment.taCenter) {
          VTd.style.setProperty("text-align","center")}
         else if ($tmp4 === pas.Classes.TAlignment.taLeftJustify) {
          VTd.style.setProperty("text-align","left")}
         else if ($tmp4 === pas.Classes.TAlignment.taRightJustify) VTd.style.setProperty("text-align","right");
        var $tmp5 = this.FLayout;
        if ($tmp5 === pas.Graphics.TTextLayout.tlBottom) {
          VTd.style.setProperty("vertical-align","bottom")}
         else if ($tmp5 === pas.Graphics.TTextLayout.tlCenter) {
          VTd.style.setProperty("vertical-align","middle")}
         else if ($tmp5 === pas.Graphics.TTextLayout.tlTop) VTd.style.setProperty("vertical-align","top");
        if (this.FWordWrap) {
          VTd.style.setProperty("word-wrap","break-word");
        } else {
          VTd.style.removeProperty("word-wrap");
        };
        VTd.style.setProperty("overflow","hidden");
        VTd.style.setProperty("text-overflow","ellipsis");
        VTd.innerHTML = this.GetText();
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.CreateContentElement = function () {
      var Result = null;
      Result = this.FHandleElement.appendChild(document.createElement("table"));
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 170;
      Result.cy = 50;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FContentElement = this.CreateContentElement();
      this.FAlignment = pas.Classes.TAlignment.taCenter;
      this.FBevelColor = 536870912;
      this.FBevelOuter = pas.Controls.TBevelCut.bvRaised;
      this.FBevelInner = pas.Controls.TBevelCut.bvNone;
      this.FBevelWidth = 1;
      this.FLayout = pas.Graphics.TTextLayout.tlCenter;
      this.FWordWrap = false;
      this.BeginUpdate();
      try {
        this.SetTabStop(false);
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
});
rtl.module("ComCtrls",["System","Classes","SysUtils","Types","JS","Web","Graphics","Controls"],function () {
  "use strict";
  var $mod = this;
  $mod.$rtti.$Class("TCustomPageControl");
  this.TTabPosition = {"0": "tpTop", tpTop: 0, "1": "tpBottom", tpBottom: 1, "2": "tpLeft", tpLeft: 2, "3": "tpRight", tpRight: 3};
  $mod.$rtti.$Enum("TTabPosition",{minvalue: 0, maxvalue: 3, ordtype: 1, enumtype: this.TTabPosition});
  rtl.createClass($mod,"TCustomTabSheet",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FTabVisible = false;
    };
    this.GetPageControl = function () {
      var Result = null;
      if ($mod.TCustomPageControl.isPrototypeOf(this.FParent)) {
        Result = this.FParent;
      } else {
        Result = null;
      };
      return Result;
    };
    this.GetPageIndex = function () {
      var Result = 0;
      if ($mod.TCustomPageControl.isPrototypeOf(this.FParent)) {
        Result = this.FParent.IndexOf(this);
      } else {
        Result = -1;
      };
      return Result;
    };
    this.SetPageControl = function (AValue) {
      if (this.GetPageControl() === AValue) {
        this.SetParent(AValue);
      };
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("background-color","#fff");
        $with1.style.setProperty("outline","none");
        $with1.style.setProperty("border","1px solid #c9c3ba");
        $with1.style.setProperty("border-top","0px");
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("span");
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FTabVisible = true;
      this.BeginUpdate();
      try {
        this.SetVisible(false);
      } finally {
        this.EndUpdate();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TTabSheet",$mod.TCustomTabSheet,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Caption",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("ClientHeight",3,rtl.nativeint,"GetClientHeight","SetClientHeight");
    $r.addProperty("ClientWidth",3,rtl.nativeint,"GetClientWidth","SetClientWidth");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("Height",2,rtl.nativeint,"FHeight","SetHeight");
    $r.addProperty("Left",2,rtl.nativeint,"FLeft","SetLeft");
    $r.addProperty("PageIndex",1,rtl.nativeint,"GetPageIndex","");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabVisible",0,rtl.boolean,"FTabVisible","FTabVisible");
    $r.addProperty("Top",2,rtl.nativeint,"FTop","SetTop");
    $r.addProperty("Width",2,rtl.nativeint,"FWidth","SetWidth");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
  });
  rtl.createClass($mod,"TCustomPageControl",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FMultiLine = false;
      this.FPageIndex = 0;
      this.FPages = null;
      this.FShowTabs = false;
      this.FTabContainerElement = null;
      this.FTabHeight = 0;
      this.FTabPosition = 0;
      this.FTabWidth = 0;
    };
    this.$final = function () {
      this.FPages = undefined;
      this.FTabContainerElement = undefined;
      pas.Controls.TWinControl.$final.call(this);
    };
    this.GetActivePage = function () {
      var Result = null;
      Result = this.GetPage(this.FPageIndex);
      return Result;
    };
    this.GetPage = function (AIndex) {
      var Result = null;
      if ((AIndex >= 0) && (AIndex < this.FPages.length)) {
        Result = rtl.getObject(this.FPages[AIndex]);
      } else {
        Result = null;
      };
      return Result;
    };
    this.GetPageCount = function () {
      var Result = 0;
      Result = this.FPages.length;
      return Result;
    };
    this.SetActivePage = function (AValue) {
      this.SetPageIndex(this.FPages.indexOf(AValue));
    };
    this.SetMultiLine = function (AValue) {
      if (this.FMultiLine !== AValue) {
        this.FMultiLine = AValue;
      };
    };
    this.SetPageIndex = function (AValue) {
      if ((AValue < 0) || (AValue >= this.FPages.length)) {
        AValue = 0;
      };
      if (AValue !== this.FPageIndex) {
        this.FPageIndex = AValue;
        this.Changed();
      };
    };
    this.SetShowTabs = function (AValue) {
      if (this.FShowTabs !== AValue) {
        this.FShowTabs = AValue;
        this.Changed();
      };
    };
    this.SetTabHeight = function (AValue) {
      if (this.FTabHeight !== AValue) {
        this.FTabHeight = AValue;
        this.Changed();
      };
    };
    this.SetTabPosition = function (AValue) {
      if (this.FTabPosition !== AValue) {
        this.FTabPosition = AValue;
      };
    };
    this.SetTabWidth = function (AValue) {
      if (this.FTabWidth !== AValue) {
        this.FTabWidth = AValue;
        this.Changed();
      };
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("outline","none");
        this.RenderTabs();
        this.UpdatePages();
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.CreateTabContainerElement = function () {
      var Result = null;
      Result = document.createElement("span");
      this.FHandleElement.appendChild(Result);
      return Result;
    };
    this.RegisterChild = function (AControl) {
      var VIndex = 0;
      pas.Controls.TControl.RegisterChild.call(this,AControl);
      if ((AControl != null) && $mod.TCustomTabSheet.isPrototypeOf(AControl)) {
        VIndex = this.FPages.indexOf(AControl);
        if (VIndex < 0) {
          this.FPages.push(AControl);
        };
      };
    };
    this.UnRegisterChild = function (AControl) {
      var VIndex = 0;
      pas.Controls.TControl.UnRegisterChild.call(this,AControl);
      if ((AControl != null) && $mod.TCustomTabSheet.isPrototypeOf(AControl)) {
        VIndex = this.FPages.indexOf(AControl);
        if (VIndex >= 0) {
          this.FPages.splice(VIndex,1);
        };
      };
    };
    this.CalcTabHeight = function () {
      var Result = 0;
      if (this.FShowTabs) {
        if (this.FTabHeight > 0) {
          Result = this.FTabHeight;
        } else {
          Result = this.FFont.TextHeight("Fj") + 10;
        };
      } else {
        Result = 0;
      };
      return Result;
    };
    this.CalcTabWidth = function (AText) {
      var Result = 0;
      if (this.FTabWidth > 0) {
        Result = this.FTabWidth;
      } else {
        Result = this.FFont.TextWidth(AText) + 10;
      };
      return Result;
    };
    this.CalcMaxTabWidth = function () {
      var Result = 0;
      var VPage = null;
      var VIndex = 0;
      var VWidth = 0;
      Result = 0;
      if (this.FTabWidth > 0) {
        Result = this.FTabWidth;
      } else {
        for (var $l1 = 0, $end2 = this.FPages.length - 1; $l1 <= $end2; $l1++) {
          VIndex = $l1;
          VPage = rtl.getObject(this.FPages[VIndex]);
          if ((VPage != null) && VPage.FTabVisible) {
            VWidth = this.CalcTabWidth(VPage.GetText());
            if (VWidth > Result) {
              Result = VWidth;
            };
          };
        };
      };
      return Result;
    };
    this.CalcSumTabsWidth = function () {
      var Result = 0;
      var VIndex = 0;
      var VPage = null;
      Result = 0;
      for (var $l1 = 0, $end2 = this.FPages.length - 1; $l1 <= $end2; $l1++) {
        VIndex = $l1;
        VPage = rtl.getObject(this.FPages[VIndex]);
        if ((VPage != null) && VPage.FTabVisible) {
          Result = Result + this.CalcTabWidth(VPage.GetText());
        };
      };
      return Result;
    };
    this.IndexOfTab = function (ACaption) {
      var Result = 0;
      var VIndex = 0;
      var VPage = null;
      Result = -1;
      for (var $l1 = 0, $end2 = this.FPages.length - 1; $l1 <= $end2; $l1++) {
        VIndex = $l1;
        VPage = rtl.getObject(this.FPages[VIndex]);
        if (((VPage != null) && VPage.FTabVisible) && pas.SysUtils.SameText(VPage.GetText(),ACaption)) {
          Result = VIndex;
        };
      };
      return Result;
    };
    this.RenderTab = function (ACaption, ALeft, ATop, AWidth, AHeight, AEvent) {
      var Result = null;
      Result = document.createElement("button");
      Result.style.setProperty("left",pas.SysUtils.IntToStr(ALeft) + "px");
      Result.style.setProperty("top",pas.SysUtils.IntToStr(ATop) + "px");
      Result.style.setProperty("width",pas.SysUtils.IntToStr(AWidth) + "px");
      Result.style.setProperty("height",pas.SysUtils.IntToStr(AHeight) + "px");
      Result.style.setProperty("border","1px solid #c9c3ba");
      Result.style.setProperty("border-top-left-radius","15px");
      Result.style.setProperty("border-top-right-radius","2px");
      Result.style.setProperty("background-color","#dddada");
      Result.style.setProperty("color",pas.Graphics.JSColor(this.FFont.FColor));
      Result.style.setProperty("font",pas.Graphics.JSFont(this.FFont));
      Result.style.setProperty("outline","none");
      Result.style.setProperty("position","absolute");
      Result.style.setProperty("overflow","hidden");
      Result.style.setProperty("padding","0");
      Result.style.setProperty("white-space","nowrap");
      Result.addEventListener("click",AEvent);
      Result.innerHTML = ACaption;
      return Result;
    };
    this.RenderTabActive = function (ACaption, ALeft, ATop, AWidth, AHeight, AEvent) {
      var Result = null;
      Result = this.RenderTab(ACaption,ALeft,ATop,AWidth,AHeight,AEvent);
      Result.style.setProperty("border-bottom","0px");
      Result.style.setProperty("background-color","#fff");
      return Result;
    };
    this.RenderTabLeft = function (ALeft, ATop, AWidth, AHeight, AEvent) {
      var Result = null;
      Result = this.RenderTab("‹",ALeft,ATop,AWidth,AHeight,AEvent);
      Result.style.setProperty("background-color","#fff");
      return Result;
    };
    this.RenderTabRight = function (ALeft, ATop, AWidth, AHeight, AEvent) {
      var Result = null;
      Result = this.RenderTab("›",ALeft,ATop,AWidth,AHeight,AEvent);
      Result.style.setProperty("background-color","#fff");
      return Result;
    };
    this.RenderTabs = function () {
      var VPage = null;
      var VIndex = 0;
      var VStartIndex = 0;
      var VEndIndex = 0;
      var VTabCaption = "";
      var VTabHeight = 0;
      var VTabLeft = 0;
      var VTabWidth = 0;
      var VSumTabsWidth = 0;
      var VMaxTabWidth = 0;
      var VTabsCount = 0;
      VTabHeight = this.CalcTabHeight();
      VSumTabsWidth = this.CalcSumTabsWidth();
      var $with1 = this.FTabContainerElement;
      $with1.innerHTML = "";
      $with1.style.setProperty("left","0px");
      $with1.style.setProperty("top","0px");
      $with1.style.setProperty("width",pas.SysUtils.IntToStr(pas.Controls.IfThen$2(VSumTabsWidth > this.FWidth,VSumTabsWidth,this.FWidth)) + "px");
      $with1.style.setProperty("height",pas.SysUtils.IntToStr(VTabHeight) + "px");
      $with1.style.setProperty("position","absolute");
      $with1.style.setProperty("overflow","hidden");
      if ((this.FPageIndex > -1) && (this.FPageIndex < this.FPages.length)) {
        if (VSumTabsWidth > this.FWidth) {
          VTabLeft = 40;
          VMaxTabWidth = this.CalcMaxTabWidth();
          VTabsCount = pas.System.Trunc(Math.floor((this.FWidth - 80) / VMaxTabWidth));
          if (VTabsCount === 0) {
            VTabsCount = 1;
          };
          if ((this.FPageIndex - VTabsCount) >= 0) {
            VStartIndex = (this.FPageIndex - VTabsCount) + 1;
            VEndIndex = this.FPageIndex;
          } else {
            VStartIndex = 0;
            VEndIndex = VTabsCount - 1;
          };
          VMaxTabWidth = pas.System.Trunc(Math.floor((this.FWidth - 80) / VTabsCount));
          for (var $l2 = VStartIndex, $end3 = VEndIndex; $l2 <= $end3; $l2++) {
            VIndex = $l2;
            VPage = rtl.getObject(this.FPages[VIndex]);
            if ((VPage != null) && VPage.FTabVisible) {
              VTabCaption = VPage.GetText();
              VTabWidth = VMaxTabWidth;
              if (VIndex === this.FPageIndex) {
                this.FTabContainerElement.appendChild(this.RenderTabActive(VTabCaption,VTabLeft,0,VTabWidth,VTabHeight,rtl.createCallback(this,"TabClick")));
              } else {
                this.FTabContainerElement.appendChild(this.RenderTab(VTabCaption,VTabLeft,0,VTabWidth,VTabHeight,rtl.createCallback(this,"TabClick")));
              };
              VTabLeft = VTabLeft + VTabWidth;
            };
          };
          var $with4 = this.FTabContainerElement;
          $with4.appendChild(this.RenderTabLeft(0,0,40,VTabHeight,rtl.createCallback(this,"TabLeftClick")));
          $with4.appendChild(this.RenderTabRight(this.FWidth - 40,0,40,VTabHeight,rtl.createCallback(this,"TabRightClick")));
        } else {
          VTabLeft = 0;
          VStartIndex = 0;
          VEndIndex = this.FPages.length - 1;
          VTabWidth = Math.floor(this.FWidth / this.FPages.length);
          for (var $l5 = VStartIndex, $end6 = VEndIndex; $l5 <= $end6; $l5++) {
            VIndex = $l5;
            VPage = rtl.getObject(this.FPages[VIndex]);
            if ((VPage != null) && VPage.FTabVisible) {
              VTabCaption = VPage.GetText();
              if (VIndex === this.FPageIndex) {
                this.FTabContainerElement.appendChild(this.RenderTabActive(VTabCaption,VTabLeft,0,VTabWidth,VTabHeight,rtl.createCallback(this,"TabClick")));
              } else {
                this.FTabContainerElement.appendChild(this.RenderTab(VTabCaption,VTabLeft,0,VTabWidth,VTabHeight,rtl.createCallback(this,"TabClick")));
              };
              VTabLeft = VTabLeft + VTabWidth;
            };
          };
        };
      };
    };
    this.TabClick = function (AEvent) {
      var Result = false;
      this.SetPageIndex(this.IndexOfTab(AEvent.target.innerHTML));
      return Result;
    };
    this.TabLeftClick = function (AEvent) {
      var Result = false;
      this.SetPageIndex(this.FPageIndex - 1);
      return Result;
    };
    this.TabRightClick = function (AEvent) {
      var Result = false;
      this.SetPageIndex(this.FPageIndex + 1);
      return Result;
    };
    this.UpdatePages = function () {
      var VIndex = 0;
      var VPage = null;
      var VTabHeight = 0;
      VTabHeight = this.CalcTabHeight();
      for (var $l1 = 0, $end2 = this.FPages.length - 1; $l1 <= $end2; $l1++) {
        VIndex = $l1;
        VPage = rtl.getObject(this.FPages[VIndex]);
        if ((VPage != null) && VPage.FTabVisible) {
          VPage.BeginUpdate();
          try {
            if (VIndex === this.FPageIndex) {
              VPage.SetBounds(0,VTabHeight,this.FWidth,this.FHeight - VTabHeight);
              VPage.SetVisible(true);
            } else {
              VPage.SetVisible(false);
            };
          } finally {
            VPage.EndUpdate();
          };
        };
      };
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 200;
      Result.cy = 200;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FTabContainerElement = this.CreateTabContainerElement();
      this.FPages = new Array();
      this.FPageIndex = -1;
      this.FShowTabs = true;
      this.FTabPosition = $mod.TTabPosition.tpTop;
      this.BeginUpdate();
      try {
        this.SetTabStop(false);
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.Destroy = function () {
      this.FPages.length = 0;
      pas.Controls.TControl.Destroy.call(this);
    };
    this.AddTabSheet = function () {
      var Result = null;
      Result = $mod.TCustomTabSheet.$create("Create$1",[this]);
      Result.SetPageControl(this);
      return Result;
    };
    this.IndexOf = function (APage) {
      var Result = 0;
      Result = this.FPages.indexOf(APage);
      return Result;
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
});
rtl.module("NumCtrls",["System","Classes","SysUtils","Types","Graphics","Controls","StdCtrls","Web"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TCustomNumericEdit",pas.StdCtrls.TCustomEdit,function () {
    this.$init = function () {
      pas.StdCtrls.TCustomEdit.$init.call(this);
      this.FDecimals = 0;
    };
    this.DoEnter = function () {
      pas.StdCtrls.TCustomEdit.DoEnter.call(this);
      this.RealSetText(this.RealGetText());
    };
    this.DoExit = function () {
      pas.Controls.TWinControl.DoExit.call(this);
      this.RealSetText(this.RealGetText());
    };
    this.DoInput = function (ANewValue) {
      var VDiff = "";
      var VOldValue = "";
      VOldValue = this.RealGetText();
      if (ANewValue.length >= VOldValue.length) {
        VDiff = pas.SysUtils.StringReplace(ANewValue,VOldValue,"",{});
        if (VDiff === pas.SysUtils.DecimalSeparator) {
          if (this.FDecimals === 0) {
            VDiff = "";
          };
          if (pas.System.Pos(VDiff,VOldValue) > 0) {
            VDiff = "";
          };
        };
        if (!(VDiff.charCodeAt(0) in rtl.createSet(null,48,57,pas.SysUtils.DecimalSeparator.charCodeAt()))) {
          this.FHandleElement.value = VOldValue;
          ANewValue = VOldValue;
        };
      };
      pas.StdCtrls.TCustomEdit.DoInput.call(this,ANewValue);
    };
    this.Changed = function () {
      pas.StdCtrls.TCustomEdit.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.inputMode = "numeric";
      };
    };
    this.Create$1 = function (AOwner) {
      pas.StdCtrls.TCustomEdit.Create$1.call(this,AOwner);
      this.FDecimals = 2;
      this.BeginUpdate();
      try {
        this.SetAlignment(pas.Classes.TAlignment.taRightJustify);
      } finally {
        this.EndUpdate();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
});
rtl.module("DttCtrls",["System","Classes","SysUtils","Types","Graphics","StdCtrls"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TCustomDateTimeEdit",pas.StdCtrls.TCustomEdit,function () {
    this.DoEnter = function () {
      pas.StdCtrls.TCustomEdit.DoEnter.call(this);
      this.RealSetText(this.RealGetText());
    };
    this.DoExit = function () {
      pas.Controls.TWinControl.DoExit.call(this);
      this.RealSetText(this.RealGetText());
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
});
rtl.module("BtnCtrls",["System","Classes","SysUtils","Types","Web","Graphics","Controls","StdCtrls"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TCustomFileButton",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FFileSelect = null;
      this.FFilter = "";
      this.FOnChange = null;
      this.FOpendDialogElement = null;
    };
    this.$final = function () {
      this.FFileSelect = undefined;
      this.FOnChange = undefined;
      this.FOpendDialogElement = undefined;
      pas.Controls.TWinControl.$final.call(this);
    };
    this.SetFilter = function (AValue) {
      if (this.FFilter !== AValue) {
        this.FFilter = AValue;
        this.Changed();
      };
    };
    this.Change = function () {
      if (this.FOnChange != null) {
        this.FOnChange(this);
      };
    };
    this.HandleClick = function (AEvent) {
      var Result = false;
      Result = pas.Controls.TControl.HandleClick.call(this,AEvent);
      if (this.FOpendDialogElement != null) {
        this.FOpendDialogElement.click();
      };
      return Result;
    };
    this.HandleChange = function (AEvent) {
      var Result = false;
      var VFile = null;
      var VList = null;
      if (rtl.isExt(AEvent.target,HTMLInputElement)) {
        VList = AEvent.target.files;
        if (VList.length === 0) {
          this.FFileSelect = null;
          this.SetText("Not file selected.");
          this.Changed();
          return false;
        };
        VFile = VList.item(0);
        this.FFileSelect = VFile;
        this.SetText(VFile.name);
        this.SetHint(VFile.name);
        this.Changed();
        this.Change();
        Result = true;
      };
      return Result;
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.style.setProperty("padding","0");
        $with1.innerHTML = this.GetText();
        if (this.FOpendDialogElement != null) {
          var $with2 = this.FOpendDialogElement;
          $with2.accept = this.FFilter;
          $with2.type = "file";
        };
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("button");
      return Result;
    };
    this.CreateOpendDialogElement = function () {
      var Result = null;
      Result = this.FHandleElement.appendChild(document.createElement("input"));
      return Result;
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 80;
      Result.cy = 25;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FOpendDialogElement = this.CreateOpendDialogElement();
      this.FOpendDialogElement.addEventListener("change",rtl.createCallback(this,"HandleChange"));
      this.FFilter = "";
      this.FFileSelect = null;
      this.BeginUpdate();
      try {
        this.SetText("Not file selected.");
        this.SetHint(this.GetText());
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.Destroy = function () {
      if (this.FOpendDialogElement != null) {
        this.FOpendDialogElement.removeEventListener("change",rtl.createCallback(this,"HandleChange"));
      };
      pas.Controls.TControl.Destroy.call(this);
    };
    this.AdjustSize = function () {
      var VSize = new pas.Types.TSize();
      pas.Controls.TControl.AdjustSize.call(this);
      VSize = new pas.Types.TSize(this.FFont.TextExtent(this.GetText()));
      this.SetBounds(this.FLeft,this.FTop,VSize.cx,VSize.cy);
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
});
rtl.module("MaskUtils",["System","Classes","SysUtils","JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.TStepState = {"0": "stLeading", stLeading: 0, "1": "stUpper", stUpper: 1, "2": "stLower", stLower: 2, "3": "stSpecial", stSpecial: 3, "4": "stArbitrary", stArbitrary: 4};
  $mod.$rtti.$Enum("TStepState",{minvalue: 0, maxvalue: 4, ordtype: 1, enumtype: this.TStepState});
  $mod.$rtti.$Set("TParseState",{comptype: $mod.$rtti["TStepState"]});
  rtl.createClass($mod,"TMaskUtils",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FValue = "";
      this.FSourcePosition = 0;
      this.FPosition = 0;
      this.FEditMask = "";
      this.FMask = "";
      this.FSourceVal = "";
      this.FExitVal = "";
      this.FMatched = false;
      this.FMissChar = "";
      this.FState = {};
    };
    this.$final = function () {
      this.FState = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.EvaluateExit = function () {
      if ($mod.TStepState.stUpper in this.FState) {
        this.FExitVal = this.FExitVal + pas.SysUtils.UpperCase(this.SourcePtr());
      } else if ($mod.TStepState.stLower in this.FState) {
        this.FExitVal = this.FExitVal + pas.SysUtils.LowerCase(this.SourcePtr());
      } else {
        this.FExitVal = this.FExitVal + this.SourcePtr();
      };
      this.FSourcePosition += 1;
    };
    this.EvaluateMissing = function () {
      this.FExitVal = this.FExitVal + this.FMissChar;
      this.FSourcePosition += 1;
    };
    this.DoFillRest = function () {
      var I = 0;
      if ($mod.TStepState.stArbitrary in this.FState) {
        I = this.FSourceVal.length - this.FMask.length;
        while (I >= 0) {
          this.EvaluateExit();
          I -= 1;
        };
      };
    };
    this.DoLiteral = function () {
      if ($mod.TStepState.stSpecial in this.FState) {
        this.FState = rtl.excludeSet(this.FState,$mod.TStepState.stSpecial);
      };
      if (this.FMatched && (this.MaskPtr() !== this.SourcePtr())) {
        this.RaiseError();
      };
      if (this.FMatched || !($impl.IsAlpha(this.SourcePtr()) || $impl.IsNumeric(this.SourcePtr()))) {
        this.FSourcePosition += 1;
      };
      this.FExitVal = this.FExitVal + this.MaskPtr();
    };
    this.DoLiteralInputMask = function () {
      if ($mod.TStepState.stSpecial in this.FState) {
        this.FState = rtl.excludeSet(this.FState,$mod.TStepState.stSpecial);
      };
      this.FExitVal = this.FExitVal + this.MaskPtr();
    };
    this.DoToken = function () {
      if ($mod.TStepState.stArbitrary in this.FState) {
        this.FState = rtl.excludeSet(this.FState,$mod.TStepState.stArbitrary);
      };
      var $tmp1 = this.MaskPtr();
      if ($tmp1 === "!") {
        this.FState = rtl.includeSet(this.FState,$mod.TStepState.stLeading)}
       else if ($tmp1 === ">") {
        this.DoUpper()}
       else if ($tmp1 === "<") {
        this.DoLower()}
       else if ($tmp1 === "\\") {
        this.FState = rtl.includeSet(this.FState,$mod.TStepState.stSpecial)}
       else if ($tmp1 === "L") {
        this.DoAlpha(true)}
       else if ($tmp1 === "l") {
        this.DoAlpha(false)}
       else if ($tmp1 === "A") {
        this.DoAlphaNumeric(true)}
       else if ($tmp1 === "a") {
        this.DoAlphaNumeric(false)}
       else if ($tmp1 === "C") {
        this.DoArbitrary(true)}
       else if ($tmp1 === "c") {
        this.DoArbitrary(false)}
       else if ($tmp1 === "0") {
        this.DoNumeric(true)}
       else if ($tmp1 === "9") {
        this.DoNumeric(false)}
       else if ($tmp1 === "#") {
        this.DoNumericPlusMinus()}
       else if ($tmp1 === ":") {
        this.DoTime()}
       else if ($tmp1 === "\/") this.DoDate();
    };
    this.DoTokenInputMask = function () {
      var $tmp1 = this.MaskPtr();
      if ((($tmp1 === "!") || ($tmp1 === ">")) || ($tmp1 === "<")) {}
      else if ($tmp1 === "\\") {
        this.FState = rtl.includeSet(this.FState,$mod.TStepState.stSpecial)}
       else if ((((((((($tmp1 === "L") || ($tmp1 === "l")) || ($tmp1 === "A")) || ($tmp1 === "a")) || ($tmp1 === "C")) || ($tmp1 === "c")) || ($tmp1 === "0")) || ($tmp1 === "9")) || ($tmp1 === "#")) {
        this.FExitVal = this.FExitVal + this.FMissChar}
       else if ($tmp1 === ":") {
        this.DoTime()}
       else if ($tmp1 === "\/") this.DoDate();
    };
    this.DoUpper = function () {
      if ($mod.TStepState.stLower in this.FState) {
        this.FState = rtl.excludeSet(this.FState,$mod.TStepState.stLower);
      } else {
        this.FState = rtl.includeSet(this.FState,$mod.TStepState.stUpper);
      };
      if ((this.FPosition > 1) && (this.FMask.charAt((this.FPosition - 1) - 1) === "<")) {
        this.FState = rtl.excludeSet(this.FState,$mod.TStepState.stLower);
        this.FState = rtl.excludeSet(this.FState,$mod.TStepState.stUpper);
      };
    };
    this.DoLower = function () {
      if ($mod.TStepState.stUpper in this.FState) {
        this.FState = rtl.excludeSet(this.FState,$mod.TStepState.stUpper);
      } else {
        this.FState = rtl.includeSet(this.FState,$mod.TStepState.stLower);
      };
    };
    this.DoNumeric = function (ARequired) {
      if (ARequired) {
        if ($impl.IsNumeric(this.SourcePtr())) {
          this.EvaluateExit();
        } else {
          this.RaiseError();
        };
      } else {
        if ($impl.IsNumeric(this.SourcePtr())) {
          this.EvaluateExit();
        } else {
          this.EvaluateMissing();
        };
      };
    };
    this.DoAlpha = function (ARequired) {
      if (ARequired) {
        if ($impl.IsAlpha(this.SourcePtr())) {
          this.EvaluateExit();
        } else {
          this.RaiseError();
        };
      } else {
        if ($impl.IsAlpha(this.SourcePtr())) {
          this.EvaluateExit();
        } else {
          this.EvaluateMissing();
        };
      };
    };
    this.DoAlphaNumeric = function (ARequired) {
      if (ARequired) {
        if ($impl.IsAlpha(this.SourcePtr()) || $impl.IsNumeric(this.SourcePtr())) {
          this.EvaluateExit();
        } else {
          this.RaiseError();
        };
      } else {
        if ($impl.IsAlpha(this.SourcePtr()) || $impl.IsNumeric(this.SourcePtr())) {
          this.EvaluateExit();
        } else {
          this.EvaluateMissing();
        };
      };
    };
    this.DoNumericPlusMinus = function () {
      if (($impl.IsNumeric(this.SourcePtr()) || (this.SourcePtr() === "+")) || (this.SourcePtr() === "-")) {
        this.EvaluateExit();
      } else {
        this.EvaluateMissing();
      };
    };
    this.DoArbitrary = function (ARequired) {
      this.FState = rtl.includeSet(this.FState,$mod.TStepState.stArbitrary);
      if (ARequired) {
        if (this.FPosition > this.FSourceVal.length) {
          this.RaiseError();
        };
      } else {
        if (this.FPosition > this.FSourceVal.length) {
          this.EvaluateMissing();
        } else {
          this.EvaluateExit();
        };
      };
    };
    this.DoTime = function () {
      this.FExitVal = this.FExitVal + pas.SysUtils.TimeSeparator;
    };
    this.DoDate = function () {
      this.FExitVal = this.FExitVal + pas.SysUtils.DateSeparator;
    };
    this.GetInputMask = function () {
      var Result = "";
      this.FExitVal = "";
      this.FPosition = 1;
      this.FState = {};
      while (this.FPosition <= this.FMask.length) {
        if ($impl.IsToken(this.MaskPtr()) && !($mod.TStepState.stSpecial in this.FState)) {
          this.DoTokenInputMask();
        } else {
          this.DoLiteralInputMask();
        };
        this.FPosition += 1;
      };
      Result = this.FExitVal;
      return Result;
    };
    this.SetMask = function (AValue) {
      if (this.FEditMask !== AValue) {
        this.FEditMask = AValue;
        this.ExtractMask();
      };
    };
    this.SetValue = function (AValue) {
      if (this.FSourceVal !== AValue) {
        this.FSourceVal = AValue;
      };
    };
    this.RaiseError = function () {
      if (this.FSourcePosition > this.FSourceVal.length) {
        this.EvaluateMissing();
      } else {
        throw new Error(rtl.getResStr(pas.MaskUtils,"exInvalidMaskValue"));
      };
    };
    this.ExtractMask = function () {
      var P = 0;
      var S = "";
      this.FMissChar = " ";
      this.FMatched = false;
      S = pas.System.Copy(this.FEditMask,1,this.FEditMask.length);
      P = S.lastIndexOf(";") + 1;
      if (P === 0) {
        this.FMask = S;
      } else {
        this.FMissChar = pas.System.Copy(S,P + 1,1).charAt(0);
        pas.System.Delete({get: function () {
            return S;
          }, set: function (v) {
            S = v;
          }},P,2);
        P = S.lastIndexOf(";") + 1;
        this.FMatched = pas.System.Copy(S,P + 1,1) !== "0";
        pas.System.Delete({get: function () {
            return S;
          }, set: function (v) {
            S = v;
          }},P,2);
        this.FMask = S;
      };
    };
    this.MaskPtr = function () {
      var Result = "";
      Result = this.FMask.charAt(this.FPosition - 1);
      return Result;
    };
    this.SourcePtr = function () {
      var Result = "";
      if (this.FSourcePosition <= this.FSourceVal.length) {
        Result = this.FSourceVal.charAt(this.FSourcePosition - 1);
      } else {
        Result = "\x00";
      };
      return Result;
    };
    this.ValidateInput = function () {
      var Result = "";
      this.FExitVal = "";
      this.FPosition = 1;
      this.FSourcePosition = 1;
      this.FState = {};
      while (this.FPosition <= this.FMask.length) {
        if ($impl.IsToken(this.MaskPtr()) && !($mod.TStepState.stSpecial in this.FState)) {
          this.DoToken();
        } else {
          this.DoLiteral();
        };
        this.FPosition += 1;
      };
      this.DoFillRest();
      Result = this.FExitVal;
      return Result;
    };
  });
  this.FormatMaskText = function (AEditMask, AValue) {
    var Result = "";
    var VMask = null;
    VMask = $mod.TMaskUtils.$create("Create");
    try {
      VMask.SetMask(AEditMask);
      VMask.SetValue(AValue);
      Result = VMask.ValidateInput();
    } finally {
      VMask = rtl.freeLoc(VMask);
    };
    return Result;
  };
  this.FormatMaskInput = function (AEditMask) {
    var Result = "";
    var VMask = null;
    VMask = $mod.TMaskUtils.$create("Create");
    try {
      VMask.SetMask(AEditMask);
      Result = VMask.ValidateInput();
    } finally {
      VMask = rtl.freeLoc(VMask);
    };
    return Result;
  };
  this.MaskDoFormatText = function (AEditMask, AValue, ABlank) {
    var Result = "";
    var VMask = null;
    VMask = $mod.TMaskUtils.$create("Create");
    try {
      VMask.SetMask(AEditMask);
      VMask.SetValue(AValue);
      VMask.FMatched = false;
      VMask.FMissChar = ABlank;
      Result = VMask.ValidateInput();
    } finally {
      VMask = rtl.freeLoc(VMask);
    };
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.IsNumeric = function (C) {
    var Result = false;
    Result = C.charCodeAt() in rtl.createSet(null,48,57);
    return Result;
  };
  $impl.IsAlpha = function (C) {
    var Result = false;
    Result = C.charCodeAt() in rtl.createSet(null,97,122,null,65,90);
    return Result;
  };
  $impl.IsToken = function (C) {
    var Result = false;
    Result = C.charCodeAt() in rtl.createSet(33,62,60,92,76,108,65,97,67,99,48,57,35,58,47,59);
    return Result;
  };
  $mod.$resourcestrings = {exInvalidMaskValue: {org: "FormatMaskText function failed!"}};
});
rtl.module("DataGrid",["System","Classes","SysUtils","Types","JS","Web","Graphics","Controls"],function () {
  "use strict";
  var $mod = this;
  $mod.$rtti.$Class("TCustomDataGrid");
  this.TColumnFormat = {"0": "cfBoolean", cfBoolean: 0, "1": "cfDataTime", cfDataTime: 1, "2": "cfNumber", cfNumber: 2, "3": "cfString", cfString: 3};
  $mod.$rtti.$Enum("TColumnFormat",{minvalue: 0, maxvalue: 3, ordtype: 1, enumtype: this.TColumnFormat});
  rtl.createClass($mod,"TDataColumn",pas.Classes.TCollectionItem,function () {
    this.$init = function () {
      pas.Classes.TCollectionItem.$init.call(this);
      this.FAlignment = 0;
      this.FColor = 0;
      this.FDisplayMask = "";
      this.FFont = null;
      this.FFormat = 0;
      this.FHint = "";
      this.FName = "";
      this.FTag = 0;
      this.FTitle = "";
      this.FUpdateCount$1 = 0;
      this.FValueChecked = "";
      this.FValueUnchecked = "";
      this.FVisible = false;
      this.FWidth = 0;
    };
    this.$final = function () {
      this.FFont = undefined;
      pas.Classes.TCollectionItem.$final.call(this);
    };
    this.GetGrid = function () {
      var Result = null;
      if ((this.FCollection != null) && $mod.TDataColumns.isPrototypeOf(this.FCollection)) {
        Result = this.FCollection.FGrid;
      } else {
        Result = null;
      };
      return Result;
    };
    this.SetAlignment = function (AValue) {
      if (this.FAlignment !== AValue) {
        this.FAlignment = AValue;
        this.ColumnChanged();
      };
    };
    this.SetColor = function (AValue) {
      if (this.FColor !== AValue) {
        this.FColor = AValue;
        this.ColumnChanged();
      };
    };
    this.SetDisplayMask = function (AValue) {
      if (this.FDisplayMask !== AValue) {
        this.FDisplayMask = AValue;
        this.ColumnChanged();
      };
    };
    this.SetFont = function (AValue) {
      if (!this.FFont.IsEqual(AValue)) {
        this.FFont.Assign(AValue);
      };
    };
    this.SetFormat = function (AValue) {
      if (this.FFormat !== AValue) {
        this.FFormat = AValue;
        this.ColumnChanged();
      };
    };
    this.SetName = function (AValue) {
      if (this.FName !== AValue) {
        this.FName = AValue;
        this.ColumnChanged();
      };
    };
    this.SetTitle = function (AValue) {
      if (this.FTitle !== AValue) {
        this.FTitle = AValue;
        this.ColumnChanged();
      };
    };
    this.SetValueChecked = function (AValue) {
      if (this.FValueChecked !== AValue) {
        this.FValueChecked = AValue;
        this.ColumnChanged();
      };
    };
    this.SetValueUnchecked = function (AValue) {
      if (this.FValueUnchecked !== AValue) {
        this.FValueUnchecked = AValue;
        this.ColumnChanged();
      };
    };
    this.SetVisible = function (AValue) {
      if (this.FVisible !== AValue) {
        this.FVisible = AValue;
        this.ColumnChanged();
      };
    };
    this.SetWidth = function (AValue) {
      if (this.FWidth !== AValue) {
        this.FWidth = AValue;
        this.ColumnChanged();
      };
    };
    this.ColumnChanged = function () {
      if (this.FUpdateCount$1 === 0) {
        this.Changed(false);
      };
    };
    this.GetDisplayName = function () {
      var Result = "";
      if (this.FTitle !== "") {
        Result = this.FTitle;
      } else {
        Result = "Column " + pas.SysUtils.IntToStr(this.GetIndex());
      };
      return Result;
    };
    this.FillDefaultFont = function () {
      if (this.GetGrid() != null) {
        this.FFont.Assign(this.GetGrid().FFont);
      };
    };
    this.FontChanged = function (Sender) {
      this.ColumnChanged();
    };
    this.GetDefaultValueChecked = function () {
      var Result = "";
      Result = "1";
      return Result;
    };
    this.GetDefaultValueUnchecked = function () {
      var Result = "";
      Result = "0";
      return Result;
    };
    this.Create$1 = function (ACollection) {
      pas.Classes.TCollectionItem.Create$1.call(this,ACollection);
      this.FFont = pas.Graphics.TFont.$create("Create$1");
      this.FFont.FOnChange = rtl.createCallback(this,"FontChanged");
      this.FAlignment = pas.Classes.TAlignment.taLeftJustify;
      this.FColor = 16777215;
      this.FDisplayMask = "";
      this.FFormat = $mod.TColumnFormat.cfString;
      this.FHint = "";
      this.FName = "";
      this.FTag = 0;
      this.FTitle = "";
      this.FUpdateCount$1 = 0;
      this.FValueChecked = this.GetDefaultValueChecked();
      this.FValueUnchecked = this.GetDefaultValueUnchecked();
      this.FVisible = true;
      this.FWidth = 0;
      this.FillDefaultFont();
    };
    this.Destroy = function () {
      this.FFont.$destroy("Destroy");
      this.FFont = null;
      pas.Classes.TCollectionItem.Destroy.call(this);
    };
    this.Assign = function (Source) {
      var VColumn = null;
      if ((Source != null) && $mod.TDataColumn.isPrototypeOf(Source)) {
        this.BeginUpdate();
        try {
          VColumn = Source;
          this.FAlignment = VColumn.FAlignment;
          this.FColor = VColumn.FColor;
          this.FDisplayMask = VColumn.FDisplayMask;
          this.FFont.Assign(VColumn.FFont);
          this.FFormat = VColumn.FFormat;
          this.FHint = VColumn.FHint;
          this.FName = VColumn.FName;
          this.FTag = VColumn.FTag;
          this.FTitle = VColumn.FTitle;
          this.FValueChecked = VColumn.FValueChecked;
          this.FValueUnchecked = VColumn.FValueUnchecked;
          this.FVisible = VColumn.FVisible;
          this.FWidth = VColumn.FWidth;
        } finally {
          this.EndUpdate();
        };
      } else {
        pas.Classes.TPersistent.Assign.call(this,Source);
      };
    };
    this.BeginUpdate = function () {
      this.FUpdateCount$1 += 1;
    };
    this.EndUpdate = function () {
      if (this.FUpdateCount$1 > 0) {
        this.FUpdateCount$1 -= 1;
        if (this.FUpdateCount$1 === 0) {
          this.ColumnChanged();
        };
      };
    };
    var $r = this.$rtti;
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("DisplayMask",2,rtl.string,"FDisplayMask","SetDisplayMask");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("Format",2,$mod.$rtti["TColumnFormat"],"FFormat","SetFormat");
    $r.addProperty("Hint",0,rtl.string,"FHint","FHint");
    $r.addProperty("Name",2,rtl.string,"FName","SetName");
    $r.addProperty("Tag",0,rtl.longint,"FTag","FTag");
    $r.addProperty("Title",2,rtl.string,"FTitle","SetTitle");
    $r.addProperty("ValueChecked",2,rtl.string,"FValueChecked","SetValueChecked");
    $r.addProperty("ValueUnchecked",2,rtl.string,"FValueUnchecked","SetValueUnchecked");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("Width",2,rtl.nativeint,"FWidth","SetWidth");
  });
  rtl.createClass($mod,"TDataColumns",pas.Classes.TCollection,function () {
    this.$init = function () {
      pas.Classes.TCollection.$init.call(this);
      this.FGrid = null;
    };
    this.$final = function () {
      this.FGrid = undefined;
      pas.Classes.TCollection.$final.call(this);
    };
    this.GetColumn = function (AIndex) {
      var Result = null;
      Result = this.GetItem(AIndex);
      return Result;
    };
    this.SetColumn = function (AIndex, AValue) {
      this.GetColumn(AIndex).Assign(AValue);
    };
    this.GetOwner = function () {
      var Result = null;
      Result = this.FGrid;
      return Result;
    };
    this.Update = function (AItem) {
      this.FGrid.ColumnsChanged(AItem);
    };
    this.Create$2 = function (AGrid) {
      pas.Classes.TCollection.Create$1.call(this,$mod.TDataColumn);
      this.FGrid = AGrid;
    };
    this.Add$1 = function () {
      var Result = null;
      Result = pas.Classes.TCollection.Add.call(this);
      return Result;
    };
    this.HasIndex = function (AIndex) {
      var Result = false;
      Result = (AIndex > -1) && (AIndex < this.GetCount());
      return Result;
    };
  });
  this.TSortOrder = {"0": "soAscending", soAscending: 0, "1": "soDescending", soDescending: 1};
  $mod.$rtti.$Enum("TSortOrder",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TSortOrder});
  $mod.$rtti.$MethodVar("TOnClickEvent",{procsig: rtl.newTIProcSig([["ASender",pas.System.$rtti["TObject"]],["ACol",rtl.nativeint],["ARow",rtl.nativeint]]), methodkind: 0});
  $mod.$rtti.$MethodVar("TOnHeaderClick",{procsig: rtl.newTIProcSig([["ASender",pas.System.$rtti["TObject"]],["ACol",rtl.nativeint]]), methodkind: 0});
  rtl.createClass($mod,"TCustomDataGrid",pas.Controls.TCustomControl,function () {
    this.$init = function () {
      pas.Controls.TCustomControl.$init.call(this);
      this.FAutoCreateColumns = false;
      this.FColumnClickSorts = false;
      this.FColumns = null;
      this.FData = null;
      this.FDefColWidth = 0;
      this.FDefRowHeight = 0;
      this.FShowHeader = false;
      this.FSortColumn = 0;
      this.FSortOrder = 0;
      this.FOnCellClick = null;
      this.FOnHeaderClick = null;
      this.FActiveCell = null;
    };
    this.$final = function () {
      this.FColumns = undefined;
      this.FData = undefined;
      this.FOnCellClick = undefined;
      this.FOnHeaderClick = undefined;
      this.FActiveCell = undefined;
      pas.Controls.TCustomControl.$final.call(this);
    };
    this.GetColCount = function () {
      var Result = 0;
      Result = this.FColumns.GetCount();
      return Result;
    };
    this.GetRowCount = function () {
      var Result = 0;
      var VBody = null;
      VBody = this.FHandleElement.querySelector("tbody");
      Result = pas.Controls.IfThen$2(VBody != null,VBody.rows.length,0);
      return Result;
    };
    this.SetColumnClickSorts = function (AValue) {
      if (this.FColumnClickSorts !== AValue) {
        this.FColumnClickSorts = AValue;
      };
    };
    this.SetColumns = function (AValue) {
      this.FColumns.Assign(AValue);
    };
    this.SetData = function (AValue) {
      if (this.FData !== AValue) {
        this.FData = AValue;
        this.AutomaticallyCreateColumns();
        this.Changed();
      };
    };
    this.SetDefColWidth = function (AValue) {
      if (this.FDefColWidth !== AValue) {
        this.FDefColWidth = AValue;
        this.Changed();
      };
    };
    this.SetDefRowHeight = function (AValue) {
      if (this.FDefRowHeight !== AValue) {
        this.FDefRowHeight = AValue;
        this.Changed();
      };
    };
    this.SetShowHeader = function (AValue) {
      if (this.FShowHeader !== AValue) {
        this.FShowHeader = AValue;
        this.Changed();
      };
    };
    this.KeyDown = function (Key, Shift) {
      pas.Controls.TWinControl.KeyDown.call(this,Key,rtl.refSet(Shift));
      var $tmp1 = Key.get();
      if ($tmp1 === 35) {
        this.NavigateEnd();
        Key.set(0);
      } else if ($tmp1 === 36) {
        this.NavigateHome();
        Key.set(0);
      } else if ($tmp1 === 37) {
        this.NavigateLeft();
        Key.set(0);
      } else if ($tmp1 === 38) {
        this.NavigateUp();
        Key.set(0);
      } else if ($tmp1 === 39) {
        this.NavigateRight();
        Key.set(0);
      } else if ($tmp1 === 40) {
        this.NavigateDown();
        Key.set(0);
      };
    };
    this.DoEnter = function () {
      pas.Controls.TWinControl.DoEnter.call(this);
      if (!(this.FActiveCell != null)) {
        this.FActiveCell = this.SelectCell(0,0);
        if (this.FActiveCell != null) {
          this.FActiveCell.click();
        };
      };
    };
    this.CellClick = function (ACol, ARow) {
      if (this.FOnCellClick != null) {
        this.FOnCellClick(this,ACol,ARow);
      };
    };
    this.HeaderClick = function (ACol) {
      if (this.FColumnClickSorts) {
        if (this.FSortColumn === ACol) {
          if (this.FSortOrder === $mod.TSortOrder.soAscending) {
            this.FSortOrder = $mod.TSortOrder.soDescending;
          } else {
            this.FSortOrder = $mod.TSortOrder.soAscending;
          };
        } else {
          this.FSortOrder = $mod.TSortOrder.soAscending;
        };
        this.FSortColumn = ACol;
        this.Sort();
      };
      if (this.FOnHeaderClick != null) {
        this.FOnHeaderClick(this,ACol);
      };
    };
    this.CompareCells = function (A, B) {
      var Result = 0;
      var VColumn = null;
      var VValueA = undefined;
      var VValueB = undefined;
      if (this.FColumns.HasIndex(this.FSortColumn)) {
        VColumn = this.FColumns.GetColumn(this.FSortColumn);
        if (((((VColumn != null) && pas.System.Assigned(A)) && pas.System.Assigned(B)) && rtl.isExt(A,Object,1)) && rtl.isExt(B,Object,1)) {
          VValueA = rtl.getObject(A)[VColumn.FName];
          VValueB = rtl.getObject(B)[VColumn.FName];
          if (this.FSortOrder === $mod.TSortOrder.soAscending) {
            Result = pas.Controls.CompareValues(VValueA,VValueB);
          } else {
            Result = pas.Controls.CompareValues(VValueB,VValueA);
          };
        } else {
          Result = 0;
        };
      } else {
        Result = 0;
      };
      return Result;
    };
    this.Sort = function () {
      if (this.FData != null) {
        this.FData.sort(rtl.createCallback(this,"CompareCells"));
        this.Changed();
      };
    };
    this.NavigateDown = function () {
      var VCell = null;
      var VRow = null;
      if ((this.FActiveCell != null) && (this.FActiveCell.parentElement != null)) {
        VRow = this.FActiveCell.parentElement.nextElementSibling;
        if ((VRow != null) && (VRow.childNodes.length > 0)) {
          VCell = VRow.childNodes.item(this.FActiveCell.cellIndex);
          if (VCell != null) {
            VCell.click();
          };
        };
      };
    };
    this.NavigateUp = function () {
      var VCell = null;
      var VRow = null;
      if ((this.FActiveCell != null) && (this.FActiveCell.parentElement != null)) {
        VRow = this.FActiveCell.parentElement.previousElementSibling;
        if ((VRow != null) && (VRow.childNodes.length > 0)) {
          VCell = VRow.childNodes.item(this.FActiveCell.cellIndex);
          if (VCell != null) {
            VCell.click();
          };
        };
      };
    };
    this.NavigateLeft = function () {
      var VColumnn = null;
      var VCell = null;
      var VRow = null;
      var VIndex = 0;
      if (this.FActiveCell != null) {
        VRow = this.FActiveCell.parentElement;
        if ((VRow != null) && (VRow.childNodes.length > 0)) {
          for (var $l1 = this.FActiveCell.cellIndex - 1; $l1 >= 0; $l1--) {
            VIndex = $l1;
            VCell = VRow.childNodes.item(VIndex);
            if ((VCell != null) && this.FColumns.HasIndex(VIndex)) {
              VColumnn = this.FColumns.GetColumn(VIndex);
              if ((VColumnn != null) && VColumnn.FVisible) {
                VCell.click();
                return;
              };
            };
          };
        };
      };
    };
    this.NavigateRight = function () {
      var VColumnn = null;
      var VCell = null;
      var VRow = null;
      var VIndex = 0;
      if (this.FActiveCell != null) {
        VRow = this.FActiveCell.parentElement;
        if ((VRow != null) && (VRow.childNodes.length > 0)) {
          for (var $l1 = this.FActiveCell.cellIndex + 1, $end2 = VRow.childNodes.length - 1; $l1 <= $end2; $l1++) {
            VIndex = $l1;
            VCell = VRow.childNodes.item(VIndex);
            if ((VCell != null) && this.FColumns.HasIndex(VIndex)) {
              VColumnn = this.FColumns.GetColumn(VIndex);
              if ((VColumnn != null) && VColumnn.FVisible) {
                VCell.click();
                return;
              };
            };
          };
        };
      };
    };
    this.NavigateEnd = function () {
      var VBody = null;
      var VCell = null;
      var VRow = null;
      if (this.FActiveCell != null) {
        VBody = this.FHandleElement.querySelector("tbody");
        if ((VBody != null) && (VBody.rows.length > 0)) {
          VRow = VBody.rows.item(VBody.rows.length - 1);
          if ((VRow != null) && (VRow.childNodes.length > 0)) {
            VCell = VRow.childNodes.item(this.FActiveCell.cellIndex);
            if (VCell != null) {
              VCell.click();
            };
          };
        };
      };
    };
    this.NavigateHome = function () {
      var VBody = null;
      var VCell = null;
      var VRow = null;
      if (this.FActiveCell != null) {
        VBody = this.FHandleElement.querySelector("tbody");
        if ((VBody != null) && (VBody.rows.length > 0)) {
          VRow = VBody.rows.item(0);
          if ((VRow != null) && (VRow.childNodes.length > 0)) {
            VCell = VRow.childNodes.item(this.FActiveCell.cellIndex);
            if (VCell != null) {
              VCell.click();
            };
          };
        };
      };
    };
    this.HandleBodyScroll = function (AEvent) {
      var Result = false;
      var VBody = null;
      var VHead = null;
      VHead = this.FHandleElement.querySelector("thead");
      VBody = this.FHandleElement.querySelector("tbody");
      if ((VHead != null) && (VBody != null)) {
        VHead.scrollLeft = VBody.scrollLeft;
      };
      AEvent.stopPropagation();
      Result = true;
      return Result;
    };
    this.HandleCellClick = function (AEvent) {
      var Result = false;
      var VBody = null;
      var VCell = null;
      var VRow = null;
      VCell = AEvent.target;
      VRow = VCell.parentElement;
      AEvent.stopPropagation();
      if (VRow != null) {
        this.CellClick(VCell.cellIndex,VRow.rowIndex);
        this.SetActiveCell(VCell);
      };
      Result = true;
      VBody = this.FHandleElement.querySelector("tbody");
      if (VBody != null) {
        VBody.scrollTop = pas.Math.Ceil(VCell.offsetTop - (VBody.clientHeight / 2));
        VBody.scrollLeft = pas.Math.Ceil(VCell.offsetLeft - (VBody.clientWidth / 2));
      };
      return Result;
    };
    this.HandleHeaderClick = function (AEvent) {
      var Result = false;
      var VCell = null;
      VCell = AEvent.target;
      AEvent.stopPropagation();
      this.HeaderClick(VCell.cellIndex);
      Result = true;
      return Result;
    };
    this.Changed = function () {
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.innerHTML = "";
        $with1.style.setProperty("border","1px solid #c9c3ba");
        $with1.style.setProperty("border-collapse","collapse");
        $with1.style.setProperty("border-spacing","0px");
        $with1.style.setProperty("outline","none");
        this.RenderTableStyle();
        this.RenderTableHead();
        this.RenderTableBody();
        if (this.Focused()) {
          this.FActiveCell = this.SelectCell(this.FSortColumn,0);
          if (this.FActiveCell != null) {
            this.FActiveCell.click();
          };
        };
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("table");
      return Result;
    };
    this.RenderTableStyle = function () {
      var Self = this;
      function JSAlign(AAlignment) {
        var Result = "";
        var $tmp1 = AAlignment;
        if ($tmp1 === pas.Classes.TAlignment.taCenter) {
          Result = "center"}
         else if ($tmp1 === pas.Classes.TAlignment.taLeftJustify) {
          Result = "left"}
         else if ($tmp1 === pas.Classes.TAlignment.taRightJustify) Result = "right";
        return Result;
      };
      var VColumn = null;
      var VColumnIndex = 0;
      var VStyle = null;
      var VCss = "";
      var VHeight = 0;
      var VWidth = 0;
      VHeight = pas.Controls.IfThen$2(Self.FDefRowHeight < 0,Self.CalcDefaultRowHeight(),Self.FDefRowHeight);
      VCss = ((((((((((((((((((((("thead, tbody{" + "    display: block;") + "    position: absolute;") + "}") + "thead{") + "    overflow: hidden;") + "    width: calc(100% - ") + pas.SysUtils.IntToStr(pas.Controls.ScrollbarWidth())) + "px);") + "    height: ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(Self.FShowHeader,VHeight,0))) + "px;") + "}") + "tbody{") + "    overflow: scroll;") + "    top: ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(Self.FShowHeader,VHeight,0))) + "px;") + "    width: 100%;") + "    height: calc(100% - ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(Self.FShowHeader,VHeight,0))) + "px);") + "}";
      for (var $l1 = 0, $end2 = Self.FColumns.GetCount() - 1; $l1 <= $end2; $l1++) {
        VColumnIndex = $l1;
        VColumn = Self.FColumns.GetColumn(VColumnIndex);
        if (VColumn != null) {
          VWidth = pas.Controls.IfThen$2(VColumn.FWidth <= 0,Self.FDefColWidth,VColumn.FWidth);
          VCss = ((((((((((((((((((((((((((((VCss + "thead th:nth-child(") + pas.SysUtils.IntToStr(VColumnIndex + 1)) + "){") + "    height: ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(Self.FShowHeader,VHeight,0))) + "px;") + "    min-width: ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(VColumn.FVisible,VWidth,0))) + "px;") + "    max-width: ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(VColumn.FVisible,VWidth,0))) + "px;") + "    visibility: ") + pas.Controls.IfThen$3(VColumn.FVisible,"visible","hidden")) + ";") + "    padding: 0;") + "    overflow: hidden;") + "    border: ") + pas.SysUtils.IntToStr(pas.Math.IfThen(VColumn.FVisible,1,0))) + "px solid #ccc;") + "    background: #dddada;") + "    font: ") + pas.Graphics.JSFont(VColumn.FFont)) + ";") + "    text-align: center;") + "    text-overflow: clip;") + "    white-space: nowrap;") + "    cursor: pointer;") + "}";
          VCss = (((((((((((((((((((((((((((((((VCss + "tbody td:nth-child(") + pas.SysUtils.IntToStr(VColumnIndex + 1)) + "){") + "    height: ") + pas.SysUtils.IntToStr(VHeight)) + "px;") + "    min-width: ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(VColumn.FVisible,VWidth,0))) + "px;") + "    max-width: ") + pas.SysUtils.IntToStr(pas.Controls.IfThen$2(VColumn.FVisible,VWidth,0))) + "px;") + "    visibility: ") + pas.Controls.IfThen$3(VColumn.FVisible,"visible","hidden")) + ";") + "    padding: 0;") + "    overflow: hidden;") + "    border: ") + pas.SysUtils.IntToStr(pas.Math.IfThen(VColumn.FVisible,1,0))) + "px solid #ccc;") + "    background-color: ") + pas.Graphics.JSColor(VColumn.FColor)) + ";") + "    font: ") + pas.Graphics.JSFont(VColumn.FFont)) + ";") + "    text-align: ") + JSAlign(VColumn.FAlignment)) + ";") + "    text-overflow: clip;") + "    white-space: nowrap;") + "}";
        };
      };
      VStyle = Self.FHandleElement.appendChild(document.createElement("style"));
      VStyle.innerHTML = VCss;
    };
    this.RenderTableHead = function () {
      var VColumn = null;
      var VColumnIndex = 0;
      var VHead = null;
      var VRow = null;
      var VCell = null;
      VHead = this.FHandleElement.appendChild(document.createElement("thead"));
      VRow = VHead.appendChild(document.createElement("tr"));
      for (var $l1 = 0, $end2 = this.FColumns.GetCount() - 1; $l1 <= $end2; $l1++) {
        VColumnIndex = $l1;
        VColumn = this.FColumns.GetColumn(VColumnIndex);
        VCell = VRow.appendChild(document.createElement("th"));
        VCell.addEventListener("click",rtl.createCallback(this,"HandleHeaderClick"));
        VCell.innerHTML = this.RenderTableHeadCell(VColumn,VColumnIndex);
      };
    };
    this.RenderTableBody = function () {
      var VColumn = null;
      var VColumnIndex = 0;
      var VRowIndex = 0;
      var VBody = null;
      var VRow = null;
      var VCell = null;
      var VObject = null;
      var VValue = undefined;
      VBody = this.FHandleElement.appendChild(document.createElement("tbody"));
      if (this.FData != null) {
        VBody.addEventListener("scroll",rtl.createCallback(this,"HandleBodyScroll"));
        for (var $l1 = 0, $end2 = this.FData.length - 1; $l1 <= $end2; $l1++) {
          VRowIndex = $l1;
          VValue = this.FData[VRowIndex];
          if (pas.System.Assigned(VValue) && rtl.isObject(VValue)) {
            VObject = rtl.getObject(VValue);
            VRow = VBody.appendChild(document.createElement("tr"));
            for (var $l3 = 0, $end4 = this.FColumns.GetCount() - 1; $l3 <= $end4; $l3++) {
              VColumnIndex = $l3;
              VColumn = this.FColumns.GetColumn(VColumnIndex);
              VCell = VRow.appendChild(document.createElement("td"));
              VCell.addEventListener("click",rtl.createCallback(this,"HandleCellClick"));
              VCell.innerHTML = this.RenderTableCell(VColumn,VObject);
            };
          };
        };
      };
    };
    this.RenderTableCell = function (AColumn, AObject) {
      var Result = "";
      var VValue = undefined;
      if ((AColumn != null) && AObject.hasOwnProperty(AColumn.FName)) {
        VValue = AObject[AColumn.FName];
        var $tmp1 = pas.JS.GetValueType(VValue);
        if ((($tmp1 === pas.JS.TJSValueType.jvtArray) || ($tmp1 === pas.JS.TJSValueType.jvtObject)) || ($tmp1 === pas.JS.TJSValueType.jvtNull)) {
          Result = "";
        } else if ($tmp1 === pas.JS.TJSValueType.jvtBoolean) {
          Result = pas.SysUtils.BoolToStr(!(VValue == false),false);
        } else if ($tmp1 === pas.JS.TJSValueType.jvtInteger) {
          Result = pas.SysUtils.FloatToStr(Math.floor(VValue));
        } else if ($tmp1 === pas.JS.TJSValueType.jvtFloat) {
          var $tmp2 = AColumn.FFormat;
          if ($tmp2 === $mod.TColumnFormat.cfDataTime) {
            Result = pas.SysUtils.FormatDateTime(AColumn.FDisplayMask,rtl.getNumber(VValue));
          } else if ($tmp2 === $mod.TColumnFormat.cfNumber) {
            Result = pas.SysUtils.FormatFloat(AColumn.FDisplayMask,rtl.getNumber(VValue));
          } else {
            Result = pas.SysUtils.FloatToStr(rtl.getNumber(VValue));
          };
        } else if ($tmp1 === pas.JS.TJSValueType.jvtString) {
          if (AColumn.FDisplayMask !== "") {
            Result = pas.MaskUtils.MaskDoFormatText(AColumn.FDisplayMask,"" + VValue," ");
          } else {
            Result = "" + VValue;
          };
        };
      } else {
        Result = "";
      };
      return Result;
    };
    this.RenderTableHeadCell = function (AColumn, AIndex) {
      var Result = "";
      if (AColumn != null) {
        if (AIndex === this.FSortColumn) {
          Result = pas.Controls.IfThen$3(this.FSortOrder === $mod.TSortOrder.soAscending,"↓","↑") + AColumn.FTitle;
        } else {
          Result = AColumn.FTitle;
        };
      } else {
        Result = "";
      };
      return Result;
    };
    this.SelectCell = function (ACol, ARow) {
      var Result = null;
      var VBody = null;
      VBody = this.FHandleElement.querySelector("tbody");
      if (((VBody != null) && (VBody.rows.length > 0)) && VBody.rows.item(0).hasChildNodes()) {
        if (ARow < 0) {
          ARow = 0;
        } else if (ARow >= VBody.rows.length) {
          ARow = VBody.rows.length - 1;
        };
        if (ACol < 0) {
          ACol = 0;
        } else if (ACol >= VBody.rows.item(0).childNodes.length) {
          ACol = VBody.rows.item(0).childNodes.length - 1;
        };
        Result = VBody.rows.item(ARow).childNodes.item(ACol);
      } else {
        Result = null;
      };
      return Result;
    };
    this.SetActiveCell = function (ACell) {
      if (this.FActiveCell != null) {
        var $with1 = this.FActiveCell;
        $with1.style.setProperty("border","1px solid #ccc");
      };
      this.FActiveCell = ACell;
      if (this.FActiveCell != null) {
        var $with2 = this.FActiveCell;
        $with2.style.setProperty("border","2px solid dodgerblue");
      };
    };
    this.AutomaticallyCreateColumns = function () {
      var VColumn = null;
      var VKey = "";
      var VKeys = [];
      var VJSObject = null;
      var VJSValue = undefined;
      if ((((this.FData != null) && (this.FData.length > 0)) && (this.FColumns.GetCount() === 0)) && this.FAutoCreateColumns) {
        VJSValue = this.FData[0];
        if (pas.System.Assigned(VJSValue) && (pas.JS.GetValueType(VJSValue) === pas.JS.TJSValueType.jvtObject)) {
          VJSObject = rtl.getObject(VJSValue);
          VKeys = Object.keys(VJSObject);
          this.BeginUpdate();
          try {
            for (var $in1 = VKeys, $l2 = 0, $end3 = rtl.length($in1) - 1; $l2 <= $end3; $l2++) {
              VKey = $in1[$l2];
              VJSValue = VJSObject[VKey];
              if (pas.System.Assigned(VJSValue)) {
                var $tmp4 = pas.JS.GetValueType(VJSValue);
                if ($tmp4 === pas.JS.TJSValueType.jvtBoolean) {
                  VColumn = this.AddColumn();
                  VColumn.SetAlignment(pas.Classes.TAlignment.taCenter);
                  VColumn.SetFormat($mod.TColumnFormat.cfBoolean);
                  VColumn.SetName(VKey);
                  VColumn.SetTitle(VColumn.FName);
                  VColumn.SetWidth(100);
                } else if (($tmp4 === pas.JS.TJSValueType.jvtFloat) || ($tmp4 === pas.JS.TJSValueType.jvtInteger)) {
                  VColumn = this.AddColumn();
                  VColumn.SetAlignment(pas.Classes.TAlignment.taRightJustify);
                  VColumn.SetFormat($mod.TColumnFormat.cfNumber);
                  VColumn.SetName(VKey);
                  VColumn.SetTitle(VColumn.FName);
                  VColumn.SetWidth(100);
                } else {
                  VColumn = this.AddColumn();
                  VColumn.SetFormat($mod.TColumnFormat.cfString);
                  VColumn.SetName(VKey);
                  VColumn.SetTitle(VColumn.FName);
                  VColumn.SetWidth(200);
                };
              };
            };
          } finally {
            this.EndUpdate();
          };
        };
      };
    };
    this.ColumnsChanged = function (AColumn) {
      this.Changed();
    };
    this.CalcDefaultRowHeight = function () {
      var Result = 0;
      Result = this.FFont.TextHeight("Fj") + 10;
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 200;
      Result.cy = 100;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FColumns = $mod.TDataColumns.$create("Create$2",[this]);
      this.FActiveCell = null;
      this.FAutoCreateColumns = true;
      this.FColumnClickSorts = true;
      this.FDefColWidth = -1;
      this.FDefRowHeight = -1;
      this.FShowHeader = true;
      this.FSortColumn = -1;
      this.FSortOrder = $mod.TSortOrder.soAscending;
      this.BeginUpdate();
      try {
        this.SetColor(16777215);
        this.SetParentColor(false);
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    this.Destroy = function () {
      this.FColumns.$destroy("Destroy");
      this.FColumns = null;
      pas.Controls.TCustomControl.Destroy.call(this);
    };
    this.AddColumn = function () {
      var Result = null;
      Result = this.FColumns.Add$1();
      return Result;
    };
    this.Clear = function () {
      this.FData = null;
      this.Changed();
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
  $mod.$rtti.$MethodVar("TOnPageEvent",{procsig: rtl.newTIProcSig([["ASender",pas.System.$rtti["TObject"]],["APage",rtl.nativeint]]), methodkind: 0});
  rtl.createClass($mod,"TCustomPagination",pas.Controls.TCustomControl,function () {
    this.$init = function () {
      pas.Controls.TCustomControl.$init.call(this);
      this.FCurrentPage = 0;
      this.FOnPageClick = null;
      this.FRecordsPerPage = 0;
      this.FTotalPages = 0;
      this.FTotalRecords = 0;
    };
    this.$final = function () {
      this.FOnPageClick = undefined;
      pas.Controls.TCustomControl.$final.call(this);
    };
    this.SetCurrentPage = function (AValue) {
      if (this.FCurrentPage !== AValue) {
        this.FCurrentPage = AValue;
        this.Changed();
      };
    };
    this.SetRecordsPerPage = function (AValue) {
      if (this.FRecordsPerPage !== AValue) {
        this.FRecordsPerPage = AValue;
        this.Changed();
      };
    };
    this.SetTotalRecords = function (AValue) {
      if (this.FTotalRecords !== AValue) {
        this.FTotalRecords = AValue;
        this.Changed();
      };
    };
    this.PageClick = function (APage) {
      if (this.FOnPageClick != null) {
        this.FOnPageClick(this,APage);
      };
    };
    this.HandlePageClick = function (AEvent) {
      var Result = false;
      var VValue = "";
      VValue = AEvent.target.innerHTML;
      if (VValue !== "") {
        if (VValue === "«") {
          this.FCurrentPage = 1;
        } else if (VValue === "»") {
          this.FCurrentPage = this.FTotalPages;
        } else {
          this.FCurrentPage = pas.SysUtils.StrToIntDef(VValue,1);
        };
      } else {
        this.FCurrentPage = 1;
      };
      AEvent.stopPropagation();
      this.PageClick(this.FCurrentPage);
      Result = true;
      this.Changed();
      return Result;
    };
    this.Changed = function () {
      var VIndex = 0;
      var VPage = null;
      var VPages = null;
      var VPageWidth = 0;
      var VValue = 0;
      pas.Controls.TControl.Changed.call(this);
      if (!this.IsUpdating()) {
        var $with1 = this.FHandleElement;
        $with1.innerHTML = "";
        $with1.style.setProperty("outline","none");
        VPages = this.CalculatePages();
        VPageWidth = this.FFont.TextWidth("1000") + 10;
        if ((VPageWidth * 7) >= this.FWidth) {
          VPageWidth = pas.System.Trunc(Math.floor(this.FWidth / 7));
        };
        VPage = this.RenderPage("«",VPageWidth,rtl.createCallback(this,"HandlePageClick"),false);
        this.FHandleElement.appendChild(VPage);
        for (var $l2 = 0, $end3 = VPages.length - 1; $l2 <= $end3; $l2++) {
          VIndex = $l2;
          VValue = Math.floor(VPages[VIndex]);
          VPage = this.RenderPage(pas.SysUtils.IntToStr(VValue),VPageWidth,rtl.createCallback(this,"HandlePageClick"),VValue === this.FCurrentPage);
          this.FHandleElement.appendChild(VPage);
        };
        VPage = this.RenderPage("»",VPageWidth,rtl.createCallback(this,"HandlePageClick"),false);
        this.FHandleElement.appendChild(VPage);
      };
    };
    this.CreateHandleElement = function () {
      var Result = null;
      Result = document.createElement("div");
      return Result;
    };
    this.CalculatePages = function () {
      var Result = null;
      var VIndex = 0;
      var VEnd = 0;
      var VStart = 0;
      this.FTotalPages = pas.Math.Ceil64(this.FTotalRecords / this.FRecordsPerPage);
      if (this.FCurrentPage < 1) {
        this.FCurrentPage = 1;
      };
      if (this.FTotalPages <= 5) {
        VStart = 1;
        VEnd = this.FTotalPages;
      } else {
        if (this.FCurrentPage <= 3) {
          VStart = 1;
          VEnd = 5;
        } else if ((this.FCurrentPage + 2) >= this.FTotalPages) {
          VStart = this.FTotalPages - 4;
          VEnd = this.FTotalPages;
        } else {
          VStart = this.FCurrentPage - 2;
          VEnd = this.FCurrentPage + 2;
        };
      };
      if (VEnd <= VStart) {
        VEnd = VStart + 1;
      };
      Result = new Array();
      for (var $l1 = VStart, $end2 = VEnd; $l1 <= $end2; $l1++) {
        VIndex = $l1;
        Result.push(VIndex);
      };
      return Result;
    };
    this.RenderPage = function (ACaption, AWidth, AEvent, AActive) {
      var Result = null;
      Result = document.createElement("button");
      Result.style.setProperty("height","100%");
      Result.style.setProperty("width",pas.SysUtils.IntToStr(AWidth) + "px");
      Result.style.setProperty("border","1px solid #c9c3ba");
      Result.style.setProperty("background-color",pas.Controls.IfThen$3(AActive,"#fff","#dddada"));
      Result.style.setProperty("outline","none");
      Result.style.setProperty("padding","0");
      Result.style.setProperty("white-space","nowrap");
      Result.addEventListener("click",AEvent);
      Result.innerHTML = ACaption;
      return Result;
    };
    this.CheckChildClassAllowed = function (AChildClass) {
      var Result = false;
      Result = false;
      return Result;
    };
    this.GetControlClassDefaultSize = function () {
      var Result = new pas.Types.TSize();
      Result.cx = 150;
      Result.cy = 30;
      return Result;
    };
    this.Create$1 = function (AOwner) {
      pas.Controls.TControl.Create$1.call(this,AOwner);
      this.FCurrentPage = 1;
      this.FRecordsPerPage = 10;
      this.FTotalPages = 0;
      this.FTotalRecords = 0;
      this.BeginUpdate();
      try {
        this.SetTabStop(false);
        var $with1 = this.$class.GetControlClassDefaultSize();
        this.SetBounds(0,0,$with1.cx,$with1.cy);
      } finally {
        this.EndUpdate();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
  });
},["Math","MaskUtils"]);
rtl.module("WebCtrls",["System","Classes","SysUtils","Types","Graphics","Controls","Forms","StdCtrls","ExtCtrls","ComCtrls","NumCtrls","DttCtrls","BtnCtrls","DataGrid"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TWForm",pas.Forms.TCustomForm,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("ActiveControl",2,pas.Controls.$rtti["TWinControl"],"FActiveControl","SetActiveControl");
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("AlphaBlend",2,rtl.boolean,"FAlphaBlend","SetAlphaBlend");
    $r.addProperty("AlphaBlendValue",2,rtl.byte,"FAlphaBlendValue","SetAlphaBlendValue");
    $r.addProperty("Caption",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("ClientHeight",3,rtl.nativeint,"GetClientHeight","SetClientHeight");
    $r.addProperty("ClientWidth",3,rtl.nativeint,"GetClientWidth","SetClientWidth");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("KeyPreview",0,rtl.boolean,"FKeyPreview","FKeyPreview");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnActivate",0,pas.Classes.$rtti["TNotifyEvent"],"FOnActivate","FOnActivate");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnClose",0,pas.Forms.$rtti["TCloseEvent"],"FOnClose","FOnClose");
    $r.addProperty("OnCloseQuery",0,pas.Forms.$rtti["TCloseQueryEvent"],"FOnCloseQuery","FOnCloseQuery");
    $r.addProperty("OnCreate",0,pas.Classes.$rtti["TNotifyEvent"],"FOnCreate","FOnCreate");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnDeactivate",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDeactivate","FOnDeactivate");
    $r.addProperty("OnDestroy",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDestroy","FOnDestroy");
    $r.addProperty("OnHide",0,pas.Classes.$rtti["TNotifyEvent"],"FOnHide","FOnHide");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize$1","FOnResize$1");
    $r.addProperty("OnScroll",0,pas.Classes.$rtti["TNotifyEvent"],"FOnScroll$1","FOnScroll$1");
    $r.addProperty("OnShow",0,pas.Classes.$rtti["TNotifyEvent"],"FOnShow","FOnShow");
  });
  $mod.$rtti.$ClassRef("TWFormClass",{instancetype: $mod.$rtti["TWForm"]});
  rtl.createClass($mod,"TWFrame",pas.Forms.TCustomFrame,function () {
    this.$init = function () {
      pas.Forms.TCustomFrame.$init.call(this);
      this.FDesignLeft = 0;
      this.FDesignTop = 0;
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("ClientHeight",3,rtl.nativeint,"GetClientHeight","SetClientHeight");
    $r.addProperty("ClientWidth",3,rtl.nativeint,"GetClientWidth","SetClientWidth");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
    $r.addProperty("DesignLeft",0,rtl.longint,"FDesignLeft","FDesignLeft");
    $r.addProperty("DesignTop",0,rtl.longint,"FDesignTop","FDesignTop");
  });
  $mod.$rtti.$ClassRef("TWFrameClass",{instancetype: $mod.$rtti["TWFrame"]});
  rtl.createClass($mod,"TWDataModule",pas.Forms.TCustomDataModule,function () {
    this.$init = function () {
      pas.Forms.TCustomDataModule.$init.call(this);
      this.FHorizontalOffset = 0;
      this.FPPI = 0;
      this.FVerticalOffset = 0;
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("OnCreate",0,pas.Classes.$rtti["TNotifyEvent"],"FOnCreate","FOnCreate");
    $r.addProperty("OnDestroy",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDestroy","FOnDestroy");
    $r.addProperty("OldCreateOrder",0,rtl.boolean,"FOldOrder","FOldOrder");
    $r.addProperty("HorizontalOffset",0,rtl.longint,"FHorizontalOffset","FHorizontalOffset");
    $r.addProperty("VerticalOffset",0,rtl.longint,"FVerticalOffset","FVerticalOffset");
    $r.addProperty("PPI",0,rtl.longint,"FPPI","FPPI");
  });
  $mod.$rtti.$ClassRef("TWDataModuleClass",{instancetype: $mod.$rtti["TWDataModule"]});
  rtl.createClass($mod,"TWComboBox",pas.StdCtrls.TCustomComboBox,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("BorderStyle",2,pas.Controls.$rtti["TBorderStyle"],"FBorderStyle","SetBorderStyle");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ItemHeight",2,rtl.nativeint,"FItemHeight","SetItemHeight");
    $r.addProperty("ItemIndex",2,rtl.nativeint,"FItemIndex","SetItemIndex");
    $r.addProperty("Items",2,pas.Classes.$rtti["TStringList"],"FItems","SetItems");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("Text",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
  });
  rtl.createClass($mod,"TWEdit",pas.StdCtrls.TCustomEdit,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("BorderStyle",2,pas.Controls.$rtti["TBorderStyle"],"FBorderStyle","SetBorderStyle");
    $r.addProperty("CharCase",2,pas.StdCtrls.$rtti["TEditCharCase"],"FCharCase","SetCharCase");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("MaxLength",2,rtl.nativeint,"FMaxLength","SetMaxLength");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("PasswordChar",2,rtl.char,"FPasswordChar","SetPasswordChar");
    $r.addProperty("ReadOnly",2,rtl.boolean,"FReadOnly","SetReadOnly");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("Text",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("TextHint",2,rtl.string,"FTextHint","SetTextHint");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWMemo",pas.StdCtrls.TCustomMemo,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("BorderStyle",2,pas.Controls.$rtti["TBorderStyle"],"FBorderStyle","SetBorderStyle");
    $r.addProperty("CharCase",2,pas.StdCtrls.$rtti["TEditCharCase"],"FCharCase","SetCharCase");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("Lines",2,pas.Classes.$rtti["TStringList"],"FLines","SetLines");
    $r.addProperty("MaxLength",2,rtl.nativeint,"FMaxLength","SetMaxLength");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ReadOnly",2,rtl.boolean,"FReadOnly","SetReadOnly");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TextHint",2,rtl.string,"FTextHint","SetTextHint");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("WantReturns",2,rtl.boolean,"FWantReturns","SetWantReturns");
    $r.addProperty("WantTabs",2,rtl.boolean,"FWantTabs","SetWantTabs");
    $r.addProperty("WordWrap",2,rtl.boolean,"FWordWrap","SetWordWrap");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWButton",pas.StdCtrls.TCustomButton,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("Caption",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("Hint",2,rtl.string,"FHint","SetHint");
    $r.addProperty("ModalResult",0,pas.Forms.$rtti["TModalResult"],"FModalResult","FModalResult");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWCheckbox",pas.StdCtrls.TCustomCheckbox,function () {
    rtl.addIntf(this,pas.System.IUnknown);
  });
  rtl.createClass($mod,"TWLabel",pas.StdCtrls.TCustomLabel,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("Caption",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("FocusControl",0,pas.Controls.$rtti["TWinControl"],"FFocusControl","FFocusControl");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("Layout",2,pas.Graphics.$rtti["TTextLayout"],"FLayout","SetLayout");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("Transparent",2,rtl.boolean,"FTransparent","SetTransparent");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("WordWrap",2,rtl.boolean,"FWordWrap","SetWordWrap");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWImage",pas.ExtCtrls.TCustomImage,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("Center",2,rtl.boolean,"FCenter","SetCenter");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("Picture",2,pas.Graphics.$rtti["TPicture"],"FPicture","SetPicture");
    $r.addProperty("Proportional",2,rtl.boolean,"FProportional","SetProportiona");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("Stretch",2,rtl.boolean,"FStretch","SetStretch");
    $r.addProperty("StretchOutEnabled",2,rtl.boolean,"FStretchOutEnabled","SetStretchOutEnabled");
    $r.addProperty("StretchInEnabled",2,rtl.boolean,"FStretchInEnabled","SetStretchInEnabled");
    $r.addProperty("Transparent",2,rtl.boolean,"FTransparent","SetTransparent");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnPaint",0,pas.Classes.$rtti["TNotifyEvent"],"FOnPaint","FOnPaint");
    $r.addProperty("OnPictureChanged",0,pas.Classes.$rtti["TNotifyEvent"],"FOnPictureChanged","FOnPictureChanged");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWPanel",pas.ExtCtrls.TCustomPanel,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BevelColor",2,rtl.nativeuint,"FBevelColor","SetBevelColor");
    $r.addProperty("BevelInner",2,pas.Controls.$rtti["TBevelCut"],"FBevelInner","SetBevelInner");
    $r.addProperty("BevelOuter",2,pas.Controls.$rtti["TBevelCut"],"FBevelOuter","SetBevelOuter");
    $r.addProperty("BevelWidth",2,pas.ExtCtrls.$rtti["TBevelWidth"],"FBevelWidth","SetBevelWidth");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("Caption",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("ClientHeight",3,rtl.nativeint,"GetClientHeight","SetClientHeight");
    $r.addProperty("ClientWidth",3,rtl.nativeint,"GetClientWidth","SetClientWidth");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("WordWrap",2,rtl.boolean,"FWordWrap","SetWordWrap");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnPaint",0,pas.Classes.$rtti["TNotifyEvent"],"FOnPaint","FOnPaint");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWPageControl",pas.ComCtrls.TCustomPageControl,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("ActivePage",3,pas.ComCtrls.$rtti["TCustomTabSheet"],"GetActivePage","SetActivePage");
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("ShowTabs",2,rtl.boolean,"FShowTabs","SetShowTabs");
    $r.addProperty("TabHeight",2,rtl.smallint,"FTabHeight","SetTabHeight");
    $r.addProperty("TabIndex",2,rtl.nativeint,"FPageIndex","SetPageIndex");
    $r.addProperty("TabPosition",2,pas.ComCtrls.$rtti["TTabPosition"],"FTabPosition","SetTabPosition");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TabWidth",2,rtl.smallint,"FTabWidth","SetTabWidth");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
  });
  rtl.createClass($mod,"TWFloatEdit",pas.NumCtrls.TCustomNumericEdit,function () {
    this.GetValue = function () {
      var Result = 0.0;
      Result = pas.SysUtils.StrToFloatDef(this.RealGetText(),0);
      return Result;
    };
    this.SetValue = function (AValue) {
      this.RealSetText(pas.SysUtils.FloatToStrF(AValue,pas.SysUtils.TFloatFormat.ffFixed,20,this.FDecimals));
    };
    this.RealSetText = function (AValue) {
      pas.StdCtrls.TCustomEdit.RealSetText.call(this,pas.SysUtils.FloatToStrF(pas.SysUtils.StrToFloatDef(AValue,0),pas.SysUtils.TFloatFormat.ffFixed,20,this.FDecimals));
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("BorderStyle",2,pas.Controls.$rtti["TBorderStyle"],"FBorderStyle","SetBorderStyle");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("DecimalPlaces",0,rtl.nativeint,"FDecimals","FDecimals");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("PasswordChar",2,rtl.char,"FPasswordChar","SetPasswordChar");
    $r.addProperty("ReadOnly",2,rtl.boolean,"FReadOnly","SetReadOnly");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("Text",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("TextHint",2,rtl.string,"FTextHint","SetTextHint");
    $r.addProperty("Value",3,rtl.double,"GetValue","SetValue");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWIntegertEdit",pas.NumCtrls.TCustomNumericEdit,function () {
    this.GetValue = function () {
      var Result = 0;
      Result = pas.SysUtils.StrToIntDef(this.RealGetText(),0);
      return Result;
    };
    this.SetValue = function (AValue) {
      this.RealSetText(pas.SysUtils.FloatToStrF(AValue,pas.SysUtils.TFloatFormat.ffFixed,20,this.FDecimals));
    };
    this.RealSetText = function (AValue) {
      pas.StdCtrls.TCustomEdit.RealSetText.call(this,pas.SysUtils.FloatToStrF(pas.SysUtils.StrToFloatDef(AValue,0),pas.SysUtils.TFloatFormat.ffFixed,20,this.FDecimals));
    };
    this.Create$1 = function (AOwner) {
      pas.NumCtrls.TCustomNumericEdit.Create$1.call(this,AOwner);
      this.BeginUpdate();
      try {
        this.FDecimals = 0;
      } finally {
        this.EndUpdate();
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("BorderStyle",2,pas.Controls.$rtti["TBorderStyle"],"FBorderStyle","SetBorderStyle");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("PasswordChar",2,rtl.char,"FPasswordChar","SetPasswordChar");
    $r.addProperty("ReadOnly",2,rtl.boolean,"FReadOnly","SetReadOnly");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("Text",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("TextHint",2,rtl.string,"FTextHint","SetTextHint");
    $r.addProperty("Value",3,rtl.nativeint,"GetValue","SetValue");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWDateEditBox",pas.DttCtrls.TCustomDateTimeEdit,function () {
    this.GetValue = function () {
      var Result = 0.0;
      Result = pas.SysUtils.StrToDateDef(this.RealGetText(),0);
      return Result;
    };
    this.SetValue = function (AValue) {
      this.RealSetText(pas.SysUtils.DateToStr(AValue));
    };
    this.InputType = function () {
      var Result = "";
      Result = "date";
      return Result;
    };
    this.RealSetText = function (AValue) {
      pas.StdCtrls.TCustomEdit.RealSetText.call(this,pas.SysUtils.FormatDateTime(pas.SysUtils.ShortDateFormat,pas.SysUtils.StrToDateDef(AValue,0)));
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("BorderStyle",2,pas.Controls.$rtti["TBorderStyle"],"FBorderStyle","SetBorderStyle");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("PasswordChar",2,rtl.char,"FPasswordChar","SetPasswordChar");
    $r.addProperty("ReadOnly",2,rtl.boolean,"FReadOnly","SetReadOnly");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("Text",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("TextHint",2,rtl.string,"FTextHint","SetTextHint");
    $r.addProperty("Value",3,pas.System.$rtti["TDate"],"GetValue","SetValue");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWTimeEditBox",pas.DttCtrls.TCustomDateTimeEdit,function () {
    this.GetValue = function () {
      var Result = 0.0;
      Result = pas.SysUtils.StrToTimeDef(this.RealGetText(),0);
      return Result;
    };
    this.SetValue = function (AValue) {
      this.RealSetText(pas.SysUtils.TimeToStr(AValue));
    };
    this.InputType = function () {
      var Result = "";
      Result = "time";
      return Result;
    };
    this.RealSetText = function (AValue) {
      pas.StdCtrls.TCustomEdit.RealSetText.call(this,pas.SysUtils.FormatDateTime(pas.SysUtils.ShortTimeFormat,pas.SysUtils.StrToTimeDef(AValue,0)));
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("Alignment",2,pas.Classes.$rtti["TAlignment"],"FAlignment","SetAlignment");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("BorderStyle",2,pas.Controls.$rtti["TBorderStyle"],"FBorderStyle","SetBorderStyle");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentColor",2,rtl.boolean,"FParentColor","SetParentColor");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("PasswordChar",2,rtl.char,"FPasswordChar","SetPasswordChar");
    $r.addProperty("ReadOnly",2,rtl.boolean,"FReadOnly","SetReadOnly");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("Text",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("TextHint",2,rtl.string,"FTextHint","SetTextHint");
    $r.addProperty("Value",3,pas.System.$rtti["TTime"],"GetValue","SetValue");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnDblClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnDblClick","FOnDblClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWFileButton",pas.BtnCtrls.TCustomFileButton,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("AutoSize",2,rtl.boolean,"FAutoSize","SetAutoSize");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("Caption",3,pas.Controls.$rtti["TCaption"],"GetText","SetText");
    $r.addProperty("Color",2,rtl.nativeuint,"FColor","SetColor");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Filter",2,rtl.string,"FFilter","SetFilter");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
    $r.addProperty("OnClick",0,pas.Classes.$rtti["TNotifyEvent"],"FOnClick","FOnClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnResize",0,pas.Classes.$rtti["TNotifyEvent"],"FOnResize","FOnResize");
  });
  rtl.createClass($mod,"TWDataGrid",pas.DataGrid.TCustomDataGrid,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("Columns",2,pas.DataGrid.$rtti["TDataColumns"],"FColumns","SetColumns");
    $r.addProperty("ColumnClickSorts",2,rtl.boolean,"FColumnClickSorts","SetColumnClickSorts");
    $r.addProperty("DefaultColWidth",2,rtl.nativeint,"FDefColWidth","SetDefColWidth");
    $r.addProperty("DefaultRowHeight",2,rtl.nativeint,"FDefRowHeight","SetDefRowHeight");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("SortOrder",0,pas.DataGrid.$rtti["TSortOrder"],"FSortOrder","");
    $r.addProperty("ShowHeader",2,rtl.boolean,"FShowHeader","SetShowHeader");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnCellClick",0,pas.DataGrid.$rtti["TOnClickEvent"],"FOnCellClick","FOnCellClick");
    $r.addProperty("OnEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnEnter","FOnEnter");
    $r.addProperty("OnExit",0,pas.Classes.$rtti["TNotifyEvent"],"FOnExit","FOnExit");
    $r.addProperty("OnHeaderClick",0,pas.DataGrid.$rtti["TOnHeaderClick"],"FOnHeaderClick","FOnHeaderClick");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
  });
  rtl.createClass($mod,"TWPagination",pas.DataGrid.TCustomPagination,function () {
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Align",2,pas.Controls.$rtti["TAlign"],"FAlign","SetAlign");
    $r.addProperty("BorderSpacing",2,pas.Controls.$rtti["TControlBorderSpacing"],"FBorderSpacing","SetBorderSpacing");
    $r.addProperty("CurrentPage",2,rtl.nativeint,"FCurrentPage","SetCurrentPage");
    $r.addProperty("Enabled",2,rtl.boolean,"FEnabled","SetEnabled");
    $r.addProperty("Font",2,pas.Graphics.$rtti["TFont"],"FFont","SetFont");
    $r.addProperty("HandleClass",2,rtl.string,"FHandleClass","SetHandleClass");
    $r.addProperty("HandleId",2,rtl.string,"FHandleId","SetHandleId");
    $r.addProperty("ParentFont",2,rtl.boolean,"FParentFont","SetParentFont");
    $r.addProperty("ParentShowHint",2,rtl.boolean,"FParentShowHint","SetParentShowHint");
    $r.addProperty("RecordsPerPage",2,rtl.nativeint,"FRecordsPerPage","SetRecordsPerPage");
    $r.addProperty("ShowHint",2,rtl.boolean,"FShowHint","SetShowHint");
    $r.addProperty("TabOrder",2,rtl.nativeint,"FTabOrder","SetTabOrder");
    $r.addProperty("TabStop",2,rtl.boolean,"FTabStop","SetTabStop");
    $r.addProperty("TotalPages",0,rtl.nativeint,"FTotalPages","");
    $r.addProperty("TotalRecords",2,rtl.nativeint,"FTotalRecords","SetTotalRecords");
    $r.addProperty("Visible",2,rtl.boolean,"FVisible","SetVisible");
    $r.addProperty("OnKeyDown",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyDown","FOnKeyDown");
    $r.addProperty("OnKeyPress",0,pas.Controls.$rtti["TKeyPressEvent"],"FOnKeyPress","FOnKeyPress");
    $r.addProperty("OnKeyUp",0,pas.Controls.$rtti["TKeyEvent"],"FOnKeyUp","FOnKeyUp");
    $r.addProperty("OnMouseDown",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseDown","FOnMouseDown");
    $r.addProperty("OnMouseEnter",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseEnter","FOnMouseEnter");
    $r.addProperty("OnMouseLeave",0,pas.Classes.$rtti["TNotifyEvent"],"FOnMouseLeave","FOnMouseLeave");
    $r.addProperty("OnMouseMove",0,pas.Controls.$rtti["TMouseMoveEvent"],"FOnMouseMove","FOnMouseMove");
    $r.addProperty("OnMouseUp",0,pas.Controls.$rtti["TMouseEvent"],"FOnMouseUp","FOnMouseUp");
    $r.addProperty("OnMouseWheel",0,pas.Controls.$rtti["TMouseWheelEvent"],"FOnMouseWheel","FOnMouseWheel");
    $r.addProperty("OnPageClick",0,pas.DataGrid.$rtti["TOnPageEvent"],"FOnPageClick","FOnPageClick");
  });
});
rtl.module("uJSChamps",["System","Classes","SysUtils","JS"],function () {
  "use strict";
  var $mod = this;
  $mod.$rtti.$MethodVar("TOnSet",{procsig: rtl.newTIProcSig([["_propertyKey",pas.JS.$rtti["TJSObject"]],["_value",pas.JS.$rtti["TJSObject"]]]), methodkind: 0});
  rtl.createClassExt($mod,"TJSChamps",Object,"",function () {
    this.$init = function () {
      this.proxy = null;
      this.OnSet = null;
      this.handler = null;
    };
    this.$final = function () {
      this.proxy = undefined;
      this.OnSet = undefined;
      this.handler = undefined;
    };
    this.proxy_OnSet = function (_propertyKey, _value) {
      if (this.OnSet != null) this.OnSet(_propertyKey,_value);
    };
    this.Create$2 = function () {
      this.OnSet = null;
      this.handler = null;
      this.handler=
      {
      set(target, propertyKey, value, receiver)
        {
        target.proxy_OnSet( propertyKey, value);
        return Reflect.set(target, propertyKey, value, receiver);
        }
      };
      pas.System.Writeln("handler:",JSON.stringify(this.handler));
      this.proxy = new Proxy(this,this.handler);
      this.proxy_OnSet(null,null);
    };
  });
});
rtl.module("ucWChamp_Edit",["System","SysUtils","Classes","Controls","StdCtrls","WebCtrls","JS","uJSChamps"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TWChamp_Edit",pas.WebCtrls.TWEdit,function () {
    this.$init = function () {
      pas.WebCtrls.TWEdit.$init.call(this);
      this.FChamps = null;
      this.FField = "";
      this.Champs_Changing = false;
    };
    this.$final = function () {
      this.FChamps = undefined;
      pas.WebCtrls.TWEdit.$final.call(this);
    };
    this.Create$1 = function (AOwner) {
      pas.StdCtrls.TCustomEdit.Create$1.apply(this,arguments);
      this.FChamps = null;
      this.Champs_Changing = false;
    };
    this.Destroy = function () {
      pas.Controls.TControl.Destroy.apply(this,arguments);
    };
    this.Change = function () {
      pas.StdCtrls.TCustomEdit.Change.apply(this,arguments);
      if (!this.Champ_OK()) return;
      this._to_Champs();
    };
    this.GetChamps = function () {
      var Result = null;
      Result = this.FChamps;
      return Result;
    };
    this.SetChamps = function (Value) {
      if ((this.FChamps != null) && rtl.eqCallback(rtl.createCallback(this,"Champs_OnSet"),this.FChamps.OnSet)) this.FChamps.OnSet = null;
      this.FChamps = null;
      this.SetText("");
      this.FChamps = Value;
      if (!this.Champ_OK()) return;
      this.FChamps.OnSet = rtl.createCallback(this,"Champs_OnSet");
      this._from_Champs();
    };
    this.Champ_OK = function () {
      var Result = false;
      Result = this.FChamps != null;
      if (!Result) return Result;
      Result = this.FChamps.proxy.hasOwnProperty(this.FField);
      return Result;
    };
    this.Champs_OnSet = function (_propertyKey, _value) {
      if (this.Champs_Changing) return;
      if (this.FField !== JSON.stringify(_propertyKey)) return;
      this._from_Champs_interne(_value);
    };
    this._from_Champs_interne = function (_Value) {
      if (this.Champs_Changing) return;
      try {
        this.Champs_Changing = true;
        this.SetText(JSON.stringify(_Value));
      } finally {
        this.Champs_Changing = false;
      };
    };
    this._from_Champs = function () {
      if (this.Champs_Changing) return;
      this._from_Champs_interne(this.FChamps.proxy[this.FField]);
    };
    this._to_Champs = function () {
      if (this.Champs_Changing) return;
      try {
        this.Champs_Changing = true;
        this.FChamps.proxy[this.FField] = this.GetText();
      } finally {
        this.Champs_Changing = false;
      };
    };
    rtl.addIntf(this,pas.System.IUnknown);
    var $r = this.$rtti;
    $r.addProperty("Field",0,rtl.string,"FField","FField");
  });
});
rtl.module("OD_DelphiReportEngine_Controls_pas2js_runtime",["System","ucWChamp_Edit","uJSChamps"],function () {
  "use strict";
  var $mod = this;
});
