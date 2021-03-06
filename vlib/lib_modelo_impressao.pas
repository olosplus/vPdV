unit lib_modelo_impressao;

interface

uses
   Classes, WinInet, Dialogs, Windows, Forms,
   IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
   lib_mensagem, SysUtils, Variants, Graphics, Controls,
   ComCtrls, StdCtrls, ExtCtrls, DBClient, StrUtils;

type
   TImpressao_Nao_Fiscal = Class(TPersistent)
   private
     procedure Layout_Body(cdsProduto, cdsAdicionais: TClientDataSet; Texto_Impressao: TMemo);
//   protected
   public
     function Verif_Impressora: Boolean;
     procedure Layout_Finaliza_Pedido(cdsPedido, cdsProduto, cdsAdicionais: TClientDataSet; stClick: String);
     procedure Layout_Pedido(cdsPedido, cdsProduto, cdsAdicionais: TClientDataSet);
     function Ajusta(stTexto, stLetra: String; inQtdeTotStr: Integer; stLado: String = 'R'): String;
//   published
end;

implementation

  function rStatusImpressora_DUAL_DarumaFramework(): Integer; StdCall; External 'C:\Windows\System32\DarumaFrameWork.dll';
  function iImprimirTexto_DUAL_DarumaFramework(stTexto: String; iTam: Integer ): Integer; StdCall; External 'C:\Windows\System32\DarumaFramework.dll';

{ TImpressao_Nao_Fiscal }

{
  Formata��o:
  Texto centralizado: <ce>Centralizado</ce>
  Texto justificado: <ju>Justificado</ju>
  Texto em Negrito: <b>Negrito</b>
  Texto em Italico: <i>Italico</i>
  Texto em Sublinhado: <s>Sublinhado</s>
  Texto em Expandido: <e>Expandido</e>
  Texto em Condensado: <c>Condensado</c>
  Texto Normal: <n>Normal</n>
  Saltar uma Linha: <l></l>Salto de uma Linha
  Saltar varias Linhas: <sl>NN</sl>Saltar varias Linhas
  Riscar Linha com Caracter Especifico: <tc>C</tc>
  Imprimir Data Atual sistema: <dt></dt>
  Imprimir Hora Atual sistema: <hr></hr>
  Imprimir Data Atual impressora: <dti></dti>
  Imprimir Hora Atual impressora: <hri></hri>
  Inserir Espa�os em Branco: <sp>NN</sp>
  Usando as Tabulacoes <tb></tb>
  Configurar Tabulacoes <ft>n1,n2,n3,...</ft>
  Alinhando a Direita <ad></ad>
  Configura Margem <mg>e,d</mg>
  Duplica a Altura do caracter <da></da>
  Habilita o Modo Fonte Elite <fe>texto</fe>
  Texto Extra Grande <xl>texto</xl>
  Salto milimetrico <slm>xx</slm>
  Conf. Espa�o entre Linhas <cespl>xx</cespl>

  Comandos:
  Imprimir logotipo carregado <bmp></bmp>
  Imprimir bmp s/carregar <ibmp>path/arq.bmp</ibmp>
  Acionar guilhotina <gui></gui>
  Abrir Gaveta de Dinheiro: <g></g>
  Sinal Sonoro, Apitar: <sn></sn>
  Aguardar o Termino da Impress�o: <a></a>
  Configura Corte (P)Parcial  (T)Total <confgui>T</confgui>

  Imprimir C�digo de Barras:
  <ean13>123456789012</ean13>
  <ean8>1234567</ean8>
  <upc-a>12345678901</upc-a>
  <code39>CODE 39</code39>
  <code93>CODE 93</code93>
  <codabar>CODABAR</codabar>
  <msi>123456789</msi>
  <code11>12345678901</code11>
  <pdf>1234</pdf>
  <code128>123456789123-A-B-*_%-&</code128>
  <i2of5>1234</i2of5>
  <s2of5>12345678</s2of5>
  <qrcode>www.daruma.com.br</qrcode>

  Sub-tags para Codigos de Barras::
  Para c�digo na vertical <cbv></cbv>
  Imprimir Texto na lateral do Cod. Vertical <txtl></txtl>
  Imprimir c�digo abaixo das barras <txt></txt>
  Altuda do Cod. Barras <hx></hx> (onde  x = altura)
  Largura do Cod. Barras <wx></wx> (onde  x = largura)
  Colunas - para pdf <cx></cx> (onde x =coluna)
  Salva QrCode em bmp:<sbmp>c:\Imagem.bmp</sbmp>
  Nivel Corre��o QrCode: <correcao>x</correcao> (onde x = M, Q ou  H)
}

function TImpressao_Nao_Fiscal.Ajusta(stTexto, stLetra: String;
  inQtdeTotStr: Integer; stLado: String = 'R'): String;
begin
  Result := '';
  if Length(stTexto) >= inQtdeTotStr then
    stTexto := Copy(stTexto, 1, inQtdeTotStr)
  else
    while Length(stTexto) < inQtdeTotStr do
      if stLado = 'R' then
        stTexto := stTexto + stLetra
      else
        stTexto := stLetra + stTexto;
  Result := stTexto;
