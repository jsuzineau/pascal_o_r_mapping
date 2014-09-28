unit ShlObj;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
  Classes, SysUtils, Windows,Messages;

{$HPPEMIT '// If problems occur when compiling win32 structs, records, or'}
{$HPPEMIT '// unions, please define NO_WIN32_LEAN_AND_MEAN to force inclusion'}
{$HPPEMIT '// of Windows header files. '}

{$HPPEMIT '#if defined(NO_WIN32_LEAN_AND_MEAN)'}
{$HPPEMIT '#include <ole2.h>'}
{$HPPEMIT '#include <prsht.h>'}
{$HPPEMIT '#include <commctrl.h>   // for LPTBBUTTON'}
{$HPPEMIT '#include <shlguid.h>'}
{$HPPEMIT '#include <shlobj.h>'}
{$HPPEMIT '#include <shldisp.h>'}
{$HPPEMIT '#endif'}

{$HPPEMIT '#if !defined(NO_WIN32_LEAN_AND_MEAN)'}
{$HPPEMIT 'interface DECLSPEC_UUID("0000010f-0000-0000-C000-000000000046") IAdviseSink;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e2-0000-0000-c000-000000000046") IShellBrowser;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e3-0000-0000-c000-000000000046") IShellView;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e4-0000-0000-c000-000000000046") IContextMenu;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e5-0000-0000-c000-000000000046") IShellIcon;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e6-0000-0000-c000-000000000046") IShellFolder;'}
{$HPPEMIT 'interface DECLSPEC_UUID("93f2f68c-1d1b-11d3-A30e-00c04f79abd1") IShellFolder2;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214EC-0000-0000-C000-000000000046") IShellDetails;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e8-0000-0000-c000-000000000046") IShellExtInit;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e9-0000-0000-c000-000000000046") IShellPropSheetExt;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214ea-0000-0000-c000-000000000046") IPersistFolder;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f1-0000-0000-c000-000000000046") ICommDlgBrowser;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f2-0000-0000-c000-000000000046") IEnumIDList;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f3-0000-0000-c000-000000000046") IFileViewerSite;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f4-0000-0000-c000-000000000046") IContextMenu2;'}
{$HPPEMIT 'interface DECLSPEC_UUID("88e39e80-3578-11cf-ae69-08002b2e1262") IShellView2;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214e1-0000-0000-c000-000000000046") INewShortcutHookA;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f7-0000-0000-c000-000000000046") INewShortcutHookW;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f0-0000-0000-c000-000000000046") IFileViewerA;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f8-0000-0000-c000-000000000046") IFileViewerW;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214ee-0000-0000-c000-000000000046") IShellLinkA;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f9-0000-0000-c000-000000000046") IShellLinkW;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214eb-0000-0000-c000-000000000046") IExtractIconA;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214fa-0000-0000-c000-000000000046") IExtractIconW;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214f5-0000-0000-c000-000000000046") IShellExecuteHookA;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214fb-0000-0000-c000-000000000046") IShellExecuteHookW;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214EF-0000-0000-c000-000000000046") ICopyHookA;'}
{$HPPEMIT 'interface DECLSPEC_UUID("000214FC-0000-0000-c000-000000000046") ICopyHookW;'}
{$HPPEMIT 'interface DECLSPEC_UUID("00bb2762-6a77-11d0-a535-00c04fd7d062") IAutoComplete;'}
{$HPPEMIT 'interface DECLSPEC_UUID("EAC04BC0-3791-11d2-BB95-0060977B464C") IAutoComplete2;'}
{$HPPEMIT '#endif'}

{$HPPEMIT 'typedef System::DelphiInterface<IAdviseSink> _di_IAdviseSink;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellBrowser> _di_IShellBrowser;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellView> _di_IShellView;'}
{$HPPEMIT 'typedef System::DelphiInterface<IContextMenu> _di_IContextMenu;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellIcon> _di_IShellIcon;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellFolder> _di_IShellFolder;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellFolder2> _di_IShellFolder2;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellDetails> _di_IShellDetails;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellExtInit> _di_IShellExtInit;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellPropSheetExt> _di_IShellPropSheetExt;'}
{$HPPEMIT 'typedef System::DelphiInterface<IPersistFolder> _di_IPersistFolder;'}
{$HPPEMIT 'typedef System::DelphiInterface<ICommDlgBrowser> _di_ICommDlgBrowser;'}
{$HPPEMIT 'typedef System::DelphiInterface<IEnumIDList> _di_IEnumIDList;'}
{$HPPEMIT 'typedef System::DelphiInterface<IFileViewerSite> _di_IFileViewerSite;'}
{$HPPEMIT 'typedef System::DelphiInterface<IContextMenu2> _di_IContextMenu2;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellView2> _di_IShellView2;'}
{$HPPEMIT 'typedef System::DelphiInterface<INewShortcutHookA> _di_INewShortcutHookA;'}
{$HPPEMIT 'typedef System::DelphiInterface<INewShortcutHookW> _di_INewShortcutHookW;'}
{$HPPEMIT 'typedef System::DelphiInterface<IFileViewerA> _di_IFileViewerA;'}
{$HPPEMIT 'typedef System::DelphiInterface<IFileViewerW> _di_IFileViewerW;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellLinkA> _di_IShellLinkA;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellLinkW> _di_IShellLinkW;'}
{$HPPEMIT 'typedef System::DelphiInterface<IExtractIconA> _di_IExtractIconA;'}
{$HPPEMIT 'typedef System::DelphiInterface<IExtractIconW> _di_IExtractIconW;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellExecuteHookA> _di_IShellExecuteHookA;'}
{$HPPEMIT 'typedef System::DelphiInterface<IShellExecuteHookW> _di_IShellExecuteHookW;'}
{$HPPEMIT 'typedef System::DelphiInterface<ICopyHookA> _di_ICopyHookA;'}
{$HPPEMIT 'typedef System::DelphiInterface<ICopyHookW> _di_ICopyHookW;'}
{$HPPEMIT 'typedef System::DelphiInterface<IAutoComplete> _di_IAutoComplete;'}
{$HPPEMIT 'typedef System::DelphiInterface<IAutoComplete2> _di_IAutoComplete2;'}

