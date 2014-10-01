{-
ModelMaker 7 code
Copyright (C) 1994-2003
ModelMaker Tools
http://www.modelmakertools.com

No part of this code may be used or copied without
written permission of ModelMaker Tools
}

unit MMCriticsBase;

interface

uses SysUtils, Classes, MMToolsApi, MMEngineDefs;

type
  TCriticChangedEvent = procedure (Sender: TObject; Index: Integer) of object;
  TMMDesignCritic = class (TInterfacedObject, IUnknown, IMMDesignCritic)
  private
    FCategory: string;
    FEnabled: Boolean;
    FPriority: TMMMsgPriority;
    FVisible: Boolean;
  protected
    procedure Changed;
  public
    constructor Create;
    function CriticID: WideString; safecall;
    procedure Edit; dynamic; safecall;
    function GetAuthor: WideString; virtual; safecall;
    function GetCategory: WideString; virtual; safecall;
    function GetCriticName: WideString; virtual; safecall;
    procedure GetCustomState(var TaggedValues: WideString); dynamic; safecall;
    function GetDescription: WideString; virtual; safecall;
    function GetEnabled: Boolean; virtual; safecall;
    function GetHeadLine: WideString; virtual; safecall;
    function GetPriority: TMMMsgPriority; virtual; safecall;
    function GetVisible: Boolean; virtual; safecall;
    procedure MsgDoubleClicked(const M: IMMMessage; var Handled: Boolean); dynamic; 
            safecall;
    procedure Refresh; dynamic; safecall;
    procedure RefreshClass(ID: Integer); dynamic; safecall;
    procedure RefreshUnit(ID: Integer); dynamic; safecall;
    procedure SetCategory(Value: WideString); virtual; safecall;
    procedure SetCustomState(const TaggedValues: WideString); dynamic; safecall;
    procedure SetEnabled(Value: Boolean); virtual; safecall;
    procedure SetPriority(Value: TMMMsgPriority); virtual; safecall;
    procedure SetVisible(Value: Boolean); virtual; safecall;
    property Author: WideString read GetAuthor;
    property Category: WideString read GetCategory write SetCategory;
    property CriticName: WideString read GetCriticName;
    property Description: WideString read GetDescription;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property HeadLine: WideString read GetHeadLine;
    property Priority: TMMMsgPriority read GetPriority write SetPriority;
    property Visible: Boolean read GetVisible write SetVisible;
  end;
  
  TMMCriticsNotifier = class (TInterfacedObject, IMMCriticsNotifier)
  private
    FNotifierIndex: Integer;
    FOnCriticChanged: TCriticChangedEvent;
    FOnDestroy: TNotifyEvent;
    FOnDestroyed: TNotifyEvent;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CriticChanged(Index: Integer); safecall;
    procedure Destroyed; safecall;
    property NotifierIndex: Integer read FNotifierIndex write FNotifierIndex;
    property OnCriticChanged: TCriticChangedEvent read FOnCriticChanged write 
            FOnCriticChanged;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnDestroyed: TNotifyEvent read FOnDestroyed write FOnDestroyed;
  end;
  

implementation

uses Windows;

{
************************************ TMMDesignCritic *************************************
}
constructor TMMDesignCritic.Create;
begin
  inherited Create;
  FEnabled := True;
  FVisible := True;
  // You could provide a default priority and category too
end;

procedure TMMDesignCritic.Changed;
begin
  MMToolServices.CriticManager.CriticChanged(Self);
end;

function TMMDesignCritic.CriticID: WideString;
begin
  // Return a unqiue ID for this critic.
  // The CriticID is used in each session. Make sure it is independent from
  // externals like time, insertion order etc.
  // Usually there's no need to override this method
  Result := Format('%s.%s', [Author, CriticName]);
end;

procedure TMMDesignCritic.Edit;
begin
  // Override this method to edit the critic's settings
end;

function TMMDesignCritic.GetAuthor: WideString;
begin
  // Return a string that is used to identify the author.
  // "Author.CriticName" make up the Critic ID - which must be unique in the
  // MM environment. Make sure your Author name is a unique name
  // You could use a company name like ModelMaker Tools or alternatively
  // an URL like www.modelmakertools.com which is garanteed to be unique
  Result := 'Unknown Author';
end;

function TMMDesignCritic.GetCategory: WideString;
begin
  // Category can be adjusted by the user. Use the category when inserting messages
  Result := FCategory;
end;

function TMMDesignCritic.GetCriticName: WideString;
begin
  // Return the name of this critic.
  // "Author.CriticName" make up the Critic ID - which must be unique in the
  // MM environment. Make sure all your critics have unique names
  Result := ClassName;
end;

