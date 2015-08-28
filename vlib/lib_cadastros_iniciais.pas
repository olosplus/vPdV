unit lib_cadastros_iniciais;

interface

uses Windows, Messages, SysUtils;

  type
     TCadastrosIniciais = class
     private
       FidEmpresa : Integer;
       FidPais : Integer;
       FidEstado : Integer;
       FIdCidade : Integer;
       FidBairro : Integer;
       FIdFuncionario : Integer;
       Fusuario : String;
       procedure AddEmpresa;
       procedure AddPaises;
       procedure AddEstados;
       procedure AddCidade;
       procedure AddAbairro;
       procedure AddFuncionario;
       procedure AddCaixa;
     public
       procedure Executar;

     end;
implementation

uses lib_acesso, lib_db, Classes;

{ TCadastrosIniciais }

const
   DATA_PADRAO = '2015-08-22';

procedure TCadastrosIniciais.AddAbairro;
var
  tbBairro : TObjetoDB;
begin
  tbBairro := TObjetoDB.create('bairro');
  try
    tbBairro.AddParametro('empresa_id', FidEmpresa);
    tbBairro.AddParametro('cdbairro', '1');

    tbBairro.Select(['id']);

    if not tbBairro.IsEmpty then
    begin
      FidBairro := tbBairro.GetVal('id');
      Exit;
    end;

    tbBairro.AddParametro('nmbairro', 'JARDIM VIT�RIA');
    tbBairro.AddParametro('dtcadastro', DATA_PADRAO);
 //   tbBairro.AddParametro('pais_id', FidPais);
//    tbBairro.AddParametro('estado_id', FidEstado);
    tbBairro.AddParametro('cidade_id', FIdCidade);    
    tbBairro.Insert;

    tbBairro.Select(['id']);
    FidBairro := tbBairro.GetVal('id');
  finally
    FreeAndNil(tbBairro);
  end

end;

procedure TCadastrosIniciais.AddCaixa;
var
  tbCaixa : TObjetoDB;
begin
  tbCaixa := TObjetoDB.create('caixa');
  try
    tbCaixa.Select(['id']);
    if tbCaixa.IsEmpty then
    begin
      tbCaixa.AddParametro('nmcaixa', 'CAIXA');
      tbCaixa.Insert;
    end;
  finally
    FreeAndNil(tbCaixa);
  end;

end;

procedure TCadastrosIniciais.AddCidade;
var
  tbCidade : TObjetoDB;
begin
  tbCidade := TObjetoDB.create('cidade');
  try
    tbCidade.AddParametro('empresa_id', FidEmpresa);
    tbCidade.AddParametro('cdcidade', '1');

    tbCidade.Select(['id']);

    if not tbCidade.IsEmpty then
    begin
      FIdCidade := tbCidade.GetVal('id');
      Exit;
    end;

    tbCidade.AddParametro('nmcidade', 'BELO HORIZONTE');
    tbCidade.AddParametro('dtcadastro', DATA_PADRAO);
    tbCidade.AddParametro('pais_id', FidPais);
    tbCidade.AddParametro('estado_id', FidEstado);
    tbCidade.Insert;

    tbCidade.Select(['id']);
    FIdCidade := tbCidade.GetVal('id');
  finally
    FreeAndNil(tbCidade);
  end

end;

procedure TCadastrosIniciais.AddEmpresa;
var
  tbEmpresa : TObjetoDB;
begin
  tbEmpresa := TObjetoDB.create('empresa');
  try
    tbEmpresa.AddParametro('codigo', '01');

    tbEmpresa.Select(['id']);

    if not tbEmpresa.IsEmpty then
    begin
      FidEmpresa := tbEmpresa.GetVal('id');
      Exit;
    end;

    tbEmpresa.AddParametro('nmempresa', 'JHOW AÇAÍ');
    tbEmpresa.AddParametro('dtcadastro', '2015-08-22');
    tbEmpresa.Insert;

    tbEmpresa.Select(['id']);
    FidEmpresa := tbEmpresa.GetVal('id');
  finally
    FreeAndNil(tbEmpresa);
  end
end;

procedure TCadastrosIniciais.AddEstados;
var
  tbEstado : TObjetoDB;
