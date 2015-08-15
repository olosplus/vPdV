unit uvPadraoFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  StdCtrls, cxButtons, ExtCtrls, DB, DBClient;

const
  CLOSE_FRAME_PARENT = 'P';
  CLOSE_FRAME_SELF = 'S';

type
  TvPadraoFrame = class(TFrame)
    panTop: TPanel;
    btnFechar: TcxButton;
    panClient: TPanel;
    lblNomeFrame: TLabel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
    FFrameClose: String;
  public
    { Public declarations }
    procedure setFrameClose(frameClose:String);
    constructor Create(AOwner: TComponent); override;    
  end;

implementation

{$R *.dfm}

procedure TvPadraoFrame.btnFecharClick(Sender: TObject);
begin
  if FFrameClose = CLOSE_FRAME_PARENT then
    Parent.Destroy
  else
    Self.Destroy;
end;

constructor TvPadraoFrame.Create(AOwner: TComponent);
begin
  inherited;
  FFrameClose := CLOSE_FRAME_SELF;
end;

procedure TvPadraoFrame.setFrameClose(frameClose: String);
begin
  FFrameClose := frameClose;
end;

end.
