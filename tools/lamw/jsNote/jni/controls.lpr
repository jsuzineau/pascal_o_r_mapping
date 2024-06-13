{hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni}
library controls;  //by Lamw: Lazarus Android Module Wizard: 7/5/2015 1:29:10]
 
{$mode delphi}
 
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,
  Laz_And_Controls_Events, fphttpclient, blcksock, ufjsNote, ufChant,ufUtilitaires,
  uAndroid_Midi, uAudioTrack, ublChant, upoolChant, uhfChant, uFrequences,
  udmDatabase, ufChants, ufOptions, uOptions;

{%region /fold 'LAMW generated code'}

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;Landroid/content/Intent;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject;
 layout: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnCreate(PEnv, this, context, layout, intent); fChants.Reinit;
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnNewIntent
  Signature: (Landroid/content/Intent;)V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv, this, intent);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv, this, rotate);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnUpdateLayout
  Signature: ()V }
procedure pAppOnUpdateLayout(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnUpdateLayout(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv, this);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt;
 resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv, this, requestCode, resultCode, data);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnCreateOptionsMenu
  Signature: (Landroid/view/Menu;)V }
procedure pAppOnCreateOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
 cdecl;
begin
  Java_Event_pAppOnCreateOptionsMenu(PEnv, this, menu);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnClickOptionMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickOptionMenuItem(PEnv: PJNIEnv; this: JObject;
 menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
 cdecl;
begin
  Java_Event_pAppOnClickOptionMenuItem(PEnv, this, menuItem, itemID,
   itemCaption, checked);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnPrepareOptionsMenu
  Signature: (Landroid/view/Menu;I)Z }
function pAppOnPrepareOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject;
 menuSize: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenu(PEnv, this, menu, menuSize);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnPrepareOptionsMenuItem
  Signature: (Landroid/view/Menu;Landroid/view/MenuItem;I)Z }
function pAppOnPrepareOptionsMenuItem(PEnv: PJNIEnv; this: JObject;
 menu: JObject; menuItem: JObject; itemIndex: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenuItem(PEnv, this, menu, menuItem,
   itemIndex);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnCreateContextMenu
  Signature: (Landroid/view/ContextMenu;)V }
procedure pAppOnCreateContextMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
 cdecl;
begin
  Java_Event_pAppOnCreateContextMenu(PEnv, this, menu);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnClickContextMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickContextMenuItem(PEnv: PJNIEnv; this: JObject;
 menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
 cdecl;
begin
  Java_Event_pAppOnClickContextMenuItem(PEnv, this, menuItem, itemID,
   itemCaption, checked);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnDraw
  Signature: (J)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDraw(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt;
 cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1, x2, y2);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClickGeneric
  Signature: (J)V }
procedure pOnClickGeneric(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClickGeneric(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnSpecialKeyDown
  Signature: (CILjava/lang/String;)Z }
function pAppOnSpecialKeyDown(PEnv: PJNIEnv; this: JObject; keyChar: JChar;
 keyCode: JInt; keyCodeString: JString): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnSpecialKeyDown(PEnv, this, keyChar, keyCode,
   keyCodeString);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnDown
  Signature: (J)V }
procedure pOnDown(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDown(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnUp
  Signature: (J)V }
procedure pOnUp(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnUp(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt);
 cdecl;
begin
  Java_Event_pOnClick(PEnv, this, TObject(pasobj), value);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnLongClick
  Signature: (J)V }
procedure pOnLongClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnLongClick(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnDoubleClick
  Signature: (J)V }
procedure pOnDoubleClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDoubleClick(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnChange
  Signature: (JLjava/lang/String;I)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
 count: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnChanged
  Signature: (JLjava/lang/String;I)V }
procedure pOnChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
 count: JInt); cdecl;
begin
  Java_Event_pOnChanged(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnBackPressed
  Signature: (J)V }
procedure pOnBackPressed(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBackPressed(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnDone
  Signature: (J)V }
procedure pOnDone(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDone(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnSearch
  Signature: (J)V }
procedure pOnSearch(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnSearch(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnNext
  Signature: (J)V }
procedure pOnNext(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnNext(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnGo
  Signature: (J)V }
procedure pOnGo(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnGo(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnViewClick
  Signature: (Landroid/view/View;I)V }
procedure pAppOnViewClick(PEnv: PJNIEnv; this: JObject; view: JObject; id: JInt
 ); cdecl;
begin
  Java_Event_pAppOnViewClick(PEnv, this, view, id);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnListItemClick
  Signature: (Landroid/widget/AdapterView;Landroid/view/View;II)V }
procedure pAppOnListItemClick(PEnv: PJNIEnv; this: JObject; adapter: JObject;
 view: JObject; position: JInt; id: JInt); cdecl;
begin
  Java_Event_pAppOnListItemClick(PEnv, this, adapter, view, position, id);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnFlingGestureDetected
  Signature: (JI)V }
procedure pOnFlingGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 direction: JInt); cdecl;
begin
  Java_Event_pOnFlingGestureDetected(PEnv, this, TObject(pasobj), direction);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnPinchZoomGestureDetected
  Signature: (JFI)V }
procedure pOnPinchZoomGestureDetected(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; scaleFactor: JFloat; state: JInt); cdecl;
begin
  Java_Event_pOnPinchZoomGestureDetected(PEnv, this, TObject(pasobj),
   scaleFactor, state);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnLostFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnLostFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 text: JString); cdecl;