{$HPPEMIT '#ifdef UNICODE'}
{$HPPEMIT 'typedef _di_INewShortcutHookW _di_INewShortcutHook;'}
{$HPPEMIT 'typedef _di_IFileViewerW _di_IFileViewer;'}
{$HPPEMIT 'typedef _di_IShellLinkW _di_IShellLink;'}
{$HPPEMIT 'typedef _di_IExtractIconW _di_IExtractIcon;'}
{$HPPEMIT 'typedef _di_IShellExecuteHookW _di_IShellExecuteHook;'}
{$HPPEMIT 'typedef _di_ICopyHookW _di_ICopyHook;'}
{$HPPEMIT '#else'}
{$HPPEMIT 'typedef _di_INewShortcutHookA _di_INewShortcutHook;'}
{$HPPEMIT 'typedef _di_IFileViewerA _di_IFileViewer;'}
{$HPPEMIT 'typedef _di_IShellLinkA _di_IShellLink;'}
{$HPPEMIT 'typedef _di_IExtractIconA _di_IExtractIcon;'}
{$HPPEMIT 'typedef _di_IShellExecuteHookA _di_IShellExecuteHook;'}
{$HPPEMIT 'typedef _di_ICopyHookA _di_ICopyHook;'}
{$HPPEMIT '#endif'}

{$HPPEMIT '#if !defined(NO_WIN32_LEAN_AND_MEAN)'}
{$HPPEMIT 'struct _SHITEMID;'}
{$HPPEMIT 'struct _ITEMIDLIST;'}
{$HPPEMIT 'struct _CMINVOKECOMMANDINFO;'}
{$HPPEMIT 'struct _CMInvokeCommandInfoEx;'}
{$HPPEMIT 'struct FVSHOWINFO;'}
{$HPPEMIT 'struct FOLDERSETTINGS;'}
{$HPPEMIT 'struct _SV2CVW2_PARAMS;'}
{$HPPEMIT 'struct _STRRET;'}
{$HPPEMIT 'struct _SHELLDETAILS;'}
{$HPPEMIT 'struct DESKBANDINFO;'}
{$HPPEMIT 'struct _NRESARRAY;'}
{$HPPEMIT 'struct _IDA;'}
{$HPPEMIT 'struct _FILEDESCRIPTORA;'}
{$HPPEMIT 'struct _FILEDESCRIPTORW;'}
{$HPPEMIT 'struct _FILEGROUPDESCRIPTORW;'}
{$HPPEMIT 'struct _FILEGROUPDESCRIPTORA;'}
{$HPPEMIT 'struct _DROPFILES;'}
{$HPPEMIT 'struct _SHDESCRIPTIONID;'}
{$HPPEMIT 'struct SHELLFLAGSTATE;'}
{$HPPEMIT 'struct _browseinfoA;'}
{$HPPEMIT 'struct _browseinfoW;'}
{$HPPEMIT '#endif'}

{ Object identifiers in the explorer's name space (ItemID and IDList)
  All the items that the user can browse with the explorer (such as files,
  directories, servers, work-groups, etc.) has an identifier which is unique
  among items within the parent folder. Those identifiers are called item
  IDs (SHITEMID). Since all its parent folders have their own item IDs,
  any items can be uniquely identified by a list of item IDs, which is called
  an ID list (ITEMIDLIST).

  ID lists are almost always allocated by the task allocator (see some
  description below as well as OLE 2.0 SDK) and may be passed across
  some of shell interfaces (such as IShellFolder). Each item ID in an ID list
  is only meaningful to its parent folder (which has generated it), and all
  the clients must treat it as an opaque binary data except the first two
  bytes, which indicates the size of the item ID.

  When a shell extension -- which implements the IShellFolder interace --
  generates an item ID, it may put any information in it, not only the data
  with that it needs to identifies the item, but also some additional
  information, which would help implementing some other functions efficiently.
  For example, the shell's IShellFolder implementation of file system items
  stores the primary (long) name of a file or a directory as the item
  identifier, but it also stores its alternative (short) name, size and date
  etc.

  When an ID list is passed to one of shell APIs (such as SHGetPathFromIDList),
  it is always an absolute path -- relative from the root of the name space,
  which is the desktop folder. When an ID list is passed to one of IShellFolder
  member function, it is always a relative path from the folder (unless it
  is explicitly specified). }

