program UDPReceiver;

uses
  Forms,
  uUDPReceiverForm in 'uUDPReceiverForm.pas' {UDPReceiverForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TUDPReceiverForm, UDPReceiverForm);
  Application.Run;
end.

