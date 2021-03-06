unit UJogo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, UJogoOO, Vcl.MPlayer;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure atualizarLabelNivel(Sender: TObject);
    procedure atualizarLabelPontuacao(Sender: TObject);
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
    VK_LEFT  : jogo.setCanhaoEsquerda;
    VK_RIGHT : jogo.setCanhaoDireita;
    VK_UP    : jogo.setCanhaoMeio;
    VK_DOWN  : jogo.setCanhaoMeio;
    VK_SPACE : jogo.atirar;
   end;


end;

procedure TForm3.FormShow(Sender: TObject);
var
  tmover: TTimer;
begin
   jogo := tjogo.Create;

   jogo.inicializar(Panel1);

   // Manter Label N?vel atualizada:
   TMover := TTimer.Create(jogo.tela);
   TMover.Interval := 500;
   TMover.OnTimer  := atualizarLabelNivel;
   TMover.Enabled  := true;

   // Manter Lavel Pontua??o atualizada:
   TMover := TTimer.Create(jogo.tela);
   TMover.Interval := 100;
   TMover.OnTimer  := atualizarLabelPontuacao;
   TMover.Enabled  := true;
end;

procedure TForm3.atualizarLabelNivel(Sender: TObject);
begin
  Label1.Caption := 'N?vel ' + IntToStr(jogo.nivel);
end;

procedure TForm3.atualizarLabelPontuacao(Sender: TObject);
begin
  Label2.Caption := 'Pontua??o: ' + IntToStr(jogo.pontuacao);
end;

end.