const
// Class IDs        xx=00-9F
  {$EXTERNALSYM CLSID_ShellDesktop}
  CLSID_ShellDesktop: TGUID = (
    D1:$00021400; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM CLSID_ShellLink}
  CLSID_ShellLink: TGUID = (
    D1:$00021401; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  CLSID_ActiveDesktop: TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';

// Format IDs       xx=A0-CF
  {$EXTERNALSYM FMTID_Intshcut}
  FMTID_Intshcut: TGUID = (
    D1:$000214A0; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM FMTID_InternetSite}
  FMTID_InternetSite: TGUID = (
    D1:$000214A1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

// command group ids xx=D0-DF
  {$EXTERNALSYM CGID_Explorer}
  CGID_Explorer: TGUID = (
    D1:$000214D0; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM CGID_ShellDocView}
  CGID_ShellDocView: TGUID = (
    D1:$000214D1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

// Interface IDs    xx=E0-FF
  {$EXTERNALSYM IID_INewShortcutHookA}
  IID_INewShortcutHookA: TGUID = (
    D1:$000214E1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellBrowser}
  IID_IShellBrowser: TGUID = (
    D1:$000214E2; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellView}
  IID_IShellView: TGUID = (
    D1:$000214E3; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IContextMenu}
  IID_IContextMenu: TGUID = (
    D1:$000214E4; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellIcon}
  IID_IShellIcon: TGUID = (
    D1:$000214E5; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellFolder}
  IID_IShellFolder: TGUID = (
    D1:$000214E6; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellExtInit}
  IID_IShellExtInit: TGUID = (
    D1:$000214E8; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellPropSheetExt}
  IID_IShellPropSheetExt: TGUID = (
    D1:$000214E9; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IPersistFolder}
  IID_IPersistFolder: TGUID = (
    D1:$000214EA; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IExtractIconA}
  IID_IExtractIconA: TGUID = (
    D1:$000214EB; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellLinkA}
  IID_IShellLinkA: TGUID = (
    D1:$000214EE; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellCopyHookA}
  IID_IShellCopyHookA: TGUID = (
    D1:$000214EF; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IFileViewerA}
  IID_IFileViewerA: TGUID = (
    D1:$000214F0; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_ICommDlgBrowser}
  IID_ICommDlgBrowser: TGUID = (
    D1:$000214F1; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumIDList}
  IID_IEnumIDList: TGUID = (
    D1:$000214F2; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IFileViewerSite}
  IID_IFileViewerSite: TGUID = (
    D1:$000214F3; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IContextMenu2}
  IID_IContextMenu2: TGUID = (
    D1:$000214F4; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellExecuteHook}
  IID_IShellExecuteHook: TGUID = (
    D1:$000214F5; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IPropSheetPage}
  IID_IPropSheetPage: TGUID = (
    D1:$000214F6; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_INewShortcutHookW}
  IID_INewShortcutHookW: TGUID = (
    D1:$000214F7; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IFileViewerW}
  IID_IFileViewerW: TGUID = (
    D1:$000214F8; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellLinkW}
  IID_IShellLinkW: TGUID = (
    D1:$000214F9; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IExtractIconW}
  IID_IExtractIconW: TGUID = (
    D1:$000214FA; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellExecuteHookW}
  IID_IShellExecuteHookW: TGUID = (
    D1:$000214FB; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellCopyHookW}
  IID_IShellCopyHookW: TGUID = (
    D1:$000214FC; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IShellView2}
  IID_IShellView2: TGUID = (
    D1:$88E39E80; D2:$3578; D3:$11CF; D4:($AE,$69,$08,$00,$2B,$2E,$12,$62));
  {$EXTERNALSYM IID_IShellFolder2}
  IID_IShellFolder2: TGUID = (
    D1:$93F2F68C; D2:$1D1B; D3:$11D3; D4:($A3,$0E,$00,$C0,$4F,$79,$AB,$D1));
  {$EXTERNALSYM IID_IShellDetails}
  IID_IShellDetails: TGUID = (
    D1:$000214EC; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumExtraSearch}
  IID_IEnumExtraSearch: TGUID = (
    D1:$E700BE1; D2: $9DB6; D3:$11D1; D4:($A1,$CE,$00,$C0,$4F,$D7,$5D,$13));


// String constants for Interface IDs
  SID_INewShortcutHookA  = '{000214E1-0000-0000-C000-000000000046}';
  SID_IShellBrowser      = '{000214E2-0000-0000-C000-000000000046}';
  SID_IShellView         = '{000214E3-0000-0000-C000-000000000046}';
  SID_IContextMenu       = '{000214E4-0000-0000-C000-000000000046}';
  SID_IShellIcon         = '{000214E5-0000-0000-C000-000000000046}';
  SID_IShellFolder       = '{000214E6-0000-0000-C000-000000000046}';
  SID_IShellExtInit      = '{000214E8-0000-0000-C000-000000000046}';
  SID_IShellPropSheetExt = '{000214E9-0000-0000-C000-000000000046}';
  SID_IPersistFolder     = '{000214EA-0000-0000-C000-000000000046}';
  SID_IExtractIconA      = '{000214EB-0000-0000-C000-000000000046}';
  SID_IShellLinkA        = '{000214EE-0000-0000-C000-000000000046}';
  SID_IShellCopyHookA    = '{000214EF-0000-0000-C000-000000000046}';
  SID_IFileViewerA       = '{000214F0-0000-0000-C000-000000000046}';
  SID_ICommDlgBrowser    = '{000214F1-0000-0000-C000-000000000046}';
  SID_IEnumIDList        = '{000214F2-0000-0000-C000-000000000046}';
  SID_IFileViewerSite    = '{000214F3-0000-0000-C000-000000000046}';
  SID_IContextMenu2      = '{000214F4-0000-0000-C000-000000000046}';
  SID_IShellExecuteHookA = '{000214F5-0000-0000-C000-000000000046}';
  SID_IPropSheetPage     = '{000214F6-0000-0000-C000-000000000046}';
  SID_INewShortcutHookW  = '{000214F7-0000-0000-C000-000000000046}';
  SID_IFileViewerW       = '{000214F8-0000-0000-C000-000000000046}';
  SID_IShellLinkW        = '{000214F9-0000-0000-C000-000000000046}';
  SID_IExtractIconW      = '{000214FA-0000-0000-C000-000000000046}';
  SID_IShellExecuteHookW = '{000214FB-0000-0000-C000-000000000046}';
  SID_IShellCopyHookW    = '{000214FC-0000-0000-C000-000000000046}';
  SID_IShellView2        = '{88E39E80-3578-11CF-AE69-08002B2E1262}';
  SID_IContextMenu3      = '{BCFCE0A0-EC17-11d0-8D10-00A0C90F2719}';
  SID_IPersistFolder2    = '{1AC3D9F0-175C-11d1-95BE-00609797EA4F}';
  SID_IShellIconOverlayIdentifier = '{0C6C4200-C589-11D0-999A-00C04FD655E1}';
  SID_IShellIconOverlay  = '{7D688A70-C613-11D0-999B-00C04FD655E1}';
  SID_IURLSearchHook     = '{AC60F6A0-0FD9-11D0-99CB-00C04FD64497}';
  SID_IInputObjectSite   = '{f1db8392-7331-11d0-8c99-00a0c92dbfe8}';
  SID_IInputObject       = '{68284faa-6a48-11d0-8c78-00c04fd918b4}';
  SID_IDockingWindowSite = '{2a342fc2-7b26-11d0-8ca9-00a0c92dbfe8}';
  SID_IDockingWindowFrame = '{47d2657a-7b27-11d0-8ca9-00a0c92dbfe8}';
  SID_IDockingWindow     = '{012dd920-7b26-11d0-8ca9-00a0c92dbfe8}';
  SID_IDeskBand          = '{EB0FE172-1A3A-11D0-89B3-00A0C90A90AC}';
  SID_IActiveDesktop     = '{F490EB00-1240-11D1-9888-006097DEACF9}';
  SID_IShellChangeNotify = '{00000000-0000-0000-0000-000000000000}';  // !!
  SID_IQueryInfo         = '{00021500-0000-0000-C000-000000000046}';
  SID_IShellDetails      = '{000214EC-0000-0000-C000-000000000046}';
  SID_IShellFolder2      = '{93F2F68C-1D1B-11D3-A30E-00C04F79ABD1}';
  SID_IEnumExtraSearch   = '{0E700BE1-9DB6-11D1-A1CE-00C04FD75D13}';

type
{ TSHItemID -- Item ID }
  PSHItemID = ^TSHItemID;
  {$EXTERNALSYM _SHITEMID}
  _SHITEMID = record
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;
  TSHItemID = _SHITEMID;
  {$EXTERNALSYM SHITEMID}
  SHITEMID = _SHITEMID;


{ TItemIDList -- List if item IDs (combined with 0-terminator) }
  PItemIDList = ^TItemIDList;
  {$EXTERNALSYM _ITEMIDLIST}
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  {$EXTERNALSYM ITEMIDLIST}
  ITEMIDLIST = _ITEMIDLIST;

const
{ QueryContextMenu uFlags }

  {$EXTERNALSYM CMF_NORMAL}
  CMF_NORMAL             = $00000000;
  {$EXTERNALSYM CMF_DEFAULTONLY}
  CMF_DEFAULTONLY        = $00000001;
  {$EXTERNALSYM CMF_VERBSONLY}
  CMF_VERBSONLY          = $00000002;
  {$EXTERNALSYM CMF_EXPLORE}
  CMF_EXPLORE            = $00000004;
  {$EXTERNALSYM CMF_NOVERBS}
  CMF_NOVERBS            = $00000008;
  {$EXTERNALSYM CMF_CANRENAME}
  CMF_CANRENAME          = $00000010;
  {$EXTERNALSYM CMF_NODEFAULT}
  CMF_NODEFAULT          = $00000020;
  {$EXTERNALSYM CMF_INCLUDESTATIC}
  CMF_INCLUDESTATIC      = $00000040;
  {$EXTERNALSYM CMF_RESERVED}
  CMF_RESERVED           = $FFFF0000;      { View specific }

{ GetCommandString uFlags }

  {$EXTERNALSYM GCS_VERBA}
  GCS_VERBA            = $00000000;     { canonical verb }
  {$EXTERNALSYM GCS_HELPTEXTA}
  GCS_HELPTEXTA        = $00000001;     { help text (for status bar) }
  {$EXTERNALSYM GCS_VALIDATEA}
  GCS_VALIDATEA        = $00000002;     { validate command exists }
  {$EXTERNALSYM GCS_VERBW}
  GCS_VERBW            = $00000004;     { canonical verb (unicode) }
  {$EXTERNALSYM GCS_HELPTEXTW}
  GCS_HELPTEXTW        = $00000005;     { help text (unicode version) }
  {$EXTERNALSYM GCS_VALIDATEW}
  GCS_VALIDATEW        = $00000006;     { validate command exists (unicode) }
  {$EXTERNALSYM GCS_UNICODE}
  GCS_UNICODE          = $00000004;     { for bit testing - Unicode string }









  {$EXTERNALSYM GCS_VERB}
  GCS_VERB            = GCS_VERBA;
  {$EXTERNALSYM GCS_HELPTEXT}
  GCS_HELPTEXT        = GCS_HELPTEXTA;
  {$EXTERNALSYM GCS_VALIDATE}
  GCS_VALIDATE        = GCS_VALIDATEA;


  {$EXTERNALSYM CMDSTR_NEWFOLDERA}
  CMDSTR_NEWFOLDERA       = 'NewFolder';
  {$EXTERNALSYM CMDSTR_VIEWLISTA}
  CMDSTR_VIEWLISTA        = 'ViewList';
  {$EXTERNALSYM CMDSTR_VIEWDETAILSA}
  CMDSTR_VIEWDETAILSA     = 'ViewDetails';
  {$EXTERNALSYM CMDSTR_NEWFOLDERW}
  CMDSTR_NEWFOLDERW       = 'NewFolder'; // !!! make WideString() ?
  {$EXTERNALSYM CMDSTR_VIEWLISTW}
  CMDSTR_VIEWLISTW        = 'ViewList';
  {$EXTERNALSYM CMDSTR_VIEWDETAILSW}
  CMDSTR_VIEWDETAILSW     = 'ViewDetails';









  {$EXTERNALSYM CMDSTR_NEWFOLDER}
  CMDSTR_NEWFOLDER        = CMDSTR_NEWFOLDERA;
  {$EXTERNALSYM CMDSTR_VIEWLIST}
  CMDSTR_VIEWLIST         = CMDSTR_VIEWLISTA;
  {$EXTERNALSYM CMDSTR_VIEWDETAILS}
  CMDSTR_VIEWDETAILS      = CMDSTR_VIEWDETAILSA;



  {$EXTERNALSYM CMIC_MASK_PTINVOKE}
  CMIC_MASK_PTINVOKE          = $20000000;

type
  // NOTE: When SEE_MASK_HMONITOR is set, hIcon is treated as hMonitor
  PCMInvokeCommandInfo = ^TCMInvokeCommandInfo;
  {$EXTERNALSYM _CMINVOKECOMMANDINFO}
  _CMINVOKECOMMANDINFO = record
    cbSize: DWORD;        { must be sizeof(CMINVOKECOMMANDINFO) }
    fMask: DWORD;         { any combination of CMIC_MASK_* }
    hwnd: HWND;           { might be NULL (indicating no owner window) }
    lpVerb: LPCSTR;       { either a string of MAKEINTRESOURCE(idOffset) }
    lpParameters: LPCSTR; { might be NULL (indicating no parameter) }
    lpDirectory: LPCSTR;  { might be NULL (indicating no specific directory) }
    nShow: Integer;       { one of SW_ values for ShowWindow() API }
    dwHotKey: DWORD;
    hIcon: THandle;
  end;
  TCMInvokeCommandInfo = _CMINVOKECOMMANDINFO;
  {$EXTERNALSYM CMINVOKECOMMANDINFO}
  CMINVOKECOMMANDINFO = _CMINVOKECOMMANDINFO;

  PCMInvokeCommandInfoEx = ^TCMInvokeCommandInfoEx;
  {$EXTERNALSYM _CMInvokeCommandInfoEx}
  _CMInvokeCommandInfoEx = record
    cbSize: DWORD;       { must be sizeof(CMINVOKECOMMANDINFOEX) }
    fMask: DWORD;        { any combination of CMIC_MASK_* }
    hwnd: HWND;          { might be NULL (indicating no owner window) }
    lpVerb: LPCSTR;      { either a string or MAKEINTRESOURCE(idOffset) }
    lpParameters: LPCSTR;{ might be NULL (indicating no parameter) }
    lpDirectory: LPCSTR; { might be NULL (indicating no specific directory) }
    nShow: Integer;      { one of SW_ values for ShowWindow() API }
    dwHotKey: DWORD;
    hIcon: THandle;
    lpTitle: LPCSTR;        { For CreateProcess-StartupInfo.lpTitle }
    lpVerbW: LPCWSTR;       { Unicode verb (for those who can use it) }
    lpParametersW: LPCWSTR; { Unicode parameters (for those who can use it) }
    lpDirectoryW: LPCWSTR;  { Unicode directory (for those who can use it) }
    lpTitleW: LPCWSTR;      { Unicode title (for those who can use it) }
    ptInvoke: TPoint;       { Point where it's invoked }
  end;
  TCMInvokeCommandInfoEx = _CMINVOKECOMMANDINFOEX;
  {$EXTERNALSYM CMINVOKECOMMANDINFOEX}
  CMINVOKECOMMANDINFOEX = _CMINVOKECOMMANDINFOEX;


  {$EXTERNALSYM IContextMenu}
  IContextMenu = interface(IUnknown)
    [SID_IContextMenu]
    function QueryContextMenu(Menu: HMENU;
      indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
  end;

{ IContextMenu2 (IContextMenu with one new member) }
{ IContextMenu2.HandleMenuMsg }

{  This function is called, if the client of IContextMenu is aware of }
{ IContextMenu2 interface and receives one of following messages while }
{ it is calling TrackPopupMenu (in the window proc of hwndOwner): }
{      WM_INITPOPUP, WM_DRAWITEM and WM_MEASUREITEM }
{  The callee may handle these messages to draw owner draw menuitems. }

  {$EXTERNALSYM IContextMenu2}
  IContextMenu2 = interface(IContextMenu)
    [SID_IContextMenu2]
    function HandleMenuMsg(uMsg: UINT; WParam, LParam: Integer): HResult; stdcall;
  end;

{ IContextMenu3 (IContextMenu2 with one new member }
{ IContextMenu3::HandleMenuMsg2 }

{  This function is called, if the client of IContextMenu is aware of }
{ IContextMenu3 interface and receives a menu message while }
{ it is calling TrackPopupMenu (in the window proc of hwndOwner): }

  {$EXTERNALSYM IContextMenu3}
  IContextMenu3 = interface(IContextMenu2)
    [SID_IContextMenu3]
    function HandleMenuMsg2(uMsg: UINT; wParam, lParam: Integer;
      var lpResult: Integer): HResult; stdcall;
  end;

{ Interface: IShellExtInit }

{ The IShellExtInit interface is used by the explorer to initialize shell
  extension objects. The explorer (1) calls CoCreateInstance (or equivalent)
  with the registered CLSID and IID_IShellExtInit, (2) calls its Initialize
  member, then (3) calls its QueryInterface to a particular interface (such
  as IContextMenu or IPropSheetExt and (4) performs the rest of operation. }

{ [Member functions] }

{ IShellExtInit.Initialize }

{ This member function is called when the explorer is initializing either
  context menu extension, property sheet extension or non-default drag-drop
  extension.

  Parameters: (context menu or property sheet extension)
   pidlFolder -- Specifies the parent folder
   lpdobj -- Spefifies the set of items selected in that folder.
   hkeyProgID -- Specifies the type of the focused item in the selection.

  Parameters: (non-default drag-and-drop extension)
   pidlFolder -- Specifies the target (destination) folder
   lpdobj -- Specifies the items that are dropped (see the description
    about shell's clipboard below for clipboard formats).
   hkeyProgID -- Specifies the folder type. }


{=========================================================================== }

{ Interface: IShellPropSheetExt }

{ The explorer uses the IShellPropSheetExt to allow property sheet
  extensions or control panel extensions to add additional property
  sheet pages. }

{ [Member functions] }

{ IShellPropSheetExt.AddPages }

{ The explorer calls this member function when it finds a registered
  property sheet extension for a particular type of object. For each
  additional page, the extension creates a page object by calling
  CreatePropertySheetPage API and calls lpfnAddPage.

   Parameters:
    lpfnAddPage -- Specifies the callback function.
    lParam -- Specifies the opaque handle to be passed to the callback function. }


{ IShellPropSheetExt.ReplacePage }

{ The explorer never calls this member of property sheet extensions. The
  explorer calls this member of control panel extensions, so that they
  can replace some of default control panel pages (such as a page of
  mouse control panel).

   Parameters:
    uPageID -- Specifies the page to be replaced.
    lpfnReplace Specifies the callback function.
    lParam -- Specifies the opaque handle to be passed to the callback function. }


{ IPersistFolder Interface }
{  The IPersistFolder interface is used by the file system implementation of }
{ IShellFolder::BindToObject when it is initializing a shell folder object. }

{ IPersistFolder::Initialize }
{  This member function is called when the explorer is initializing a }
{ shell folder object. }
{  Parameters: }
{   pidl -- Specifies the absolute location of the folder. }


{ IExtractIcon interface }

{ This interface is used in two different places in the shell.

  Case-1: Icons of sub-folders for the scope-pane of the explorer.

   It is used by the explorer to get the 'icon location' of
  sub-folders from each shell folders. When the user expands a folder
  in the scope pane of the explorer, the explorer does following:
   (1) binds to the folder (gets IShellFolder),
   (2) enumerates its sub-folders by calling its EnumObjects member,
   (3) calls its GetUIObjectOf member to get IExtractIcon interface
      for each sub-folders.
   In this case, the explorer uses only IExtractIcon.GetIconLocation
  member to get the location of the appropriate icon. An icon location
  always consists of a file name (typically DLL or EXE) and either an icon
  resource or an icon index.


  Case-2: Extracting an icon image from a file

   It is used by the shell when it extracts an icon image
  from a file. When the shell is extracting an icon from a file,
  it does following:
   (1) creates the icon extraction handler object (by getting its CLSID
      under the beginProgIDend\shell\ExtractIconHanler key and calling
      CoCreateInstance requesting for IExtractIcon interface).
   (2) Calls IExtractIcon.GetIconLocation.
   (3) Then, calls IExtractIcon.Extract with the location/index pair.
   (4) If (3) returns NOERROR, it uses the returned icon.
   (5) Otherwise, it recursively calls this logic with new location
      assuming that the location string contains a fully qualified path name.

   From extension programmer's point of view, there are only two cases
  where they provide implementations of IExtractIcon:
   Case-1) providing explorer extensions (i.e., IShellFolder).
   Case-2) providing per-instance icons for some types of files.

  Because Case-1 is described above, we'll explain only Case-2 here.

  When the shell is about display an icon for a file, it does following:
   (1) Finds its ProgID and ClassID.
   (2) If the file has a ClassID, it gets the icon location string from the
     'DefaultIcon' key under it. The string indicates either per-class
     icon (e.g., 'FOOBAR.DLL,2') or per-instance icon (e.g., '%1,1').
   (3) If a per-instance icon is specified, the shell creates an icon
     extraction handler object for it, and extracts the icon from it
     (which is described above).

   It is important to note that the shell calls IExtractIcon.GetIconLocation
  first, then calls IExtractIcon.Extract. Most application programs
  that support per-instance icons will probably store an icon location
  (DLL/EXE name and index/id) rather than an icon image in each file.
  In those cases, a programmer needs to implement only the GetIconLocation
  member and it Extract member simply returns S_FALSE. They need to
  implement Extract member only if they decided to store the icon images
  within files themselved or some other database (which is very rare). }

{ [Member functions] }

{ IExtractIcon.GetIconLocation }

{ This function returns an icon location.

  Parameters:
   uFlags     [in]  -- Specifies if it is opened or not (GIL_OPENICON or 0)
   szIconFile [out] -- Specifies the string buffer buffer for a location name.
   cchMax     [in]  -- Specifies the size of szIconFile (almost always MAX_PATH)
   piIndex    [out] -- Sepcifies the address of UINT for the index.
   pwFlags    [out] -- Returns GIL_* flags
  Returns:
   NOERROR, if it returns a valid location; S_FALSE, if the shell use a
   default icon.

  Notes: The location may or may not be a path to a file. The caller can
   not assume anything unless the subsequent Extract member call returns
   S_FALSE.

   if the returned location is not a path to a file, GIL_NOTFILENAME should
   be set in the returned flags. }

{ IExtractIcon.Extract }

{ This function extracts an icon image from a specified file.

  Parameters:
   pszFile [in] -- Specifies the icon location (typically a path to a file).
   nIconIndex [in] -- Specifies the icon index.
   phiconLarge [out] -- Specifies the HICON variable for large icon.
   phiconSmall [out] -- Specifies the HICON variable for small icon.
   nIconSize [in] -- Specifies the size icon required (size of large icon)
                     LOWORD is the requested large icon size
                     HIWORD is the requested small icon size
  Returns:
   NOERROR, if it extracted the from the file.
   S_FALSE, if the caller should extract from the file specified in the
           location. }

const
  {$EXTERNALSYM GIL_OPENICON}
  GIL_OPENICON         = $0001;      { allows containers to specify an "open" look }
  {$EXTERNALSYM GIL_FORSHELL}
  GIL_FORSHELL         = $0002;      { icon is to be displayed in a ShellFolder }
  {$EXTERNALSYM GIL_ASYNC}
  GIL_ASYNC            = $0020;      { this is an async extract, return E_ASYNC }

{ GetIconLocation() return flags }

  {$EXTERNALSYM GIL_SIMULATEDOC}
  GIL_SIMULATEDOC      = $0001;      { simulate this document icon for this }
  {$EXTERNALSYM GIL_PERINSTANCE}
  GIL_PERINSTANCE      = $0002;      { icons from this class are per instance (each file has its own) }
  {$EXTERNALSYM GIL_PERCLASS}
  GIL_PERCLASS         = $0004;      { icons from this class per class (shared for all files of this type) }
  {$EXTERNALSYM GIL_NOTFILENAME}
  GIL_NOTFILENAME      = $0008;      { location is not a filename, must call ::ExtractIcon }
  {$EXTERNALSYM GIL_DONTCACHE}
  GIL_DONTCACHE        = $0010;      { this icon should not be cached }



{ IShellIcon Interface }
{ Used to get a icon index for a IShellFolder object.

 This interface can be implemented by a IShellFolder, as a quick way to
 return the icon for a object in the folder.

 An instance of this interface is only created once for the folder, unlike
 IExtractIcon witch is created once for each object.

 If a ShellFolder does not implement this interface, the standard
 GetUIObject(....IExtractIcon) method will be used to get a icon
 for all objects.

 The following standard imagelist indexs can be returned:

      0   document (blank page) (not associated)
      1   document (with stuff on the page)
      2   application (exe, com, bat)
      3   folder (plain)
      4   folder (open)

 IShellIcon.GetIconOf(pidl, flags, lpIconIndex)

      pidl            object to get icon for.
      flags           GIL_* input flags (GIL_OPEN, ...)
      lpIconIndex     place to return icon index.

  returns:
      NOERROR, if lpIconIndex contains the correct system imagelist index.
      S_FALSE, if unable to get icon for this object, go through
               GetUIObject, IExtractIcon, methods. }


{ IShellIconOverlayIdentifier }
{
 Used to identify a file as a member of the group of files that have this specific
 icon overlay

 Users can create new IconOverlayIdentifiers and place them in the following registry
 location together with the Icon overlay image and their priority.
 HKEY_LOCAL_MACHINE "Software\\Microsoft\\Windows\\CurrentVersion\\ShellIconOverlayIdentifiers"

 The shell will enumerate through all IconOverlayIdentifiers at start, and prioritize
 them according to internal rules, in case the internal rules don't apply, we use their
 input priority

 IShellIconOverlayIdentifier:IsMemberOf(LPCWSTR pwszPath, DWORD dwAttrib)
      pwszPath        full path of the file
      dwAttrib        attribute of this file

  returns:
      S_OK,    if the file is a member
      S_FALSE, if the file is not a member
      E_FAIL,  if the operation failed due to bad WIN32_FIND_DATA

 IShellIconOverlayIdentifier::GetOverlayInfo(LPWSTR pwszIconFile, int * pIndex, DWORD * dwFlags) PURE;
      pszIconFile    the path of the icon file
      pIndex         Depend on the flags, this could contain the IconIndex or the Sytem Imagelist Index
      dwFlags        defined below

 IShellIconOverlayIdentifier::GetPriority(int * pIPriority) PURE;
      pIPriority     the priority of this Overlay Identifier
}


const
  {$EXTERNALSYM ISIOI_ICONFILE}
  ISIOI_ICONFILE            = $00000001;  // path is returned through pwszIconFile
  {$EXTERNALSYM ISIOI_ICONINDEX}
  ISIOI_ICONINDEX           = $00000002;  // icon index in pwszIconFile is returned through pIndex
  {$EXTERNALSYM ISIOI_SYSIMAGELISTINDEX}
  ISIOI_SYSIMAGELISTINDEX   = $00000004;  // system imagelist icon index is returned through pIndex

{ IShellIconOverlay }
{
 Used to return the icon overlay index or its icon index for an IShellFolder object,
 this is always implemented with IShellFolder

 IShellIconOverlay:GetOverlayIndex(LPCITEMIDLIST pidl, DWORD * pdwIndex)
      pidl            object to identify icon overlay for.
      pdwIndex        the Overlay Index in the system image list

 IShellIconOverlay:GetOverlayIconIndex(LPCITEMIDLIST pidl, DWORD * pdwIndex)
      pdwIconIndex    the Overlay Icon index in the system image list
 This method is only used for those who are interested in seeing the real bits
 of the Overlay Icon

  returns:
      S_OK,  if the index of an Overlay is found
      S_FALSE, if no Overlay exists for this file
      E_FAIL, if pidl is bad
}
type
  {$EXTERNALSYM IShellIconOverlay}
  IShellIconOverlay = interface(IUnknown)
    [SID_IShellIconOverlay]
    function GetOverlayIndex(pidl: PItemIDList; out pIndex: Integer): HResult; stdcall;
    function GetOverlayIconIndex(pidl: PItemIDList; out pIconIndex: Integer): HResult; stdcall;
  end;

{ IShellLink Interface }
const
  { IShellLink.Resolve fFlags }
  {$EXTERNALSYM SLR_NO_UI}
  SLR_NO_UI           = $0001;
  {$EXTERNALSYM SLR_ANY_MATCH}
  SLR_ANY_MATCH       = $0002;
  {$EXTERNALSYM SLR_UPDATE}
  SLR_UPDATE          = $0004;
  {$EXTERNALSYM SLR_NOUPDATE}
  SLR_NOUPDATE        = $0008;

  { IShellLink.GetPath fFlags }
  {$EXTERNALSYM SLGP_SHORTPATH}
  SLGP_SHORTPATH      = $0001;
  {$EXTERNALSYM SLGP_UNCPRIORITY}
  SLGP_UNCPRIORITY    = $0002;
  {$EXTERNALSYM SLGP_RAWPATH}
  SLGP_RAWPATH        = $0004;



{ SHBrowseForFolder API }

type
  {$EXTERNALSYM BFFCALLBACK}
  BFFCALLBACK = function(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
  TFNBFFCallBack = type BFFCALLBACK;

  PBrowseInfoA = ^TBrowseInfoA;
  PBrowseInfoW = ^TBrowseInfoW;
  PBrowseInfo = PBrowseInfoA;
  {$EXTERNALSYM _browseinfoA}
  _browseinfoA = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PAnsiChar;  { Return display name of item selected. }
    lpszTitle: PAnsiChar;      { text to go in the banner over the tree. }
    ulFlags: UINT;           { Flags that control the return stuff }
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;          { extra info that's passed back in callbacks }
    iImage: Integer;         { output var: where to return the Image index. }
  end;
  {$EXTERNALSYM _browseinfoW}
  _browseinfoW = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PWideChar;  { Return display name of item selected. }
    lpszTitle: PWideChar;      { text to go in the banner over the tree. }
    ulFlags: UINT;           { Flags that control the return stuff }
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;          { extra info that's passed back in callbacks }
    iImage: Integer;         { output var: where to return the Image index. }
  end;
  {$EXTERNALSYM _browseinfo}
  _browseinfo = _browseinfoA;
  TBrowseInfoA = _browseinfoA;
  TBrowseInfoW = _browseinfoW;
  TBrowseInfo = TBrowseInfoA;
  {$EXTERNALSYM BROWSEINFOA}
  BROWSEINFOA = _browseinfoA;
  {$EXTERNALSYM BROWSEINFOW}
  BROWSEINFOW = _browseinfoW;
  {$EXTERNALSYM BROWSEINFO}
  BROWSEINFO = BROWSEINFOA;

const
{ message from browser }

  {$EXTERNALSYM BFFM_INITIALIZED}
  BFFM_INITIALIZED       = 1;
  {$EXTERNALSYM BFFM_SELCHANGED}
  BFFM_SELCHANGED        = 2;
  {$EXTERNALSYM BFFM_VALIDATEFAILEDA}
  BFFM_VALIDATEFAILEDA   = 3;   { lParam:szPath ret:1(cont),0(EndDialog) }
  {$EXTERNALSYM BFFM_VALIDATEFAILEDW}
  BFFM_VALIDATEFAILEDW   = 4;   { lParam:wzPath ret:1(cont),0(EndDialog) }

  { messages to browser }

    {$EXTERNALSYM BFFM_SETSTATUSTEXTA}
    BFFM_SETSTATUSTEXTA         = WM_USER + 100;
    {$EXTERNALSYM BFFM_ENABLEOK}
    BFFM_ENABLEOK               = WM_USER + 101;
    {$EXTERNALSYM BFFM_SETSELECTIONA}
    BFFM_SETSELECTIONA          = WM_USER + 102;
    {$EXTERNALSYM BFFM_SETSELECTIONW}
    BFFM_SETSELECTIONW          = WM_USER + 103;
    {$EXTERNALSYM BFFM_SETSTATUSTEXTW}
    BFFM_SETSTATUSTEXTW         = WM_USER + 104;

    {$EXTERNALSYM BFFM_VALIDATEFAILED}
    BFFM_VALIDATEFAILED     = BFFM_VALIDATEFAILEDA;
    {$EXTERNALSYM BFFM_SETSTATUSTEXT}
    BFFM_SETSTATUSTEXT      = BFFM_SETSTATUSTEXTA;
    {$EXTERNALSYM BFFM_SETSELECTION}
    BFFM_SETSELECTION       = BFFM_SETSELECTIONA;

implementation

end.

