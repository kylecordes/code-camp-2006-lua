{  Oasis Digital Touch Screen Slider Control Demo Application w/ Scripting

Copyright (c) 2006, Oasis Digital Solutions Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    * Neither the name of the <ORGANIZATION> nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, uSlider, ComCtrls, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPClient, Lua;

type
  TSliderExampleForm = class(TForm)
    Timer1: TTimer;
    Bevel1: TBevel;
    UdpClient: TIdUDPClient;
    Label0: TLabel;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure SliderMoved(Sender: TObject);
    procedure ScriptableSliderMoved(Sender: TObject);
  end;

var
  SliderExampleForm: TSliderExampleForm;

implementation

{$R *.dfm}

// ************************************************ GUI Code

// Without the scripting mechanis, this is all the code - as you can see,
// it is a small demo app.

procedure TSliderExampleForm.Timer1Timer(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to ComponentCount-1 do begin
    if Components[I] is TSlider then
      (Components[I] as TSlider).MoveCloser;
  end;
end;

procedure TSliderExampleForm.FormCreate(Sender: TObject);
var
  Slider: TSlider;
  I: integer;
begin
  for I := 0 to 5 do begin
    Slider := TSlider.Create(Self);
    Slider.Parent := Self;
    Slider.Left := 24 + I * 75;
    Slider.Top := 16;
    Slider.Width := 49;
    Slider.Height := 249;
    Slider.Name := 'Channel' + IntTostr(I);

    // This line wires up the non-scripted protocol code:
    //Slider.OnSliderMove := SliderMoved;

    // This line wires up the cripted protocol code:
    Slider.OnSliderMove := ScriptableSliderMoved;
  end;
end;

// The non-scripted protocol code is hard-wired for one specific protocol:

procedure TSliderExampleForm.SliderMoved(Sender: TObject);
var
  Slider: TSlider;
begin
  Slider := Sender as TSlider;
  SliderExampleForm.UdpClient.Send(Slider.Name + ' ' + IntToStr(Slider.Position));
end;


// ************************************************ Lua Scripting:

var
  LState: lua_State;

procedure CheckLuaErrCode(const ErrCode: integer);
var
  ErrorMessage: string;
  ErrorMessageP: PChar;
begin
  if ErrCode = 0 then
    Exit; // No error

  ErrorMessageP := lua_tostring(LState, -1);
  ErrorMessage := ErrorMessageP;
  lua_pop(LState, 1);
  raise Exception.Create('Lua error ' + IntToStr(ErrCode) + ': ' +
    ErrorMessage);
end;

// Two primitive we will expose to the scripts:

function send_packet(L: lua_State): Integer; cdecl;
var
  NumArguments: integer;
  P: PChar;
begin
  NumArguments := lua_gettop(L);
  Assert(NumArguments = 1, 'We require NumArguments=1');
  P := lua_tostring(L, 1);

  SliderExampleForm.UdpClient.Send(P);

  Result := 0;
end;

function set_label(L: lua_State): Integer; cdecl;
var
  NumArguments: integer;
  ControlName, Text: PChar;
begin
  NumArguments := lua_gettop(L);
  Assert(NumArguments = 2, 'We require NumArguments=2');
  ControlName := lua_tostring(L, 1);
  Text := lua_tostring(L, 2);

  (SliderExampleForm.FindComponent(ControlName) as TLabel).Caption := Text;

  Result := 0;
end;

// I think of the Lua code as somewhere between code and configuration; hence
// load "config":

procedure LoadConfig;
begin
  if not Assigned(LState) then begin
    LState := lua_open;      // create a Lua context


    lua_baselibopen(LState);  // Load in some Lua primitives
    lua_strlibopen(LState);
    lua_mathlibopen(LState);
    lua_tablibopen(LState);

    // Register our two primitives:
    lua_register(LState, 'send_packet', send_packet);
    lua_register(LState, 'set_label', set_label);

    // Load the file:
    CheckLuaErrCode(luaL_loadfile(LState, 'protocol.lua'));
    CheckLuaErrCode(lua_pcall(LState, 0, 0, 0));
  end;
end;

// Route events in to the script:

procedure TSliderExampleForm.ScriptableSliderMoved(Sender: TObject);
var
  Slider: TSlider;
begin
  Slider := Sender as TSlider;

  LoadConfig;

  // Call slider_moved in the Lua code:
  lua_pushstring(LState, 'slider_moved');
  lua_gettable(LState, LUA_GLOBALSINDEX); // find it in Lua
  lua_pushstring(LState, PChar(Slider.Name));
  lua_pushstring(LState, PChar(IntToStr(Slider.Position)));

  CheckLuaErrCode(lua_pcall(LState, 2, 0, 0));
end;

procedure TSliderExampleForm.FormShow(Sender: TObject);
begin
  LoadConfig;   // Run/Load the config at startup since it set GUI labels:
end;

initialization

finalization
  if Assigned(LState) then
    lua_close(LState);

end.

