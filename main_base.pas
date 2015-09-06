unit main_base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinsdxNavBar2Painter, dxNavBarCollns, cxClasses,
  dxNavBarBase, dxNavBar, dxSkinscxPCPainter, cxPC, ImgList, dxSkinsForm;

type
  TfrmMainBase = class(TForm)
    nbMain_Base: TdxNavBar;
    pgcPrincipal: TcxPageControl;
    nbgCadastro: TdxNavBarGroup;
    nbiCliente: TdxNavBarItem;
    nbgSair: TdxNavBarGroup;
    nbgPDV: TdxNavBarGroup;
    nbgEstoque: TdxNavBarGroup;
    nbiEntrada: TdxNavBarItem;
    nbiSaida: TdxNavBarItem;
    cilMenu: TcxImageList;
    nbiFornecedor: TdxNavBarItem;
    procedure nbgSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure nbgPDVClick(Sender: TObject);
    procedure nbiClienteClick(Sender: TObject);
    procedure nbiFornecedorClick(Sender: TObject);
  private
    { Private declarations }
//    procedure InvocadordeBpl(stClasse: String);
  public
    { Public declarations }
    Fusuario : string;
    FidUsuario : Integer;
  end;

var
  frmMainBase: TfrmMainBase;

implementation

{$R *.dfm}

uses
   libframes, pdv_main, pdv_aberturacaixa, pdv_abertura_fechamento_caixa, uvCadastroClienteFrame,
   uvCadastroFornecedorFrame;

procedure TfrmMainBase.nbgSairClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmMainBase.FormCreate(Sender: TObject);
var
   region: hrgn;
begin
   Height := Screen.WorkAreaHeight-20;
   Width  := Screen.WorkAreaWidth-20;
   Position := poScreenCenter;

   DoubleBuffered := True;
   region := CreateRoundRectRgn(0, 0, width, height, 15, 15);
   SetWindowRgn(handle, region, true);
end;

//procedure TfrmMainBase.Invocadordebpl(stClasse: String);
//var
//   Classe: TPersistentClass;
//begin
//   Classe := GetClass(stClasse);
//   if Classe <> nil then
//   begin
//      with TComponentClass(Classe).Create(Application) as TFrame do
//         Visible := True;
//   end;
//end;

procedure TfrmMainBase.nbgPDVClick(Sender: TObject);
begin
  if CaixaAberto then
    TAbasNavegacao.CriarAba(pgcPrincipal, TfrmPDVMain);
end;

procedure TfrmMainBase.nbiClienteClick(Sender: TObject);
begin
  TAbasNavegacao.CriarAba(pgcPrincipal, TvCadastroCliente);
end;

procedure TfrmMainBase.nbiFornecedorClick(Sender: TObject);
begin
  TAbasNavegacao.CriarAba(pgcPrincipal, TvCadastroFornecedorFrame);
end;

end.
