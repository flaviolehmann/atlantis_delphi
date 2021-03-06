unit UJogoOO;

interface

uses Vcl.ExtCtrls,Vcl.Controls, Vcl.Dialogs,Vcl.MPlayer ;

type
  TJogo = class
  public
    nivel       : integer;
    Tela        : TwinControl;
    pontuacao   : integer;

  private
    { Private declarations }
    TCriador    : TTimer;
    TMover      : TTimer;
    TNivel      : TTimer;

    bateu       : boolean;
    NumeroNaves : integer;




    Nave        : TImage;
    ImgBatida   : tImage;
    ImgFundo    : tImage;
    direcaoCanhao: integer; // 0 - Esquerda, 1 - Meio, 2 - Cima
    tm          : TMediaPlayer;


    function    VerificaColisao(O1, O2 : TControl):boolean;

    procedure   CriaInimigo(Sender:TObject);
    procedure   MoveInimigos(Sender:TObject);
    procedure   IncrementaNivel(Sender:TObject);

    procedure   ExibeBatida;

  public
  { Public declarations }
    procedure setCanhaoEsquerda;
    procedure setCanhaoDireita;
    procedure setCanhaoMeio;
    procedure atirar;

    procedure inicializar(T:TwinControl);

  end;


implementation

{ TJogo }

procedure TJogo.CriaInimigo(Sender: TObject);
var t : timage;
begin
   inc(NumeroNaves);
   if not(bateu) and (NumeroNaves < 20) then
   begin
      t         := timage.Create(tela);
      t.Parent  := tela;
      t.Picture.LoadFromFile('..\..\nave_inimiga.png');
      t.Height := 50;
      t.Width  := 75;
      t.Stretch := true;
      t.Proportional := true;
      t.Visible := true;
      t.Left     := 0;


      t.Top    := Random(tela.Height - 240);
      t.Tag     := 1;
   end;
end;
procedure TJogo.ExibeBatida;
var tm : TMediaPlayer ;
begin
     tm := TMediaPlayer.Create(tela);
     tm.Parent   := tela;
     tm.Visible  := false;
     tm.FileName := '..\..\tiro.mp3';
     tm.Open;
     tm.Play;
end;

procedure TJogo.IncrementaNivel(Sender: TObject);
var i : integer;
begin
   if not bateu then
   begin
       for i := 0 to Tela.ComponentCount-1 do
       begin
         if Tela.Components[i] is TPanel then
         begin
            if TPanel(Tela.Components[i]).tag =1 then
            begin
               TPanel(Tela.Components[i]).Height := TPanel(Tela.Components[i]).Height + 2;
               TPanel(Tela.Components[i]).Width  := TPanel(Tela.Components[i]).Width + 2;
            end;
         end;
       end;
   end;

   if nivel > 10 then TMover.Interval := 1;

   inc(nivel);

end;

procedure TJogo.inicializar(T:TwinControl);
begin

   tela        := t;
   bateu       := false;
   NumeroNaves := 0;
   nivel       := 1;
   pontuacao   := 0;

   // fundo
   ImgFundo := timage.Create(tela);
   ImgFundo.Parent := tela;
   ImgFundo.Picture.LoadFromFile('..\..\fundo.png');
   ImgFundo.Height := 400;
   ImgFundo.Width  := 702;
   ImgFundo.Stretch := true;
   ImgFundo.Proportional := true;
   ImgFundo.Visible := true;

   //heroi - tiro
   nave := timage.Create(tela);
   nave.Parent := tela;
   nave.Picture.LoadFromFile('..\..\tiro.png');
   nave.Height := 41;
   nave.Width  := 25;
   nave.Stretch := true;
   nave.Proportional := true;
   nave.Visible := false;

   nave.Top   := tela.Height;
   nave.Left  := tela.Width;

   // audio tiro
   tm := TMediaPlayer.Create(tela);
   tm.Parent   := tela;
   tm.Visible  := false;
   tm.FileName := '..\..\tiro.mp3';
   tm.Open;

   //explosao
   ImgBatida := timage.Create(tela);
   ImgBatida.Parent := tela;
   ImgBatida.Picture.LoadFromFile('..\..\colisao.png');
   ImgBatida.Height := 200;
   ImgBatida.Width  := 200;
   ImgBatida.Stretch := true;
   ImgBatida.Proportional := true;
   imgbatida.Visible := false;


   TCriador := TTimer.Create(Tela);
   TCriador.Interval := 2000;
   TCriador.OnTimer  := CriaInimigo;
   TCriador.Enabled  := true;

   TMover := TTimer.Create(Tela);
   TMover.Interval := 2;
   TMover.OnTimer  := MoveInimigos;
   TMover.Enabled  := true;

   TNivel := TTimer.Create(Tela);
   TNivel.Interval := 5000;
   TNivel.OnTimer  := IncrementaNivel;
   TNivel.Enabled  := true;

end;

procedure TJogo.setCanhaoEsquerda;
begin
   direcaoCanhao := 0;
end;

procedure TJogo.setCanhaoMeio;
begin
   direcaoCanhao := 1;
end;

procedure TJogo.setCanhaoDireita;
begin
   direcaoCanhao := 2;
end;

procedure TJogo.atirar;
begin
     tm.Rewind;
     tm.Play;
     nave.Visible := true;
     if direcaoCanhao = 0 then
     begin
         Nave.Top := 230;
         Nave.Left := 50;
     end
     else if direcaoCanhao = 1 then
     begin
         Nave.Top := 210;
         Nave.Left := 290;
     end
     else
     begin
        Nave.Top := 210;
         Nave.Left := 580;
     end;

     // TODO: logica do tiro
end;

procedure TJogo.MoveInimigos(Sender: TObject);
var i : integer;
begin
   if not bateu then
   begin
       for i := 0 to tela.ComponentCount-1 do
       begin
         if tela.Components[i] is TImage then
         begin
            if TPanel(tela.Components[i]).tag =1 then
            begin
               TPanel(tela.Components[i]).Left := TPanel(tela.Components[i]).Left + 1;
               if TPanel(tela.Components[i]).Left > tela.Width then
               begin
                  TPanel(tela.Components[i]).Left    := 40;
                  TPanel(tela.Components[i]).Left   := Random(tela.Width - 30);
               end;

               if VerificaColisao(nave, TPanel(tela.Components[i])) then
               begin
                  bateu := true;
                  ExibeBatida;
               end;
            end;
         end;
       end;
   end;
end;

function TJogo.VerificaColisao(O1, O2: TControl): boolean;
var topo, baixo, esquerda, direita : boolean;
begin
    topo     := false;
    baixo    := false;
    esquerda := false;
    direita  := false;
    if (O1.Top >= O2.top ) and (O1.top  <= O2.top  + O2.Height) then
    begin
       topo := true;
    end;

    if (O1.left >= O2.left) and (O1.left <= O2.left + O2.Width ) then
    begin
      esquerda := true;
    end;

    if (O1.top + O1.Height >= O2.top ) and (O1.top + O1.Height  <= O2.top + O2.Height) then
    begin
      baixo := true;
    end;

    if (O1.left + O1.Width >= O2.left ) and (O1.left + O1.Width  <= O2.left + O2.Width) then
    begin
      direita := true;
    end;

    if (topo or baixo) and (esquerda or direita) then
       o2.Visible := false;

    VerificaColisao := (topo or baixo) and (esquerda or direita);

end;


end.