end;

procedure TImpressao_Nao_Fiscal.Layout_Body(cdsProduto,
  cdsAdicionais: TClientDataSet; Texto_Impressao: TMemo);
begin
  Texto_Impressao.Lines.Add('<b>Produto  <tb><tb><tb>Qtde<tb>   Valor</b>');
  cdsProduto.First;

  while not cdsProduto.Eof do begin
    Texto_Impressao.Lines.Add(Ajusta(cdsProduto.FieldByName('NMPRODUTO').AsString, ' ', 22)+
      Ajusta(' ',' ',3)+Ajusta(FormatFloat('#####0.000', cdsProduto.FieldByName('QTITEM').AsFloat),' ',10,'L')+
      Ajusta(' ',' ',3)+Ajusta(FormatFloat('#####0.00', cdsProduto.FieldByName('VRTOTAL').AsFloat),' ',9,'L'));

    cdsAdicionais.Filtered := False;
    cdsAdicionais.Filter := ' ITEMPEDIDO_ID = '+cdsProduto.FieldByName('ID').AsString;
    cdsAdicionais.Filtered := True;

    cdsAdicionais.First;
    while not cdsAdicionais.Eof do begin
      if cdsAdicionais.FieldByName('VRUNITARIO').AsFloat > 0 then
      begin
        Texto_Impressao.Lines.Add(Ajusta(' ',' ',4)+'- '+Ajusta(cdsAdicionais.FieldByName('NMPRODUTO').AsString, ' ', 16)+
          Ajusta(' ',' ',3)+Ajusta(FormatFloat('####0.000', cdsAdicionais.FieldByName('QTITEM').AsFloat),' ',10,'L')+
          Ajusta(' ',' ',3)+Ajusta(FormatFloat('####0.00', cdsAdicionais.FieldByName('VRTOTAITEM').AsFloat),' ',9,'L'));
      end else
      begin
        Texto_Impressao.Lines.Add(Ajusta(' ',' ',4)+'- '+Ajusta(cdsAdicionais.FieldByName('NMPRODUTO').AsString, ' ', 16)+
          Ajusta(' ',' ',3)+Ajusta(FormatFloat('####0.000', cdsAdicionais.FieldByName('QTITEM').AsFloat),' ',10,'L')+
          Ajusta(' ',' ',3)+Ajusta(FormatFloat('####0.00', cdsAdicionais.FieldByName('VRTOTAITEM').AsFloat),' ',9,'L'));
      end;
      cdsAdicionais.Next;
    end;
    cdsProduto.Next;
  end;
end;

procedure TImpressao_Nao_Fiscal.Layout_Finaliza_Pedido(cdsPedido, cdsProduto, cdsAdicionais: TClientDataSet; stClick: String);
var
  Texto_Impressao: TMemo;
begin
  Texto_Impressao := TMemo.Create(nil);
  Texto_Impressao.Parent := TForm(Application.MainForm);
  Texto_Impressao.Visible := False;
  {
    #                                       #
    #                Empresa                #
    #                Unidade                #
    #                                       #
    #  Destino                              #
    #                                       #
    #  Produto 1     qdte  valor total item #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #  Produto 1     qdte  valor total item #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #  Produto 1     qdte  valor total item #
    #  Produto 1     qdte  valor total item #
    #                                       #
    #                  VMSis                #
    #          dd/mm/yyyy - hh:mi           #
  }

  if stClick = 'F' then
  begin
    Texto_Impressao.Lines.Add('<e><ce><b>'+cdsPedido.FieldByName('EMPRESA').AsString+'</b></ce></e>');
    Texto_Impressao.Lines.Add('<ce>'+cdsPedido.FieldByName('UNIDADE').AsString+'</ce>');
    Texto_Impressao.Lines.Add('<l></l>');
  end;

  case AnsiIndexStr(UpperCase(cdsPedido.FieldByName('TIPOPEDIDO').AsString), ['D','M','B']) of
    0: begin
        Texto_Impressao.Lines.Add('<n>Delivery</n>');
        if stClick = 'F' then
        begin
          Texto_Impressao.Lines.Add('<n>'+cdsPedido.FieldByName('ENDERECO').AsString+'</n>');
          Texto_Impressao.Lines.Add('<n>'+cdsPedido.FieldByName('REFERENCIA').AsString+'</n>');
          Texto_Impressao.Lines.Add('<n>'+cdsPedido.FieldByName('CONTATO').AsString+'</n>');
//        Texto_Impressao.Lines.Add('<b>Vendedor</b> Luara Di Latella');
        end;
       end;
    1: begin
        Texto_Impressao.Lines.Add('<b>Mesa</b> '+cdsPedido.FieldByName('ENDERECO').AsString+'</n>');
//        Texto_Impressao.Lines.Add('<b>Vendedor</b> Luara Di Latella');
       end;
    3: begin
        Texto_Impressao.Lines.Add('<n>Balc�o</n>');
        if not cdsPedido.FieldByName('CONTATO').IsNull then
          Texto_Impressao.Lines.Add('<n>'+cdsPedido.FieldByName('CONTATO').AsString+'</n>');