begin
  Java_Event_pOnLostFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; text: JString);
 cdecl;
begin
  Java_Event_pOnFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnBeforeDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnBeforeDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnBeforeDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnAfterDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnAfterDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnAfterDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnLayouting
  Signature: (JZ)V }
procedure pOnLayouting(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 changed: JBoolean); cdecl;
begin
  Java_Event_pOnLayouting(PEnv, this, TObject(pasobj), changed);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pAppOnRequestPermissionResult
  Signature: (ILjava/lang/String;I)V }
procedure pAppOnRequestPermissionResult(PEnv: PJNIEnv; this: JObject;
 requestCode: JInt; permission: JString; grantResult: JInt); cdecl;
begin
  Java_Event_pAppOnRequestPermissionResult(PEnv, this, requestCode, permission,
   grantResult);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnRunOnUiThread
  Signature: (JI)V }
procedure pOnRunOnUiThread(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 tag: JInt); cdecl;
begin
  Java_Event_pOnRunOnUiThread(PEnv, this, TObject(pasobj), tag);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnCustomDialogShow
  Signature: (JLandroid/app/Dialog;Ljava/lang/String;)V }
procedure pOnCustomDialogShow(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 dialog: JObject; title: JString); cdecl;
begin
  Java_Event_pOnCustomDialogShow(PEnv, this, TObject(pasobj), dialog, title);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnCustomDialogBackKeyPressed
  Signature: (JLjava/lang/String;)V }
procedure pOnCustomDialogBackKeyPressed(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; title: JString); cdecl;
begin
  Java_Event_pOnCustomDialogBackKeyPressed(PEnv, this, TObject(pasobj), title);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pEditTextOnActionIconTouchUp
  Signature: (JLjava/lang/String;)V }
procedure pEditTextOnActionIconTouchUp(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; textContent: JString); cdecl;
begin
  Java_Event_pEditTextOnActionIconTouchUp(PEnv, this, TObject(pasobj),
   textContent);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pEditTextOnActionIconTouchDown
  Signature: (JLjava/lang/String;)V }
procedure pEditTextOnActionIconTouchDown(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; textContent: JString); cdecl;
begin
  Java_Event_pEditTextOnActionIconTouchDown(PEnv, this, TObject(pasobj),
   textContent);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnImageViewPopupItemSelected
  Signature: (JLjava/lang/String;)V }
procedure pOnImageViewPopupItemSelected(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; caption: JString); cdecl;
begin
  Java_Event_pOnImageViewPopupItemSelected(PEnv, this, TObject(pasobj), caption
   );
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClickWidgetItem
  Signature: (JIZ)V }
procedure pOnClickWidgetItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt; checked: JBoolean); cdecl;
begin
  Java_Event_pOnClickWidgetItem(PEnv, this, TObject(pasobj), position, checked);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClickImageItem
  Signature: (JI)V }
procedure pOnClickImageItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt); cdecl;
begin
  Java_Event_pOnClickImageItem(PEnv, this, TObject(pasobj), position);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClickCaptionItem
  Signature: (JILjava/lang/String;)V }
procedure pOnClickCaptionItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickCaptionItem(PEnv, this, TObject(pasobj), position, caption
   );
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClickItemTextLeft
  Signature: (JILjava/lang/String;)V }
procedure pOnClickItemTextLeft(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickItemTextLeft(PEnv, this, TObject(pasobj), position, caption
   );
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClickItemTextCenter
  Signature: (JILjava/lang/String;)V }
procedure pOnClickItemTextCenter(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickItemTextCenter(PEnv, this, TObject(pasobj), position,
   caption);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnClickItemTextRight
  Signature: (JILjava/lang/String;)V }
procedure pOnClickItemTextRight(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickItemTextRight(PEnv, this, TObject(pasobj), position,
   caption);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewLongClickCaptionItem
  Signature: (JILjava/lang/String;)V }
procedure pOnListViewLongClickCaptionItem(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnListViewLongClickCaptionItem(PEnv, this, TObject(pasobj),
   position, caption);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewDrawItemCaptionColor
  Signature: (JILjava/lang/String;)I }
function pOnListViewDrawItemCaptionColor(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; position: JInt; caption: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemCaptionColor(PEnv, this, TObject(pasobj
   ), position, caption);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewDrawItemCustomFont
  Signature: (JILjava/lang/String;)Ljava/lang/String; }
