unit ChatGPT;

interface

uses
  System.SysUtils, System.Classes, IdHTTP, IdSSLOpenSSL,
  System.Generics.Collections, System.Threading;

const
  API_URL = 'https://api.openai.com/v1/completions';

type
  TChatGPT = class
  private
    FAPIKey: string;
    FHttpClient: TIdHTTP;
    FIOHandler: TIdSSLIOHandlerSocketOpenSSL;
    FTask: ITask;
    FResponse: string;
    FOnResponse: TNotifyEvent;
    function BuildRequest(Question: string): string;
    function ParseResponse(Response: string): string;
    function Post(const AURL: string; AStream: TStream): string;
    procedure DoResponse;
    procedure SetAPIKey(const Value: string);
  public
    constructor Create; overload;
    constructor Create(const AAPIKey: string); overload;
    destructor Destroy; override;
    procedure Ask(const Question: string);
    property APIKey: string read FAPIKey write SetAPIKey;
    property Response: string read FResponse;
    property OnResponse: TNotifyEvent read FOnResponse write FOnResponse;
  end;

implementation

uses
  System.JSON;

{ TChatGPT }

procedure TChatGPT.Ask(const Question: string);
begin
  if Assigned(FTask) and (FTask.Status = TTaskStatus.Running) then
    raise Exception.Create('Another request is already running');

  FTask := TTask.Run(
    procedure
    var
      Request: string;
      Stream: TStringStream;
    begin
      Request := BuildRequest(Question);
      Stream := TStringStream.Create(Request);
      try
        TMonitor.Enter(FHttpClient);
        try
          FResponse := Post(API_URL, Stream);
        finally
          TMonitor.Exit(FHttpClient);
        end;
        FResponse := ParseResponse(FResponse);
        TThread.Synchronize(TThread.Current, DoResponse);
      finally
        Stream.Free;
      end;
    end);
end;

function TChatGPT.BuildRequest(Question: string): string;
var
  JSONRequest: TJSONObject;
begin
  JSONRequest := TJSONObject.Create;
  try
    JSONRequest.AddPair('model', 'text-davinci-003');
    JSONRequest.AddPair('prompt', Question);
    JSONRequest.AddPair('max_tokens', TJSONNumber.Create(2048));
    JSONRequest.AddPair('temperature', TJSONNumber.Create(0));
    Result := JSONRequest.ToJSON;
  finally
    JSONRequest.Free;
  end;
end;

constructor TChatGPT.Create;
begin
  FHttpClient := TIdHTTP.Create(nil);
  FIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FIOHandler.SSLOptions.Method := sslvTLSv1_2;
  FIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  FHttpClient.IOHandler := FIOHandler;
end;

constructor TChatGPT.Create(const AAPIKey: string);
begin
  Create;
  FAPIKey := AAPIKey;
end;

destructor TChatGPT.Destroy;
begin
  FIOHandler.Free;
  FHttpClient.Free;
  inherited;
end;

procedure TChatGPT.DoResponse;
begin
  if Assigned(FOnResponse) then
    FOnResponse(Self);
end;

function TChatGPT.ParseResponse(Response: string): string;
var
  JSONResponse: TJSONValue;
  Bytes: TBytes;
begin
  JSONResponse := TJSONObject.ParseJSONValue(Response);
  try
    JSONResponse := JSONResponse.GetValue<TJSONValue>('choices');
    JSONResponse := TJSONArray(JSONResponse).Items[0];
    JSONResponse := JSONResponse.GetValue<TJSONString>('text');

    Bytes := TEncoding.GetEncoding('ISO-8859-1').GetBytes(JSONResponse.Value);
    Result := TEncoding.UTF8.GetString(Bytes);
  finally
    JSONResponse.Free;
  end;
end;

function TChatGPT.Post(const AURL: string; AStream: TStream): string;
begin
  FHttpClient.Request.ContentType := 'application/json';
  FHttpClient.Request.CustomHeaders.Clear;
  FHttpClient.Request.CustomHeaders.Add('Authorization: Bearer ' + FAPIKey);
  Result := FHttpClient.Post(AURL, AStream);
end;

procedure TChatGPT.SetAPIKey(const Value: string);
begin
  TMonitor.Enter(FHttpClient);
  try
    FAPIKey := Value;
  finally
    TMonitor.Exit(FHttpClient);
  end;
end;

end.
