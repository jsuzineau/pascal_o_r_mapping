unit ufjsExplorer;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uPhi_Form,
 {$IFDEF MSWINDOWS}
 windows,
 {$ENDIF}
 Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 StdCtrls, JSONPropStorage, ComCtrls;

type

 { TfjsExplorer }

 TfjsExplorer = class(TForm)
  bAdd: TButton;
  bCLI: TButton;
  bExplore: TButton;
  bGIT_PULL: TButton;
  bGIT_STATUS: TButton;
  bjsWorks: TButton;
  bTortoiseGitSync: TButton;
  bWindows_CLI_cmd: TButton;
  bWindows_CLI_git_bash: TButton;
  bWindows_CLI_powershell: TButton;
  eTortoiseGitProc: TEdit;
  eUbuntu_CLI: TEdit;
  eWindows_CLI: TEdit;
  eWindows_GIT_BASH: TEdit;
  jps: TJSONPropStorage;
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  lb: TListBox;
  Panel1: TPanel;
  pc: TPageControl;
  pUbuntu_CLI: TProcess;
  pWindows_CLI: TProcess;
  pWindows_Explorer: TProcess;
  pUbuntu_pcmanfm: TProcess;
  pUbuntu_git_gui: TProcess;
  pjsWorks: TProcess;
  pWindows_TortoiseGitSync: TProcess;
  sd: TSelectDirectoryDialog;
  tsConfig: TTabSheet;
  tsRun: TTabSheet;
  procedure bCLIClick(Sender: TObject);
  procedure bExploreClick(Sender: TObject);
  procedure bGIT_PULLClick(Sender: TObject);
  procedure bGIT_STATUSClick(Sender: TObject);
  procedure bjsWorksClick(Sender: TObject);
  procedure bWindows_CLI_cmdClick(Sender: TObject);
  procedure bWindows_CLI_git_bashClick(Sender: TObject);
  procedure bWindows_CLI_powershellClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure jpsRestoringProperties(Sender: TObject);
  procedure bAddClick(Sender: TObject);
  procedure bTortoiseGitSyncClick(Sender: TObject);
 private
  Directory: String;
  function not_Directory_Get: Boolean;
  function Windows_Directory: String;
  procedure CLI_init;
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
     ThPhi_Form.Create( Self);
end;

function TfjsExplorer.Windows_Directory: String;
{$IFDEF MSWINDOWS}
var
   buffer: array[0..MAX_PATH] of Char;
begin
     GetWindowsDirectory( PChar(buffer), SizeOf(buffer));
     Result:= IncludeTrailingPathDelimiter( PChar(buffer) );
end;
{$ELSE}
begin
     Result:= '';
end;
{$ENDIF}

procedure TfjsExplorer.bWindows_CLI_cmdClick(Sender: TObject);
begin
     eWindows_CLI.Text:= Windows_Directory+'system32\cmd.exe';
end;

procedure TfjsExplorer.bWindows_CLI_powershellClick(Sender: TObject);
begin
     eWindows_CLI.Text:= Windows_Directory+'System32\WindowsPowerShell\v1.0\powershell.exe';
end;

procedure TfjsExplorer.bWindows_CLI_git_bashClick(Sender: TObject);
begin
     eWindows_CLI.Text:= eWindows_GIT_BASH.Text;
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

procedure TfjsExplorer.CLI_init;
begin
     {$IFDEF LINUX}
       pUbuntu_CLI.CurrentDirectory:= Directory;
       pUbuntu_CLI.Executable:= eUbuntu_CLI.Text;
       pUbuntu_CLI.Parameters.Text:= '';
     {$ELSE}
       pWindows_CLI.CurrentDirectory:= Directory;
       pWindows_CLI.Executable:= eWindows_CLI.Text;
       pWindows_CLI.Parameters.Text:= '';
     {$ENDIF};
end;

procedure TfjsExplorer.bCLIClick(Sender: TObject);
begin
     if not_Directory_Get then exit;
     CLI_init;
     {$IFDEF LINUX}
       pUbuntu_CLI.Execute;
     {$ELSE}
       pWindows_CLI.Execute;
     {$ENDIF};
end;

procedure TfjsExplorer.bGIT_PULLClick(Sender: TObject);
begin
     if not_Directory_Get then exit;
     CLI_init;
     {$IFDEF LINUX}
       pUbuntu_CLI.Executable:= '/usr/bin/xterm';
       pUbuntu_CLI.Parameters.Add( '-hold');
       pUbuntu_CLI.Parameters.Add( '-e');
       pUbuntu_CLI.Parameters.Add( 'git');
       pUbuntu_CLI.Parameters.Add( 'pull');
       pUbuntu_CLI.Execute;
     {$ELSE}
       pWindows_CLI.Executable:=eWindows_GIT_BASH.Text;
       pWindows_CLI.Parameters.Add( '-c');
       pWindows_CLI.Parameters.Add( '"git pull;bash"');
       pWindows_CLI.Execute;
     {$ENDIF};
     //note commande git de définition d'un remote par défaut pour une branche :
     //   git branch --set-upstream-to=serveur_git/master master
     // propositions de serveur/branche si on fait un git pull tout seul
end;

procedure TfjsExplorer.bGIT_STATUSClick(Sender: TObject);
begin
     if not_Directory_Get then exit;
     CLI_init;
     {$IFDEF LINUX}
       pUbuntu_CLI.Executable:= '/usr/bin/xterm';
       pUbuntu_CLI.Parameters.Add( '-hold');
       pUbuntu_CLI.Parameters.Add( '-e');
       pUbuntu_CLI.Parameters.Add( 'git');
       pUbuntu_CLI.Parameters.Add( 'status');
       pUbuntu_CLI.Execute;
     {$ELSE}
       pWindows_CLI.Executable:=eWindows_GIT_BASH.Text;
       pWindows_CLI.Parameters.Add( '-c');
       pWindows_CLI.Parameters.Add( '"git status;bash"');
       pWindows_CLI.Execute;
     {$ENDIF};
end;

procedure TfjsExplorer.bjsWorksClick(Sender: TObject);
var
   jsWorks_Dir: String;
begin
     if not_Directory_Get then exit;

     jsWorks_Dir := IncludeTrailingPathDelimiter( Directory)+'01_jsWorks';
     pjsWorks.CurrentDirectory:= jsWorks_Dir;
     {$IFDEF LINUX}
       pjsWorks.Executable:= IncludeTrailingPathDelimiter( jsWorks_Dir)+'jsWorks';
     {$ELSE}
       pjsWorks.Executable:= IncludeTrailingPathDelimiter( jsWorks_Dir)+'jsWorks.exe';
     {$ENDIF};
     pjsWorks.Execute;
end;

end.

