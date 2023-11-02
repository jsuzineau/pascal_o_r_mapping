unit ufjsExplorer;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 StdCtrls, JSONPropStorage, ComCtrls,
 uEXE_INI;

type

 { TfjsExplorer }

 TfjsExplorer = class(TForm)
  bAdd: TButton;
  bCLI: TButton;
  bExplore: TButton;
  bTortoiseGitSync: TButton;
  eTortoiseGitProc: TEdit;
  jps: TJSONPropStorage;
  Label1: TLabel;
  lb: TListBox;
  Panel1: TPanel;
  pc: TPageControl;
  pUbuntu_bash: TProcess;
  pWindows_CLI: TProcess;
  pWindows_Explorer: TProcess;
  pUbuntu_pcmanfm: TProcess;
  pUbuntu_git_gui: TProcess;
  pWindows_TortoiseGitSync: TProcess;
  sd: TSelectDirectoryDialog;
  tsConfig: TTabSheet;
  tsRun: TTabSheet;
  procedure bCLIClick(Sender: TObject);
  procedure bExploreClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure jpsRestoringProperties(Sender: TObject);
  procedure bAddClick(Sender: TObject);
  procedure bTortoiseGitSyncClick(Sender: TObject);
 private
  Directory: String;
  function not_Directory_Get: Boolean;
 public

 end;

var
 fjsExplorer: TfjsExplorer;

implementation

{$R *.lfm}

{ TfjsExplorer }

procedure TfjsExplorer.jpsRestoringProperties(Sender: TObject);
begin
     ForceDirectories( ExtractFileDir( EXE_INI_Nom));
     jps.JSONFileName:= ChangeFileExt( EXE_INI_Nom, '.'+EXE_INI.os+'json');
end;

procedure TfjsExplorer.FormCreate(Sender: TObject);
begin
     jps.Restore;
end;

procedure TfjsExplorer.bAddClick(Sender: TObject);
begin
     if not sd.Execute then exit;
     Directory:= sd.FileName;

     lb.AddItem( Directory, nil);
end;

function TfjsExplorer.not_Directory_Get: Boolean;
begin
     Result:= 1 <> lb.SelCount;
     if Result then exit;

     Directory:= lb.GetSelectedText;
     Result:= '' = Directory;
end;

procedure TfjsExplorer.bTortoiseGitSyncClick(Sender: TObject);
begin
     if not_Directory_Get then exit;

     {$IFDEF LINUX}
       pUbuntu_git_gui.CurrentDirectory:= Directory;
       pUbuntu_git_gui.Execute;
     {$ELSE}
       pWindows_TortoiseGitSync.CurrentDirectory:= Directory;
       pWindows_TortoiseGitSync.Executable:= eTortoiseGitProc.Text;
       pWindows_TortoiseGitSync.Execute;
     {$ENDIF};
end;

procedure TfjsExplorer.bExploreClick(Sender: TObject);
begin
     if not_Directory_Get then exit;
     {$IFDEF LINUX}
       pUbuntu_pcmanfm.CurrentDirectory:= Directory;
       pUbuntu_pcmanfm.Execute;
     {$ELSE}
       pWindows_Explorer.Parameters.Text:= '/root,"'+Directory+'"';
       pWindows_Explorer.Execute;
     {$ENDIF};
end;

procedure TfjsExplorer.bCLIClick(Sender: TObject);
begin
     if not_Directory_Get then exit;
     {$IFDEF LINUX}
       pUbuntu_bash.CurrentDirectory:= Directory;
       pUbuntu_bash.Execute;
     {$ELSE}
       pWindows_CLI.CurrentDirectory:= Directory;
       pWindows_CLI.Execute;
     {$ENDIF};
end;

end.


