program ChatGPTApp;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  ChatGPT in 'ChatGPT\ChatGPT.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
