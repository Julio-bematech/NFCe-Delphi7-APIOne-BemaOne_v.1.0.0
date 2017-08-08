// Exemplo de uso da BemaOne.DLL - BemaOne API
// Autores: Anderson Lima, Daniel Lima, Adroaldo Martins, Frederico Schneider
// Data: 27 janeiro 2017

unit FormPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, UnitDeclaracoes, IdBaseComponent, IdCoder,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdCoder3to4, IdCoderMIME, IdGlobal;

type
  TFormMain = class(TForm)
    rdoDLL: TRadioButton;
    rdoAPI: TRadioButton;
    grpFuncoes: TGroupBox;
    grpConsultarNota: TGroupBox;
    grpSerieNumeroConsultarNota: TGroupBox;
    edtSerieConsultarNota: TEdit;
    grpChaveAcessoConsultarNota: TGroupBox;
    edtChaveAcessoConsultarNota: TEdit;
    chkPDFConsultarNota: TCheckBox;
    chkJSONConsultarNota: TCheckBox;
    lblChaveAcessoConsultarNota: TLabel;
    edtNumeroConsultarNota: TEdit;
    lblNumeroConsultar: TLabel;
    lblSerieConsultar: TLabel;
    btnAbrirNota: TButton;
    lblSerie: TLabel;
    edtSerie: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    btnVenderItem: TButton;
    btnPagarNota: TButton;
    btnFecharNota: TButton;
    btnStatusImpressora: TButton;
    btnInformacoesSistema: TButton;
    btnEnviarNotaRejeicao: TButton;
    btnConsultarNota: TButton;
    memEnvio: TMemo;
    lblEnvio: TLabel;
    memRetorno: TMemo;
    lblRetorno: TLabel;
    memEnviarTextoLivre: TMemo;
    lblEnviarTextoLivre: TLabel;
    chkGuilhotinaTextoLivre: TCheckBox;
    btnEnviarTextoLivre: TButton;
    IdEncoderMIME1: TIdEncoderMIME;
    btnEstornarNota: TButton;
    btnCancelarNota: TButton;
    lblChaveAcessoCancelarNota: TLabel;
    edtChaveAcessoCancelarNota: TEdit;
    grpCancelarNota: TGroupBox;
    HTTP_API: TIdHTTP;
    lblCNPJ: TLabel;
    edtCNPJ: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnAbrirNotaClick(Sender: TObject);
    procedure btnVenderItemClick(Sender: TObject);
    procedure btnPagarNotaClick(Sender: TObject);
    procedure btnFecharNotaClick(Sender: TObject);
    procedure btnEstornarNotaClick(Sender: TObject);
    procedure btnStatusImpressoraClick(Sender: TObject);
    procedure btnInformacoesSistemaClick(Sender: TObject);
    procedure btnEnviarNotaRejeicaoClick(Sender: TObject);
    procedure btnCancelarNotaClick(Sender: TObject);
    procedure btnConsultarNotaClick(Sender: TObject);
    procedure btnEnviarTextoLivreClick(Sender: TObject);
    procedure chkPDFConsultarNotaClick(Sender: TObject);
    procedure chkJSONConsultarNotaClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  fusoHorario: TTimeZoneInformation;
  numeroSessaoAtual: String;

implementation

uses StrUtils;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  rdoDLL.Checked := true;
  rdoAPI.Checked := false;
  chkPDFConsultarNota.Checked := false;
  chkJSONConsultarNota.Checked := true;

  GetTimeZoneInformation(fusoHorario);
end;

