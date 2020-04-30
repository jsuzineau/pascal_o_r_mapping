var pas = {};

var rtl = {

  version: 10420,

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

  hiInt: Math.pow(2,53),

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

  isTRecord: function(type){
    return (rtl.isObject(type) && type.hasOwnProperty('$new') && (typeof(type.$new)==='function'));
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
        var errMsg = rtl.hasString(re.$classname) ? re.$classname : '';
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

  initStruct: function(c,parent,name){
    if ((parent.$module) && (parent.$module.$impl===parent)) parent=parent.$module;
    c.$parent = parent;
    if (rtl.isModule(parent)){
      c.$module = parent;
      c.$name = name;
    } else {
      c.$module = parent.$module;
      c.$name = parent.$name+'.'+name;
    };
    return parent;
  },

  initClass: function(c,parent,name,initfn){
    parent[name] = c;
    c.$class = c; // Note: o.$class === Object.getPrototypeOf(o)
    c.$classname = name;
    parent = rtl.initStruct(c,parent,name);
    c.$fullname = parent.$name+'.'+name;
    // rtti
    if (rtl.debug_rtti) rtl.debug('initClass '+c.$fullname);
    var t = c.$module.$rtti.$Class(c.$name,{ "class": c });
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
      c.$create = function(fn,args){
        if (args == undefined) args = [];
        var o = Object.create(this);
        o.$init();
        try{
          if (typeof(fn)==="string"){
            o[fn].apply(o,args);
          } else {
            fn.apply(o,args);
          };
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
    var c = Object.create(ancestor);
    c.$create = function(fn,args){
      if (args == undefined) args = [];
      var o = null;
      if (newinstancefnname.length>0){
        o = this[newinstancefnname](fn,args);
      } else {
        o = Object.create(this);
      }
      if (o.$init) o.$init();
      try{
        if (typeof(fn)==="string"){
          o[fn].apply(o,args);
        } else {
          fn.apply(o,args);
        };
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

  createHelper: function(parent,name,ancestor,initfn){
    // create a helper,
    // ancestor must be null or a helper,
    var c = null;
    if (ancestor != null){
      c = Object.create(ancestor);
      c.$ancestor = ancestor;
      // c.$ancestor === Object.getPrototypeOf(c)
    } else {
      c = {};
    };
    parent[name] = c;
    c.$class = c; // Note: o.$class === Object.getPrototypeOf(o)
    c.$classname = name;
    parent = rtl.initStruct(c,parent,name);
    c.$fullname = parent.$name+'.'+name;
    // rtti
    var t = c.$module.$rtti.$Helper(c.$name,{ "helper": c });
    c.$rtti = t;
    if (rtl.isObject(ancestor)) t.ancestor = ancestor.$rtti;
    if (!t.ancestor) t.ancestor = null;
    // init members
    initfn.call(c);
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

  recNewT: function(parent,name,initfn,full){
    // create new record type
    var t = {};
    if (parent) parent[name] = t;
    function hide(prop){
      Object.defineProperty(t,prop,{enumerable:false});
    }
    if (full){
      rtl.initStruct(t,parent,name);
      t.$record = t;
      hide('$record');
      hide('$name');
      hide('$parent');
      hide('$module');
    }
    initfn.call(t);
    if (!t.$new){
      t.$new = function(){ return Object.create(this); };
    }
    t.$clone = function(r){ return this.$new().$assign(r); };
    hide('$new');
    hide('$clone');
    hide('$eq');
    hide('$assign');
    return t;
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
  EPropWriteOnly: null,

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
    var g = rtl.strToGUIDR(guid,TGuid.$new());
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
    var i = rtl.getIntfG(obj,intftype.$guid);
    if (!i) return false;
    if (i.$kind === 'com') i._Release();
    return true;
  },

  asIntfT: function (obj,intftype){
    var i = rtl.getIntfG(obj,intftype.$guid);
    if (i!==null) return i;
    rtl.raiseEInvalidCast();
  },

  intfIsIntfT: function(intf,intftype){
    return (intf!==null) && rtl.queryIntfIsT(intf.$o,intftype);
  },

  intfAsIntfT: function (intf,intftype){
    if (intf){
      var i = rtl.getIntfG(intf.$o,intftype.$guid);
      if (i!==null) return i;
    }
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
    var stack = [];
    for (var i=2; i<arguments.length; i++){
      stack.push({ dim:arguments[i]+0, a:null, i:0, src:null });
    }
    var dimmax = stack.length-1;
    var depth = 0;
    var lastlen = stack[dimmax].dim;
    var item = null;
    var a = null;
    var src = arr;
    var oldlen = 0
    do{
      a = [];
      if (depth>0){
        item=stack[depth-1];
        item.a[item.i]=a;
        src = (item.src && item.src.length>item.i)?item.src[item.i]:null;
        item.i++;
      }
      if (depth<dimmax){
        item = stack[depth];
        item.a = a;
        item.i = 0;
        item.src = src;
        depth++;
      } else {
        oldlen = src?src.length:0;
        if (rtl.isArray(defaultvalue)){
          for (var i=0; i<lastlen; i++) a[i]=(i<oldlen)?src[i]:[]; // array of dyn array
        } else if (rtl.isObject(defaultvalue)) {
          if (rtl.isTRecord(defaultvalue)){
            for (var i=0; i<lastlen; i++){
              a[i]=(i<oldlen)?defaultvalue.$clone(src[i]):defaultvalue.$new(); // e.g. record
            }
          } else {
            for (var i=0; i<lastlen; i++) a[i]=(i<oldlen)?rtl.refSet(src[i]):{}; // e.g. set
          }
        } else {
          for (var i=0; i<lastlen; i++)
            a[i]=(i<oldlen)?src[i]:defaultvalue;
        }
        while ((depth>0) && (stack[depth-1].i>=stack[depth-1].dim)){
          depth--;
        };
        if (depth===0){
          if (dimmax===0) return a;
          return stack[0].a;
        }
      }
    }while (true);
  },

  /*arrayChgLength: function(arr,defaultvalue,newlength){
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
          } else if (rtl.isObject(defaultvalue)) {
            if (rtl.isTRecord(defaultvalue)){
              for (var i=oldlen; i<newlen; i++) a[i]=defaultvalue.$new(); // e.g. record
            } else {
              for (var i=oldlen; i<newlen; i++) a[i]={}; // e.g. set
            }
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
  },*/

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
    if(type === 'refSet') {
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = rtl.refSet(src[srcpos]); // ref set
    } else if (rtl.isTRecord(type)){
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = type.$clone(src[srcpos]); // clone record
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

  floatToStr: function(d,w,p){
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

  valEnum: function(s, enumType, setCodeFn){
    s = s.toLowerCase();
    for (var key in enumType){
      if((typeof(key)==='string') && (key.toLowerCase()===s)){
        setCodeFn(0);
        return enumType[key];
      }
    }
    setCodeFn(1);
    return 0;
  },

  lw: function(l){
    // fix longword bitwise operation
    return l<0?l+0x100000000:l;
  },

  and: function(a,b){
    var hi = 0x80000000;
    var low = 0x7fffffff;
    var h = (a / hi) & (b / hi);
    var l = (a & low) & (b & low);
    return h*hi + l;
  },

  or: function(a,b){
    var hi = 0x80000000;
    var low = 0x7fffffff;
    var h = (a / hi) | (b / hi);
    var l = (a & low) | (b & low);
    return h*hi + l;
  },

  xor: function(a,b){
    var hi = 0x80000000;
    var low = 0x7fffffff;
    var h = (a / hi) ^ (b / hi);
    var l = (a & low) ^ (b & low);
    return h*hi + l;
  },

  shr: function(a,b){
    if (a<0) a += rtl.hiInt;
    if (a<0x80000000) return a >> b;
    if (b<=0) return a;
    if (b>54) return 0;
    return Math.floor(a / Math.pow(2,b));
  },

  shl: function(a,b){
    if (a<0) a += rtl.hiInt;
    if (b<=0) return a;
    if (b>54) return 0;
    var r = a * Math.pow(2,b);
    if (r <= rtl.hiInt) return r;
    return r % rtl.hiInt;
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
    newBaseTI("tTypeInfoInterface",18 /* tkInterface */,rtl.tTypeInfoStruct);
    newBaseTI("tTypeInfoHelper",19 /* tkHelper */,rtl.tTypeInfoStruct);
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
    $Interface: function(name,o){ return this.$Scope(name,rtl.tTypeInfoInterface,o); },
    $Helper: function(name,o){ return this.$Scope(name,rtl.tTypeInfoHelper,o); }
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
  this.MaxLongint = 0x7fffffff;
  this.Maxint = 2147483647;
  rtl.createClass($mod,"TObject",null,function () {
    this.$init = function () {
    };
    this.$final = function () {
    };
    this.Create = function () {
      return this;
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
    if ((Index < 1) || (Index > S.get().length) || (Size <= 0)) return;
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
     else Target.set($mod.Copy(t,1,Index - 1) + Insertion + $mod.Copy(t,Index,t.length));
  };
  this.upcase = function (c) {
    return c.toUpperCase();
  };
  this.val = function (S, NI, Code) {
    NI.set($impl.valint(S,-4503599627370496,4503599627370495,Code));
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
  $mod.$init = function () {
    rtl.exitcode = 0;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.valint = function (S, MinVal, MaxVal, Code) {
    var Result = 0;
    var x = 0.0;
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
        return Result;
      };
    };
    if (isNaN(x) || (x !== $mod.Int(x))) {
      Code.set(1)}
     else if ((x < MinVal) || (x > MaxVal)) {
      Code.set(2)}
     else {
      Result = $mod.Trunc(x);
      Code.set(0);
    };
    return Result;
  };
});
rtl.module("Types",["System"],function () {
  "use strict";
  var $mod = this;
  this.TDuplicates = {"0": "dupIgnore", dupIgnore: 0, "1": "dupAccept", dupAccept: 1, "2": "dupError", dupError: 2};
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
rtl.module("RTLConsts",["System"],function () {
  "use strict";
  var $mod = this;
  this.SArgumentMissing = 'Missing argument in format "%s"';
  this.SInvalidFormat = 'Invalid format specifier : "%s"';
  this.SInvalidArgIndex = 'Invalid argument index in format: "%s"';
  this.SListCapacityError = "List capacity (%s) exceeded.";
  this.SListIndexError = "List index (%s) out of bounds";
  this.SDuplicateString = "String list does not allow duplicates";
  this.SErrFindNeedsSortedList = "Cannot use find on unsorted list";
});
rtl.module("SysUtils",["System","RTLConsts","JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  rtl.createClass($mod,"Exception",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.fMessage = "";
    };
    this.Create$1 = function (Msg) {
      this.fMessage = Msg;
      return this;
    };
    this.CreateFmt = function (Msg, Args) {
      this.Create$1($mod.Format(Msg,Args));
      return this;
    };
  });
  rtl.createClass($mod,"EConvertError",$mod.Exception,function () {
  });
  this.TrimLeft = function (S) {
    return S.replace(/^[\s\uFEFF\xA0\x00-\x1f]+/,'');
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
        while ((ChPos <= Len) && (Fmt.charAt(ChPos - 1) <= "9") && (Fmt.charAt(ChPos - 1) >= "0")) ChPos += 1;
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
            while ((rtl.shl(1,Index * 4) <= vq) && (Index < 16)) Index += 1;
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
  this.TStringReplaceFlag = {"0": "rfReplaceAll", rfReplaceAll: 0, "1": "rfIgnoreCase", rfIgnoreCase: 1};
  this.StringReplace = function (aOriginal, aSearch, aReplace, Flags) {
    var Result = "";
    var REFlags = "";
    var REString = "";
    REFlags = "";
    if (0 in Flags) REFlags = "g";
    if (1 in Flags) REFlags = REFlags + "i";
    REString = aSearch.replace(new RegExp($impl.RESpecials,"g"),"\\$1");
    Result = aOriginal.replace(new RegExp(REString,REFlags),aReplace);
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
  var HexDigits = "0123456789ABCDEF";
  this.IntToHex = function (Value, Digits) {
    var Result = "";
    if (Digits === 0) Digits = 1;
    Result = "";
    while (Value > 0) {
      Result = HexDigits.charAt(((Value & 15) + 1) - 1) + Result;
      Value = Math.floor(Value / 16);
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
    if ((format !== 4) && (Result.length > 1) && (Result.charAt(0) === "-")) $impl.RemoveLeadingNegativeSign({get: function () {
        return Result;
      }, set: function (v) {
        Result = v;
      }},DS);
    return Result;
  };
  this.TryStrToFloat$1 = function (S, res) {
    var Result = false;
    var J = undefined;
    var N = "";
    N = S;
    if ($mod.ThousandSeparator !== "") N = $mod.StringReplace(N,$mod.ThousandSeparator,"",rtl.createSet(0));
    if ($mod.DecimalSeparator !== ".") N = $mod.StringReplace(N,$mod.DecimalSeparator,".",{});
    J = parseFloat(N);
    Result = !isNaN(J);
    if (Result) res.set(rtl.getNumber(J));
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
      Result = pas.System.Copy(S,1,P - 1) + DS + pas.System.Copy(S,P + 1,S.length - P)}
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
        while ((Result.charAt(P - 1) === "0") && (P < Result.length) && (pas.System.Copy(Result,P + 1,DS.length) !== DS)) pas.System.Delete({get: function () {
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
        Result = rtl.setCharAt(Result,P - Exponent - 1,Result.charAt(P - Exponent - 1 - 1));
        Result = rtl.setCharAt(Result,P - 1,".");
        if (Exponent !== -1) Result = rtl.setCharAt(Result,P - Exponent - 1 - 1,"0");
      };
      Q = Result.length;
      while ((Q > 0) && (Result.charAt(Q - 1) === "0")) Q -= 1;
      if (Result.charAt(Q - 1) === ".") Q -= 1;
      if ((Q === 0) || ((Q === 1) && (Result.charAt(0) === "-"))) {
        Result = "0"}
       else Result = rtl.strSetLength(Result,Q);
    } else {
      while (Result.charAt(PE - 1 - 1) === "0") {
        pas.System.Delete({get: function () {
            return Result;
          }, set: function (v) {
            Result = v;
          }},PE - 1,1);
        PE -= 1;
      };
      if (Result.charAt(PE - 1 - 1) === DS) {
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
    Digits = (Result.length - P - Digits) + 1;
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
      if (Result.charAt(P - 1 - 1) !== "-") pas.System.Insert(TS,{get: function () {
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
        Result = $mod.CurrencyString + " " + Result}
       else if ($tmp1 === 3) Result = Result + " " + $mod.CurrencyString;
    } else {
      var $tmp2 = $mod.NegCurrFormat;
      if ($tmp2 === 0) {
        Result = "(" + $mod.CurrencyString + Result + ")"}
       else if ($tmp2 === 1) {
        Result = "-" + $mod.CurrencyString + Result}
       else if ($tmp2 === 2) {
        Result = $mod.CurrencyString + "-" + Result}
       else if ($tmp2 === 3) {
        Result = $mod.CurrencyString + Result + "-"}
       else if ($tmp2 === 4) {
        Result = "(" + Result + $mod.CurrencyString + ")"}
       else if ($tmp2 === 5) {
        Result = "-" + Result + $mod.CurrencyString}
       else if ($tmp2 === 6) {
        Result = Result + "-" + $mod.CurrencyString}
       else if ($tmp2 === 7) {
        Result = Result + $mod.CurrencyString + "-"}
       else if ($tmp2 === 8) {
        Result = "-" + Result + " " + $mod.CurrencyString}
       else if ($tmp2 === 9) {
        Result = "-" + $mod.CurrencyString + " " + Result}
       else if ($tmp2 === 10) {
        Result = Result + " " + $mod.CurrencyString + "-"}
       else if ($tmp2 === 11) {
        Result = $mod.CurrencyString + " " + Result + "-"}
       else if ($tmp2 === 12) {
        Result = $mod.CurrencyString + " " + "-" + Result}
       else if ($tmp2 === 13) {
        Result = Result + "-" + " " + $mod.CurrencyString}
       else if ($tmp2 === 14) {
        Result = "(" + $mod.CurrencyString + " " + Result + ")"}
       else if ($tmp2 === 15) Result = "(" + Result + " " + $mod.CurrencyString + ")";
    };
    return Result;
  };
  $impl.RESpecials = "([\\+\\[\\]\\(\\)\\\\\\.\\*])";
});
rtl.module("Classes",["System","RTLConsts","Types","SysUtils"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  rtl.createClass($mod,"EListError",pas.SysUtils.Exception,function () {
  });
  rtl.createClass($mod,"EStringListError",$mod.EListError,function () {
  });
  rtl.createClass($mod,"TPersistent",pas.System.TObject,function () {
  });
  rtl.createClass($mod,"TStrings",$mod.TPersistent,function () {
    this.$init = function () {
      $mod.TPersistent.$init.call(this);
      this.FAlwaysQuote = false;
      this.FUpdateCount = 0;
    };
    this.Error = function (Msg, Data) {
      throw $mod.EStringListError.$create("CreateFmt",[Msg,[pas.SysUtils.IntToStr(Data)]]);
    };
    this.GetCapacity = function () {
      var Result = 0;
      Result = this.GetCount();
      return Result;
    };
    this.DoCompareText = function (s1, s2) {
      var Result = 0;
      Result = pas.SysUtils.CompareText(s1,s2);
      return Result;
    };
    this.Create$1 = function () {
      pas.System.TObject.Create.call(this);
      this.FAlwaysQuote = false;
      return this;
    };
    this.IndexOf = function (S) {
      var Result = 0;
      Result = 0;
      while ((Result < this.GetCount()) && (this.DoCompareText(this.Get(Result),S) !== 0)) Result = Result + 1;
      if (Result === this.GetCount()) Result = -1;
      return Result;
    };
  });
  rtl.recNewT($mod,"TStringItem",function () {
    this.FString = "";
    this.FObject = null;
    this.$eq = function (b) {
      return (this.FString === b.FString) && (this.FObject === b.FObject);
    };
    this.$assign = function (s) {
      this.FString = s.FString;
      this.FObject = s.FObject;
      return this;
    };
  });
  this.TStringsSortStyle = {"0": "sslNone", sslNone: 0, "1": "sslUser", sslUser: 1, "2": "sslAuto", sslAuto: 2};
  rtl.createClass($mod,"TStringList",$mod.TStrings,function () {
    this.$init = function () {
      $mod.TStrings.$init.call(this);
      this.FList = [];
      this.FCount = 0;
      this.FOnChange = null;
      this.FOnChanging = null;
      this.FDuplicates = 0;
      this.FCaseSensitive = false;
      this.FSortStyle = 0;
    };
    this.$final = function () {
      this.FList = undefined;
      this.FOnChange = undefined;
      this.FOnChanging = undefined;
      $mod.TStrings.$final.call(this);
    };
    this.GetSorted = function () {
      var Result = false;
      Result = this.FSortStyle in rtl.createSet(1,2);
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
    this.CheckIndex = function (AIndex) {
      if ((AIndex < 0) || (AIndex >= this.FCount)) this.Error(pas.RTLConsts.SListIndexError,AIndex);
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
    this.SetCapacity = function (NewCapacity) {
      if (NewCapacity < 0) this.Error(pas.RTLConsts.SListCapacityError,NewCapacity);
      if (NewCapacity !== this.GetCapacity()) this.FList = rtl.arraySetLength(this.FList,$mod.TStringItem,NewCapacity);
    };
    this.InsertItem = function (Index, S) {
      this.InsertItem$1(Index,S,null);
    };
    this.InsertItem$1 = function (Index, S, O) {
      var It = $mod.TStringItem.$new();
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
    this.Add = function (S) {
      var Result = 0;
      if (!(this.FSortStyle === 2)) {
        Result = this.FCount}
       else if (this.Find(S,{get: function () {
          return Result;
        }, set: function (v) {
          Result = v;
        }})) {
        var $tmp1 = this.FDuplicates;
        if ($tmp1 === 0) {
          return Result}
         else if ($tmp1 === 2) this.Error(pas.RTLConsts.SDuplicateString,0);
      };
      this.InsertItem(Result,S);
      return Result;
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
            if (this.FDuplicates !== 1) L = I;
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
rtl.module("Math",["System","SysUtils"],function () {
  "use strict";
  var $mod = this;
  this.IfThen = function (val, ifTrue, ifFalse) {
    var Result = 0;
    if (val) {
      Result = ifTrue}
     else Result = ifFalse;
    return Result;
  };
});
rtl.module("uFrequence",["System","Classes","SysUtils","Math","Types"],function () {
  "use strict";
  var $mod = this;
  this.sFrequence = function (_Frequence, _digits, _Separateur) {
    var Result = "";
    function s_from_d(_d) {
      var Result = "";
      var Nb_Chiffres_partie_entiere = 0;
      var Decimals = 0;
      Nb_Chiffres_partie_entiere = pas.System.Trunc(Math.log10(_d)) + 1;
      Decimals = _digits - 1 - Nb_Chiffres_partie_entiere;
      if (Decimals < 0) Decimals = 0;
      Result = rtl.floatToStr(_d,_digits,Decimals);
      return Result;
    };
    function Hz() {
      Result = s_from_d(_Frequence) + _Separateur + "Hz";
    };
    function KHz() {
      Result = s_from_d(_Frequence / 1E3) + _Separateur + "KHz";
    };
    function MHz() {
      Result = s_from_d(_Frequence / 1E6) + _Separateur + "MHz";
    };
    function GHz() {
      Result = s_from_d(_Frequence / 1E9) + _Separateur + "GHz";
    };
    function THz() {
      Result = s_from_d(_Frequence / 1E12) + _Separateur + "THz";
    };
    if (_Frequence < 1E3) {
      Hz()}
     else if (_Frequence < 1E6) {
      KHz()}
     else if (_Frequence < 1E9) {
      MHz()}
     else if (_Frequence < 1E12) {
      GHz()}
     else THz();
    return Result;
  };
  this.uFrequence_Separateur_Lignes = "\r\n";
  this.Note_Latine = function (_Index) {
    var Result = "";
    var $tmp1 = _Index % 12;
    if ($tmp1 === 0) {
      Result = "do  "}
     else if ($tmp1 === 1) {
      Result = "do# "}
     else if ($tmp1 === 2) {
      Result = "ré  "}
     else if ($tmp1 === 3) {
      Result = "ré# "}
     else if ($tmp1 === 4) {
      Result = "mi  "}
     else if ($tmp1 === 5) {
      Result = "fa  "}
     else if ($tmp1 === 6) {
      Result = "fa# "}
     else if ($tmp1 === 7) {
      Result = "sol "}
     else if ($tmp1 === 8) {
      Result = "sol#"}
     else if ($tmp1 === 9) {
      Result = "la  "}
     else if ($tmp1 === 10) {
      Result = "la# "}
     else if ($tmp1 === 11) Result = "si  ";
    return Result;
  };
});
rtl.module("uCouleur",["System","Classes","SysUtils","Math"],function () {
  "use strict";
  var $mod = this;
  this.Nanometres_from_metre = 1E9;
  this.SpeedOfLight = 2.9979E8;
  this.Couleur_WavelengthMinimum = 380;
  this.Couleur_WavelengthMaximum = 780;
  this.Couleur_Frequence_Min = 299790000 / (780 / 1000000000);
  this.Couleur_Frequence_Max = 299790000 / (380 / 1000000000);
  this.Vision_from_Longueur_onde = function (_Longueur_onde) {
    var Result = 0.0;
    function Up(_Debut, _Fin) {
      var Result = 0.0;
      Result = (_Longueur_onde - _Debut) / (_Fin - _Debut);
      return Result;
    };
    function Down(_Debut, _Fin) {
      var Result = 0.0;
      Result = (_Fin - _Longueur_onde) / (_Fin - _Debut);
      return Result;
    };
    var $tmp1 = pas.System.Trunc(_Longueur_onde);
    if (($tmp1 >= 380) && ($tmp1 <= 419)) {
      Result = 0.3 + (0.7 * Up(380,420))}
     else if (($tmp1 >= 420) && ($tmp1 <= 700)) {
      Result = 1.0}
     else if (($tmp1 >= 701) && ($tmp1 <= 780)) {
      Result = 0.3 + (0.7 * Down(700,780))}
     else {
      Result = 0.0;
    };
    return Result;
  };
  var Gamma = 0.80;
  this.RGB_from_Longueur_onde = function (_Longueur_onde, _Red, _Green, _Blue) {
    var Factor = 0.0;
    function Up(_Debut, _Fin) {
      var Result = 0.0;
      Result = (_Longueur_onde - _Debut) / (_Fin - _Debut);
      return Result;
    };
    function Down(_Debut, _Fin) {
      var Result = 0.0;
      Result = (_Fin - _Longueur_onde) / (_Fin - _Debut);
      return Result;
    };
    function RGB(_R, _G, _B) {
      _Red.set(_R);
      _Green.set(_G);
      _Blue.set(_B);
    };
    function Adjust(Color, Factor) {
      var Result = 0.0;
      Result = 0;
      if (0 === Color) return Result;
      Result = Math.pow(Color * Factor,0.8);
      return Result;
    };
    var $tmp1 = pas.System.Trunc(_Longueur_onde);
    if (($tmp1 >= 380) && ($tmp1 <= 439)) {
      RGB(Down(380,440),0,1)}
     else if (($tmp1 >= 440) && ($tmp1 <= 489)) {
      RGB(0,Up(440,490),1)}
     else if (($tmp1 >= 490) && ($tmp1 <= 509)) {
      RGB(0,1,Down(490,510))}
     else if (($tmp1 >= 510) && ($tmp1 <= 579)) {
      RGB(Up(510,580),1,0)}
     else if (($tmp1 >= 580) && ($tmp1 <= 644)) {
      RGB(1,Down(580,644),0)}
     else if (($tmp1 >= 645) && ($tmp1 <= 780)) {
      RGB(1,0,0)}
     else {
      RGB(0,0,0);
    };
    Factor = $mod.Vision_from_Longueur_onde(_Longueur_onde);
    _Red.set(Adjust(_Red.get(),Factor));
    _Green.set(Adjust(_Green.get(),Factor));
    _Blue.set(Adjust(_Blue.get(),Factor));
  };
  this.RGB_from_Longueur_onde_hex = function (_Longueur_onde) {
    var Result = "";
    var Red = 0.0;
    var Green = 0.0;
    var Blue = 0.0;
    function T(_d) {
      var Result = "";
      var b = 0;
      b = Math.round(255 * _d);
      Result = pas.SysUtils.IntToHex(b,2);
      return Result;
    };
    $mod.RGB_from_Longueur_onde(_Longueur_onde,{get: function () {
        return Red;
      }, set: function (v) {
        Red = v;
      }},{get: function () {
        return Green;
      }, set: function (v) {
        Green = v;
      }},{get: function () {
        return Blue;
      }, set: function (v) {
        Blue = v;
      }});
    Result = "#" + T(Red) + T(Green) + T(Blue);
    return Result;
  };
  this.RGB_from_Longueur_onde_rgba = function (_Longueur_onde, _Alpha) {
    var Result = "";
    var Red = 0.0;
    var Green = 0.0;
    var Blue = 0.0;
    function T(_d) {
      var Result = "";
      var b = 0;
      b = Math.round(255 * _d);
      Result = pas.SysUtils.IntToStr(b);
      return Result;
    };
    $mod.RGB_from_Longueur_onde(_Longueur_onde,{get: function () {
        return Red;
      }, set: function (v) {
        Red = v;
      }},{get: function () {
        return Green;
      }, set: function (v) {
        Green = v;
      }},{get: function () {
        return Blue;
      }, set: function (v) {
        Blue = v;
      }});
    Result = pas.SysUtils.Format("rgba( %s, %s, %s, %f)",[T(Red),T(Green),T(Blue),_Alpha]);
    return Result;
  };
  this.Longueur_onde_from_Frequence = function (_Frequence) {
    var Result = 0.0;
    Result = 1000000000 * (299790000 / _Frequence);
    return Result;
  };
  this.RGB_from_Frequency_hex = function (_Frequence) {
    var Result = "";
    var Longueur_onde = 0.0;
    Longueur_onde = $mod.Longueur_onde_from_Frequence(_Frequence);
    Result = $mod.RGB_from_Longueur_onde_hex(Longueur_onde);
    return Result;
  };
  this.RGB_from_Frequency_rgba = function (_Frequence, _Alpha) {
    var Result = "";
    var Longueur_onde = 0.0;
    Longueur_onde = $mod.Longueur_onde_from_Frequence(_Frequence);
    Result = $mod.RGB_from_Longueur_onde_rgba(Longueur_onde,_Alpha);
    return Result;
  };
  this.RGB_from_Frequency_tag_begin = function (_Frequence) {
    var Result = "";
    var hex = "";
    hex = $mod.RGB_from_Frequency_hex(_Frequence);
    Result = '<em style="background-color:' + hex + ';">';
    return Result;
  };
  this.RGB_from_Frequency_tag_body = function (_Frequence) {
    var Result = "";
    var Longueur_onde = 0.0;
    var Red = 0.0;
    var Green = 0.0;
    var Blue = 0.0;
    var R = 0;
    var G = 0;
    var B = 0;
    var hex = "";
    Longueur_onde = $mod.Longueur_onde_from_Frequence(_Frequence);
    $mod.RGB_from_Longueur_onde(Longueur_onde,{get: function () {
        return Red;
      }, set: function (v) {
        Red = v;
      }},{get: function () {
        return Green;
      }, set: function (v) {
        Green = v;
      }},{get: function () {
        return Blue;
      }, set: function (v) {
        Blue = v;
      }});
    R = Math.round(255 * Red);
    G = Math.round(255 * Green);
    B = Math.round(255 * Blue);
    hex = $mod.RGB_from_Frequency_hex(_Frequence);
    Result = pas.SysUtils.Format("longueur d'onde: %f nm  Rouge: %.3d; Vert: %.3d; Bleu: %.3d soit %s",[Longueur_onde,R,G,B,hex]);
    return Result;
  };
  this.RGB_from_Frequency_tag_end = function () {
    var Result = "";
    Result = "<\/em>";
    return Result;
  };
  this.Is_Visible = function (_Frequence_Min, _Frequence_Max) {
    var Result = false;
    Result = false;
    if (_Frequence_Max < 3.8434615384615388E14) return Result;
    if (_Frequence_Min > 788921052631579) return Result;
    Result = true;
    return Result;
  };
  this.Is_Visible$1 = function (_Frequence) {
    var Result = false;
    Result = (3.8434615384615388E14 <= _Frequence) && (_Frequence <= 788921052631579);
    return Result;
  };
});
rtl.module("uFrequences",["System","uFrequence","uCouleur","Classes","SysUtils","Math","Types"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.uFrequences_coherent = [256,269.8,288,303.1,324,341.2,364.7,384,404.5,432,455.1,486];
  this.uFrequences_decoherent = [249.4,262.8,278.8,295.5,313.4,332.5,352.8,374.3,394.1,418.0,443.2,470.3];
  this.uFrequences_band_half_width = 0.85;
  this.uFrequences_Bas_factor = 1 - (0.85 / 100);
  this.uFrequences_Haut_factor = 1 + (0.85 / 100);
  rtl.createClass($mod,"TFrequences",pas.System.TObject,function () {
    this.Boundaries = function (_Octave, _NbOctaves, _Base) {
      var $Self = this;
      var Result = [];
      var LBase = 0;
      var O = 0;
      var I = 0;
      function Traite_Frequence() {
        var Frequence = 0.0;
        var Bas = 0.0;
        var Haut = 0.0;
        Frequence = $Self.Harmonique(_Base[I],_Octave + O);
        Bas = Frequence * 0.9915;
        Haut = Frequence * 1.0085;
        Result[(O * LBase) + (2 * I) + 0] = Bas;
        Result[(O * LBase) + (2 * I) + 1] = Haut;
      };
      LBase = 2 * rtl.length(_Base);
      Result = rtl.arraySetLength(Result,0.0,_NbOctaves * LBase);
      for (var $l1 = 0, $end2 = _NbOctaves - 1; $l1 <= $end2; $l1++) {
        O = $l1;
        for (var $l3 = 0, $end4 = rtl.length(_Base) - 1; $l3 <= $end4; $l3++) {
          I = $l3;
          Traite_Frequence();
        };
      };
      return Result;
    };
    this.Centers = function (_Octave, _NbOctaves, _Base) {
      var Result = [];
      var LBase = 0;
      var O = 0;
      var I = 0;
      LBase = rtl.length(_Base);
      Result = rtl.arraySetLength(Result,0.0,_NbOctaves * LBase);
      for (var $l1 = 0, $end2 = _NbOctaves - 1; $l1 <= $end2; $l1++) {
        O = $l1;
        for (var $l3 = 0, $end4 = rtl.length(_Base) - 1; $l3 <= $end4; $l3++) {
          I = $l3;
          Result[(O * LBase) + I] = this.Harmonique(_Base[I],_Octave + O);
        };
      };
      return Result;
    };
    this.sFrequence = function (_Octave, _Base, _Note_Index) {
      var Result = "";
      var Frequence = 0.0;
      var Bas = 0.0;
      var Haut = 0.0;
      Frequence = this.Harmonique(_Base,_Octave);
      Bas = Frequence * 0.9915;
      Haut = Frequence * 1.0085;
      Result = pas.uFrequence.Note_Latine(_Note_Index) + " Min: " + pas.uFrequence.sFrequence(Bas,6," ") + " \/ Centre: " + pas.uFrequence.sFrequence(Frequence,6," ") + " \/ Max: " + pas.uFrequence.sFrequence(Haut,6," ");
      if (pas.uCouleur.Is_Visible$1(Frequence)) Result = pas.uCouleur.RGB_from_Frequency_tag_begin(Frequence) + Result + " " + pas.uCouleur.RGB_from_Frequency_tag_body(Frequence) + pas.uCouleur.RGB_from_Frequency_tag_end();
      return Result;
    };
    this.aCoherent_boundaries = function (_Octave, _NbOctaves) {
      var Result = [];
      Result = this.Boundaries(_Octave,_NbOctaves,$mod.uFrequences_coherent);
      return Result;
    };
    this.aDeCoherent_boundaries = function (_Octave, _NbOctaves) {
      var Result = [];
      Result = this.Boundaries(_Octave,_NbOctaves,$mod.uFrequences_decoherent);
      return Result;
    };
    this.aCoherent_centers = function (_Octave, _NbOctaves) {
      var Result = [];
      Result = this.Centers(_Octave,_NbOctaves,$mod.uFrequences_coherent);
      return Result;
    };
    this.aDeCoherent_centers = function (_Octave, _NbOctaves) {
      var Result = [];
      Result = this.Centers(_Octave,_NbOctaves,$mod.uFrequences_decoherent);
      return Result;
    };
    this.Liste = function (_Octave, _NbOctaves) {
      var Result = "";
      var I = 0;
      var O = 0;
      Result = "<pre>Octave: " + pas.SysUtils.IntToStr(_Octave) + pas.uFrequence.uFrequence_Separateur_Lignes + "Bandes de fréquences cohérentes";
      for (var $l1 = _Octave, $end2 = (_Octave + _NbOctaves) - 1; $l1 <= $end2; $l1++) {
        O = $l1;
        for (var $l3 = 0, $end4 = rtl.length($mod.uFrequences_coherent) - 1; $l3 <= $end4; $l3++) {
          I = $l3;
          Result = Result + pas.uFrequence.uFrequence_Separateur_Lignes + this.sFrequence(O,$mod.uFrequences_coherent[I],I);
        };
      };
      Result = Result + pas.uFrequence.uFrequence_Separateur_Lignes + "Bandes de fréquences décohérentes";
      for (var $l5 = _Octave, $end6 = (_Octave + _NbOctaves) - 1; $l5 <= $end6; $l5++) {
        O = $l5;
        for (var $l7 = 0, $end8 = rtl.length($mod.uFrequences_decoherent) - 1; $l7 <= $end8; $l7++) {
          I = $l7;
          Result = Result + pas.uFrequence.uFrequence_Separateur_Lignes + this.sFrequence(O,$mod.uFrequences_decoherent[I],I);
        };
      };
      Result = Result + "<\/pre>";
      return Result;
    };
    this.Liste_from_Frequence = function (_Frequence) {
      var Result = "";
      var Octave = 0;
      Octave = this.Octave_from_Frequence(_Frequence);
      Result = "<pre>Fréquence: " + pas.uFrequence.sFrequence(_Frequence,6," ") + pas.uFrequence.uFrequence_Separateur_Lignes + this.Liste(Octave,1);
      Result = Result + "<\/pre>";
      return Result;
    };
    this.Match_Base = function (_Octave, _Base, _Frequence, _Prefixe, _Note_Index, _Nb) {
      var Result = "";
      var F = 0.0;
      var Bas = 0.0;
      var Haut = 0.0;
      F = this.Harmonique(_Base,_Octave);
      Bas = F * 0.9915;
      Haut = F * 1.0085;
      if ((Bas <= _Frequence) && (_Frequence <= Haut)) {
        Result = _Prefixe + " dans la bande " + this.sFrequence(_Octave,_Base,_Note_Index);
        _Nb.set(_Nb.get() + 1);
      } else Result = "";
      return Result;
    };
    this.sMatch = function (_Octave, _Frequence, _NbCoherent, _NbDeCoherent) {
      var Result = "";
      var I = 0;
      Result = "";
      for (var $l1 = 0, $end2 = rtl.length($mod.uFrequences_coherent) - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        Result = Result + this.Match_Base(_Octave,$mod.uFrequences_coherent[I],_Frequence,"  cohérent",I,_NbCoherent);
      };
      for (var $l3 = 0, $end4 = rtl.length($mod.uFrequences_coherent) - 1; $l3 <= $end4; $l3++) {
        I = $l3;
        Result = Result + this.Match_Base(_Octave + 1,$mod.uFrequences_coherent[I],_Frequence,"  cohérent",I,_NbCoherent);
      };
      for (var $l5 = 0, $end6 = rtl.length($mod.uFrequences_decoherent) - 1; $l5 <= $end6; $l5++) {
        I = $l5;
        Result = Result + this.Match_Base(_Octave,$mod.uFrequences_decoherent[I],_Frequence,"décohérent",I,_NbDeCoherent);
      };
      for (var $l7 = 0, $end8 = rtl.length($mod.uFrequences_decoherent) - 1; $l7 <= $end8; $l7++) {
        I = $l7;
        Result = Result + this.Match_Base(_Octave + 1,$mod.uFrequences_decoherent[I],_Frequence,"décohérent",I,_NbDeCoherent);
      };
      return Result;
    };
    this.Octave_from_Frequence = function (_Frequence) {
      var Result = 0;
      if (_Frequence > $mod.uFrequences_Min()) {
        Result = pas.System.Trunc(Math.log2(_Frequence / $mod.uFrequences_Min()))}
       else Result = -pas.System.Trunc(Math.log2($mod.uFrequences_Max() / _Frequence));
      return Result;
    };
    this.Harmonique = function (_Frequence, _Octave) {
      var Result = 0.0;
      Result = _Frequence * Math.pow(2,_Octave);
      return Result;
    };
  });
  this.Frequences = function () {
    var Result = null;
    if (null === $impl.FFrequences) $impl.FFrequences = $mod.TFrequences.$create("Create");
    Result = $impl.FFrequences;
    return Result;
  };
  this.uFrequences_Min = function () {
    var Result = 0.0;
    Result = $mod.uFrequences_decoherent[0];
    return Result;
  };
  this.uFrequences_Max = function () {
    var Result = 0.0;
    Result = $mod.uFrequences_coherent[rtl.length($mod.uFrequences_coherent) - 1];
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.FFrequences = null;
});
rtl.module("uCPL_G3",["System","Classes","SysUtils","uFrequence","uFrequences"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.CPL_G3_NbPorteuses = 36;
  this.CPL_G3_Min = 35938;
  this.CPL_G3_Espacement = 1562.5;
  rtl.createClass($mod,"TCPL_G3",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.F = [];
    };
    this.$final = function () {
      this.F = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function () {
      this.Calcule_F();
      return this;
    };
    this.Calcule_F = function () {
      var I = 0;
      this.F = rtl.arraySetLength(this.F,0.0,36);
      for (var $l1 = 0, $end2 = rtl.length(this.F) - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        this.F[I] = 35938 + (I * 1562.5);
      };
    };
    this.Liste = function () {
      var $Self = this;
      var Result = "";
      var I = 0;
      var NbCoherent = 0;
      var NbDeCoherent = 0;
      var NbNeutre = 0;
      function sNb(_Nb, _S) {
        var Result = "";
        var dPourcent = 0.0;
        dPourcent = (_Nb / 36) * 100;
        Result = pas.SysUtils.IntToStr(_Nb) + _S + " soit " + pas.SysUtils.Format("%.2f",[dPourcent]) + "% des fréquences porteuses" + pas.uFrequence.uFrequence_Separateur_Lignes;
        return Result;
      };
      NbCoherent = 0;
      NbDeCoherent = 0;
      Result = "";
      for (var $l1 = 0, $end2 = rtl.length($Self.F) - 1; $l1 <= $end2; $l1++) {
        I = $l1;
        Result = Result + pas.uFrequence.uFrequence_Separateur_Lignes + pas.SysUtils.IntToStr(I + 1) + ": " + pas.uFrequence.sFrequence($Self.F[I],6," ") + " " + pas.uFrequences.Frequences().sMatch(7,$Self.F[I],{get: function () {
            return NbCoherent;
          }, set: function (v) {
            NbCoherent = v;
          }},{get: function () {
            return NbDeCoherent;
          }, set: function (v) {
            NbDeCoherent = v;
          }});
      };
      NbNeutre = 36 - NbCoherent - NbDeCoherent;
      Result = "<pre>Fréquences porteuses CPL G3" + pas.uFrequence.uFrequence_Separateur_Lignes + sNb(NbCoherent," fréquences cohérentes") + sNb(NbDeCoherent," fréquences décohérentes") + sNb(NbNeutre," fréquences neutres") + Result;
      Result = Result + "<\/pre>";
      return Result;
    };
  });
  this.CPL_G3 = function () {
    var Result = null;
    if (null === $impl.FCPL_G3) $impl.FCPL_G3 = $mod.TCPL_G3.$create("Create$1");
    Result = $impl.FCPL_G3;
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.FCPL_G3 = null;
});
rtl.module("uGamme",["System","uFrequence","Classes","SysUtils","Math","Types"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  rtl.createClass($mod,"TGamme_Temperee",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.Diapason = 0.0;
      this.Base = rtl.arraySetLength(null,0.0,12);
    };
    this.$final = function () {
      this.Base = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function (_Diapason) {
      this.Diapason = _Diapason;
      this.Calcule();
      return this;
    };
    this.Calcule = function () {
      var I = 0;
      for (I = 0; I <= 11; I++) this.Base[I] = this.Diapason * Math.pow(2,(I - 9) / 12);
    };
    this.sFrequence = function (_Octave, _Base, _Note_Index) {
      var Result = "";
      var Frequence = 0.0;
      Frequence = this.Harmonique(_Base,_Octave);
      Result = pas.uFrequence.Note_Latine(_Note_Index) + " " + pas.uFrequence.sFrequence(Frequence,6," ");
      return Result;
    };
    this.Liste = function (_Octave) {
      var Result = "";
      var I = 0;
      Result = "<pre>Octave: " + pas.SysUtils.IntToStr(_Octave) + pas.uFrequence.uFrequence_Separateur_Lignes + "Gamme tempérée, diapason " + pas.SysUtils.FloatToStr(this.Diapason) + " Hz";
      for (I = 0; I <= 11; I++) Result = Result + pas.uFrequence.uFrequence_Separateur_Lignes + this.sFrequence(_Octave,this.Base[I],I);
      Result = Result + "<\/pre>";
      return Result;
    };
    this.Harmonique = function (_Frequence, _Octave) {
      var Result = 0.0;
      Result = _Frequence * Math.pow(2,_Octave);
      return Result;
    };
  });
  this.Gamme_418Hz = function () {
    var Result = null;
    if (null === $impl.FGamme_418Hz) $impl.FGamme_418Hz = $mod.TGamme_Temperee.$create("Create$1",[418]);
    Result = $impl.FGamme_418Hz;
    return Result;
  };
  this.Gamme_432Hz = function () {
    var Result = null;
    if (null === $impl.FGamme_432Hz) $impl.FGamme_432Hz = $mod.TGamme_Temperee.$create("Create$1",[432]);
    Result = $impl.FGamme_432Hz;
    return Result;
  };
  this.Gamme_440Hz = function () {
    var Result = null;
    if (null === $impl.FGamme_440Hz) $impl.FGamme_440Hz = $mod.TGamme_Temperee.$create("Create$1",[440]);
    Result = $impl.FGamme_440Hz;
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.FGamme_418Hz = null;
  $impl.FGamme_432Hz = null;
  $impl.FGamme_440Hz = null;
});
rtl.module("ChartJS",["System","JS","Web"],function () {
  "use strict";
  var $mod = this;
  rtl.createClassExt($mod,"TChartXYData",Object,"",function () {
    this.$init = function () {
      this.x = undefined;
      this.y = undefined;
    };
    this.$final = function () {
    };
    this.new$1 = function (x, y) {
      this.x = x;
      this.y = y;
      return this;
    };
  });
});
rtl.module("strutils",["System","SysUtils"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.IfThen = function (AValue, ATrue, AFalse) {
    var Result = "";
    if (AValue) {
      Result = ATrue}
     else Result = AFalse;
    return Result;
  };
  this.Soundex = function (AText, ALength) {
    var Result = "";
    var S = "";
    var PS = "";
    var I = 0;
    var L = 0;
    Result = "";
    PS = "\x00";
    if (AText.length > 0) {
      Result = pas.System.upcase(AText.charAt(0));
      I = 2;
      L = AText.length;
      while ((I <= L) && (Result.length < ALength)) {
        S = $impl.SScore.charAt(AText.charCodeAt(I - 1) - 1);
        if (!(S.charCodeAt() in rtl.createSet(48,105,PS.charCodeAt()))) Result = Result + S;
        if (S !== "i") PS = S;
        I += 1;
      };
    };
    L = Result.length;
    if (L < ALength) Result = Result + pas.System.StringOfChar("0",ALength - L);
    return Result;
  };
  this.SoundexSimilar = function (AText, AOther, ALength) {
    var Result = false;
    Result = $mod.Soundex(AText,ALength) === $mod.Soundex(AOther,ALength);
    return Result;
  };
  this.SoundexSimilar$1 = function (AText, AOther) {
    var Result = false;
    Result = $mod.SoundexSimilar(AText,AOther,4);
    return Result;
  };
  this.SoundexProc = function (AText, AOther) {
    var Result = false;
    Result = $mod.SoundexSimilar$1(AText,AOther);
    return Result;
  };
  this.AnsiResemblesProc = null;
  this.ResemblesProc = null;
  $mod.$init = function () {
    $mod.AnsiResemblesProc = $mod.SoundexProc;
    $mod.ResemblesProc = $mod.SoundexProc;
  };
},["JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.SScore = "00000000000000000000000000000000" + "00000000000000000000000000000000" + "0123012i02245501262301i2i2" + "000000" + "0123012i02245501262301i2i2" + "00000000000000000000000000000000" + "00000000000000000000000000000000" + "00000000000000000000000000000000" + "00000000000000000000000000000000" + "00000";
});
rtl.module("uFrequencesCharter",["System","uFrequence","uFrequences","uCouleur","Classes","SysUtils","JS","Web","Math","ChartJS","Types","strutils"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  rtl.createClass($mod,"TFrequencesCharter",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.config = null;
      this.Octave = 0;
      this.NbOctaves = 0;
      this.Coherent_Boundaries = [];
      this.DeCoherent_Boundaries = [];
      this.Coherent_Centers = [];
      this.DeCoherent_Centers = [];
      this.bleu = "";
      this.gris = "";
      this.vert = "";
      this.gris_fonce = "";
      this.vert_fonce = "";
      this.slCanvas = null;
    };
    this.$final = function () {
      this.config = undefined;
      this.Coherent_Boundaries = undefined;
      this.DeCoherent_Boundaries = undefined;
      this.Coherent_Centers = undefined;
      this.DeCoherent_Centers = undefined;
      this.slCanvas = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function () {
      this.slCanvas = pas.Classes.TStringList.$create("Create$1");
      return this;
    };
    this.Push_dataset = function (_Name, _Color, _BkColor, _y, _Data) {
      var $Self = this;
      var dataset = null;
      function Push_Data() {
        var I = 0;
        for (var $l1 = 0, $end2 = rtl.length(_Data) - 1; $l1 <= $end2; $l1++) {
          I = $l1;
          dataset.data.push(pas.ChartJS.TChartXYData.$create("new$1",[_Data[I],_y]));
        };
      };
      dataset = new Object();
      dataset.label = _Name;
      dataset.borderColor = _Color;
      dataset.backgroundColor = _BkColor;
      dataset.showLine = false;
      dataset.data = new Array();
      Push_Data();
      $Self.config.data.datasets.push(dataset);
    };
    this.Axes = function () {
      var x = null;
      var y = null;
      x = new Object();
      x.type = "linear";
      x.id = "x-axis-0";
      y = new Object();
      y.type = "linear";
      y.id = "y-axis-0";
      this.config.options.scales = new Object();
      this.config.options.scales.xAxes = new Array(x);
      this.config.options.scales.yAxes = new Array(y);
    };
    this.Cree_Options = function () {
      var oa = null;
      var o = null;
      oa = new Object();
      oa.annotations = new Array();
      o = new Object();
      o.annotation = oa;
      this.config.options = o;
      this.Axes();
    };
    this.Plugin_annotation_box = function (_XMin, _XMax, _YMin, _YMax, _Color) {
      var a = null;
      a = new Object();
      a.drawTime = "beforeDatasetsDraw";
      a.type = "box";
      a.xScaleID = "x-axis-0";
      a.yScaleID = "y-axis-0";
      a.xMin = _XMin;
      a.xMax = _XMax;
      a.yMin = _YMin;
      a.yMax = _YMax;
      a.backgroundColor = _Color;
      a.borderColor = _Color;
      a.borderWidth = 1;
      this.config.options.annotation.annotations.push(a);
    };
    this.Plugin_annotation_line = function (_Value, _label_position, _Note_index, _Background_Color) {
      var a = null;
      a = new Object();
      a.drawTime = "beforeDatasetsDraw";
      a.type = "line";
      a.mode = "vertical";
      a.scaleID = "x-axis-0";
      a.value = _Value;
      a.borderColor = "black";
      a.borderWidth = 1;
      a.label = new Object();
      a.label.backgroundColor = _Background_Color;
      if (-1 === _Note_index) {
        a.label.content = pas.uFrequence.sFrequence(_Value,6," ")}
       else a.label.content = pas.uFrequence.Note_Latine(_Note_index);
      a.label.position = _label_position;
      a.label.enabled = true;
      this.config.options.annotation.annotations.push(a);
    };
    this.Plugin_annotations = function (_Centers, _Boundaries, _Box_Color, _Line_Color, _Frequence_Note_, _label_on_top) {
      var I2 = 0;
      var I = 0;
      var L = 0;
      var L2 = 0;
      var V1 = 0.0;
      var V2 = 0.0;
      var C = 0.0;
      var label_position = "";
      var Visible_ydebut = 0.0;
      var Visible_yfin = 0.0;
      L = rtl.length(_Boundaries);
      L2 = Math.floor(L / 2);
      for (var $l1 = 0, $end2 = L2 - 1; $l1 <= $end2; $l1++) {
        I2 = $l1;
        I = 0 + (2 * I2);
        V1 = _Boundaries[I + 0];
        V2 = _Boundaries[I + 1];
        C = _Centers[I2];
        label_position = pas.strutils.IfThen(_label_on_top,"top","bottom");
        if (_label_on_top) {
          Visible_ydebut = 2.2;
          Visible_yfin = 2.6;
        } else {
          Visible_ydebut = 1.2;
          Visible_yfin = 1.6;
        };
        this.Plugin_annotation_box(V1,V2,1,3,_Box_Color);
        if (pas.uCouleur.Is_Visible(V1,V2)) this.Plugin_annotation_box(V1,V2,Visible_ydebut,Visible_yfin,pas.uCouleur.RGB_from_Frequency_rgba(C,1));
        this.Plugin_annotation_line(C,label_position,pas.Math.IfThen(_Frequence_Note_,-1,I2),_Line_Color);
      };
    };
    this.Bandes_from_Octave = function (_Octave, _NbOctaves, _Frequence_Note_) {
      this.Octave = _Octave;
      this.NbOctaves = _NbOctaves;
      this.bleu = "blue";
      this.gris = "rgba(192, 192, 192, 1)";
      this.gris_fonce = "rgba(128, 128, 128, 1)";
      this.vert = "rgba(128, 255, 128, 1)";
      this.vert_fonce = "rgba(  0, 192,   0, 1)";
      this.Coherent_Boundaries = pas.uFrequences.Frequences().aCoherent_boundaries(this.Octave,this.NbOctaves);
      this.DeCoherent_Boundaries = pas.uFrequences.Frequences().aDeCoherent_boundaries(this.Octave,this.NbOctaves);
      this.Coherent_Centers = pas.uFrequences.Frequences().aCoherent_centers(this.Octave,this.NbOctaves);
      this.DeCoherent_Centers = pas.uFrequences.Frequences().aDeCoherent_centers(this.Octave,this.NbOctaves);
      this.config = new Object();
      this.config.type = "scatter";
      this.config.data = new Object();
      this.Cree_Options();
      this.Plugin_annotations(this.Coherent_Centers,this.Coherent_Boundaries,this.vert,this.vert_fonce,_Frequence_Note_,true);
      this.Plugin_annotations(this.DeCoherent_Centers,this.DeCoherent_Boundaries,this.gris,this.gris_fonce,_Frequence_Note_,false);
      this.config.data.datasets = new Array();
      this.Push_dataset("Décohérentes",this.gris,this.gris,1,this.DeCoherent_Centers);
      this.Push_dataset("Cohérentes",this.vert,this.vert,3,this.Coherent_Centers);
    };
    this.Cree_Chart = function (_Canvas_Name) {
      this.Dimensionne_Canvas(_Canvas_Name);
      new Chart(_Canvas_Name,this.config);
    };
    this.Dimensionne_Canvas = function (_Canvas_Name) {
      var Canvas = null;
      var dpr = 0.0;
      if (-1 !== this.slCanvas.IndexOf(_Canvas_Name)) return;
      this.slCanvas.Add(_Canvas_Name);
      dpr = window.devicePixelRatio;
      Canvas = document.getElementById(_Canvas_Name);
      Canvas.height = pas.System.Trunc(100 * dpr);
    };
    this.Draw_Chart_from_Octave = function (_Octave, _Canvas_Name, _NbOctaves, _Frequence_Note_) {
      this.Bandes_from_Octave(_Octave,_NbOctaves,_Frequence_Note_);
      this.Cree_Chart(_Canvas_Name);
    };
    this.Draw_Chart_from_Frequence = function (_Libelle, _Frequence, _Canvas_Name, _NbOctaves, _Frequence_Note_) {
      this.Bandes_from_Octave(pas.uFrequences.Frequences().Octave_from_Frequence(_Frequence),_NbOctaves,_Frequence_Note_);
      this.Push_dataset(_Libelle,this.bleu,this.bleu,2.5,[_Frequence]);
      this.Cree_Chart(_Canvas_Name);
    };
    this.Draw_Chart_from_Frequences = function (_Octave, _NbOctaves, _Libelle, _Frequences, _Canvas_Name) {
      this.Bandes_from_Octave(_Octave,_NbOctaves,false);
      this.Push_dataset(_Libelle,this.bleu,this.bleu,2.5,_Frequences);
      this.Cree_Chart(_Canvas_Name);
    };
  });
  this.FrequencesCharter = function () {
    var Result = null;
    if (null === $impl.FFrequencesCharter) $impl.FFrequencesCharter = $mod.TFrequencesCharter.$create("Create$1");
    Result = $impl.FFrequencesCharter;
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.FFrequencesCharter = null;
});
rtl.module("ufjsFrequences",["System","uFrequence","uFrequences","uCPL_G3","uGamme","uFrequencesCharter","Classes","SysUtils","JS","Web","Math","ChartJS","Types"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  rtl.createClass($mod,"TfjsFrequences",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.iOctave = null;
      this.iFrequence = null;
      this.sFrequence = null;
      this.dOctave = null;
      this.dFrequence = null;
      this.dCPL_G3 = null;
      this.dCouleur = null;
      this.dInfos = null;
    };
    this.$final = function () {
      this.iOctave = undefined;
      this.iFrequence = undefined;
      this.sFrequence = undefined;
      this.dOctave = undefined;
      this.dFrequence = undefined;
      this.dCPL_G3 = undefined;
      this.dCouleur = undefined;
      this.dInfos = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function () {
      this.Connecte_Interface();
      return this;
    };
    this.Connecte_Interface = function () {
      this.iOctave = $impl.input_from_id("iOctave");
      this.iOctave.oninput = rtl.createCallback(this,"iOctaveInput");
      this.iOctave.onchange = rtl.createCallback(this,"iOctaveInput");
      $impl.input_from_id("iOctave_Note").oninput = rtl.createCallback(this,"iOctaveInput");
      this.iFrequence = $impl.input_from_id("iFrequence");
      this.iFrequence.oninput = rtl.createCallback(this,"iFrequenceInput");
      this.iFrequence.onchange = rtl.createCallback(this,"iFrequenceInput");
      this.sFrequence = $impl.element_from_id("sFrequence");
      $impl.input_from_id("iFrequence_Note").oninput = rtl.createCallback(this,"iFrequenceInput");
      this.dOctave = $impl.element_from_id("dOctave");
      this.dFrequence = $impl.element_from_id("dFrequence");
      this.Traite_Octave();
      this.Traite_Frequence();
      this.Traite_Gamme_Temperee(418,pas.uGamme.Gamme_418Hz());
      this.Traite_Gamme_Temperee(432,pas.uGamme.Gamme_432Hz());
      this.Traite_Gamme_Temperee(440,pas.uGamme.Gamme_440Hz());
      this.dCPL_G3 = $impl.element_from_id("dCPL_G3");
      this.Traite_CPL_G3();
      this.dCouleur = $impl.element_from_id("dCouleur");
      this.Traite_Couleur();
      this.dInfos = $impl.element_from_id("dInfos");
      this.dInfos.innerHTML = "compilé avec pas2js version " + "1.4.20" + "<br>" + "target: " + "ECMAScript5" + " - " + "Browser" + "<br>" + "os: " + "Browser" + "<br>" + "cpu: " + "ECMAScript5" + "<br>" + "compilé le " + "2020\/4\/30" + " à " + " 1:59:21" + "<br>" + "langue du navigateur: " + window.navigator.language + "<br>" + "window.devicePixelRatio: " + pas.SysUtils.FloatToStr(window.devicePixelRatio);
    };
    this.iOctaveInput = function (_Event) {
      var Result = false;
      this.Traite_Octave();
      return Result;
    };
    this.iFrequenceInput = function (_Event) {
      var Result = false;
      this.Traite_Frequence();
      return Result;
    };
    this.Traite_Octave = function () {
      var iOctave_Note = null;
      var Octave = 0;
      var Octave_Note = false;
      this.iOctave = $impl.input_from_id("iOctave");
      if (!pas.SysUtils.TryStrToInt(this.iOctave.value,{get: function () {
          return Octave;
        }, set: function (v) {
          Octave = v;
        }})) return;
      iOctave_Note = $impl.input_from_id("iOctave_Note");
      Octave_Note = iOctave_Note.checked;
      pas.uFrequencesCharter.FrequencesCharter().Draw_Chart_from_Octave(Octave,"cOctave",1,!Octave_Note);
      this.dOctave = $impl.element_from_id("dOctave");
      this.dOctave.innerHTML = pas.uFrequences.Frequences().Liste(Octave,1);
    };
    this.Traite_Frequence = function () {
      var iFrequence_Note = null;
      var Frequence_Note = false;
      var Frequence = 0.0;
      if (!pas.SysUtils.TryStrToFloat$1(this.iFrequence.value,{get: function () {
          return Frequence;
        }, set: function (v) {
          Frequence = v;
        }})) return;
      iFrequence_Note = $impl.input_from_id("iFrequence_Note");
      Frequence_Note = iFrequence_Note.checked;
      pas.uFrequencesCharter.FrequencesCharter().Draw_Chart_from_Frequence(pas.uFrequence.sFrequence(Frequence,6," "),Frequence,"cFrequence",1,!Frequence_Note);
      this.dFrequence.innerHTML = pas.uFrequences.Frequences().Liste_from_Frequence(Frequence);
      this.sFrequence.innerHTML = pas.uFrequence.sFrequence(Frequence,6," ");
    };
    this.Traite_CPL_G3 = function () {
      pas.uFrequencesCharter.FrequencesCharter().Draw_Chart_from_Frequences(7,2,"Porteuses CPL G3",pas.uCPL_G3.CPL_G3().F,"cCPL_G3");
      this.dCPL_G3.innerHTML = pas.uCPL_G3.CPL_G3().Liste();
    };
    var Octave = 40;
    this.Traite_Couleur = function () {
      pas.uFrequencesCharter.FrequencesCharter().Draw_Chart_from_Octave(40,"cCouleur",2,false);
      this.dCouleur.innerHTML = pas.uFrequences.Frequences().Liste(40,2);
    };
    this.Traite_Gamme_Temperee = function (_Diapason, _Gamme_Temperee) {
      var sDiapason = "";
      sDiapason = pas.SysUtils.IntToStr(_Diapason);
      pas.uFrequencesCharter.FrequencesCharter().Draw_Chart_from_Frequences(0,1,"Gamme tempérée diapason " + sDiapason + " Hz",_Gamme_Temperee.Base.slice(0),"c" + sDiapason + "Hz");
      $impl.element_from_id("d" + sDiapason + "Hz").innerHTML = _Gamme_Temperee.Liste(0);
    };
  });
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.element_from_id = function (_id) {
    var Result = null;
    Result = document.getElementById(_id);
    return Result;
  };
  $impl.input_from_id = function (_id) {
    var Result = null;
    Result = document.getElementById(_id);
    return Result;
  };
});
rtl.module("program",["System","JS","Classes","SysUtils","Web","ufjsFrequences","uFrequence","uGamme","uFrequencesCharter","uCouleur"],function () {
  "use strict";
  var $mod = this;
  $mod.$main = function () {
    pas.uFrequence.uFrequence_Separateur_Lignes = "<br>";
    pas.ufjsFrequences.TfjsFrequences.$create("Create$1");
  };
});
//# sourceMappingURL=jsFrequences.js.map