function pOnListViewDrawItemCustomFont(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; position: JInt; caption: JString): JString; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemCustomFont(PEnv, this, TObject(pasobj),
   position, caption);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewDrawItemBackgroundColor
  Signature: (JI)I }
function pOnListViewDrawItemBackgroundColor(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; position: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemBackgroundColor(PEnv, this, TObject(
   pasobj), position);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewDrawItemBitmap
  Signature: (JILjava/lang/String;)Landroid/graphics/Bitmap; }
function pOnListViewDrawItemBitmap(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt; caption: JString): JObject; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemBitmap(PEnv, this, TObject(pasobj),
   position, caption);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnWidgeItemLostFocus
  Signature: (JILjava/lang/String;)V }
procedure pOnWidgeItemLostFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 position: JInt; widgetText: JString); cdecl;
begin
  Java_Event_pOnWidgeItemLostFocus(PEnv, this, TObject(pasobj), position,
   widgetText);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewScrollStateChanged
  Signature: (JIIIZ)V }
procedure pOnListViewScrollStateChanged(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; firstVisibleItem: JInt; visibleItemCount: JInt;
 totalItemCount: JInt; lastItemReached: JBoolean); cdecl;
begin
  Java_Event_pOnListViewScrollStateChanged(PEnv, this, TObject(pasobj),
   firstVisibleItem, visibleItemCount, totalItemCount, lastItemReached);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewDrawItemWidgetTextColor
  Signature: (JILjava/lang/String;)I }
function pOnListViewDrawItemWidgetTextColor(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; position: JInt; widgetText: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemWidgetTextColor(PEnv, this, TObject(
   pasobj), position, widgetText);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewDrawItemWidgetText
  Signature: (JILjava/lang/String;)Ljava/lang/String; }
function pOnListViewDrawItemWidgetText(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; position: JInt; widgetText: JString): JString; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemWidgetText(PEnv, this, TObject(pasobj),
   position, widgetText);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnListViewDrawItemWidgetImage
  Signature: (JILjava/lang/String;)Landroid/graphics/Bitmap; }
function pOnListViewDrawItemWidgetImage(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; position: JInt; widgetText: JString): JObject; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemWidgetImage(PEnv, this, TObject(pasobj
   ), position, widgetText);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnMediaPlayerPrepared
  Signature: (JII)V }
procedure pOnMediaPlayerPrepared(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 videoWidth: JInt; videoHeigh: JInt); cdecl;
begin
  Java_Event_pOnMediaPlayerPrepared(PEnv, this, TObject(pasobj), videoWidth,
   videoHeigh);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnMediaPlayerVideoSizeChanged
  Signature: (JII)V }
procedure pOnMediaPlayerVideoSizeChanged(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; videoWidth: JInt; videoHeight: JInt); cdecl;
begin
  Java_Event_pOnMediaPlayerVideoSizeChanged(PEnv, this, TObject(pasobj),
   videoWidth, videoHeight);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnMediaPlayerCompletion
  Signature: (J)V }
procedure pOnMediaPlayerCompletion(PEnv: PJNIEnv; this: JObject; pasobj: JLong
 ); cdecl;
begin
  Java_Event_pOnMediaPlayerCompletion(PEnv, this, TObject(pasobj));
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnMediaPlayerTimedText
  Signature: (JLjava/lang/String;)V }
procedure pOnMediaPlayerTimedText(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 timedText: JString); cdecl;
begin
  Java_Event_pOnMediaPlayerTimedText(PEnv, this, TObject(pasobj), timedText);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnMidiManagerDeviceAdded
  Signature: (JILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V }
procedure pOnMidiManagerDeviceAdded(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; deviceId: JInt; deviceName: JString; productId: JString;
 manufacture: JString); cdecl;
begin
  Java_Event_pOnMidiManagerDeviceAdded(PEnv, this, TObject(pasobj), deviceId,
   deviceName, productId, manufacture);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnMidiManagerDeviceRemoved
  Signature: (JILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V }
procedure pOnMidiManagerDeviceRemoved(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; deviceId: JInt; deviceName: JString; productId: JString;
 manufacture: JString); cdecl;
begin
  Java_Event_pOnMidiManagerDeviceRemoved(PEnv, this, TObject(pasobj), deviceId,
   deviceName, productId, manufacture);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnFileSelected
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnFileSelected(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 path: JString; fileName: JString); cdecl;
begin
  Java_Event_pOnFileSelected(PEnv, this, TObject(pasobj), path, fileName);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pRadioGroupCheckedChanged
  Signature: (JILjava/lang/String;)V }
procedure pRadioGroupCheckedChanged(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; checkedIndex: JInt; checkedCaption: JString); cdecl;
begin
  Java_Event_pRadioGroupCheckedChanged(PEnv, this, TObject(pasobj),
   checkedIndex, checkedCaption);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnSqliteDataAccessAsyncPostExecute
  Signature: (JILjava/lang/String;)V }
