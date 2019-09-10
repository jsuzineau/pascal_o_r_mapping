var pas = {};

var rtl = {

  version: 10101,

  quiet: false,
  debug_load_units: false,
  debug_rtti: false,

  debug: function(){
    if (rtl.quiet || !console || !console.log) return;
    console.log(arguments);
  },

  error: function(s){
    rtl.debug('Error: ',s);
    throw s;
  },

  warn: function(s){
    rtl.debug('Warn: ',s);
  },

  checkVersion: function(v){
    if (rtl.version != v) throw "expected rtl version "+v+", but found "+rtl.version;
  },

  hasString: function(s){
    return rtl.isString(s) && (s.length>0);
  },

  isArray: function(a) {
    return Array.isArray(a);
  },

  isFunction: function(f){
    return typeof(f)==="function";
  },

  isModule: function(m){
    return rtl.isObject(m) && rtl.hasString(m.$name) && (pas[m.$name]===m);
  },

  isImplementation: function(m){
    return rtl.isObject(m) && rtl.isModule(m.$module) && (m.$module.$impl===m);
  },

  isNumber: function(n){
    return typeof(n)==="number";
  },

  isObject: function(o){
    var s=typeof(o);
    return (typeof(o)==="object") && (o!=null);
  },

  isString: function(s){
    return typeof(s)==="string";
  },

  getNumber: function(n){
    return typeof(n)==="number"?n:NaN;
  },

  getChar: function(c){
    return ((typeof(c)==="string") && (c.length===1)) ? c : "";
  },

  getObject: function(o){
    return ((typeof(o)==="object") || (typeof(o)==='function')) ? o : null;
  },

  isPasClass: function(type){
    return (rtl.isObject(type) && type.hasOwnProperty('$classname') && rtl.isObject(type.$module));
  },

  isPasClassInstance: function(type){
    return (rtl.isObject(type) && rtl.isPasClass(type.$class));
  },

  hexStr: function(n,digits){
    return ("000000000000000"+n.toString(16).toUpperCase()).slice(-digits);
  },

  m_loading: 0,
  m_loading_intf: 1,
  m_intf_loaded: 2,
  m_loading_impl: 3, // loading all used unit
  m_initializing: 4, // running initialization
  m_initialized: 5,

  module: function(module_name, intfuseslist, intfcode, impluseslist, implcode){
    if (rtl.debug_load_units) rtl.debug('rtl.module name="'+module_name+'" intfuses='+intfuseslist+' impluses='+impluseslist+' hasimplcode='+rtl.isFunction(implcode));
    if (!rtl.hasString(module_name)) rtl.error('invalid module name "'+module_name+'"');
    if (!rtl.isArray(intfuseslist)) rtl.error('invalid interface useslist of "'+module_name+'"');
    if (!rtl.isFunction(intfcode)) rtl.error('invalid interface code of "'+module_name+'"');
    if (!(impluseslist==undefined) && !rtl.isArray(impluseslist)) rtl.error('invalid implementation useslist of "'+module_name+'"');
    if (!(implcode==undefined) && !rtl.isFunction(implcode)) rtl.error('invalid implementation code of "'+module_name+'"');

    if (pas[module_name])
      rtl.error('module "'+module_name+'" is already registered');

    var module = pas[module_name] = {
      $name: module_name,
      $intfuseslist: intfuseslist,
      $impluseslist: impluseslist,
      $state: rtl.m_loading,
      $intfcode: intfcode,
      $implcode: implcode,
      $impl: null,
      $rtti: Object.create(rtl.tSectionRTTI)
    };
    module.$rtti.$module = module;
    if (implcode) module.$impl = {
      $module: module,
      $rtti: module.$rtti
    };
  },

  exitcode: 0,

  run: function(module_name){
  
    function doRun(){
      if (!rtl.hasString(module_name)) module_name='program';
      if (rtl.debug_load_units) rtl.debug('rtl.run module="'+module_name+'"');
      rtl.initRTTI();
      var module = pas[module_name];
      if (!module) rtl.error('rtl.run module "'+module_name+'" missing');
      rtl.loadintf(module);
      rtl.loadimpl(module);
      if (module_name=='program'){
        if (rtl.debug_load_units) rtl.debug('running $main');
        var r = pas.program.$main();
        if (rtl.isNumber(r)) rtl.exitcode = r;
      }
    }
    
    if (rtl.showUncaughtExceptions) {
      try{
        doRun();
      } catch(re) {
        var errMsg = re.hasOwnProperty('$class') ? re.$class.$classname : '';
	    errMsg +=  ((errMsg) ? ': ' : '') + (re.hasOwnProperty('fMessage') ? re.fMessage : re);
        alert('Uncaught Exception : '+errMsg);
        rtl.exitCode = 216;
      }
    } else {
      doRun();
    }
    return rtl.exitcode;
  },

  loadintf: function(module){
    if (module.$state>rtl.m_loading_intf) return; // already finished
    if (rtl.debug_load_units) rtl.debug('loadintf: "'+module.$name+'"');
    if (module.$state===rtl.m_loading_intf)
      rtl.error('unit cycle detected "'+module.$name+'"');
    module.$state=rtl.m_loading_intf;
    // load interfaces of interface useslist
    rtl.loaduseslist(module,module.$intfuseslist,rtl.loadintf);
    // run interface
    if (rtl.debug_load_units) rtl.debug('loadintf: run intf of "'+module.$name+'"');
    module.$intfcode(module.$intfuseslist);
    // success
    module.$state=rtl.m_intf_loaded;
    // Note: units only used in implementations are not yet loaded (not even their interfaces)
  },

  loaduseslist: function(module,useslist,f){
    if (useslist==undefined) return;
    for (var i in useslist){
      var unitname=useslist[i];
      if (rtl.debug_load_units) rtl.debug('loaduseslist of "'+module.$name+'" uses="'+unitname+'"');
      if (pas[unitname]==undefined)
        rtl.error('module "'+module.$name+'" misses "'+unitname+'"');
      f(pas[unitname]);
    }
  },

  loadimpl: function(module){
    if (module.$state>=rtl.m_loading_impl) return; // already processing
    if (module.$state<rtl.m_intf_loaded) rtl.error('loadimpl: interface not loaded of "'+module.$name+'"');
    if (rtl.debug_load_units) rtl.debug('loadimpl: load uses of "'+module.$name+'"');
    module.$state=rtl.m_loading_impl;
    // load interfaces of implementation useslist
    rtl.loaduseslist(module,module.$impluseslist,rtl.loadintf);
    // load implementation of interfaces useslist
    rtl.loaduseslist(module,module.$intfuseslist,rtl.loadimpl);
    // load implementation of implementation useslist
    rtl.loaduseslist(module,module.$impluseslist,rtl.loadimpl);
    // Note: At this point all interfaces used by this unit are loaded. If
    //   there are implementation uses cycles some used units might not yet be
    //   initialized. This is by design.
    // run implementation
    if (rtl.debug_load_units) rtl.debug('loadimpl: run impl of "'+module.$name+'"');
    if (rtl.isFunction(module.$implcode)) module.$implcode(module.$impluseslist);
    // run initialization
    if (rtl.debug_load_units) rtl.debug('loadimpl: run init of "'+module.$name+'"');
    module.$state=rtl.m_initializing;
    if (rtl.isFunction(module.$init)) module.$init();
    // unit initialized
    module.$state=rtl.m_initialized;
  },

  createCallback: function(scope, fn){
    var cb;
    if (typeof(fn)==='string'){
      cb = function(){
        return scope[fn].apply(scope,arguments);
      };
    } else {
      cb = function(){
        return fn.apply(scope,arguments);
      };
    };
    cb.scope = scope;
    cb.fn = fn;
    return cb;
  },

  cloneCallback: function(cb){
    return rtl.createCallback(cb.scope,cb.fn);
  },

  eqCallback: function(a,b){
    // can be a function or a function wrapper
    if (a==b){
      return true;
    } else {
      return (a!=null) && (b!=null) && (a.fn) && (a.scope===b.scope) && (a.fn==b.fn);
    }
  },

  initClass: function(c,parent,name,initfn){
    parent[name] = c;
    c.$class = c; // Note: o.$class === Object.getPrototypeOf(o)
    c.$classname = name;
    if ((parent.$module) && (parent.$module.$impl===parent)) parent=parent.$module;
    c.$parent = parent;
    c.$fullname = parent.$name+'.'+name;
    if (rtl.isModule(parent)){
      c.$module = parent;
      c.$name = name;
    } else {
      c.$module = parent.$module;
      c.$name = parent.name+'.'+name;
    };
    // rtti
    if (rtl.debug_rtti) rtl.debug('initClass '+c.$fullname);
    var t = c.$module.$rtti.$Class(c.$name,{ "class": c, module: parent });
    c.$rtti = t;
    if (rtl.isObject(c.$ancestor)) t.ancestor = c.$ancestor.$rtti;
    if (!t.ancestor) t.ancestor = null;
    // init members
    initfn.call(c);
  },

  createClass: function(parent,name,ancestor,initfn){
    // create a normal class,
    // ancestor must be null or a normal class,
    // the root ancestor can be an external class
    var c = null;
    if (ancestor != null){
      c = Object.create(ancestor);
      c.$ancestor = ancestor;
      // Note:
      // if root is an "object" then c.$ancestor === Object.getPrototypeOf(c)
      // if root is a "function" then c.$ancestor === c.__proto__, Object.getPrototypeOf(c) returns the root
    } else {
      c = {};
      c.$create = function(fnname,args){
        if (args == undefined) args = [];
        var o = Object.create(this);
        o.$init();
        try{
          o[fnname].apply(o,args);
          o.AfterConstruction();
        } catch($e){
          // do not call BeforeDestruction
          if (o.Destroy) o.Destroy();
          o.$final();
          throw $e;
        }
        return o;
      };
      c.$destroy = function(fnname){
        this.BeforeDestruction();
        if (this[fnname]) this[fnname]();
        this.$final();
      };
    };
    rtl.initClass(c,parent,name,initfn);
  },

  createClassExt: function(parent,name,ancestor,newinstancefnname,initfn){
    // Create a class using an external ancestor.
    // If newinstancefnname is given, use that function to create the new object.
    // If exist call BeforeDestruction and AfterConstruction.
    var c = null;
    c = Object.create(ancestor);
    c.$create = function(fnname,args){
      if (args == undefined) args = [];
      var o = null;
      if (newinstancefnname.length>0){
        o = this[newinstancefnname](fnname,args);
      } else {
        o = Object.create(this);
      }
      if (o.$init) o.$init();
      try{
        o[fnname].apply(o,args);
        if (o.AfterConstruction) o.AfterConstruction();
      } catch($e){
        // do not call BeforeDestruction
        if (o.Destroy) o.Destroy();
        if (o.$final) this.$final();
        throw $e;
      }
      return o;
    };
    c.$destroy = function(fnname){
      if (this.BeforeDestruction) this.BeforeDestruction();
      if (this[fnname]) this[fnname]();
      if (this.$final) this.$final();
    };
    rtl.initClass(c,parent,name,initfn);
  },

  tObjectDestroy: "Destroy",

  free: function(obj,name){
    if (obj[name]==null) return;
    obj[name].$destroy(rtl.tObjectDestroy);
    obj[name]=null;
  },

  freeLoc: function(obj){
    if (obj==null) return;
    obj.$destroy(rtl.tObjectDestroy);
    return null;
  },

  is: function(instance,type){
    return type.isPrototypeOf(instance) || (instance===type);
  },

  isExt: function(instance,type,mode){
    // mode===1 means instance must be a Pascal class instance
    // mode===2 means instance must be a Pascal class
    // Notes:
    // isPrototypeOf and instanceof return false on equal
    // isPrototypeOf does not work for Date.isPrototypeOf(new Date())
    //   so if isPrototypeOf is false test with instanceof
    // instanceof needs a function on right side
    if (instance == null) return false; // Note: ==null checks for undefined too
    if ((typeof(type) !== 'object') && (typeof(type) !== 'function')) return false;
    if (instance === type){
      if (mode===1) return false;
      if (mode===2) return rtl.isPasClass(instance);
      return true;
    }
    if (type.isPrototypeOf && type.isPrototypeOf(instance)){
      if (mode===1) return rtl.isPasClassInstance(instance);
      if (mode===2) return rtl.isPasClass(instance);
      return true;
    }
    if ((typeof type == 'function') && (instance instanceof type)) return true;
    return false;
  },

  Exception: null,
  EInvalidCast: null,
  EAbstractError: null,
  ERangeError: null,

  raiseE: function(typename){
    var t = rtl[typename];
    if (t==null){
      var mod = pas.SysUtils;
      if (!mod) mod = pas.sysutils;
      if (mod){
        t = mod[typename];
        if (!t) t = mod[typename.toLowerCase()];
        if (!t) t = mod['Exception'];
        if (!t) t = mod['exception'];
      }
    }
    if (t){
      if (t.Create){
        throw t.$create("Create");
      } else if (t.create){
        throw t.$create("create");
      }
    }
    if (typename === "EInvalidCast") throw "invalid type cast";
    if (typename === "EAbstractError") throw "Abstract method called";
    if (typename === "ERangeError") throw "range error";
    throw typename;
  },

  as: function(instance,type){
    if((instance === null) || rtl.is(instance,type)) return instance;
    rtl.raiseE("EInvalidCast");
  },

  asExt: function(instance,type,mode){
    if((instance === null) || rtl.isExt(instance,type,mode)) return instance;
    rtl.raiseE("EInvalidCast");
  },

  createInterface: function(module, name, guid, fnnames, ancestor, initfn){
    //console.log('createInterface name="'+name+'" guid="'+guid+'" names='+fnnames);
    var i = ancestor?Object.create(ancestor):{};
    module[name] = i;
    i.$module = module;
    i.$name = name;
    i.$fullname = module.$name+'.'+name;
    i.$guid = guid;
    i.$guidr = null;
    i.$names = fnnames?fnnames:[];
    if (rtl.isFunction(initfn)){
      // rtti
      if (rtl.debug_rtti) rtl.debug('createInterface '+i.$fullname);
      var t = i.$module.$rtti.$Interface(name,{ "interface": i, module: module });
      i.$rtti = t;
      if (ancestor) t.ancestor = ancestor.$rtti;
      if (!t.ancestor) t.ancestor = null;
      initfn.call(i);
    }
    return i;
  },

  strToGUIDR: function(s,g){
    var p = 0;
    function n(l){
      var h = s.substr(p,l);
      p+=l;
      return parseInt(h,16);
    }
    p+=1; // skip {
    g.D1 = n(8);
    p+=1; // skip -
    g.D2 = n(4);
    p+=1; // skip -
    g.D3 = n(4);
    p+=1; // skip -
    if (!g.D4) g.D4=[];
    g.D4[0] = n(2);
    g.D4[1] = n(2);
    p+=1; // skip -
    for(var i=2; i<8; i++) g.D4[i] = n(2);
    return g;
  },

  guidrToStr: function(g){
    if (g.$intf) return g.$intf.$guid;
    var h = rtl.hexStr;
    var s='{'+h(g.D1,8)+'-'+h(g.D2,4)+'-'+h(g.D3,4)+'-'+h(g.D4[0],2)+h(g.D4[1],2)+'-';
    for (var i=2; i<8; i++) s+=h(g.D4[i],2);
    s+='}';
    return s;
  },

  createTGUID: function(guid){
    var TGuid = (pas.System)?pas.System.TGuid:pas.system.tguid;
    var g = rtl.strToGUIDR(guid,new TGuid());
    return g;
  },

  getIntfGUIDR: function(intfTypeOrVar){
    if (!intfTypeOrVar) return null;
    if (!intfTypeOrVar.$guidr){
      var g = rtl.createTGUID(intfTypeOrVar.$guid);
      if (!intfTypeOrVar.hasOwnProperty('$guid')) intfTypeOrVar = Object.getPrototypeOf(intfTypeOrVar);
      g.$intf = intfTypeOrVar;
      intfTypeOrVar.$guidr = g;
    }
    return intfTypeOrVar.$guidr;
  },

  addIntf: function (aclass, intf, map){
    function jmp(fn){
      if (typeof(fn)==="function"){
        return function(){ return fn.apply(this.$o,arguments); };
      } else {
        return function(){ rtl.raiseE('EAbstractError'); };
      }
    }
    if(!map) map = {};
    var t = intf;
    var item = Object.create(t);
    if (!aclass.hasOwnProperty('$intfmaps')) aclass.$intfmaps = {};
    aclass.$intfmaps[intf.$guid] = item;
    do{
      var names = t.$names;
      if (!names) break;
      for (var i=0; i<names.length; i++){
        var intfname = names[i];
        var fnname = map[intfname];
        if (!fnname) fnname = intfname;
        //console.log('addIntf: intftype='+t.$name+' index='+i+' intfname="'+intfname+'" fnname="'+fnname+'" old='+typeof(item[intfname]));
        item[intfname] = jmp(aclass[fnname]);
      }
      t = Object.getPrototypeOf(t);
    }while(t!=null);
  },

  getIntfG: function (obj, guid, query){
    if (!obj) return null;
    //console.log('getIntfG: obj='+obj.$classname+' guid='+guid+' query='+query);
    // search
    var maps = obj.$intfmaps;
    if (!maps) return null;
    var item = maps[guid];
    if (!item) return null;
    // check delegation
    //console.log('getIntfG: obj='+obj.$classname+' guid='+guid+' query='+query+' item='+typeof(item));
    if (typeof item === 'function') return item.call(obj); // delegate. Note: COM contains _AddRef
    // check cache
    var intf = null;
    if (obj.$interfaces){
      intf = obj.$interfaces[guid];
      //console.log('getIntfG: obj='+obj.$classname+' guid='+guid+' cache='+typeof(intf));
    }
    if (!intf){ // intf can be undefined!
      intf = Object.create(item);
      intf.$o = obj;
      if (!obj.$interfaces) obj.$interfaces = {};
      obj.$interfaces[guid] = intf;
    }
    if (typeof(query)==='object'){
      // called by queryIntfT
      var o = null;
      if (intf.QueryInterface(rtl.getIntfGUIDR(query),
          {get:function(){ return o; }, set:function(v){ o=v; }}) === 0){
        return o;
      } else {
        return null;
      }
    } else if(query===2){
      // called by TObject.GetInterfaceByStr
      if (intf.$kind === 'com') intf._AddRef();
    }
    return intf;
  },

  getIntfT: function(obj,intftype){
    return rtl.getIntfG(obj,intftype.$guid);
  },

  queryIntfT: function(obj,intftype){
    return rtl.getIntfG(obj,intftype.$guid,intftype);
  },

  queryIntfIsT: function(obj,intftype){
    var i = rtl.queryIntfG(obj,intftype.$guid);
    if (!i) return false;
    if (i.$kind === 'com') i._Release();
    return true;
  },

  asIntfT: function (obj,intftype){
    var i = rtl.getIntfG(obj,intftype.$guid);
    if (i!==null) return i;
    rtl.raiseEInvalidCast();
  },

  intfIsClass: function(intf,classtype){
    return (intf!=null) && (rtl.is(intf.$o,classtype));
  },

  intfAsClass: function(intf,classtype){
    if (intf==null) return null;
    return rtl.as(intf.$o,classtype);
  },

  intfToClass: function(intf,classtype){
    if ((intf!==null) && rtl.is(intf.$o,classtype)) return intf.$o;
    return null;
  },

  // interface reference counting
  intfRefs: { // base object for temporary interface variables
    ref: function(id,intf){
      // called for temporary interface references needing delayed release
      var old = this[id];
      //console.log('rtl.intfRefs.ref: id='+id+' old="'+(old?old.$name:'null')+'" intf="'+(intf?intf.$name:'null')+' $o='+(intf?intf.$o:'null'));
      if (old){
        // called again, e.g. in a loop
        delete this[id];
        old._Release(); // may fail
      }
      this[id]=intf;
      return intf;
    },
    free: function(){
      //console.log('rtl.intfRefs.free...');
      for (var id in this){
        if (this.hasOwnProperty(id)){
          //console.log('rtl.intfRefs.free: id='+id+' '+this[id].$name+' $o='+this[id].$o.$classname);
          this[id]._Release();
        }
      }
    }
  },

  createIntfRefs: function(){
    //console.log('rtl.createIntfRefs');
    return Object.create(rtl.intfRefs);
  },

  setIntfP: function(path,name,value,skipAddRef){
    var old = path[name];
    //console.log('rtl.setIntfP path='+path+' name='+name+' old="'+(old?old.$name:'null')+'" value="'+(value?value.$name:'null')+'"');
    if (old === value) return;
    if (old !== null){
      path[name]=null;
      old._Release();
    }
    if (value !== null){
      if (!skipAddRef) value._AddRef();
      path[name]=value;
    }
  },

  setIntfL: function(old,value,skipAddRef){
    //console.log('rtl.setIntfL old="'+(old?old.$name:'null')+'" value="'+(value?value.$name:'null')+'"');
    if (old !== value){
      if (value!==null){
        if (!skipAddRef) value._AddRef();
      }
      if (old!==null){
        old._Release();  // Release after AddRef, to avoid double Release if Release creates an exception
      }
    } else if (skipAddRef){
      if (old!==null){
        old._Release();  // value has an AddRef
      }
    }
    return value;
  },

  _AddRef: function(intf){
    //if (intf) console.log('rtl._AddRef intf="'+(intf?intf.$name:'null')+'"');
    if (intf) intf._AddRef();
    return intf;
  },

  _Release: function(intf){
    //if (intf) console.log('rtl._Release intf="'+(intf?intf.$name:'null')+'"');
    if (intf) intf._Release();
    return intf;
  },

  checkMethodCall: function(obj,type){
    if (rtl.isObject(obj) && rtl.is(obj,type)) return;
    rtl.raiseE("EInvalidCast");
  },

  rc: function(i,minval,maxval){
    // range check integer
    if ((Math.floor(i)===i) && (i>=minval) && (i<=maxval)) return i;
    rtl.raiseE('ERangeError');
  },

  rcc: function(c,minval,maxval){
    // range check char
    if ((typeof(c)==='string') && (c.length===1)){
      var i = c.charCodeAt(0);
      if ((i>=minval) && (i<=maxval)) return c;
    }
    rtl.raiseE('ERangeError');
  },

  rcSetCharAt: function(s,index,c){
    // range check setCharAt
    if ((typeof(s)!=='string') || (index<0) || (index>=s.length)) rtl.raiseE('ERangeError');
    return rtl.setCharAt(s,index,c);
  },

  rcCharAt: function(s,index){
    // range check charAt
    if ((typeof(s)!=='string') || (index<0) || (index>=s.length)) rtl.raiseE('ERangeError');
    return s.charAt(index);
  },

  rcArrR: function(arr,index){
    // range check read array
    if (Array.isArray(arr) && (typeof(index)==='number') && (index>=0) && (index<arr.length)){
      if (arguments.length>2){
        // arr,index1,index2,...
        arr=arr[index];
        for (var i=2; i<arguments.length; i++) arr=rtl.rcArrR(arr,arguments[i]);
        return arr;
      }
      return arr[index];
    }
    rtl.raiseE('ERangeError');
  },

  rcArrW: function(arr,index,value){
    // range check write array
    // arr,index1,index2,...,value
    for (var i=3; i<arguments.length; i++){
      arr=rtl.rcArrR(arr,index);
      index=arguments[i-1];
      value=arguments[i];
    }
    if (Array.isArray(arr) && (typeof(index)==='number') && (index>=0) && (index<arr.length)){
      return arr[index]=value;
    }
    rtl.raiseE('ERangeError');
  },

  length: function(arr){
    return (arr == null) ? 0 : arr.length;
  },

  arraySetLength: function(arr,defaultvalue,newlength){
    // multi dim: (arr,defaultvalue,dim1,dim2,...)
    if (arr == null) arr = [];
    var p = arguments;
    function setLength(a,argNo){
      var oldlen = a.length;
      var newlen = p[argNo];
      if (oldlen!==newlength){
        a.length = newlength;
        if (argNo === p.length-1){
          if (rtl.isArray(defaultvalue)){
            for (var i=oldlen; i<newlen; i++) a[i]=[]; // nested array
          } else if (rtl.isFunction(defaultvalue)){
            for (var i=oldlen; i<newlen; i++) a[i]=new defaultvalue(); // e.g. record
          } else if (rtl.isObject(defaultvalue)) {
            for (var i=oldlen; i<newlen; i++) a[i]={}; // e.g. set
          } else {
            for (var i=oldlen; i<newlen; i++) a[i]=defaultvalue;
          }
        } else {
          for (var i=oldlen; i<newlen; i++) a[i]=[]; // nested array
        }
      }
      if (argNo < p.length-1){
        // multi argNo
        for (var i=0; i<newlen; i++) a[i]=setLength(a[i],argNo+1);
      }
      return a;
    }
    return setLength(arr,2);
  },

  arrayEq: function(a,b){
    if (a===null) return b===null;
    if (b===null) return false;
    if (a.length!==b.length) return false;
    for (var i=0; i<a.length; i++) if (a[i]!==b[i]) return false;
    return true;
  },

  arrayClone: function(type,src,srcpos,endpos,dst,dstpos){
    // type: 0 for references, "refset" for calling refSet(), a function for new type()
    // src must not be null
    // This function does not range check.
    if (rtl.isFunction(type)){
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = new type(src[srcpos]); // clone record
    } else if(type === 'refSet') {
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = rtl.refSet(src[srcpos]); // ref set
    }  else {
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = src[srcpos]; // reference
    };
  },

  arrayConcat: function(type){
    // type: see rtl.arrayClone
    var a = [];
    var l = 0;
    for (var i=1; i<arguments.length; i++){
      var src = arguments[i];
      if (src !== null) l+=src.length;
    };
    a.length = l;
    l=0;
    for (var i=1; i<arguments.length; i++){
      var src = arguments[i];
      if (src === null) continue;
      rtl.arrayClone(type,src,0,src.length,a,l);
      l+=src.length;
    };
    return a;
  },

  arrayConcatN: function(){
    var a = null;
    for (var i=1; i<arguments.length; i++){
      var src = arguments[i];
      if (src === null) continue;
      if (a===null){
        a=src; // Note: concat(a) does not clone
      } else {
        a=a.concat(src);
      }
    };
    return a;
  },

  arrayCopy: function(type, srcarray, index, count){
    // type: see rtl.arrayClone
    // if count is missing, use srcarray.length
    if (srcarray === null) return [];
    if (index < 0) index = 0;
    if (count === undefined) count=srcarray.length;
    var end = index+count;
    if (end>srcarray.length) end = srcarray.length;
    if (index>=end) return [];
    if (type===0){
      return srcarray.slice(index,end);
    } else {
      var a = [];
      a.length = end-index;
      rtl.arrayClone(type,srcarray,index,end,a,0);
      return a;
    }
  },

  setCharAt: function(s,index,c){
    return s.substr(0,index)+c+s.substr(index+1);
  },

  getResStr: function(mod,name){
    var rs = mod.$resourcestrings[name];
    return rs.current?rs.current:rs.org;
  },

  createSet: function(){
    var s = {};
    for (var i=0; i<arguments.length; i++){
      if (arguments[i]!=null){
        s[arguments[i]]=true;
      } else {
        var first=arguments[i+=1];
        var last=arguments[i+=1];
        for(var j=first; j<=last; j++) s[j]=true;
      }
    }
    return s;
  },

  cloneSet: function(s){
    var r = {};
    for (var key in s) r[key]=true;
    return r;
  },

  refSet: function(s){
    Object.defineProperty(s, '$shared', {
      enumerable: false,
      configurable: true,
      writable: true,
      value: true
    });
    return s;
  },

  includeSet: function(s,enumvalue){
    if (s.$shared) s = rtl.cloneSet(s);
    s[enumvalue] = true;
    return s;
  },

  excludeSet: function(s,enumvalue){
    if (s.$shared) s = rtl.cloneSet(s);
    delete s[enumvalue];
    return s;
  },

  diffSet: function(s,t){
    var r = {};
    for (var key in s) if (!t[key]) r[key]=true;
    return r;
  },

  unionSet: function(s,t){
    var r = {};
    for (var key in s) r[key]=true;
    for (var key in t) r[key]=true;
    return r;
  },

  intersectSet: function(s,t){
    var r = {};
    for (var key in s) if (t[key]) r[key]=true;
    return r;
  },

  symDiffSet: function(s,t){
    var r = {};
    for (var key in s) if (!t[key]) r[key]=true;
    for (var key in t) if (!s[key]) r[key]=true;
    return r;
  },

  eqSet: function(s,t){
    for (var key in s) if (!t[key]) return false;
    for (var key in t) if (!s[key]) return false;
    return true;
  },

  neSet: function(s,t){
    return !rtl.eqSet(s,t);
  },

  leSet: function(s,t){
    for (var key in s) if (!t[key]) return false;
    return true;
  },

  geSet: function(s,t){
    for (var key in t) if (!s[key]) return false;
    return true;
  },

  strSetLength: function(s,newlen){
    var oldlen = s.length;
    if (oldlen > newlen){
      return s.substring(0,newlen);
    } else if (s.repeat){
      // Note: repeat needs ECMAScript6!
      return s+' '.repeat(newlen-oldlen);
    } else {
       while (oldlen<newlen){
         s+=' ';
         oldlen++;
       };
       return s;
    }
  },

  spaceLeft: function(s,width){
    var l=s.length;
    if (l>=width) return s;
    if (s.repeat){
      // Note: repeat needs ECMAScript6!
      return ' '.repeat(width-l) + s;
    } else {
      while (l<width){
        s=' '+s;
        l++;
      };
    };
  },

  floatToStr : function(d,w,p){
    // input 1-3 arguments: double, width, precision
    if (arguments.length>2){
      return rtl.spaceLeft(d.toFixed(p),w);
    } else {
	  // exponent width
	  var pad = "";
	  var ad = Math.abs(d);
	  if (ad<1.0e+10) {
		pad='00';
	  } else if (ad<1.0e+100) {
		pad='0';
      }  	
	  if (arguments.length<2) {
	    w=9;		
      } else if (w<9) {
		w=9;
      }		  
      var p = w-8;
      var s=(d>0 ? " " : "" ) + d.toExponential(p);
      s=s.replace(/e(.)/,'E$1'+pad);
      return rtl.spaceLeft(s,w);
    }
  },

  initRTTI: function(){
    if (rtl.debug_rtti) rtl.debug('initRTTI');

    // base types
    rtl.tTypeInfo = { name: "tTypeInfo" };
    function newBaseTI(name,kind,ancestor){
      if (!ancestor) ancestor = rtl.tTypeInfo;
      if (rtl.debug_rtti) rtl.debug('initRTTI.newBaseTI "'+name+'" '+kind+' ("'+ancestor.name+'")');
      var t = Object.create(ancestor);
      t.name = name;
      t.kind = kind;
      rtl[name] = t;
      return t;
    };
    function newBaseInt(name,minvalue,maxvalue,ordtype){
      var t = newBaseTI(name,1 /* tkInteger */,rtl.tTypeInfoInteger);
      t.minvalue = minvalue;
      t.maxvalue = maxvalue;
      t.ordtype = ordtype;
      return t;
    };
    newBaseTI("tTypeInfoInteger",1 /* tkInteger */);
    newBaseInt("shortint",-0x80,0x7f,0);
    newBaseInt("byte",0,0xff,1);
    newBaseInt("smallint",-0x8000,0x7fff,2);
    newBaseInt("word",0,0xffff,3);
    newBaseInt("longint",-0x80000000,0x7fffffff,4);
    newBaseInt("longword",0,0xffffffff,5);
    newBaseInt("nativeint",-0x10000000000000,0xfffffffffffff,6);
    newBaseInt("nativeuint",0,0xfffffffffffff,7);
    newBaseTI("char",2 /* tkChar */);
    newBaseTI("string",3 /* tkString */);
    newBaseTI("tTypeInfoEnum",4 /* tkEnumeration */,rtl.tTypeInfoInteger);
    newBaseTI("tTypeInfoSet",5 /* tkSet */);
    newBaseTI("double",6 /* tkDouble */);
    newBaseTI("boolean",7 /* tkBool */);
    newBaseTI("tTypeInfoProcVar",8 /* tkProcVar */);
    newBaseTI("tTypeInfoMethodVar",9 /* tkMethod */,rtl.tTypeInfoProcVar);
    newBaseTI("tTypeInfoArray",10 /* tkArray */);
    newBaseTI("tTypeInfoDynArray",11 /* tkDynArray */);
    newBaseTI("tTypeInfoPointer",15 /* tkPointer */);
    var t = newBaseTI("pointer",15 /* tkPointer */,rtl.tTypeInfoPointer);
    t.reftype = null;
    newBaseTI("jsvalue",16 /* tkJSValue */);
    newBaseTI("tTypeInfoRefToProcVar",17 /* tkRefToProcVar */,rtl.tTypeInfoProcVar);

    // member kinds
    rtl.tTypeMember = {};
    function newMember(name,kind){
      var m = Object.create(rtl.tTypeMember);
      m.name = name;
      m.kind = kind;
      rtl[name] = m;
    };
    newMember("tTypeMemberField",1); // tmkField
    newMember("tTypeMemberMethod",2); // tmkMethod
    newMember("tTypeMemberProperty",3); // tmkProperty

    // base object for storing members: a simple object
    rtl.tTypeMembers = {};

    // tTypeInfoStruct - base object for tTypeInfoClass, tTypeInfoRecord, tTypeInfoInterface
    var tis = newBaseTI("tTypeInfoStruct",0);
    tis.$addMember = function(name,ancestor,options){
      if (rtl.debug_rtti){
        if (!rtl.hasString(name) || (name.charAt()==='$')) throw 'invalid member "'+name+'", this="'+this.name+'"';
        if (!rtl.is(ancestor,rtl.tTypeMember)) throw 'invalid ancestor "'+ancestor+':'+ancestor.name+'", "'+this.name+'.'+name+'"';
        if ((options!=undefined) && (typeof(options)!='object')) throw 'invalid options "'+options+'", "'+this.name+'.'+name+'"';
      };
      var t = Object.create(ancestor);
      t.name = name;
      this.members[name] = t;
      this.names.push(name);
      if (rtl.isObject(options)){
        for (var key in options) if (options.hasOwnProperty(key)) t[key] = options[key];
      };
      return t;
    };
    tis.addField = function(name,type,options){
      var t = this.$addMember(name,rtl.tTypeMemberField,options);
      if (rtl.debug_rtti){
        if (!rtl.is(type,rtl.tTypeInfo)) throw 'invalid type "'+type+'", "'+this.name+'.'+name+'"';
      };
      t.typeinfo = type;
      this.fields.push(name);
      return t;
    };
    tis.addFields = function(){
      var i=0;
      while(i<arguments.length){
        var name = arguments[i++];
        var type = arguments[i++];
        if ((i<arguments.length) && (typeof(arguments[i])==='object')){
          this.addField(name,type,arguments[i++]);
        } else {
          this.addField(name,type);
        };
      };
    };
    tis.addMethod = function(name,methodkind,params,result,options){
      var t = this.$addMember(name,rtl.tTypeMemberMethod,options);
      t.methodkind = methodkind;
      t.procsig = rtl.newTIProcSig(params);
      t.procsig.resulttype = result?result:null;
      this.methods.push(name);
      return t;
    };
    tis.addProperty = function(name,flags,result,getter,setter,options){
      var t = this.$addMember(name,rtl.tTypeMemberProperty,options);
      t.flags = flags;
      t.typeinfo = result;
      t.getter = getter;
      t.setter = setter;
      // Note: in options: params, stored, defaultvalue
      if (rtl.isArray(t.params)) t.params = rtl.newTIParams(t.params);
      this.properties.push(name);
      if (!rtl.isString(t.stored)) t.stored = "";
      return t;
    };
    tis.getField = function(index){
      return this.members[this.fields[index]];
    };
    tis.getMethod = function(index){
      return this.members[this.methods[index]];
    };
    tis.getProperty = function(index){
      return this.members[this.properties[index]];
    };

    newBaseTI("tTypeInfoRecord",12 /* tkRecord */,rtl.tTypeInfoStruct);
    newBaseTI("tTypeInfoClass",13 /* tkClass */,rtl.tTypeInfoStruct);
    newBaseTI("tTypeInfoClassRef",14 /* tkClassRef */);
    newBaseTI("tTypeInfoInterface",15 /* tkInterface */,rtl.tTypeInfoStruct);
  },

  tSectionRTTI: {
    $module: null,
    $inherited: function(name,ancestor,o){
      if (rtl.debug_rtti){
        rtl.debug('tSectionRTTI.newTI "'+(this.$module?this.$module.$name:"(no module)")
          +'"."'+name+'" ('+ancestor.name+') '+(o?'init':'forward'));
      };
      var t = this[name];
      if (t){
        if (!t.$forward) throw 'duplicate type "'+name+'"';
        if (!ancestor.isPrototypeOf(t)) throw 'typeinfo ancestor mismatch "'+name+'" ancestor="'+ancestor.name+'" t.name="'+t.name+'"';
      } else {
        t = Object.create(ancestor);
        t.name = name;
        t.$module = this.$module;
        this[name] = t;
      }
      if (o){
        delete t.$forward;
        for (var key in o) if (o.hasOwnProperty(key)) t[key]=o[key];
      } else {
        t.$forward = true;
      }
      return t;
    },
    $Scope: function(name,ancestor,o){
      var t=this.$inherited(name,ancestor,o);
      t.members = {};
      t.names = [];
      t.fields = [];
      t.methods = [];
      t.properties = [];
      return t;
    },
    $TI: function(name,kind,o){ var t=this.$inherited(name,rtl.tTypeInfo,o); t.kind = kind; return t; },
    $Int: function(name,o){ return this.$inherited(name,rtl.tTypeInfoInteger,o); },
    $Enum: function(name,o){ return this.$inherited(name,rtl.tTypeInfoEnum,o); },
    $Set: function(name,o){ return this.$inherited(name,rtl.tTypeInfoSet,o); },
    $StaticArray: function(name,o){ return this.$inherited(name,rtl.tTypeInfoArray,o); },
    $DynArray: function(name,o){ return this.$inherited(name,rtl.tTypeInfoDynArray,o); },
    $ProcVar: function(name,o){ return this.$inherited(name,rtl.tTypeInfoProcVar,o); },
    $RefToProcVar: function(name,o){ return this.$inherited(name,rtl.tTypeInfoRefToProcVar,o); },
    $MethodVar: function(name,o){ return this.$inherited(name,rtl.tTypeInfoMethodVar,o); },
    $Record: function(name,o){ return this.$Scope(name,rtl.tTypeInfoRecord,o); },
    $Class: function(name,o){ return this.$Scope(name,rtl.tTypeInfoClass,o); },
    $ClassRef: function(name,o){ return this.$inherited(name,rtl.tTypeInfoClassRef,o); },
    $Pointer: function(name,o){ return this.$inherited(name,rtl.tTypeInfoPointer,o); },
    $Interface: function(name,o){ return this.$Scope(name,rtl.tTypeInfoInterface,o); }
  },

  newTIParam: function(param){
    // param is an array, 0=name, 1=type, 2=optional flags
    var t = {
      name: param[0],
      typeinfo: param[1],
      flags: (rtl.isNumber(param[2]) ? param[2] : 0)
    };
    return t;
  },

  newTIParams: function(list){
    // list: optional array of [paramname,typeinfo,optional flags]
    var params = [];
    if (rtl.isArray(list)){
      for (var i=0; i<list.length; i++) params.push(rtl.newTIParam(list[i]));
    };
    return params;
  },

  newTIProcSig: function(params,result,flags){
    var s = {
      params: rtl.newTIParams(params),
      resulttype: result,
      flags: flags
    };
    return s;
  }
}
rtl.module("System",[],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.LineEnding = "\n";
  rtl.createClass($mod,"TObject",null,function () {
    this.$init = function () {
    };
    this.$final = function () {
    };
    this.Create = function () {
    };
    this.Destroy = function () {
    };
    this.ClassType = function () {
      return this;
    };
    this.InheritsFrom = function (aClass) {
      return (aClass!=null) && ((this==aClass) || aClass.isPrototypeOf(this));
    };
    this.AfterConstruction = function () {
    };
    this.BeforeDestruction = function () {
    };
  });
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
  this.Assigned = function (V) {
    return (V!=undefined) && (V!=null) && (!rtl.isArray(V) || (V.length > 0));
  };
  $mod.$init = function () {
    rtl.exitcode = 0;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
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
  this.SInvalidName = 'Invalid component name: "%s"';
  this.SDuplicateName = 'Duplicate component name: "%s"';
});
rtl.module("Types",["System"],function () {
  "use strict";
  var $mod = this;
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
  this.Rect = function (Left, Top, Right, Bottom) {
    var Result = new $mod.TRect();
    Result.Left = Left;
    Result.Top = Top;
    Result.Right = Right;
    Result.Bottom = Bottom;
    return Result;
  };
  this.Point = function (x, y) {
    var Result = new $mod.TPoint();
    Result.x = x;
    Result.y = y;
    return Result;
  };
  this.Size = function (AWidth, AHeight) {
    var Result = new $mod.TSize();
    Result.cx = AWidth;
    Result.cy = AHeight;
    return Result;
  };
});
rtl.module("JS",["System","Types"],function () {
  "use strict";
  var $mod = this;
  this.isInteger = function (v) {
    return Math.floor(v)===v;
  };
  this.isNull = function (v) {
    return v === null;
  };
  this.ToString = function (Value) {
    var Result = "";
    if (rtl.isString(Value)) {
      Result = "" + Value}
     else Result = "";
    return Result;
  };
  this.TJSValueType = {"0": "jvtNull", jvtNull: 0, "1": "jvtBoolean", jvtBoolean: 1, "2": "jvtInteger", jvtInteger: 2, "3": "jvtFloat", jvtFloat: 3, "4": "jvtString", jvtString: 4, "5": "jvtObject", jvtObject: 5, "6": "jvtArray", jvtArray: 6};
  this.GetValueType = function (JS) {
    var Result = 0;
    var t = "";
    if ($mod.isNull(JS)) {
      Result = 0}
     else {
      t = typeof(JS);
      if (t === "string") {
        Result = 4}
       else if (t === "boolean") {
        Result = 1}
       else if (t === "object") {
        if (rtl.isArray(JS)) {
          Result = 6}
         else Result = 5;
      } else if (t === "number") if ($mod.isInteger(JS)) {
        Result = 2}
       else Result = 3;
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
  rtl.createClass($mod,"Exception",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.fMessage = "";
    };
    this.Create$1 = function (Msg) {
      this.fMessage = Msg;
    };
    this.CreateFmt = function (Msg, Args) {
      this.Create$1($mod.Format(Msg,Args));
    };
  });
  rtl.createClass($mod,"EConvertError",$mod.Exception,function () {
  });
  this.TrimLeft = function (S) {
    return S.replace(/^[\s\uFEFF\xA0\x00-\x1f]+/,'');
  };
  this.LowerCase = function (s) {
    return s.toLowerCase();
  };
  this.CompareText = function (s1, s2) {
    var l1 = s1.toLowerCase();
    var l2 = s2.toLowerCase();
    if (l1>l2){ return 1;
    } else if (l1<l2){ return -1;
    } else { return 0; };
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
          Checkarg(2,true);
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
          Checkarg(2,true);
          if (Math.floor(Args[DoArg]) < 0) $impl.DoFormatError(3,Fmt);
          ToAdd = $mod.IntToStr(Math.floor(Args[DoArg]));
          Width = Math.abs(Width);
          Index = Prec - ToAdd.length;
          ToAdd = pas.System.StringOfChar("0",Index) + ToAdd;
        } else if ($tmp1 === "E") {
          if (Checkarg(3,false) || Checkarg(2,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),0,9999,Prec);
        } else if ($tmp1 === "F") {
          if (Checkarg(3,false) || Checkarg(2,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),0,9999,Prec);
        } else if ($tmp1 === "G") {
          if (Checkarg(3,false) || Checkarg(2,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),1,Prec,3);
        } else if ($tmp1 === "N") {
          if (Checkarg(3,false) || Checkarg(2,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),3,9999,Prec);
        } else if ($tmp1 === "M") {
          if (Checkarg(3,false) || Checkarg(2,true)) ToAdd = $mod.FloatToStrF(rtl.getNumber(Args[DoArg]),4,9999,Prec);
        } else if ($tmp1 === "S") {
          Checkarg(4,true);
          Hs = "" + Args[DoArg];
          Index = Hs.length;
          if ((Prec !== -1) && (Index > Prec)) Index = Prec;
          ToAdd = pas.System.Copy(Hs,1,Index);
        } else if ($tmp1 === "P") {
          Checkarg(2,true);
          ToAdd = $mod.IntToHex(Math.floor(Args[DoArg]),31);
        } else if ($tmp1 === "X") {
          Checkarg(2,true);
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
  this.IntToStr = function (Value) {
    var Result = "";
    Result = "" + Value;
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
  this.TFloatFormat = {"0": "ffFixed", ffFixed: 0, "1": "ffGeneral", ffGeneral: 1, "2": "ffExponent", ffExponent: 2, "3": "ffNumber", ffNumber: 3, "4": "ffCurrency", ffCurrency: 4};
  this.FloatToStr = function (Value) {
    var Result = "";
    Result = $mod.FloatToStrF(Value,1,15,0);
    return Result;
  };
  this.FloatToStrF = function (Value, format, Precision, Digits) {
    var Result = "";
    var DS = "";
    DS = $mod.DecimalSeparator;
    var $tmp1 = format;
    if ($tmp1 === 1) {
      Result = $impl.FormatGeneralFloat(Value,Precision,DS)}
     else if ($tmp1 === 2) {
      Result = $impl.FormatExponentFloat(Value,Precision,Digits,DS)}
     else if ($tmp1 === 0) {
      Result = $impl.FormatFixedFloat(Value,Digits,DS)}
     else if ($tmp1 === 3) {
      Result = $impl.FormatNumberFloat(Value,Digits,DS,$mod.ThousandSeparator)}
     else if ($tmp1 === 4) Result = $impl.FormatNumberCurrency(Value * 10000,Digits,DS,$mod.ThousandSeparator);
    if (((format !== 4) && (Result.length > 1)) && (Result.charAt(0) === "-")) $impl.RemoveLeadingNegativeSign({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},DS);
    return Result;
  };
  this.DecimalSeparator = ".";
  this.ThousandSeparator = "";
  rtl.createClass($mod,"TFormatSettings",pas.System.TObject,function () {
  });
  this.FormatSettings = null;
  this.CurrencyFormat = 0;
  this.NegCurrFormat = 0;
  this.CurrencyDecimals = 2;
  this.CurrencyString = "$";
  $mod.$init = function () {
    $mod.FormatSettings = $mod.TFormatSettings.$create("Create");
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
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
});
rtl.module("Classes",["System","RTLConsts","Types","SysUtils"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $mod.$rtti.$MethodVar("TNotifyEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]]]), methodkind: 0});
  rtl.createClass($mod,"EListError",pas.SysUtils.Exception,function () {
  });
  rtl.createClass($mod,"EComponentError",pas.SysUtils.Exception,function () {
  });
  this.TAlignment = {"0": "taLeftJustify", taLeftJustify: 0, "1": "taRightJustify", taRightJustify: 1, "2": "taCenter", taCenter: 2};
  $mod.$rtti.$Enum("TAlignment",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TAlignment});
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
    this.Get = function (Index) {
      var Result = undefined;
      if ((Index < 0) || (Index >= this.FCount)) this.RaiseIndexError(Index);
      Result = this.FList[Index];
      return Result;
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
    this.IndexOf = function (Item) {
      var Result = 0;
      var C = 0;
      Result = 0;
      C = this.FCount;
      while ((Result < C) && (this.FList[Result] != Item)) Result += 1;
      if (Result >= C) Result = -1;
      return Result;
    };
    this.Last = function () {
      var Result = undefined;
      if (this.FCount === 0) {
        Result = null}
       else Result = this.Get(this.FCount - 1);
      return Result;
    };
    this.Remove = function (Item) {
      var Result = 0;
      Result = this.IndexOf(Item);
      if (Result !== -1) this.Delete(Result);
      return Result;
    };
  });
  this.TListNotification = {"0": "lnAdded", lnAdded: 0, "1": "lnExtracted", lnExtracted: 1, "2": "lnDeleted", lnDeleted: 2};
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
    this.Get = function (Index) {
      var Result = undefined;
      Result = this.FList.Get(Index);
      return Result;
    };
    this.Notify = function (aValue, Action) {
      if (pas.System.Assigned(aValue)) ;
      if (Action === 1) ;
    };
    this.GetCount = function () {
      var Result = 0;
      Result = this.FList.FCount;
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
    this.Add = function (Item) {
      var Result = 0;
      Result = this.FList.Add(Item);
      if (pas.System.Assigned(Item)) this.Notify(Item,0);
      return Result;
    };
    this.Clear = function () {
      while (this.FList.FCount > 0) this.Delete(this.GetCount() - 1);
    };
    this.Delete = function (Index) {
      var V = undefined;
      V = this.FList.Get(Index);
      this.FList.Delete(Index);
      if (pas.System.Assigned(V)) this.Notify(V,2);
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
    this.Remove = function (Item) {
      var Result = 0;
      Result = this.IndexOf(Item);
      if (Result !== -1) this.Delete(Result);
      return Result;
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
    this.Assign = function (Source) {
      if (Source !== null) {
        Source.AssignTo(this)}
       else this.AssignError(null);
    };
  });
  this.TOperation = {"0": "opInsert", opInsert: 0, "1": "opRemove", opRemove: 1};
  this.TComponentStateItem = {"0": "csLoading", csLoading: 0, "1": "csReading", csReading: 1, "2": "csWriting", csWriting: 2, "3": "csDestroying", csDestroying: 3, "4": "csDesigning", csDesigning: 4, "5": "csAncestor", csAncestor: 5, "6": "csUpdating", csUpdating: 6, "7": "csFixups", csFixups: 7, "8": "csFreeNotification", csFreeNotification: 8, "9": "csInline", csInline: 9, "10": "csDesignInstance", csDesignInstance: 10};
  this.TComponentStyleItem = {"0": "csInheritable", csInheritable: 0, "1": "csCheckPropAvail", csCheckPropAvail: 1, "2": "csSubComponent", csSubComponent: 2, "3": "csTransient", csTransient: 3};
  rtl.createClass($mod,"TComponent",$mod.TPersistent,function () {
    this.$init = function () {
      $mod.TPersistent.$init.call(this);
      this.FOwner = null;
      this.FName = "";
      this.FTag = 0;
      this.FComponents = null;
      this.FFreeNotifies = null;
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
          this.FComponentState = rtl.excludeSet(this.FComponentState,8);
        };
      };
    };
    this.ChangeName = function (NewName) {
      this.FName = NewName;
    };
    this.Loaded = function () {
      this.FComponentState = rtl.excludeSet(this.FComponentState,0);
    };
    this.Notification = function (AComponent, Operation) {
      var C = 0;
      if (Operation === 1) this.RemoveFreeNotification(AComponent);
      if (!(this.FComponents != null)) return;
      C = this.FComponents.FCount - 1;
      while (C >= 0) {
        rtl.getObject(this.FComponents.Get(C)).Notification(AComponent,Operation);
        C -= 1;
        if (C >= this.FComponents.FCount) C = this.FComponents.FCount - 1;
      };
    };
    this.SetDesigning = function (Value, SetChildren) {
      var Runner = 0;
      if (Value) {
        this.FComponentState = rtl.includeSet(this.FComponentState,4)}
       else this.FComponentState = rtl.excludeSet(this.FComponentState,4);
      if ((this.FComponents != null) && SetChildren) for (var $l1 = 0, $end2 = this.FComponents.FCount - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        rtl.getObject(this.FComponents.Get(Runner)).SetDesigning(Value,true);
      };
    };
    this.SetName = function (NewName) {
      if (this.FName === NewName) return;
      if ((NewName !== "") && !pas.SysUtils.IsValidIdent(NewName,false,false)) throw $mod.EComponentError.$create("CreateFmt",[pas.RTLConsts.SInvalidName,[NewName]]);
      if (this.FOwner != null) {
        this.FOwner.ValidateRename(this,this.FName,NewName)}
       else this.ValidateRename(null,this.FName,NewName);
      this.ChangeName(NewName);
    };
    this.ValidateRename = function (AComponent, CurName, NewName) {
      if ((((AComponent !== null) && (pas.SysUtils.CompareText(CurName,NewName) !== 0)) && (AComponent.FOwner === this)) && (this.FindComponent(NewName) !== null)) throw $mod.EComponentError.$create("CreateFmt",[pas.RTLConsts.SDuplicateName,[NewName]]);
      if ((4 in this.FComponentState) && (this.FOwner !== null)) this.FOwner.ValidateRename(AComponent,CurName,NewName);
    };
    this.ValidateContainer = function (AComponent) {
      AComponent.ValidateInsert(this);
    };
    this.ValidateInsert = function (AComponent) {
      if (AComponent === null) ;
    };
    this.Create$1 = function (AOwner) {
      this.FComponentStyle = rtl.createSet(0);
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
          C.Notification(this,1);
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
      if (!(3 in this.FComponentState)) this.Destroying();
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
      if (3 in this.FComponentState) return;
      this.FComponentState = rtl.includeSet(this.FComponentState,3);
      if (this.FComponents != null) for (var $l1 = 0, $end2 = this.FComponents.FCount - 1; $l1 <= $end2; $l1++) {
        Runner = $l1;
        rtl.getObject(this.FComponents.Get(Runner)).Destroying();
      };
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
    this.RemoveFreeNotification = function (AComponent) {
      this.RemoveNotification(AComponent);
      AComponent.RemoveNotification(this);
    };
    this.InsertComponent = function (AComponent) {
      AComponent.ValidateContainer(this);
      this.ValidateRename(AComponent,"",AComponent.FName);
      this.Insert(AComponent);
      if (4 in this.FComponentState) AComponent.SetDesigning(true,true);
      this.Notification(AComponent,0);
    };
    this.RemoveComponent = function (AComponent) {
      this.Notification(AComponent,1);
      this.Remove(AComponent);
      AComponent.SetDesigning(false,true);
      this.ValidateRename(AComponent,AComponent.FName,"");
    };
    var $r = this.$rtti;
    $r.addProperty("Name",6,rtl.string,"FName","SetName");
    $r.addProperty("Tag",0,rtl.nativeint,"FTag","FTag");
  });
  $mod.$init = function () {
    $impl.ClassList = Object.create(null);
  };
},["JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.ClassList = null;
});
rtl.module("Web",["System","Types","JS"],function () {
  "use strict";
  var $mod = this;
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
  rtl.createClass($mod,"TCanvas",pas.Classes.TPersistent,function () {
    this.$init = function () {
      pas.Classes.TPersistent.$init.call(this);
      this.FBrush = null;
      this.FFont = null;
      this.FPen = null;
      this.FOnChange = null;
    };
    this.$final = function () {
      this.FBrush = undefined;
      this.FFont = undefined;
      this.FPen = undefined;
      this.FOnChange = undefined;
      pas.Classes.TPersistent.$final.call(this);
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
    var $r = this.$rtti;
    $r.addProperty("Brush",0,$mod.$rtti["TBrush"],"FBrush","FBrush");
    $r.addProperty("Font",0,$mod.$rtti["TFont"],"FFont","FFont");
    $r.addProperty("Pen",0,$mod.$rtti["TPen"],"FPen","FPen");
    $r.addProperty("OnChange",0,pas.Classes.$rtti["TNotifyEvent"],"FOnChange","FOnChange");
  });
  this.clBlack = 0x0;
  this.clWhite = 0xFFFFFF;
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
  this.ffMonospace = "Consolas, monaco, monospace";
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
rtl.module("Controls",["System","Classes","SysUtils","Types","JS","Web","Graphics"],function () {
  "use strict";
  var $mod = this;
  this.mrNone = 0;
  this.crDefault = 0;
  this.crNone = -1;
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
  this.crHourGlass = -11;
  this.crNoDrop = -13;
  this.crHSplit = -14;
  this.crVSplit = -15;
  this.crSQLWait = -17;
  this.crNo = -18;
  this.crAppStart = -19;
  this.crHelp = -20;
  this.crHandPoint = -21;
  $mod.$rtti.$Class("TWinControl");
  this.TAlign = {"0": "alNone", alNone: 0, "1": "alTop", alTop: 1, "2": "alBottom", alBottom: 2, "3": "alLeft", alLeft: 3, "4": "alRight", alRight: 4, "5": "alClient", alClient: 5, "6": "alCustomd", alCustomd: 6};
  $mod.$rtti.$Enum("TAlign",{minvalue: 0, maxvalue: 6, ordtype: 1, enumtype: this.TAlign});
  this.TFormBorderStyle = {"0": "bsNone", bsNone: 0, "1": "bsSingle", bsSingle: 1, "2": "bsSizeable", bsSizeable: 2, "3": "bsDialog", bsDialog: 3, "4": "bsToolWindow", bsToolWindow: 4, "5": "bsSizeToolWin", bsSizeToolWin: 5};
  $mod.$rtti.$Enum("TBorderStyle",{minvalue: 0, maxvalue: 1, ordtype: 1, enumtype: this.TFormBorderStyle});
  $mod.$rtti.$inherited("TCaption",rtl.string,{});
  $mod.$rtti.$Int("TCursor",{minvalue: -32768, maxvalue: 32767, ordtype: 2});
  rtl.createClass($mod,"TControlCanvas",pas.Graphics.TCanvas,function () {
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
          $with1.style.setProperty("font-weight",$mod.IfThen$3(0 in this.FFont.FStyle,"bold","normal"));
          $with1.style.setProperty("text-decoration",$mod.IfThen$3(2 in this.FFont.FStyle,"underline","normal"));
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
        if (this.FBorderStyle === 0) {
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
          if (((VControl != null) && (VControl.FAlign === 1)) && VControl.FVisible) {
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
          if (((VControl != null) && (VControl.FAlign === 2)) && VControl.FVisible) {
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
          if (((VControl != null) && (VControl.FAlign === 3)) && VControl.FVisible) {
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
          if (((VControl != null) && (VControl.FAlign === 4)) && VControl.FVisible) {
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
          if (((VControl != null) && (VControl.FAlign === 5)) && VControl.FVisible) {
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
    this.Create$1 = function (AOwner) {
      pas.Classes.TComponent.Create$1.call(this,AOwner);
      this.FHandleElement = this.CreateHandleElement();
      this.FHandleClass = "";
      this.FHandleId = "";
      this.RegisterHandleEvents();
      this.FControls = new Array();
      this.FBorderSpacing = $mod.TControlBorderSpacing.$create("Create$1");
      this.FBorderSpacing.FOnChange = rtl.createCallback(this,"BorderSpacingChanged");
      this.FBorderStyle = 1;
      this.FFont = pas.Graphics.TFont.$create("Create$1");
      this.FFont.FOnChange = rtl.createCallback(this,"FontChanged");
      this.FAlign = 0;
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
    this.IsUpdating = function () {
      var Result = false;
      Result = this.FUpdateCount > 0;
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
            if (0 in VShift) {
              VControl = this.FParent.FindFocusControl(this,3);
              if (!(VControl != null)) {
                VControl = this.FParent.FindFocusControl(null,1);
              };
            } else {
              VControl = this.FParent.FindFocusControl(this,2);
              if (!(VControl != null)) {
                VControl = this.FParent.FindFocusControl(null,0);
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
          if (ADirection in rtl.createSet(0)) {
            VTabOrder = VArray.length - 1;
          } else {
            VTabOrder = 0;
          };
        };
        var $tmp1 = ADirection;
        if ($tmp1 === 0) {
          VControl = rtl.getObject(VArray[0]);
          if (((((VControl != null) && $mod.TWinControl.isPrototypeOf(VControl)) && VControl.FEnabled) && VControl.FVisible) && VControl.FTabStop) {
            return VControl;
          };
        } else if ($tmp1 === 1) {
          VControl = rtl.getObject(VArray[VArray.length - 1]);
          if (((((VControl != null) && $mod.TWinControl.isPrototypeOf(VControl)) && VControl.FEnabled) && VControl.FVisible) && VControl.FTabStop) {
            return VControl;
          };
        } else if ($tmp1 === 2) {
          if (VTabOrder < (VArray.length - 1)) {
            for (var $l2 = VTabOrder + 1, $end3 = VArray.length - 1; $l2 <= $end3; $l2++) {
              VIndex = $l2;
              VControl = rtl.getObject(VArray[VIndex]);
              if (((((VControl != null) && $mod.TWinControl.isPrototypeOf(VControl)) && VControl.FEnabled) && VControl.FVisible) && VControl.FTabStop) {
                return VControl;
              };
            };
          };
        } else if ($tmp1 === 3) {
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
  });
  this.IfThen$3 = function (AExpression, AConsequence, AAlternative) {
    var Result = "";
    if (AExpression) {
      Result = AConsequence;
    } else {
      Result = AAlternative;
    };
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
      Result = rtl.unionSet(Result,rtl.createSet(1));
    };
    if (AEvent.ctrlKey) {
      Result = rtl.unionSet(Result,rtl.createSet(2));
    };
    if (AEvent.shiftKey) {
      Result = rtl.unionSet(Result,rtl.createSet(0));
    };
    return Result;
  };
  this.ExtractShiftState$1 = function (AEvent) {
    var Result = {};
    Result = {};
    if (AEvent.altKey) {
      Result = rtl.unionSet(Result,rtl.createSet(1));
    };
    if (AEvent.ctrlKey) {
      Result = rtl.unionSet(Result,rtl.createSet(2));
    };
    if (AEvent.shiftKey) {
      Result = rtl.unionSet(Result,rtl.createSet(0));
    };
    return Result;
  };
  this.ExtractMouseButton = function (AEvent) {
    var Result = 0;
    var $tmp1 = AEvent.button;
    if ($tmp1 === 1) {
      Result = 2}
     else if ($tmp1 === 2) {
      Result = 1}
     else {
      Result = 2;
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
rtl.module("Forms",["System","Classes","SysUtils","Types","JS","Web","Graphics","Controls"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.TFormType = {"0": "ftModalForm", ftModalForm: 0, "1": "ftWindow", ftWindow: 1};
  this.TCloseAction = {"0": "caNone", caNone: 0, "1": "caHide", caHide: 1, "2": "caFree", caFree: 2};
  $mod.$rtti.$Enum("TCloseAction",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TCloseAction});
  $mod.$rtti.$MethodVar("TCloseEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["CloseAction",$mod.$rtti["TCloseAction"],1]]), methodkind: 0});
  $mod.$rtti.$MethodVar("TCloseQueryEvent",{procsig: rtl.newTIProcSig([["Sender",pas.System.$rtti["TObject"]],["CanClose",rtl.boolean,1]]), methodkind: 0});
  $mod.$rtti.$Int("TModalResult",{minvalue: -2147483648, maxvalue: 2147483647, ordtype: 4});
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
      if ((this.FChildForm != null) && (this.FChildForm.FFormType === 0)) {
        this.FChildForm.Show();
      } else {
        if (this.FActiveControl != null) {
          VControl = this.FActiveControl;
        } else {
          VControl = this.FindFocusControl(null,0);
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
      this.FFormType = 1;
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
        VAction = 1;
        this.DoClose({get: function () {
            return VAction;
          }, set: function (v) {
            VAction = v;
          }});
        if (VAction !== 0) {
          if ($mod.Application().FMainForm === this) {
            $mod.Application().Terminate();
          } else {
            this.Hide();
            if (this.FFormType === 0) {
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
      if ($tmp1 === 0) {
        VWidth = this.FWidth;
        VHeight = this.FHeight;
        VLeft = Math.floor((VWindowWidth - VWidth) / 2);
        VTop = Math.floor((VWindowHeight - VHeight) / 2);
        this.SetBounds(VLeft,VTop,VWidth,VHeight);
      } else if ($tmp1 === 1) {
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
  });
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
  $impl.VAppInstance = null;
});
rtl.module("StdCtrls",["System","Classes","SysUtils","Types","Web","Graphics","Controls","Forms"],function () {
  "use strict";
  var $mod = this;
  this.TEditCharCase = {"0": "ecNormal", ecNormal: 0, "1": "ecUppercase", ecUppercase: 1, "2": "ecLowerCase", ecLowerCase: 2};
  $mod.$rtti.$Enum("TEditCharCase",{minvalue: 0, maxvalue: 2, ordtype: 1, enumtype: this.TEditCharCase});
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
    this.SetPasswordChar = function (AValue) {
      if (this.FPasswordChar !== AValue) {
        this.FPasswordChar = AValue;
        this.Changed();
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
        if ($tmp2 === 1) {
          $with1.style.setProperty("text-align","right")}
         else if ($tmp2 === 2) {
          $with1.style.setProperty("text-align","center")}
         else {
          $with1.style.removeProperty("text-align");
        };
        var $tmp3 = this.FCharCase;
        if ($tmp3 === 2) {
          $with1.style.setProperty("text-transform","lowercase")}
         else if ($tmp3 === 1) {
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
  });
  rtl.createClass($mod,"TCustomButton",pas.Controls.TWinControl,function () {
    this.$init = function () {
      pas.Controls.TWinControl.$init.call(this);
      this.FModalResult = 0;
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
        if ($tmp3 === 2) {
          VTd.style.setProperty("text-align","center")}
         else if ($tmp3 === 0) {
          VTd.style.setProperty("text-align","left")}
         else if ($tmp3 === 1) VTd.style.setProperty("text-align","right");
        var $tmp4 = this.FLayout;
        if ($tmp4 === 2) {
          VTd.style.setProperty("vertical-align","bottom")}
         else if ($tmp4 === 1) {
          VTd.style.setProperty("vertical-align","middle")}
         else if ($tmp4 === 0) VTd.style.setProperty("vertical-align","top");
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
      this.FAlignment = 0;
      this.FFocusControl = null;
      this.FLayout = 0;
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
  });
});
rtl.module("WebCtrls",["System","Classes","SysUtils","Types","Graphics","Controls","Forms","StdCtrls"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TWForm",pas.Forms.TCustomForm,function () {
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
  rtl.createClass($mod,"TWEdit",pas.StdCtrls.TCustomEdit,function () {
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
  rtl.createClass($mod,"TWButton",pas.StdCtrls.TCustomButton,function () {
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
  rtl.createClass($mod,"TWLabel",pas.StdCtrls.TCustomLabel,function () {
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
});
rtl.module("uJSChamps",["System","Classes","SysUtils","JS"],function () {
  "use strict";
  var $mod = this;
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
      var jsv = undefined;
      var os = null;
      var $in1 = this.OnSet.GetEnumerator();
      try {
        while ($in1.MoveNext()) {
          jsv = $in1.GetCurrent();
          if (!pas.System.Assigned(jsv)) continue;
          os = jsv;
          os(_propertyKey,_value);
        }
      } finally {
        $in1 = rtl.freeLoc($in1)
      };
    };
    this.Create$2 = function () {
      this.OnSet = pas.Classes.TList.$create("Create$1");
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
    this.SetChamps = function (Value) {
      if (this.FChamps != null) this.FChamps.OnSet.Remove(rtl.createCallback(this,"Champs_OnSet"));
      this.FChamps = null;
      this.SetText("");
      this.FChamps = Value;
      if (!this.Champ_OK()) return;
      this.FChamps.OnSet.Add(rtl.createCallback(this,"Champs_OnSet"));
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
      if (this.FField !== _propertyKey.toString()) return;
      this._from_Champs_interne(_value);
    };
    this._from_Champs_interne = function (_Value) {
      if (this.Champs_Changing) return;
      try {
        this.Champs_Changing = true;
        this.SetText("" + _Value);
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
    var $r = this.$rtti;
    $r.addProperty("Field",0,rtl.string,"FField","FField");
  });
});
rtl.module("ufAutre_Form",["System","JS","Classes","SysUtils","Graphics","Controls","Forms","WebCtrls"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TfAutre_Form",pas.WebCtrls.TWForm,function () {
    this.$init = function () {
      pas.WebCtrls.TWForm.$init.call(this);
      this.bfTest = null;
      this.WLabel1 = null;
    };
    this.$final = function () {
      this.bfTest = undefined;
      this.WLabel1 = undefined;
      pas.WebCtrls.TWForm.$final.call(this);
    };
    this.bfTestClick = function (Sender) {
      pas.ufTest.fTest.Show();
    };
    this.Loaded = function () {
      pas.Forms.TCustomForm.Loaded.call(this);
      this.BeginUpdate();
      try {
        this.SetLeft(878);
        this.SetHeight(240);
        this.SetTop(1048);
        this.SetWidth(320);
        this.SetAlphaBlend(false);
        this.SetAlphaBlendValue(255);
        this.SetText("fAutre_Form");
        this.SetClientHeight(240);
        this.SetClientWidth(320);
        this.WLabel1 = pas.WebCtrls.TWLabel.$create("Create$1",[this]);
        this.WLabel1.BeginUpdate();
        try {
          this.WLabel1.SetParent(this);
          this.WLabel1.SetLeft(30);
          this.WLabel1.SetHeight(17);
          this.WLabel1.SetTop(24);
          this.WLabel1.SetWidth(65);
          this.WLabel1.SetAutoSize(false);
          this.WLabel1.SetText("Truc");
          this.WLabel1.SetParentColor(false);
        } finally {
          this.WLabel1.EndUpdate();
        };
        this.bfTest = pas.WebCtrls.TWButton.$create("Create$1",[this]);
        this.bfTest.BeginUpdate();
        try {
          this.bfTest.SetParent(this);
          this.bfTest.SetLeft(39);
          this.bfTest.SetHeight(25);
          this.bfTest.SetTop(81);
          this.bfTest.SetWidth(211);
          this.bfTest.SetText("bfTest");
          this.bfTest.SetTabOrder(0);
          this.bfTest.FOnClick = rtl.createCallback(this,"bfTestClick");
        } finally {
          this.bfTest.EndUpdate();
        };
      } finally {
        this.EndUpdate();
      };
    };
  });
  this.fAutre_Form = null;
},["ufTest"]);
rtl.module("ufTest",["System","JS","Classes","SysUtils","Graphics","Controls","Forms","WebCtrls","StdCtrls","uJSChamps","ucWChamp_Edit"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TfTest",pas.WebCtrls.TWForm,function () {
    this.$init = function () {
      pas.WebCtrls.TWForm.$init.call(this);
      this.b = null;
      this.bAffiche_proxy = null;
      this.l = null;
      this.lAffiche_proxy = null;
      this.lProxy = null;
      this.bProxy = null;
      this.lCallBack = null;
      this.bAffiche_target = null;
      this.lAffiche_Target = null;
      this.bAutre_Form = null;
      this.wce = null;
      this.wce1 = null;
      this.WEdit1 = null;
      this.tric = null;
    };
    this.$final = function () {
      this.b = undefined;
      this.bAffiche_proxy = undefined;
      this.l = undefined;
      this.lAffiche_proxy = undefined;
      this.lProxy = undefined;
      this.bProxy = undefined;
      this.lCallBack = undefined;
      this.bAffiche_target = undefined;
      this.lAffiche_Target = undefined;
      this.bAutre_Form = undefined;
      this.wce = undefined;
      this.wce1 = undefined;
      this.WEdit1 = undefined;
      this.tric = undefined;
      pas.WebCtrls.TWForm.$final.call(this);
    };
    this.bAffiche_proxyClick = function (Sender) {
      this.lAffiche_proxy.SetText(pas.JS.ToString(this.tric.proxy["a"]));
    };
    this.bAffiche_targetClick = function (Sender) {
      this.lAffiche_Target.SetText(pas.JS.ToString(this.tric["a"]));
    };
    this.bAutre_FormClick = function (Sender) {
      pas.ufAutre_Form.fAutre_Form.Show();
    };
    this.bClick = function (Sender) {
      if ("Truc" === this.l.GetText()) {
        this.l.SetText("Troc")}
       else this.l.SetText("Truc");
    };
    this.bProxyClick = function (Sender) {
      var jsv = undefined;
      this.tric.proxy["a"] = "affecté par proxy";
      jsv = this.tric["a"];
      this.lProxy.SetText(pas.JS.ToString(jsv));
      this.tric["a"] = "affecté par target";
    };
    this.Loaded = function () {
      pas.Forms.TCustomForm.Loaded.call(this);
      this.BeginUpdate();
      try {
        this.SetLeft(885);
        this.SetHeight(490);
        this.SetTop(1105);
        this.SetWidth(793);
        this.SetAlphaBlend(false);
        this.SetAlphaBlendValue(255);
        this.SetText("fTest");
        this.SetClientHeight(490);
        this.SetClientWidth(793);
        this.b = pas.WebCtrls.TWButton.$create("Create$1",[this]);
        this.b.BeginUpdate();
        try {
          this.b.SetParent(this);
          this.b.SetLeft(8);
          this.b.SetHeight(25);
          this.b.SetTop(16);
          this.b.SetWidth(91);
          this.b.SetText("b");
          this.b.SetTabOrder(0);
          this.b.FOnClick = rtl.createCallback(this,"bClick");
        } finally {
          this.b.EndUpdate();
        };
        this.l = pas.WebCtrls.TWLabel.$create("Create$1",[this]);
        this.l.BeginUpdate();
        try {
          this.l.SetParent(this);
          this.l.SetLeft(104);
          this.l.SetHeight(21);
          this.l.SetTop(20);
          this.l.SetWidth(680);
          this.l.SetAutoSize(false);
          this.l.SetText("l");
          this.l.SetParentColor(false);
        } finally {
          this.l.EndUpdate();
        };
        this.lProxy = pas.WebCtrls.TWLabel.$create("Create$1",[this]);
        this.lProxy.BeginUpdate();
        try {
          this.lProxy.SetParent(this);
          this.lProxy.SetLeft(104);
          this.lProxy.SetHeight(21);
          this.lProxy.SetTop(56);
          this.lProxy.SetWidth(684);
          this.lProxy.SetAutoSize(false);
          this.lProxy.SetText("lProxy");
          this.lProxy.SetParentColor(false);
        } finally {
          this.lProxy.EndUpdate();
        };
        this.bProxy = pas.WebCtrls.TWButton.$create("Create$1",[this]);
        this.bProxy.BeginUpdate();
        try {
          this.bProxy.SetParent(this);
          this.bProxy.SetLeft(8);
          this.bProxy.SetHeight(25);
          this.bProxy.SetTop(48);
          this.bProxy.SetWidth(91);
          this.bProxy.SetText("bProxy");
          this.bProxy.SetTabOrder(1);
          this.bProxy.FOnClick = rtl.createCallback(this,"bProxyClick");
        } finally {
          this.bProxy.EndUpdate();
        };
        this.lCallBack = pas.WebCtrls.TWLabel.$create("Create$1",[this]);
        this.lCallBack.BeginUpdate();
        try {
          this.lCallBack.SetParent(this);
          this.lCallBack.SetLeft(8);
          this.lCallBack.SetHeight(21);
          this.lCallBack.SetTop(83);
          this.lCallBack.SetWidth(752);
          this.lCallBack.SetAutoSize(false);
          this.lCallBack.SetText("lCallBack");
          this.lCallBack.SetParentColor(false);
        } finally {
          this.lCallBack.EndUpdate();
        };
        this.bAffiche_target = pas.WebCtrls.TWButton.$create("Create$1",[this]);
        this.bAffiche_target.BeginUpdate();
        try {
          this.bAffiche_target.SetParent(this);
          this.bAffiche_target.SetLeft(8);
          this.bAffiche_target.SetHeight(25);
          this.bAffiche_target.SetTop(112);
          this.bAffiche_target.SetWidth(224);
          this.bAffiche_target.SetText("bAffiche_target");
          this.bAffiche_target.SetTabOrder(2);
          this.bAffiche_target.FOnClick = rtl.createCallback(this,"bAffiche_targetClick");
        } finally {
          this.bAffiche_target.EndUpdate();
        };
        this.lAffiche_Target = pas.WebCtrls.TWLabel.$create("Create$1",[this]);
        this.lAffiche_Target.BeginUpdate();
        try {
          this.lAffiche_Target.SetParent(this);
          this.lAffiche_Target.SetLeft(240);
          this.lAffiche_Target.SetHeight(17);
          this.lAffiche_Target.SetTop(119);
          this.lAffiche_Target.SetWidth(546);
          this.lAffiche_Target.SetAutoSize(false);
          this.lAffiche_Target.SetText("lAffiche_Target");
          this.lAffiche_Target.SetParentColor(false);
        } finally {
          this.lAffiche_Target.EndUpdate();
        };
        this.lAffiche_proxy = pas.WebCtrls.TWLabel.$create("Create$1",[this]);
        this.lAffiche_proxy.BeginUpdate();
        try {
          this.lAffiche_proxy.SetParent(this);
          this.lAffiche_proxy.SetLeft(240);
          this.lAffiche_proxy.SetHeight(17);
          this.lAffiche_proxy.SetTop(150);
          this.lAffiche_proxy.SetWidth(546);
          this.lAffiche_proxy.SetAutoSize(false);
          this.lAffiche_proxy.SetText("lAffiche_proxy");
          this.lAffiche_proxy.SetParentColor(false);
        } finally {
          this.lAffiche_proxy.EndUpdate();
        };
        this.bAffiche_proxy = pas.WebCtrls.TWButton.$create("Create$1",[this]);
        this.bAffiche_proxy.BeginUpdate();
        try {
          this.bAffiche_proxy.SetParent(this);
          this.bAffiche_proxy.SetLeft(8);
          this.bAffiche_proxy.SetHeight(25);
          this.bAffiche_proxy.SetTop(150);
          this.bAffiche_proxy.SetWidth(224);
          this.bAffiche_proxy.SetText("bAffiche_proxy");
          this.bAffiche_proxy.SetTabOrder(3);
          this.bAffiche_proxy.FOnClick = rtl.createCallback(this,"bAffiche_proxyClick");
        } finally {
          this.bAffiche_proxy.EndUpdate();
        };
        this.wce = pas.ucWChamp_Edit.TWChamp_Edit.$create("Create$1",[this]);
        this.wce.BeginUpdate();
        try {
          this.wce.SetParent(this);
          this.wce.SetLeft(8);
          this.wce.SetHeight(38);
          this.wce.SetTop(184);
          this.wce.SetWidth(760);
          this.wce.SetTabOrder(4);
          this.wce.SetText("wce");
          this.wce.FField = "a";
        } finally {
          this.wce.EndUpdate();
        };
        this.wce1 = pas.ucWChamp_Edit.TWChamp_Edit.$create("Create$1",[this]);
        this.wce1.BeginUpdate();
        try {
          this.wce1.SetParent(this);
          this.wce1.SetLeft(8);
          this.wce1.SetHeight(38);
          this.wce1.SetTop(232);
          this.wce1.SetWidth(760);
          this.wce1.SetTabOrder(5);
          this.wce1.SetText("wce1");
          this.wce1.FField = "a";
        } finally {
          this.wce1.EndUpdate();
        };
        this.WEdit1 = pas.WebCtrls.TWEdit.$create("Create$1",[this]);
        this.WEdit1.BeginUpdate();
        try {
          this.WEdit1.SetParent(this);
          this.WEdit1.SetLeft(32);
          this.WEdit1.SetHeight(38);
          this.WEdit1.SetTop(283);
          this.WEdit1.SetWidth(80);
          this.WEdit1.SetTabOrder(6);
          this.WEdit1.SetText("WEdit1");
        } finally {
          this.WEdit1.EndUpdate();
        };
        this.bAutre_Form = pas.WebCtrls.TWButton.$create("Create$1",[this]);
        this.bAutre_Form.BeginUpdate();
        try {
          this.bAutre_Form.SetParent(this);
          this.bAutre_Form.SetLeft(31);
          this.bAutre_Form.SetHeight(25);
          this.bAutre_Form.SetTop(340);
          this.bAutre_Form.SetWidth(187);
          this.bAutre_Form.SetText("bAutre_Form");
          this.bAutre_Form.SetTabOrder(7);
          this.bAutre_Form.FOnClick = rtl.createCallback(this,"bAutre_FormClick");
        } finally {
          this.bAutre_Form.EndUpdate();
        };
      } finally {
        this.EndUpdate();
      };
      this.tric = pas.uJSChamps.TJSChamps.$create("Create$2");
      this.tric["a"] = "affecté par TfTest.Loaded;";
      this.tric.OnSet.Add(rtl.createCallback(this,"proxy_OnSet"));
      this.wce.SetChamps(this.tric);
      this.wce1.SetChamps(this.tric);
    };
    this.proxy_OnSet = function (_propertyKey, _value) {
      this.lCallBack.SetText((("Callback: " + JSON.stringify(_propertyKey)) + "=") + JSON.stringify(_value));
    };
  });
  this.fTest = null;
},["ufAutre_Form"]);
rtl.module("program",["System","Forms","ufTest","uJSChamps","ufAutre_Form"],function () {
  "use strict";
  var $mod = this;
  $mod.$main = function () {
    pas.Forms.Application().Initialize();
    pas.Forms.Application().CreateForm(pas.ufTest.TfTest,{p: pas.ufTest, get: function () {
        return this.p.fTest;
      }, set: function (v) {
        this.p.fTest = v;
      }});
    pas.Forms.Application().CreateForm(pas.ufAutre_Form.TfAutre_Form,{p: pas.ufAutre_Form, get: function () {
        return this.p.fAutre_Form;
      }, set: function (v) {
        this.p.fAutre_Form = v;
      }});
    pas.Forms.Application().Run();
  };
});
//# sourceMappingURL=test.js.map