//        Texto_Impressao.Lines.Add('<b>Vendedor</b> Luara Di Latella');
       end;
  else
    Texto_Impressao.Lines.Add('<l></l>');
  end;
  Texto_Impressao.Lines.Add('<l></l>');

  Layout_Body(cdsProduto, cdsAdicionais, Texto_Impressao);

  if stClick = 'F' then
  begin
    Texto_Impressao.Lines.Add('<b>TOTAL '+Ajusta(FormatFloat('######0.00', cdsPedido.FieldByName('VRPEDIDO').AsFloat),' ',41,'L')+'</b>');
    Texto_Impressao.Lines.Add('<l></l>');    
    Texto_Impressao.Lines.Add('Fidelidade');
    Texto_Impressao.Lines.Add('<ce>Documento sem valor fiscal</ce>');
  end;
  Texto_Impressao.Lines.Add('<ce><dt> - <hr></hr></dt></ce>');     
  Texto_Impressao.Lines.Add('<ce>VMSis</ce>');
  Texto_Impressao.Lines.Add('<sl>1</sl>');
  Texto_Impressao.Lines.Add('<l></l>');

  try
    if iImprimirTexto_DUAL_DarumaFramework(Texto_Impressao.Text, 0) <> 1 then
      Erro(ERRO_AO_IMPRIMIR);
  except
    raise;
  end;

  FreeAndNil(cdsPedido);
  FreeAndNil(cdsProduto);
  FreeAndNil(cdsAdicionais);
  FreeAndNil(Texto_Impressao);
end;

procedure TImpressao_Nao_Fiscal.Layout_Pedido(cdsPedido, cdsProduto, cdsAdicionais: TClientDataSet);
var
  Texto_Impressao: TMemo;
begin
  Texto_Impressao := TMemo.Create(nil);
  {
    #                                       #
    #                Empresa                #
    #                Unidade                #
    #                                       #
    #  Destino                              #
    #                                       #
    #  Produto 1     qdte  valor total item #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #  Produto 1     qdte  valor total item #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #     Adicional  qtde                   #
    #  Produto 1     qdte  valor total item #
    #  Produto 1     qdte  valor total item #
    #                                       #
    #                  VMSis                #
    #          dd/mm/yyyy - hh:mi           #
  }

  Texto_Impressao.Lines.Add('<sl>3</sl>');
  Texto_Impressao.Lines.Add('<e><ce><b>'+cdsPedido.FieldByName('EMPRESA').AsString+'</b></ce></e>');
  Texto_Impressao.Lines.Add('<ce>'+cdsPedido.FieldByName('UNIDADE').AsString+'<ce>');
  Texto_Impressao.Lines.Add('<l></l>');

  case AnsiIndexStr(UpperCase(cdsPedido.FieldByName('TIPOPEDIDO').AsString), ['D','M','B']) of
    0: begin
        Texto_Impressao.Lines.Add('<n>Delivery</n>');                                      
        Texto_Impressao.Lines.Add('<n>'+cdsPedido.FieldByName('CONTATO').AsString+'</n>');
       end;
    1: Texto_Impressao.Lines.Add('<n>Mesa: '+cdsPedido.FieldByName('ENDERECO').AsString+'</n>');
    3: begin
        Texto_Impressao.Lines.Add('<n>Balc�o</n>');
        Texto_Impressao.Lines.Add('<n>'+cdsPedido.FieldByName('CONTATO').AsString+'</n>');
       end;
  else
    Texto_Impressao.Lines.Add('<n>Destino n�o identificado</n>');
  end;

  Layout_Body(cdsProduto, cdsAdicionais, Texto_Impressao);

  Texto_Impressao.Lines.Add('<l></l>');
  Texto_Impressao.Lines.Add('<ce><dt> - <hr></hr></dt></ce>');
  Texto_Impressao.Lines.Add('<ce>VMSis</ce>');
  Texto_Impressao.Lines.Add('<sl>4</sl>');
  Texto_Impressao.Lines.Add('<l></l>');                                            

  try
    if iImprimirTexto_DUAL_DarumaFramework(Texto_Impressao.Text, 0) <> 1 then
      Erro(ERRO_AO_IMPRIMIR);
  except
    raise;
  end;

  FreeAndNil(cdsPedido);  
  FreeAndNil(cdsProduto);
  FreeAndNil(cdsAdicionais);
end;

function TImpressao_Nao_Fiscal.Verif_Impressora: Boolean;
var
  boOK: Boolean;  
  iRetorno: Integer;
begin
  boOK := False;
  iRetorno := rStatusImpressora_DUAL_DarumaFramework();
  case iRetorno of
    0: Aviso(IMPRESSORA_DESLIGADA);
    1: boOk := True;
    -27: Erro(ERRO_GENERICO);
    -50: Erro(IMPRESSORA_OFFLINE);
    -51: Aviso(IMPRESSORA_SEMPAPEL);
    -52: Aviso(IMPRESSORA_INICIALIZANDO);
  else
    Erro(ERRO_RETORNO_NAO_ESPERADO);
  end;
  Result := boOK;
end;

end.