procedure TMMDesignCritic.GetCustomState(var TaggedValues: WideString);
begin
  {
  This method is called after the critics standard properties have been saved.
  Override this method to save any additonal critic state.
  Unless you have added state that should be persistent there's no need to override
  this method.
  The format of the TaggedValues should be a Name=Value list separated by CRLFs.
  For example:
  
  State := TStringList.Create;
  try
    State.Values['Prop1'] := Prop1Value;
    State.Values['Prop2'] := Prop2Value;
    TaggedValues := State.Text;
  finally
    State.Free;
  end;
  
  After loading SetCustomState is called to which should
  perform the opposite operation
  }
end;

function TMMDesignCritic.GetDescription: WideString;
begin
  // Return the long text of this critic, describing what this critic does
  // You can use line breaks (#13) in description
  Result := HeadLine;
end;

function TMMDesignCritic.GetEnabled: Boolean;
begin
  // Return the enabled state which can be adjusted by the user
  // Only enabled and visible critics are including in a full refresh
  Result := FEnabled;
end;

function TMMDesignCritic.GetHeadLine: WideString;
begin
  // Return a short one liner about this critic
  Result := 'Basic critic';
end;

function TMMDesignCritic.GetPriority: TMMMsgPriority;
begin
  // Priority can be adjusted by the user. Use the priority when inserting messages
  Result := FPriority;
end;

function TMMDesignCritic.GetVisible: Boolean;
begin
  // Return the visible state which can be adjusted by the user
  // Only enabled and visible critics are including in a full refresh
  Result := FVisible;
end;

procedure TMMDesignCritic.MsgDoubleClicked(const M: IMMMessage; var Handled: Boolean);
begin
  // Override this method if you want to perform an action when the user double clicked the message
  // if Handled = False (default) and message's Locate method will be called.
  Handled := False;
end;

procedure TMMDesignCritic.Refresh;
begin
  // Override this method to insert critic messages.
  // Just before this method is called the CriticManager will have cleared all
  // messages owned by this critic
  // This method is not called if the critic is either disabled or invisible
end;

procedure TMMDesignCritic.RefreshClass(ID: Integer);
begin
  // Similar to Refresh, but only Class with ID and it's members should be checked
  // Currently the MM IDE does not support invoking this method.
end;

procedure TMMDesignCritic.RefreshUnit(ID: Integer);
begin
  // Similar to Refresh, but only Unit with ID and it's classes and members should be checked
  // Currently the MM IDE does not support invoking this method.
end;

procedure TMMDesignCritic.SetCategory(Value: WideString);
var
  S: string;
begin
  // Save Category which can be adjusted by the user.
  // Use the category when inserting messages
  S := Value; // WideString Conversion
  if S <> FCategory then
  begin
    FCategory := Value;
    Changed;
  end;
end;

procedure TMMDesignCritic.SetCustomState(const TaggedValues: WideString);
begin
  {
  This method is called after the critics standard properties have been loaded.
  Override this method to restore any additonal critic state.
  Unless you have added state that should be persistent there's no need to override
  this method.
  
  The format of TaggedValues is a list of Name=Value pairs separated by CRLFs.
  You could use a TStrings to restore this to a simple name=value list
  
  S: TStrings;
  S.Text := TaggedValues;
  Prop1Value := S.Values['Prop1'];
  Prop2Value := S.Values['Prop2'];
  etc.
  
  }
end;

procedure TMMDesignCritic.SetEnabled(Value: Boolean);
begin
  // Save the enabled state which can be adjusted by the user
  // Only enabled and visible critics are including in a full refresh
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed;
  end;
end;

procedure TMMDesignCritic.SetPriority(Value: TMMMsgPriority);
begin
  // Save priority
  if FPriority <> Value then
  begin
    FPriority := Value;
    Changed;
  end;
end;

procedure TMMDesignCritic.SetVisible(Value: Boolean);
begin
  // Save the visible state which can be adjusted by the user
  // Only enabled and visible critics are including in a full refresh
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

{
*********************************** TMMCriticsNotifier ***********************************
}
constructor TMMCriticsNotifier.Create;
begin
  FNotifierIndex := -1;
  inherited Create;
end;

destructor TMMCriticsNotifier.Destroy;
begin
  if Assigned(FOnDestroy) then
   try
     FOnDestroy(Self);
   except
     on E: Exception do
       Windows.MessageBox(0, PChar(E.Message), nil, 0);
   end;
  FNotifierIndex := -1;
  inherited Destroy;
end;

procedure TMMCriticsNotifier.CriticChanged(Index: Integer);
begin
  // If Index = -1, multiple crtics have changed or critcs have been added/removed
  // Index >=0 : Critics[Index] changed
  if Assigned(FOnCriticChanged) then FOnCriticChanged(Self, Index);
end;

procedure TMMCriticsNotifier.Destroyed;
begin
  if Assigned(FOnDestroyed) then FOnDestroyed(Self);
end;


end.