begin
  tbEstado := TObjetoDB.create('estado');
  try
    tbEstado.AddParametro('empresa_id', FidEmpresa);
    tbEstado.AddParametro('cdestado', '31');

    tbEstado.Select(['id']);

    if not tbEstado.IsEmpty then
    begin
      FidEstado := tbEstado.GetVal('id');
      Exit;
    end;

    tbEstado.AddParametro('dtcadastro', DATA_PADRAO);
    tbEstado.AddParametro('nmestado', 'MINAS GERAIS');
    tbEstado.AddParametro('sgestado', 'MG');
    tbEstado.AddParametro('pais_id', FidPais);
    tbEstado.AddParametro('dsregiao', 'SUDESTE');        
    tbEstado.Insert;

    tbEstado.Select(['id']);
    FidEstado := tbEstado.GetVal('id');

  finally
    FreeAndNil(tbEstado);
  end;

end;

procedure TCadastrosIniciais.AddFuncionario;
var
  tbFunc : TobjetoDB;
begin
  tbFunc := TObjetoDB.create('funcionario');
  try

    tbFunc.AddParametro('usuario', 'vmsismaster');

    tbFunc.Select(['id', 'usuario']);
    if not tbFunc.IsEmpty then
    begin
      FIdFuncionario := tbFunc.GetVal('id');
      Fusuario := tbFunc.GetVal('usuario');
      Exit;
    end;

    tbFunc.AddParametro('empresa_id', FidEmpresa);
    tbFunc.AddParametro('dtcadastro', DATA_PADRAO);
    tbFunc.AddParametro('nome', 'vmsismaster');
    tbFunc.AddParametro('sexo', 'M');
    tbFunc.AddParametro('dtnascimento', DATA_PADRAO);
    tbFunc.AddParametro('email', 'vmsis@vmsis.com.br');
    tbFunc.AddParametro('senha', 'masterVMSIS123v');
    tbFunc.AddParametro('confsenha', 'masterVMSIS123v');
    tbFunc.AddParametro('endereco', 'RUA 1');
    tbFunc.AddParametro('numero', '1');
    tbFunc.AddParametro('complemento', 'SEM COMPLEMENTO');
    tbFunc.AddParametro('cep', '31300000');
    tbFunc.AddParametro('pais_id', FidPais);
    tbFunc.AddParametro('estado_id', FidEstado);
    tbFunc.AddParametro('cidade_id', FIdCidade);
    tbFunc.AddParametro('bairro_id', FidBairro);
    tbFunc.AddParametro('dtadmissao', DATA_PADRAO);
    tbFunc.AddParametro('pessoa', 'J');
    tbFunc.Insert;

    tbFunc.Select(['id', 'usuario']);
    FIdFuncionario := tbFunc.GetVal('id');
    Fusuario := tbFunc.GetVal('usuario');
  finally
    FreeAndNil(tbFunc);
  end;
end;

procedure TCadastrosIniciais.AddPaises;
var
  tbPais : TObjetoDB;
begin
  tbPais := TObjetoDB.create('pais');
  try
    tbPais.AddParametro('empresa_id', FidEmpresa);
    tbPais.AddParametro('cdpais', '0055');

    tbPais.Select(['id']);

    if not tbPais.IsEmpty then
    begin
      FidPais := tbPais.GetVal('id');
      Exit;
    end;

    tbPais.AddParametro('dtcadastro', DATA_PADRAO);
    tbPais.AddParametro('nmpais', 'BRASIL');
    tbPais.Insert;

    tbPais.Select(['id']);
    FidPais := tbPais.GetVal('id');

  finally
    FreeAndNil(tbPais);
  end;

end;

procedure TCadastrosIniciais.Executar;
var
  UsrAce : TAcessoUsuario;
begin
   AddEmpresa;
   AddPaises;
   AddEstados;
   AddCidade;
   AddAbairro;
   AddFuncionario;
   AddCaixa;
   TAcesso.AddRotinas;

   UsrAce := TAcessoUsuario.create(Fusuario);
   try
     UsrAce.AddPermissao('gaveta', TpmProcessar);
   finally
     FreeAndNil(UsrAce);
   end

end;

end.