procedure pOnSqliteDataAccessAsyncPostExecute(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; count: JInt; msgResult: JString); cdecl;
begin
  Java_Event_pOnSqliteDataAccessAsyncPostExecute(PEnv, this, TObject(pasobj),
   count, msgResult);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnWebViewStatus
  Signature: (JILjava/lang/String;)I }
function pOnWebViewStatus(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
 EventType: JInt; url: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnWebViewStatus(PEnv, this, TObject(pasobj), EventType,
   url);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnWebViewFindResultReceived
  Signature: (JII)V }
procedure pOnWebViewFindResultReceived(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; findIndex: JInt; findCount: JInt); cdecl;
begin
  Java_Event_pOnWebViewFindResultReceived(PEnv, this, TObject(pasobj),
   findIndex, findCount);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnWebViewEvaluateJavascriptResult
  Signature: (JLjava/lang/String;)V }
procedure pOnWebViewEvaluateJavascriptResult(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; data: JString); cdecl;
begin
  Java_Event_pOnWebViewEvaluateJavascriptResult(PEnv, this, TObject(pasobj),
   data);
end;

{ Class:     com_mars42_jsNote_Controls
  Method:    pOnWebViewReceivedSslError
  Signature: (JLjava/lang/String;I)Z }
function pOnWebViewReceivedSslError(PEnv: PJNIEnv; this: JObject;
 pasobj: JLong; error: JString; primaryError: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnWebViewReceivedSslError(PEnv, this, TObject(pasobj),
   error, primaryError);
end;

const NativeMethods: array[0..82] of JNINativeMethod = (
   (name: 'pAppOnCreate';
    signature: '(Landroid/content/Context;Landroid/widget/RelativeLayout;'
     +'Landroid/content/Intent;)V';
    fnPtr: @pAppOnCreate; ),
   (name: 'pAppOnScreenStyle';
    signature: '()I';
    fnPtr: @pAppOnScreenStyle; ),
   (name: 'pAppOnNewIntent';
    signature: '(Landroid/content/Intent;)V';
    fnPtr: @pAppOnNewIntent; ),
   (name: 'pAppOnDestroy';
    signature: '()V';
    fnPtr: @pAppOnDestroy; ),
   (name: 'pAppOnPause';
    signature: '()V';
    fnPtr: @pAppOnPause; ),
   (name: 'pAppOnRestart';
    signature: '()V';
    fnPtr: @pAppOnRestart; ),
   (name: 'pAppOnResume';
    signature: '()V';
    fnPtr: @pAppOnResume; ),
   (name: 'pAppOnStart';
    signature: '()V';
    fnPtr: @pAppOnStart; ),
   (name: 'pAppOnStop';
    signature: '()V';
    fnPtr: @pAppOnStop; ),
   (name: 'pAppOnBackPressed';
    signature: '()V';
    fnPtr: @pAppOnBackPressed; ),
   (name: 'pAppOnRotate';
    signature: '(I)I';
    fnPtr: @pAppOnRotate; ),
   (name: 'pAppOnUpdateLayout';
    signature: '()V';
    fnPtr: @pAppOnUpdateLayout; ),
   (name: 'pAppOnConfigurationChanged';
    signature: '()V';
    fnPtr: @pAppOnConfigurationChanged; ),
   (name: 'pAppOnActivityResult';
    signature: '(IILandroid/content/Intent;)V';
    fnPtr: @pAppOnActivityResult; ),
   (name: 'pAppOnCreateOptionsMenu';
    signature: '(Landroid/view/Menu;)V';
    fnPtr: @pAppOnCreateOptionsMenu; ),
   (name: 'pAppOnClickOptionMenuItem';
    signature: '(Landroid/view/MenuItem;ILjava/lang/String;Z)V';
    fnPtr: @pAppOnClickOptionMenuItem; ),
   (name: 'pAppOnPrepareOptionsMenu';
    signature: '(Landroid/view/Menu;I)Z';
    fnPtr: @pAppOnPrepareOptionsMenu; ),
   (name: 'pAppOnPrepareOptionsMenuItem';
    signature: '(Landroid/view/Menu;Landroid/view/MenuItem;I)Z';
    fnPtr: @pAppOnPrepareOptionsMenuItem; ),
   (name: 'pAppOnCreateContextMenu';
    signature: '(Landroid/view/ContextMenu;)V';
    fnPtr: @pAppOnCreateContextMenu; ),
   (name: 'pAppOnClickContextMenuItem';
    signature: '(Landroid/view/MenuItem;ILjava/lang/String;Z)V';
    fnPtr: @pAppOnClickContextMenuItem; ),
   (name: 'pOnDraw';
    signature: '(J)V';
    fnPtr: @pOnDraw; ),
   (name: 'pOnTouch';
    signature: '(JIIFFFF)V';
    fnPtr: @pOnTouch; ),
   (name: 'pOnClickGeneric';
    signature: '(J)V';
    fnPtr: @pOnClickGeneric; ),
   (name: 'pAppOnSpecialKeyDown';
    signature: '(CILjava/lang/String;)Z';
    fnPtr: @pAppOnSpecialKeyDown; ),
   (name: 'pOnDown';
    signature: '(J)V';
    fnPtr: @pOnDown; ),
   (name: 'pOnUp';
    signature: '(J)V';
    fnPtr: @pOnUp; ),
   (name: 'pOnClick';
    signature: '(JI)V';
    fnPtr: @pOnClick; ),
   (name: 'pOnLongClick';
    signature: '(J)V';
    fnPtr: @pOnLongClick; ),
   (name: 'pOnDoubleClick';
    signature: '(J)V';
    fnPtr: @pOnDoubleClick; ),
   (name: 'pOnChange';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChange; ),
   (name: 'pOnChanged';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChanged; ),
   (name: 'pOnEnter';
    signature: '(J)V';
    fnPtr: @pOnEnter; ),
   (name: 'pOnBackPressed';
    signature: '(J)V';
    fnPtr: @pOnBackPressed; ),
   (name: 'pOnDone';
    signature: '(J)V';
    fnPtr: @pOnDone; ),
   (name: 'pOnSearch';
    signature: '(J)V';
    fnPtr: @pOnSearch; ),
   (name: 'pOnNext';
    signature: '(J)V';
    fnPtr: @pOnNext; ),
   (name: 'pOnGo';
    signature: '(J)V';
    fnPtr: @pOnGo; ),
   (name: 'pOnClose';
    signature: '(J)V';
    fnPtr: @pOnClose; ),
   (name: 'pAppOnViewClick';
    signature: '(Landroid/view/View;I)V';
    fnPtr: @pAppOnViewClick; ),
   (name: 'pAppOnListItemClick';
    signature: '(Landroid/widget/AdapterView;Landroid/view/View;II)V';
    fnPtr: @pAppOnListItemClick; ),
   (name: 'pOnFlingGestureDetected';
    signature: '(JI)V';
    fnPtr: @pOnFlingGestureDetected; ),
   (name: 'pOnPinchZoomGestureDetected';
    signature: '(JFI)V';
    fnPtr: @pOnPinchZoomGestureDetected; ),
   (name: 'pOnLostFocus';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnLostFocus; ),
   (name: 'pOnFocus';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnFocus; ),
   (name: 'pOnBeforeDispatchDraw';
    signature: '(JLandroid/graphics/Canvas;I)V';
    fnPtr: @pOnBeforeDispatchDraw; ),
   (name: 'pOnAfterDispatchDraw';
    signature: '(JLandroid/graphics/Canvas;I)V';
    fnPtr: @pOnAfterDispatchDraw; ),
   (name: 'pOnLayouting';
    signature: '(JZ)V';
    fnPtr: @pOnLayouting; ),
   (name: 'pAppOnRequestPermissionResult';
    signature: '(ILjava/lang/String;I)V';
    fnPtr: @pAppOnRequestPermissionResult; ),
   (name: 'pOnRunOnUiThread';
    signature: '(JI)V';
    fnPtr: @pOnRunOnUiThread; ),
   (name: 'pOnCustomDialogShow';
    signature: '(JLandroid/app/Dialog;Ljava/lang/String;)V';
    fnPtr: @pOnCustomDialogShow; ),
   (name: 'pOnCustomDialogBackKeyPressed';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnCustomDialogBackKeyPressed; ),
   (name: 'pEditTextOnActionIconTouchUp';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pEditTextOnActionIconTouchUp; ),
   (name: 'pEditTextOnActionIconTouchDown';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pEditTextOnActionIconTouchDown; ),
   (name: 'pOnImageViewPopupItemSelected';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnImageViewPopupItemSelected; ),
   (name: 'pOnClickWidgetItem';
    signature: '(JIZ)V';
    fnPtr: @pOnClickWidgetItem; ),
   (name: 'pOnClickImageItem';
    signature: '(JI)V';
    fnPtr: @pOnClickImageItem; ),
   (name: 'pOnClickCaptionItem';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnClickCaptionItem; ),
   (name: 'pOnClickItemTextLeft';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnClickItemTextLeft; ),
   (name: 'pOnClickItemTextCenter';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnClickItemTextCenter; ),
   (name: 'pOnClickItemTextRight';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnClickItemTextRight; ),
   (name: 'pOnListViewLongClickCaptionItem';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnListViewLongClickCaptionItem; ),
   (name: 'pOnListViewDrawItemCaptionColor';
    signature: '(JILjava/lang/String;)I';
    fnPtr: @pOnListViewDrawItemCaptionColor; ),
   (name: 'pOnListViewDrawItemCustomFont';
    signature: '(JILjava/lang/String;)Ljava/lang/String;';
    fnPtr: @pOnListViewDrawItemCustomFont; ),
   (name: 'pOnListViewDrawItemBackgroundColor';
    signature: '(JI)I';
    fnPtr: @pOnListViewDrawItemBackgroundColor; ),
   (name: 'pOnListViewDrawItemBitmap';
    signature: '(JILjava/lang/String;)Landroid/graphics/Bitmap;';
    fnPtr: @pOnListViewDrawItemBitmap; ),
   (name: 'pOnWidgeItemLostFocus';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnWidgeItemLostFocus; ),
   (name: 'pOnListViewScrollStateChanged';
    signature: '(JIIIZ)V';
    fnPtr: @pOnListViewScrollStateChanged; ),
   (name: 'pOnListViewDrawItemWidgetTextColor';
    signature: '(JILjava/lang/String;)I';
    fnPtr: @pOnListViewDrawItemWidgetTextColor; ),
   (name: 'pOnListViewDrawItemWidgetText';
    signature: '(JILjava/lang/String;)Ljava/lang/String;';
    fnPtr: @pOnListViewDrawItemWidgetText; ),
   (name: 'pOnListViewDrawItemWidgetImage';
    signature: '(JILjava/lang/String;)Landroid/graphics/Bitmap;';
    fnPtr: @pOnListViewDrawItemWidgetImage; ),
   (name: 'pOnMediaPlayerPrepared';
    signature: '(JII)V';
    fnPtr: @pOnMediaPlayerPrepared; ),
   (name: 'pOnMediaPlayerVideoSizeChanged';
    signature: '(JII)V';
    fnPtr: @pOnMediaPlayerVideoSizeChanged; ),
   (name: 'pOnMediaPlayerCompletion';
    signature: '(J)V';
    fnPtr: @pOnMediaPlayerCompletion; ),
   (name: 'pOnMediaPlayerTimedText';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnMediaPlayerTimedText; ),
   (name: 'pOnMidiManagerDeviceAdded';
    signature: '(JILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnMidiManagerDeviceAdded; ),
   (name: 'pOnMidiManagerDeviceRemoved';
    signature: '(JILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnMidiManagerDeviceRemoved; ),
   (name: 'pOnFileSelected';
    signature: '(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnFileSelected; ),
   (name: 'pRadioGroupCheckedChanged';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pRadioGroupCheckedChanged; ),
   (name: 'pOnSqliteDataAccessAsyncPostExecute';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnSqliteDataAccessAsyncPostExecute; ),
   (name: 'pOnWebViewStatus';
    signature: '(JILjava/lang/String;)I';
    fnPtr: @pOnWebViewStatus; ),
   (name: 'pOnWebViewFindResultReceived';
    signature: '(JII)V';
    fnPtr: @pOnWebViewFindResultReceived; ),
   (name: 'pOnWebViewEvaluateJavascriptResult';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnWebViewEvaluateJavascriptResult; ),
   (name: 'pOnWebViewReceivedSslError';
    signature: '(JLjava/lang/String;I)Z';
    fnPtr: @pOnWebViewReceivedSslError; )
);

function RegisterNativeMethodsArray(PEnv: PJNIEnv; className: PChar;
 methods: PJNINativeMethod; countMethods: integer): integer;
var
  curClass: jClass;
begin
  Result:= JNI_FALSE;
  curClass:= (PEnv^).FindClass(PEnv, className);
  if curClass <> nil then
    result := (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods);
end;

function RegisterNativeMethods(PEnv: PJNIEnv; className: PChar): integer;
begin
  Result:= RegisterNativeMethodsArray(PEnv, className, @NativeMethods[0], Length
   (NativeMethods));
end;

function JNI_OnLoad(VM: PJavaVM; {%H-}reserved: pointer): JInt; cdecl;
var
  PEnv: PPointer;
  curEnv: PJNIEnv;
  rc: integer;
begin
  PEnv:= nil;
  Result:= JNI_VERSION_1_6;

  if (VM^).GetEnv(VM, @PEnv, Result) <> JNI_OK then
  begin
   result := JNI_ERR;
   exit;
  end;

  if PEnv <> nil then
  begin
     curEnv:= PJNIEnv(PEnv);
     gjClass:= (curEnv^).FindClass(curEnv, 'com/mars42/jsNote/Controls');
     gjClass:= (curEnv^).NewGlobalRef(curEnv, gjClass);
     rc := RegisterNativeMethods(curEnv, 'com/mars42/jsNote/Controls');
     if (rc <> JNI_OK) then result := rc;
  end;
  gjClassName:= 'com/mars42/jsNote/Controls';
  gVM:= VM; {AndroidWidget.pas}
end;

procedure JNI_OnUnload(VM: PJavaVM; {%H-}reserved: pointer); cdecl;
var
  PEnv: PPointer;
  curEnv: PJNIEnv;
begin
  PEnv:= nil;

  if (VM^).GetEnv(VM, @PEnv, JNI_VERSION_1_6) <> JNI_OK then exit;

  if PEnv <> nil then
  begin
    curEnv:= PJNIEnv(PEnv);
    (curEnv^).DeleteGlobalRef(curEnv, gjClass);
    gjClass:= nil; {AndroidWidget.pas}
    gVM:= nil; {AndroidWidget.pas}
  end;
  gApp.Terminate;
  FreeAndNil(gApp);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  pAppOnCreate name 'Java_com_mars42_jsNote_Controls_pAppOnCreate',
  pAppOnScreenStyle name 'Java_com_mars42_jsNote_Controls_pAppOnScreenStyle',
  pAppOnNewIntent name 'Java_com_mars42_jsNote_Controls_pAppOnNewIntent',
  pAppOnDestroy name 'Java_com_mars42_jsNote_Controls_pAppOnDestroy',
  pAppOnPause name 'Java_com_mars42_jsNote_Controls_pAppOnPause',
  pAppOnRestart name 'Java_com_mars42_jsNote_Controls_pAppOnRestart',
  pAppOnResume name 'Java_com_mars42_jsNote_Controls_pAppOnResume',
  pAppOnStart name 'Java_com_mars42_jsNote_Controls_pAppOnStart',
  pAppOnStop name 'Java_com_mars42_jsNote_Controls_pAppOnStop',
  pAppOnBackPressed name 'Java_com_mars42_jsNote_Controls_pAppOnBackPressed',
  pAppOnRotate name 'Java_com_mars42_jsNote_Controls_pAppOnRotate',
  pAppOnUpdateLayout name 'Java_com_mars42_jsNote_Controls_pAppOnUpdateLayout',
  pAppOnConfigurationChanged name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnActivityResult',
  pAppOnCreateOptionsMenu name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnCreateOptionsMenu',
  pAppOnClickOptionMenuItem name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnClickOptionMenuItem',
  pAppOnPrepareOptionsMenu name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnPrepareOptionsMenu',
  pAppOnPrepareOptionsMenuItem name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnPrepareOptionsMenuItem',
  pAppOnCreateContextMenu name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnCreateContextMenu',
  pAppOnClickContextMenuItem name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnClickContextMenuItem',
  pOnDraw name 'Java_com_mars42_jsNote_Controls_pOnDraw',
  pOnTouch name 'Java_com_mars42_jsNote_Controls_pOnTouch',
  pOnClickGeneric name 'Java_com_mars42_jsNote_Controls_pOnClickGeneric',
  pAppOnSpecialKeyDown name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnSpecialKeyDown',
  pOnDown name 'Java_com_mars42_jsNote_Controls_pOnDown',
  pOnUp name 'Java_com_mars42_jsNote_Controls_pOnUp',
  pOnClick name 'Java_com_mars42_jsNote_Controls_pOnClick',
  pOnLongClick name 'Java_com_mars42_jsNote_Controls_pOnLongClick',
  pOnDoubleClick name 'Java_com_mars42_jsNote_Controls_pOnDoubleClick',
  pOnChange name 'Java_com_mars42_jsNote_Controls_pOnChange',
  pOnChanged name 'Java_com_mars42_jsNote_Controls_pOnChanged',
  pOnEnter name 'Java_com_mars42_jsNote_Controls_pOnEnter',
  pOnBackPressed name 'Java_com_mars42_jsNote_Controls_pOnBackPressed',
  pOnDone name 'Java_com_mars42_jsNote_Controls_pOnDone',
  pOnSearch name 'Java_com_mars42_jsNote_Controls_pOnSearch',
  pOnNext name 'Java_com_mars42_jsNote_Controls_pOnNext',
  pOnGo name 'Java_com_mars42_jsNote_Controls_pOnGo',
  pOnClose name 'Java_com_mars42_jsNote_Controls_pOnClose',
  pAppOnViewClick name 'Java_com_mars42_jsNote_Controls_pAppOnViewClick',
  pAppOnListItemClick name
   'Java_com_mars42_jsNote_Controls_pAppOnListItemClick',
  pOnFlingGestureDetected name 'Java_com_mars42_jsNote_Controls_'
   +'pOnFlingGestureDetected',
  pOnPinchZoomGestureDetected name 'Java_com_mars42_jsNote_Controls_'
   +'pOnPinchZoomGestureDetected',
  pOnLostFocus name 'Java_com_mars42_jsNote_Controls_pOnLostFocus',
  pOnFocus name 'Java_com_mars42_jsNote_Controls_pOnFocus',
  pOnBeforeDispatchDraw name 'Java_com_mars42_jsNote_Controls_'
   +'pOnBeforeDispatchDraw',
  pOnAfterDispatchDraw name 'Java_com_mars42_jsNote_Controls_'
   +'pOnAfterDispatchDraw',
  pOnLayouting name 'Java_com_mars42_jsNote_Controls_pOnLayouting',
  pAppOnRequestPermissionResult name 'Java_com_mars42_jsNote_Controls_'
   +'pAppOnRequestPermissionResult',
  pOnRunOnUiThread name 'Java_com_mars42_jsNote_Controls_pOnRunOnUiThread',
  pOnCustomDialogShow name
   'Java_com_mars42_jsNote_Controls_pOnCustomDialogShow',
  pOnCustomDialogBackKeyPressed name 'Java_com_mars42_jsNote_Controls_'
   +'pOnCustomDialogBackKeyPressed',
  pEditTextOnActionIconTouchUp name 'Java_com_mars42_jsNote_Controls_'
   +'pEditTextOnActionIconTouchUp',
  pEditTextOnActionIconTouchDown name 'Java_com_mars42_jsNote_Controls_'
   +'pEditTextOnActionIconTouchDown',
  pOnImageViewPopupItemSelected name 'Java_com_mars42_jsNote_Controls_'
   +'pOnImageViewPopupItemSelected',
  pOnClickWidgetItem name 'Java_com_mars42_jsNote_Controls_pOnClickWidgetItem',
  pOnClickImageItem name 'Java_com_mars42_jsNote_Controls_pOnClickImageItem',
  pOnClickCaptionItem name
   'Java_com_mars42_jsNote_Controls_pOnClickCaptionItem',
  pOnClickItemTextLeft name 'Java_com_mars42_jsNote_Controls_'
   +'pOnClickItemTextLeft',
  pOnClickItemTextCenter name 'Java_com_mars42_jsNote_Controls_'
   +'pOnClickItemTextCenter',
  pOnClickItemTextRight name 'Java_com_mars42_jsNote_Controls_'
   +'pOnClickItemTextRight',
  pOnListViewLongClickCaptionItem name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewLongClickCaptionItem',
  pOnListViewDrawItemCaptionColor name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewDrawItemCaptionColor',
  pOnListViewDrawItemCustomFont name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewDrawItemCustomFont',
  pOnListViewDrawItemBackgroundColor name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewDrawItemBackgroundColor',
  pOnListViewDrawItemBitmap name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewDrawItemBitmap',
  pOnWidgeItemLostFocus name 'Java_com_mars42_jsNote_Controls_'
   +'pOnWidgeItemLostFocus',
  pOnListViewScrollStateChanged name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewScrollStateChanged',
  pOnListViewDrawItemWidgetTextColor name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewDrawItemWidgetTextColor',
  pOnListViewDrawItemWidgetText name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewDrawItemWidgetText',
  pOnListViewDrawItemWidgetImage name 'Java_com_mars42_jsNote_Controls_'
   +'pOnListViewDrawItemWidgetImage',
  pOnMediaPlayerPrepared name 'Java_com_mars42_jsNote_Controls_'
   +'pOnMediaPlayerPrepared',
  pOnMediaPlayerVideoSizeChanged name 'Java_com_mars42_jsNote_Controls_'
   +'pOnMediaPlayerVideoSizeChanged',
  pOnMediaPlayerCompletion name 'Java_com_mars42_jsNote_Controls_'
   +'pOnMediaPlayerCompletion',
  pOnMediaPlayerTimedText name 'Java_com_mars42_jsNote_Controls_'
   +'pOnMediaPlayerTimedText',
  pOnMidiManagerDeviceAdded name 'Java_com_mars42_jsNote_Controls_'
   +'pOnMidiManagerDeviceAdded',
  pOnMidiManagerDeviceRemoved name 'Java_com_mars42_jsNote_Controls_'
   +'pOnMidiManagerDeviceRemoved',
  pOnFileSelected name 'Java_com_mars42_jsNote_Controls_pOnFileSelected',
  pRadioGroupCheckedChanged name 'Java_com_mars42_jsNote_Controls_'
   +'pRadioGroupCheckedChanged',
  pOnSqliteDataAccessAsyncPostExecute name 'Java_com_mars42_jsNote_Controls_'
   +'pOnSqliteDataAccessAsyncPostExecute',
  pOnWebViewStatus name 'Java_com_mars42_jsNote_Controls_pOnWebViewStatus',
  pOnWebViewFindResultReceived name 'Java_com_mars42_jsNote_Controls_'
   +'pOnWebViewFindResultReceived',
  pOnWebViewEvaluateJavascriptResult name 'Java_com_mars42_jsNote_Controls_'
   +'pOnWebViewEvaluateJavascriptResult',
  pOnWebViewReceivedSslError name 'Java_com_mars42_jsNote_Controls_'
   +'pOnWebViewReceivedSslError';

{%endregion}

begin
  gApp:= jApp.Create(nil);{AndroidWidget.pas}
  gApp.Title:= 'jsNote';
  gjAppName:= 'com.mars42.jsNote';{AndroidWidget.pas}
  gjClassName:= 'com/mars42/jsNote/Controls';{AndroidWidget.pas}
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(TfChants, fChants);
end.
