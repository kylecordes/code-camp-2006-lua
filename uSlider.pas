{  Oasis Digital Touch Screen Slider Control

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
}

unit uSlider;

interface

uses
  Classes, Windows, Graphics, Controls, ExtCtrls;

type
  TSlider = class(TPaintBox)
  protected
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
      override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure Paint; override;
  private
    SliderY, TargetY: integer;
    WhenPushed: Cardinal;
    procedure CalculateTargetY(const Y: integer);
    procedure MoveOneStepCloser;
  public
    OnSliderMove: TNotifyEvent;
    procedure MoveCloser;
    function Position: integer;
  end;

implementation

{ TSlider }

uses
  Math;

const
  SliderHeight = 15;

procedure TSlider.CalculateTargetY(const Y: integer);
begin
  TargetY := Y - (SliderHeight div 2);
  if TargetY < 0 then
    TargetY := 0;

  if TargetY > Height - SliderHeight then
    TargetY := Height - SliderHeight;
end;

procedure TSlider.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  WhenPushed := GetTickCount;
  CalculateTargetY(Y);
  MoveOneStepCloser;
end;

procedure TSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ssLeft in Shift then begin
    CalculateTargetY(Y);
  end;
end;

procedure TSlider.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  TargetY := SliderY; // stop motion when mouse released
end;

procedure TSlider.MoveCloser;
var
  SpeedLimit: integer;
  Gap: integer;
  CurrentTickCount: Cardinal;
begin
  if TargetY = SliderY then
    Exit;

  CurrentTickCount := GetTickCount;

  // Wait briefly, so a single click does not move it
  if CurrentTickCount < WhenPushed+120 then
    Exit;

  // Go up slowly at first, then after 700 milliseconds go up more quickly
  SpeedLimit := 1;
  if CurrentTickCount > WhenPushed+700 then
    SpeedLimit := 2;

  // Go down very fast
  if TargetY > SliderY then
    SpeedLimit := 15;

  Gap := Abs(TargetY - SliderY);

  SliderY := SliderY + Sign(TargetY - SliderY) * Min(Gap, SpeedLimit);

  if Assigned(OnSliderMove) then
    OnSliderMove(Self);

  Invalidate;
end;

procedure TSlider.MoveOneStepCloser;
begin
  if TargetY = SliderY then
    Exit;

  // In this example, assume one step is one pixel.  In reality we need to
  // do all this based on target and actual slider "Value" which is not
  // the same as pixels, rather it is the configured 0..100 or -72..0 scale.

  if TargetY > SliderY then
    SliderY := SliderY + 1;

  if TargetY < SliderY then
    SliderY := SliderY - 1;

  if Assigned(OnSliderMove) then
    OnSliderMove(Self);

  Invalidate;
end;

procedure TSlider.Paint;
begin
  inherited;
  Canvas.Pen.Color := clGray;
  Canvas.Rectangle(0, 0, Width, Height);
  Canvas.Rectangle(30, 5, 34, Height - 5);

  Canvas.TextOut(2, 1, '0');
  Canvas.TextOut(2, Height - canvas.TextHeight('-72')-1, '-72');

  Canvas.Pen.Color := clRed;
  Canvas.Brush.Color := clYellow;
  Canvas.Rectangle(20, SliderY, Width - 5, SLiderY + SliderHeight);
end;

function TSlider.Position: integer;
begin
  Result := SliderY;
end;

end.

