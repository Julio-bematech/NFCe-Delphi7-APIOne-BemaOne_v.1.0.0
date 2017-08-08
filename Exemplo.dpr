program Exemplo;

uses
  Forms,
  FormPrincipal in 'FormPrincipal.pas' {FormMain},
  UnitDeclaracoes in 'UnitDeclaracoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exemplo Delphi 7';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