//*********************************************************************//
//  Função Abrir Nota
//*********************************************************************//
procedure TFormMain.btnAbrirNotaClick(Sender: TObject);
Var
  jsonAbrirNota: String;
  retornoFuncao : String;
  dataHoraAtual : String;
  numeroSessaoAuxiliar : String;
  URL: String;                        // Para utilizar API sem DLL
  dadosEnvioAPI: TStringStream;       // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  dataHoraAtual := FormatDateTime('yyyy-mm-dd',(now))       //Obtem Data Atual
    + 'T' + FormatDateTime('hh:nn:ss',(now))                //Obtem Hora Atual
    + '-02:00';
    //+ FormatFloat('00', fusoHorario.Bias div -60) + ':00';  //Obtem Fuso Atual

  jsonAbrirNota := '{' + #13 + #10
    + ' "versao": "3.10", ' + #13 + #10
    + ' "configuracao": ' + #13 + #10
    + ' { ' + #13 + #10
    + '   "imprimir": true, ' + #13 + #10
    + '   "email": true ' + #13 + #10
    + ' }, '
    + ' "identificacao": ' + #13 + #10
    + ' { ' + #13 + #10
    + '   "cuf": "41", ' + #13 + #10
    + '   "cnf": "00005000", ' + #13 + #10
    + '   "natOp": "VENDA", ' + #13 + #10
    + '   "indPag": 0, ' + #13 + #10
    + '   "mod": "65", ' + #13 + #10
    + '   "serie": "' + edtSerie.Text + '", ' + #13 + #10
    + '   "nnf": "' + edtNumero.Text + '", ' + #13 + #10
    + '   "dhEmi": "' + dataHoraAtual + '", ' + #13 + #10
    + '   "tpNF": "1", ' + #13 + #10
    + '   "idDest": 1, ' + #13 + #10
    + '   "tpImp": 4, ' + #13 + #10
    + '   "tpEmis": 1, ' + #13 + #10
    + '   "cdv": 8, ' + #13 + #10
    + '   "tpAmb": 2, ' + #13 + #10
    + '   "finNFe": 1, ' + #13 + #10
    + '   "indFinal": 1, ' + #13 + #10
    + '   "indPres": 1, ' + #13 + #10
    + '   "procEmi": 0, ' + #13 + #10
    + '   "verProc": "1.0.0.0", ' + #13 + #10
    + '   "cMunFG": "4106902" ' + #13 + #10
    + ' }, ' + #13 + #10
    + ' "emitente":' + #13 + #10
    + ' { ' + #13 + #10
    + '   "cnpj": "82373077000171", ' + #13 + #10
    + '   "endereco": ' + #13 + #10
    + '   { ' + #13 + #10
    +       '"nro": "0", ' + #13 + #10
    +       '"uf": "PR", ' + #13 + #10
    + '     "cep": "81320400", ' + #13 + #10
    + '     "fone": "4184848484", ' + #13 + #10
    + '     "xBairro": "CABRAL", ' + #13 + #10
    + '     "xLgr": "AV Teste", ' + #13 + #10
    + '     "cMun": "4106902", ' + #13 + #10
    + '     "cPais": "1058", ' + #13 + #10
    + '     "xPais": "BRASIL", ' + #13 + #10
    + '     "xMun": "Curitiba" ' + #13 + #10
    + '   }, ' + #13 + #10
    + '   "ie": "1018146530", ' + #13 + #10
    + '   "crt": 3, ' + #13 + #10
    + '   "xNome": "BEMATECH SA", ' + #13 + #10
    + '   "xFant": "BEMATECH" ' + #13 + #10
    + ' }, ' + #13 + #10
    + ' "destinatario":' + #13 + #10
    + ' { ' + #13 + #10
    + '   "cpf": "76643539129", ' + #13 + #10
    + '   "endereco":' + #13 + #10
    + '   { ' + #13 + #10
    + '     "nro": "842", ' + #13 + #10
    + '     "uf": "PR", ' + #13 + #10
    + '     "cep": "80020320", ' + #13 + #10
    + '     "fone": "41927598874", ' + #13 + #10
    + '     "xBairro": "Centro", ' + #13 + #10
    + '     "xLgr": "Marechal Deodoro", ' + #13 + #10
    + '     "cMun": "4106902", ' + #13 + #10
    + '     "cPais": "1058", ' + #13 + #10
    + '     "xPais": "Brasil", ' + #13 + #10
    + '     "xMun": "Curitiba" ' + #13 + #10
    + '   }, ' + #13 + #10
    + '   "indIEDest": 9, ' + #13 + #10
    + '   "email": "teste@teste.com", ' + #13 + #10
    + '   "xNome": "NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL " ' + #13 + #10
    + ' } ' + #13 + #10
    + '}';

  memEnvio.Text := jsonAbrirNota;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_AbrirNota(jsonAbrirNota);
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio com o JSON criado
    HTTP_API := TIdHTTP.Create();
    dadosEnvioAPI := TStringStream.Create(UTF8Encode(jsonAbrirNota));
    retornoFuncaoAPI := TStringStream.Create('');

    //Abrir Nota - Serviço POST
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/documento/cupom';
    Try
      HTTP_API.Post(URL, dadosEnvioAPI, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
      retornoFuncao := retornoFuncaoAPI.DataString;
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;

  //Se existir a chave numeroSessao, removemos /r, /n, " e } para pegar a sessao atual
  if((Pos('"numeroSessao"', retornoFuncao)) > 0) then
  begin
    numeroSessaoAuxiliar := retornoFuncao;
    numeroSessaoAuxiliar := StringReplace(numeroSessaoAuxiliar,#$A,'',[rfReplaceAll]);
    numeroSessaoAuxiliar := StringReplace(numeroSessaoAuxiliar,#$D,'',[rfReplaceAll]);
    numeroSessaoAuxiliar := StringReplace(numeroSessaoAuxiliar,'"','',[rfReplaceAll]);
    numeroSessaoAuxiliar := StringReplace(numeroSessaoAuxiliar,'}','',[rfReplaceAll]);
    numeroSessaoAtual := RightStr(numeroSessaoAuxiliar, 32);
  end;
end;

//*********************************************************************//
//  Função Vender Item
//*********************************************************************//
procedure TFormMain.btnVenderItemClick(Sender: TObject);
Var
  jsonVenderItem: String;
  retornoFuncao: String;
  URL: String;                        // Para utilizar API sem DLL
  dadosEnvioAPI: TStringStream;       // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  jsonVenderItem := '{ ' + #13 + #10
    + ' "produto":' + #13 + #10
    + ' { ' + #13 + #10
    + '   "cean": "7897238304177", ' + #13 + #10
    + '   "ncm": "85258029", ' + #13 + #10
    + '   "cfop": "5101", ' + #13 + #10
    + '   "indTot": 1, ' + #13 + #10
    + '   "vUnCom": 1.000, ' + #13 + #10
    + '   "uTrib": "UN", ' + #13 + #10
    + '   "vUnTrib": "1.000", ' + #13 + #10
    + '   "cProd": "85258029901234", ' + #13 + #10
    + '   "xProd": "Produto Teste", ' + #13 + #10
    + '   "uCom": "UN", ' + #13 + #10
    + '   "qTrib": 1.000, ' + #13 + #10
    + '   "qCom": "1.000", ' + #13 + #10
    + '   "vProd": 1.00 ' + #13 + #10
    + ' }, '
    + ' "imposto":' + #13 + #10
    + ' { ' + #13 + #10
    + '   "icms":' + #13 + #10
    + '   { ' + #13 + #10
    + '     "icms00":' + #13 + #10
    + '     { ' + #13 + #10
    + '       "orig": 1, ' + #13 + #10
    + '       "cst": "00", ' + #13 + #10
    + '       "modBC": 3, ' + #13 + #10
    + '       "vbc": 1.00, ' + #13 + #10
    + '       "picms": 1.01, ' + #13 + #10
    + '       "vicms": 0.01 ' + #13 + #10
    + '     } ' + #13 + #10
    + '   }, ' + #13 + #10
    + '   "vTotTrib": 0.00 ' + #13 + #10
    + ' } ' + #13 + #10
    + '}';

  memEnvio.Text := jsonVenderItem;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_VenderItem(jsonVenderItem);
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio com o JSON criado
    HTTP_API := TIdHTTP.Create();
    dadosEnvioAPI := TStringStream.Create(UTF8Encode(jsonVenderItem));
    retornoFuncaoAPI := TStringStream.Create('');

    //Vender Item - Serviço POST
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/documento/cupom/' + numeroSessaoAtual + '/item';
    Try
      HTTP_API.Post(URL, dadosEnvioAPI, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
end;

//*********************************************************************//
//  Função Pagar Nota
//*********************************************************************//
procedure TFormMain.btnPagarNotaClick(Sender: TObject);
Var
  jsonPagarNota: String;
  retornoFuncao: String;
  URL: String;                        // Para utilizar API sem DLL
  dadosEnvioAPI: TStringStream;       // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  jsonPagarNota := '{ ' + #13 + #10
    + ' "tPag": 1, ' + #13 + #10
    + ' "vPag": 1.00 ' + #13 + #10
    + '} ';

  memEnvio.Text := jsonPagarNota;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_EfetuarPagamento(jsonPagarNota);
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio com o JSON criado
    HTTP_API := TIdHTTP.Create();
    dadosEnvioAPI := TStringStream.Create(UTF8Encode(jsonPagarNota));
    retornoFuncaoAPI := TStringStream.Create('');

    //Pagar Nota - Serviço POST
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/documento/cupom/' + numeroSessaoAtual + '/pagamento';
    Try
      HTTP_API.Post(URL, dadosEnvioAPI, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
end;

//*********************************************************************//
//  Função Fechar Nota
//*********************************************************************//
procedure TFormMain.btnFecharNotaClick(Sender: TObject);
Var
  jsonFecharNota: String;
  retornoFuncao: String;
  URL: String;                        // Para utilizar API sem DLL
  dadosEnvioAPI: TStringStream;       // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  jsonFecharNota := '{' + #13 + #10
    + ' "total":' + #13 + #10
    + ' { ' + #13 + #10
    + '   "icmsTotal":' + #13 + #10
    + '   { ' + #13 + #10
    + '     "vbc": 1.00, ' + #13 + #10
    + '     "vicms": 0.01, ' + #13 + #10
    + '     "vicmsDeson": 0.00, ' + #13 + #10
    + '     "vbcst": 0.00, ' + #13 + #10
    + '     "vst": 0.00, ' + #13 + #10
    + '     "vii": 0.00, ' + #13 + #10
    + '     "vipi": 0.00, ' + #13 + #10
    + '     "vpis": 0.00, ' + #13 + #10
    + '     "vcofins": 0.00, ' + #13 + #10
    + '     "vnf": 1.00, ' + #13 + #10
    + '     "vTotTrib": 0.00, ' + #13 + #10
    + '     "vDesc": 0.00, ' + #13 + #10
    + '     "vProd": 1.00, ' + #13 + #10
    + '     "vOutro": 0.00, ' + #13 + #10
    + '     "vSeg": 0.00, ' + #13 + #10
    + '     "vFrete": 0.00 ' + #13 + #10
    + '   } ' + #13 + #10
    + ' }, ' + #13 + #10
    + ' "informacaoAdicional":' + #13 + #10
    + ' {' + #13 + #10
    + '   "infCpl": "COO:000328 | CCF:000209 | Sequência 004 - Nota com Cliente", ' + #13 + #10
    + '   "observacoesContribuintes":' + #13 + #10
    + '   [{' + #13 + #10
    + '     "xTexto": "0.00", ' + #13 + #10
    + '     "xCampo": "Troco" ' + #13 + #10
    + '   }] ' + #13 + #10
    + ' }' + #13 + #10
    + '}';

  memEnvio.Text := jsonFecharNota;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_FecharNota(jsonFecharNota);
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio com o JSON criado
    HTTP_API := TIdHTTP.Create();
    dadosEnvioAPI := TStringStream.Create(UTF8Encode(jsonFecharNota));
    retornoFuncaoAPI := TStringStream.Create('');

    //Fechar Nota - Serviço POST
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/documento/cupom/' + numeroSessaoAtual;
    Try
      HTTP_API.Post(URL, dadosEnvioAPI, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
end;

//*********************************************************************//
//  Função Estornar Nota
//*********************************************************************//
procedure TFormMain.btnEstornarNotaClick(Sender: TObject);
Var
  retornoFuncao: String;
  URL: String;                        // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  memEnvio.Clear;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_EstornarNota();
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio
    HTTP_API := TIdHTTP.Create();
    retornoFuncaoAPI := TStringStream.Create('');

    //Estornar Nota - Serviço DELETE
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/documento/cupom/' + numeroSessaoAtual;
    Try
      HTTP_API.Delete(URL, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
end;

//*********************************************************************//
//  Função Status Impressora
//*********************************************************************//
procedure TFormMain.btnStatusImpressoraClick(Sender: TObject);
Var
  retornoFuncao: String;
  URL: String;                        // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  memEnvio.Clear;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_ObterStatusImpressora();
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio
    HTTP_API := TIdHTTP.Create();
    retornoFuncaoAPI := TStringStream.Create('');

    //Status Impressora - Serviço GET
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/impressora';
    Try
      HTTP_API.Get(URL, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
end;

//*********************************************************************//
//  Função Informação Sistema
//*********************************************************************//
procedure TFormMain.btnInformacoesSistemaClick(Sender: TObject);
Var
  retornoFuncao: String;
  URL: String;
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  memEnvio.Clear;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_ObterInformacoesSistema();
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio
    HTTP_API := TIdHTTP.Create();
    retornoFuncaoAPI := TStringStream.Create('');

    //Informações Sistema - Serviço GET
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/sistema';
    Try
      HTTP_API.Get(URL, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
end;

//*********************************************************************//
//  Função de Envio de Nota com Rejeicao
//*********************************************************************//
procedure TFormMain.btnEnviarNotaRejeicaoClick(Sender: TObject);
Var
  retornoFuncao: String;
  jsonVenderItemComErro: String;
  URL: String;                        // Para utilizar API sem DLL
  dadosEnvioAPI: TStringStream;       // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  btnAbrirNotaClick(self.btnAbrirNota); //Chamada à função de Abertura de Nota

  jsonVenderItemComErro := '{ ' + #13 + #10
    + ' "produto":' + #13 + #10
    + ' { ' + #13 + #10
    + '   "cean": "7897238304177", ' + #13 + #10
    + '   "ncm": "85258029", ' + #13 + #10
    + '   "cfop": "5101", ' + #13 + #10
    + '   "indTot": 1, ' + #13 + #10
    + '   "vUnCom": 1.000, ' + #13 + #10
    + '   "uTrib": "UN", ' + #13 + #10
    + '   "vUnTrib": "1.000", ' + #13 + #10
    + '   "cProd": "85258029901234", ' + #13 + #10
    + '   "xProd": "Produto Teste", ' + #13 + #10
    + '   "uCom": "UN", ' + #13 + #10
    + '   "qTrib": 1.000, ' + #13 + #10
    + '   "qCom": "1.000", ' + #13 + #10
    + '   "vProd": 0.00 ' + #13 + #10     //Inserido erro no valor do produto - R$0,00
    + ' }, '
    + ' "imposto":' + #13 + #10
    + ' { ' + #13 + #10
    + '   "icms":' + #13 + #10
    + '   { ' + #13 + #10
    + '     "icms00":' + #13 + #10
    + '     { ' + #13 + #10
    + '       "orig": 1, ' + #13 + #10
    + '       "cst": "00", ' + #13 + #10
    + '       "modBC": 3, ' + #13 + #10
    + '       "vbc": 1.00, ' + #13 + #10
    + '       "picms": 1.01, ' + #13 + #10
    + '       "vicms": 0.01 ' + #13 + #10
    + '     } ' + #13 + #10
    + '   }, ' + #13 + #10
    + '   "vTotTrib": 0.00 ' + #13 + #10
    + ' } ' + #13 + #10
    + '}';

  memEnvio.Text := jsonVenderItemComErro;
  memRetorno.Clear;
  memEnvio.SetFocus;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_VenderItem(jsonVenderItemComErro);
  end
  else
  begin
    //Inicializa dados de envio com o JSON criado
    HTTP_API := TIdHTTP.Create();
    dadosEnvioAPI := TStringStream.Create(UTF8Encode(jsonVenderItemComErro));
    retornoFuncaoAPI := TStringStream.Create('');

    //Vender Item - Serviço POST
    HTTP_API.Request.ContentType := 'application/json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/documento/cupom/' + numeroSessaoAtual + '/item';
    Try
      HTTP_API.Post(URL, dadosEnvioAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;

  btnPagarNotaClick(self.btnPagarNota); //Chamada à função de Efetuar Pagamento
  btnFecharNotaClick(self.btnFecharNota); //Chamada à função de Fechar Nota
end;

//*********************************************************************//
//  Função Cancelar Nota
//*********************************************************************//
procedure TFormMain.btnCancelarNotaClick(Sender: TObject);
Var
  jsonCancelarNota: String;
  retornoFuncao : String;
  dataHoraAtual : String;
  URL: String;                        // Para utilizar API sem DLL
  dadosEnvioAPI: TStringStream;       // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  dataHoraAtual := FormatDateTime('yyyy-mm-dd',(now))       //Obtem Data Atual
    + 'T' + FormatDateTime('hh:nn:ss',(now))                //Obtem Hora Atual
    + '-02:00';
    //+ FormatFloat('00', fusoHorario.Bias div -60) + ':00';  //Obtem Fuso Atual

  jsonCancelarNota := '{' + #13 + #10
    + ' "id": "' + edtChaveAcessoCancelarNota.Text + '", ' + #13 + #10
    + ' "xJust": "Cancelado pelo Desenvolvedor", ' + #13 + #10
    + ' "dhEvento": "' + dataHoraAtual + '" ' + #13 + #10
    + '}';

  memEnvio.Text := jsonCancelarNota;
  memRetorno.Clear;
  memEnvio.SetFocus;
  Screen.Cursor := crHourglass;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_CancelarNota(jsonCancelarNota);
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio com o JSON criado
    HTTP_API := TIdHTTP.Create();
    dadosEnvioAPI := TStringStream.Create(UTF8Encode(jsonCancelarNota));
    retornoFuncaoAPI := TStringStream.Create('');

    //Cancelar Nota - Serviço POST
    //ContentType - application/vnd+bematech.bnc+json
    HTTP_API.Request.ContentType := 'application/vnd+bematech.bnc+json';
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/documento/' + edtChaveAcessoCancelarNota.Text;
    Try
      HTTP_API.Post(URL, dadosEnvioAPI, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
  Screen.Cursor := crDefault;
end;

//*********************************************************************//
//  Função Consultar Nota
//*********************************************************************//
procedure TFormMain.btnConsultarNotaClick(Sender: TObject);
Var
  retornoFuncao: String;
  retornoFuncaoBytes : TIdBytes;
  jsonConsultarNota: String;
  formatoConsultarNota: String;
  arquivoPDFResposta: TextFile;
  path : String;
  URL: String;                        // Para utilizar API sem DLL
  retornoFuncaoAPI: TStringStream;    // Para utilizar API sem DLL
begin
  if(rdoDLL.Checked) then
  begin
    if(chkPDFConsultarNota.Checked) then
    begin
      formatoConsultarNota := ' "formato": "pdf" ';
    end
    else
    begin
      formatoConsultarNota := ' "formato": "json" ';
    end;

    if(Length(edtChaveAcessoConsultarNota.Text) = 0) then
    begin
      jsonConsultarNota := '{' + #13 + #10
        + ' "modelo": "65", ' + #13 + #10
        + ' "serie": "' + edtSerieConsultarNota.Text + '", ' + #13 + #10
        + ' "numero": "' + edtNumeroConsultarNota.Text + '", ' + #13 + #10
        + formatoConsultarNota + #13 + #10
        + '}';
    end
    else
    begin
      jsonConsultarNota := '{' + #13 + #10
        + ' "id": "' + edtChaveAcessoConsultarNota.Text + '", '
        + formatoConsultarNota
        + '}';
    end;

    memEnvio.Text := jsonConsultarNota;
    memRetorno.Clear;
    memEnvio.SetFocus;

    retornoFuncao := Bematech_Fiscal_ConsultarNota(jsonConsultarNota);
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio
    HTTP_API := TIdHTTP.Create();
    retornoFuncaoAPI := TStringStream.Create('');

    //Consultar Nota - Serviço GET
    HTTP_API.Request.ContentType := 'application/json';

    //Se o retorno for PDF, deve ser alterado o ContentType de Resposta para 'application/pdf'
    if(chkPDFConsultarNota.Checked) then
    begin
      HTTP_API.Request.Accept := 'application/pdf';
    end
    else
    begin
      HTTP_API.Request.Accept := 'application/json';
    end;

    if Length(edtChaveAcessoConsultarNota.Text) = 0 then
    begin
      URL := 'http://localhost:9999/api/v1/documento/65/' + edtSerieConsultarNota.Text + '/' + edtNumeroConsultarNota.Text;
    end
    else
    begin
      URL := 'http://localhost:9999/api/v1/documento/' + edtChaveAcessoConsultarNota.Text;
    end;

    memEnvio.Clear;
    memRetorno.Clear;
    memEnvio.SetFocus;

    Try
      HTTP_API.Get(URL, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
      retornoFuncao := retornoFuncaoAPI.DataString;
    except
      on E: EIdHTTPProtocolException do
      begin
        memRetorno.Lines.Add(e.ErrorMessage);
        exit;
      end;
    end;
  end;

  if(chkPDFConsultarNota.Checked) then
  begin
    path := ExtractFileDir(Application.ExeName) + '\';
    if(Length(edtChaveAcessoConsultarNota.Text) = 0) then
    begin
      path := path + edtSerieConsultarNota.Text + edtNumeroConsultarNota.Text + '.pdf';
    end
    else
    begin
      path := path + edtChaveAcessoConsultarNota.Text + '.pdf';
    end;

    //Deve ser decodificada em bytes a mensagem oriunda da API One.
    retornoFuncaoBytes := TIdDecoderMIME.DecodeBytes(retornoFuncao);

    AssignFile(arquivoPDFResposta, path);
    ReWrite(arquivoPDFResposta);
    Write(arquivoPDFResposta, BytesToString(retornoFuncaoBytes));
    CloseFile(arquivoPDFResposta);

    Application.MessageBox(PAnsiChar('Arquivo salvo em: ' + path), 'Aviso' ,mb_Ok+mb_IconExclamation);
  end;
end;

//*********************************************************************//
//  Função Texto Livre
//*********************************************************************//
procedure TFormMain.btnEnviarTextoLivreClick(Sender: TObject);
Var
  retornoFuncao: String;
  jsonEnviarTextoLivre: String;
  textoLivreBase64: String;
  URL: String;                        // Para utilizar API sem DLL
  dadosEnvioAPI: TStringStream;       // Para utilizar API sem DLL
  retornoFuncaoAPI : TStringStream;   // Para utilizar API sem DLL
begin
  memEnvio.Clear;
  memRetorno.Clear;
  memEnvio.SetFocus;

  jsonEnviarTextoLivre := '{' + #13 + #10
    + ' "dados": "';

  // Se desejar acionar guilhotina, adicionar o comando ao texto livre e converter para base64
  if(chkGuilhotinaTextoLivre.Checked) then
  begin
    textoLivreBase64 := TIdEncoderMIME.EncodeString(memEnviarTextoLivre.Text + char(27) + char(109));
    jsonEnviarTextoLivre := jsonEnviarTextoLivre + textoLivreBase64 + '", '
      + ' "base64": true ' + #13 + #10; //Uma vez que está em base64, deve ser informada a API o uso desta funcionalidade
  end
  else
  begin
    jsonEnviarTextoLivre := jsonEnviarTextoLivre + memEnviarTextoLivre.Text + char(13) + char(10) + '", '
      + ' "base64": false ' + #13 + #10;
  end;

  jsonEnviarTextoLivre := jsonEnviarTextoLivre + '}';
  memEnvio.Text := jsonEnviarTextoLivre;

  if(rdoDLL.Checked) then
  begin
    retornoFuncao := Bematech_Fiscal_ImprimirTextoLivre(jsonEnviarTextoLivre);
    memRetorno.Text := retornoFuncao;
  end
  else
  begin
    //Inicializa dados de envio com o JSON criado
    HTTP_API := TIdHTTP.Create();
    retornoFuncaoAPI := TStringStream.Create('');

    if(chkGuilhotinaTextoLivre.Checked) then
    begin
      dadosEnvioAPI := TStringStream.Create(UTF8Encode(memEnviarTextoLivre.Text + char(27) + char(109)));
      HTTP_API.Request.ContentType := 'application/json';
      HTTP_API.Request.AcceptEncoding := 'Content-Transfer-Encoding: base64';
    end
    else
    begin
      dadosEnvioAPI := TStringStream.Create(UTF8Encode(memEnviarTextoLivre.Text) + char(13) + char(10));
      //HTTP_API.Request.ContentType := 'application/json';
    end;

    //Imprimir Texto Livre - Serviço POST
    HTTP_API.Request.Accept := 'application/json';

    URL := 'http://localhost:9999/api/v1/impressora/documento/';
    Try
      HTTP_API.Post(URL, dadosEnvioAPI, retornoFuncaoAPI);
      memRetorno.Lines.Add(UTF8Decode(retornoFuncaoAPI.DataString));
    except
      on E: EIdHTTPProtocolException do
        memRetorno.Lines.Add(e.ErrorMessage);
    end;
  end;
end;

//*********************************************************************//
//  Funções Auxiliares do Exemplo - Não fazem parte da API e DLL ONE
//*********************************************************************//
procedure TFormMain.chkPDFConsultarNotaClick(Sender: TObject);
begin
  if(chkPDFConsultarNota.Checked) then
  begin
    chkJSONConsultarNota.Checked := false;
  end
  else
  begin
    chkJSONConsultarNota.Checked := true;
  end;
end;

procedure TFormMain.chkJSONConsultarNotaClick(Sender: TObject);
begin
  if(chkJSONConsultarNota.Checked) then
  begin
    chkPDFConsultarNota.Checked := false;
  end
  else
  begin
    chkPDFConsultarNota.Checked := true;
  end;
end;

end.
