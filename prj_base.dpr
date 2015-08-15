program prj_base;

uses
  Forms,
  main_base in 'main_base.pas' {frmMainBase},
  login_base in 'login\login_base.pas' {frmLoginBase},
  pkg_uses in 'lib\pkg_uses.pas',
  lib_mensagem in 'lib\lib_mensagem.pas',
  lib_vmsis in 'lib\lib_vmsis.pas',
  libframes in 'lib\libframes.pas',
  pdv in 'app\pdv\pdv.pas' {frmPDV: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainBase, frmMainBase);
  frmLoginBase := TfrmLoginBase.Create(nil);
  frmLoginBase.ShowModal;
  if frmLoginBase.GetLogado then begin
     frmLoginBase.Release;
     Application.Run;
  end;
end.