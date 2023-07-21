program todos;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {Form5},
  udatatypes in 'udatatypes.pas',
  udmSQLite in 'udmSQLite.pas' {dataM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
