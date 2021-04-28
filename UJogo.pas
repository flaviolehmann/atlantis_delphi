unit UJogo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, UJogoOO, Vcl.MPlayer;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  Jogo : TJogo;


implementation

{$R *.dfm}


procedure TForm3.FormCreate(Sender: TObject);
begin
   DoubleBuffered := true;

end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
    VK_LEFT  : jogo.MoveEsquerda;
    VK_RIGHT : jogo.Movedireita;
    VK_UP    : jogo.MoveCima;
    VK_DOWN  : jogo.MoveBaixo;
   end;


end;

procedure TForm3.FormShow(Sender: TObject);
begin
   jogo := tjogo.Create;

   jogo.inicializar(Panel1);

end;

end.
