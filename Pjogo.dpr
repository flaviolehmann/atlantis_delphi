program Pjogo;

uses
  Vcl.Forms,
  UJogo in 'UJogo.pas' {Form3},
  UJogoOO in 'UJogoOO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
