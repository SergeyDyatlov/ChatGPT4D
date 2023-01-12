unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, IdHTTP, IdSSLOpenSSL, IdMultipartFormData, ChatGPT;

type
  TMainForm = class(TForm)
    edtAPIKey: TEdit;
    memChat: TMemo;
    edtQuestion: TEdit;
    lblSecretKey: TLabel;
    procedure edtQuestionKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FChatGPT: TChatGPT;
    procedure AskChatGPT(const APIKey: string; Question: string);
    procedure ChatGPTResponse(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  System.Threading, System.SyncObjs;

{$R *.dfm}

procedure TMainForm.AskChatGPT(const APIKey: string; Question: string);
begin
  FChatGPT.APIKey := APIKey;
  FChatGPT.Ask(Question);
end;

procedure TMainForm.ChatGPTResponse(Sender: TObject);
var
  ChatGPT: TChatGPT;
  List: TStringList;
begin
  List := TStringList.Create;
  try
    ChatGPT := Sender as TChatGPT;
    List.Text := ChatGPT.Response;
    memChat.Lines.AddStrings(List);
    memChat.Lines.Add('');
  finally
    List.Free;
  end;
end;

procedure TMainForm.edtQuestionKeyPress(Sender: TObject; var Key: Char);
var
  APIKey, Question: string;
begin
  if Key = #13 then
  begin
    APIKey := edtAPIKey.Text;
    Question := edtQuestion.Text;
    edtQuestion.Clear;

    memChat.Lines.Add(Question);
    memChat.Lines.Add('');

    AskChatGPT(APIKey, Question);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FChatGPT := TChatGPT.Create;
  FChatGPT.OnResponse := ChatGPTResponse;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FChatGPT.Free;
end;

initialization

ReportMemoryLeaksOnShutdown := True;

end.
