unit uUDPReceiverForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer,
  IdGlobal, IdSocketHandle;

type
  TUDPReceiverForm = class(TForm)
    IdUDPServer1: TIdUDPServer;
    Label1: TLabel;
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TBytes;
      ABinding: TIdSocketHandle);
  end;

var
  UDPReceiverForm: TUDPReceiverForm;

implementation

{$R *.dfm}

procedure TUDPReceiverForm.IdUDPServer1UDPRead(Sender: TObject; AData: TBytes;
  ABinding: TIdSocketHandle);
var
  Data: string;
begin
  SetLength(Data, High(AData) + 1);
  Move(AData[0], Data[1], High(AData) + 1);
  Label1.Caption := Data;
end;

end.

