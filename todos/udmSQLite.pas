unit udmSQLite;

interface

uses
  System.SysUtils, System.Classes,
  udatatypes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

const
  // Путь к базе данных по умолчанию
  DBDEFAULT = 'C:\Users\Public\Documents\Embarcadero\Studio\22.0\Samples\data\FDDemo.sdb' ;

  // Создание таблицы
  Todos_Create =
    'create table if not exists ToDOs (' +
    '  ID integer not null prymary key, ' +
    '  Title text, ' +
    '  Category text, ' +
    '  isDone integer NOT NULL CHECK (isDone IN (0, 1)) ' +
    '); ';
  // Поиск максимального ID  в таблице
  Todos_MaxID = 'select max(ID) as MaxID from ToDOs;' ;

  // добавление новой записи
  Todos_Insert =
    'insert into ToDOs (ID, Title, Category, isDone) ' +
    '  values (:Id, :title, :category, 0) ';

  // удаление записи с указанным ID
  Todos_Delete = 'delete from ToDOs where ID = :id ; ' ;

  // Поиск записи с указанным ID
  Todos_Read = 'select ID, Title, Category, isDone ' +
    ' from ToDOs where ID = :id ;' ;

  // Выдача всех записей
  Todos_List = 'select ID, Title, Category, isDone from ToDOs' ;

  // Изменение записи с указанным ID
  Todos_Update = 'Update ToDOs set (ID = :Id, Title=:title, ' +
    ' Category=:category, isDone=:done) ' ;

type

  TdataM = class(TDataModule,IADCRUDL)
    Sqlite_demoConnection: TFDConnection;
    TodosTable: TFDQuery;
    FDQGetMaxID: TFDQuery;
    FDQInsert: TFDQuery;
    FDQUpdate: TFDQuery;
    FDQRead: TFDQuery;
    FDQDelete: TFDQuery;
    FDQList: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure Sqlite_demoConnectionAfterConnect(Sender: TObject);
    procedure Sqlite_demoConnectionBeforeConnect(Sender: TObject);
  private
    { Private declarations }
    DBpath: string;
    function GetNewID: integer;
  public
    { Public declarations }

    // IADCRUDL implementation
    function todoCreate(const rec: TTodo): Integer;
    function todoRead(id: integer; out rec: TTodo): boolean;
    function todoUpdate(const rec: TTodo): boolean;
    function todoDelete(const id: integer): boolean;
    procedure todoList(store: TTodos);
  end;

var
  dataM: TdataM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}



{$R *.dfm}

{ TdataM }

procedure TdataM.DataModuleCreate(Sender: TObject);
begin
  DBPath := DBDEFAULT;
end;

function TdataM.GetNewID: integer;
var fld: TField;
  MyClass: TObject;
begin
  FDQGetMaxID.Open;
  try
    fld := FDQGetMaxID.FieldByName('MaxID');
    if fld.isNull then
      Result := 1
    else
    Result := fld.AsInteger +1;
  finally
    FDQGetMaxID.Close;
  end;
end;

procedure TdataM.Sqlite_demoConnectionAfterConnect(Sender: TObject);
begin
//  if isMobilePlatform then
//  begin
//    TodosTable.ExecSQL(Todos_Create);
//  end;
end;

procedure TdataM.Sqlite_demoConnectionBeforeConnect(Sender: TObject);
begin
//  if isMobilePlatform then
//     DBpath := ...

  Sqlite_demoConnection.Params.Values['Database'] := DBpath;
end;

function TdataM.todoCreate(const rec: TTodo): Integer;
var newID : integer;
begin
  newID := GetNewID;
  FDQInsert.ParamByName('ID').AsInteger := newID;
  FDQInsert.ParamByName('Title').AsString := rec.Title;
  FDQInsert.ParamByName('Category').AsString := rec.Category;
  try
    FDQInsert.ExecSQL;
    Result := newID;
  except
    Result := -1 ;
  end;
end;

function TdataM.todoDelete(const id: integer): boolean;
begin
  FDQDelete.ParamByName('ID').AsInteger := id;
  try
    FDQDelete.ExecSQL;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TdataM.todoList(store: TTodos);
var
  item: TTodo;
begin
  // FDQList.SQL.Text := Todos_List + ' order by ID;' ;
  if store = nil then exit;
  store.Clear;
  FDQList.Open(Todos_List + ' order by ID;');
  try
    while not FDQList.eof do
    begin
      item.ID := FDQList.FieldByName('ID').AsInteger;
      item.Isdone := FDQList.FieldByName('isDone').AsInteger;
      item.Title := FDQList.FieldByName('Title').AsString;
      item.Category := FDQList.FieldByName('Category').AsString;
      store.Add(item);
      FDQList.Next;
    end;

  finally
    FDQList.Close;
  end;
end;

function TdataM.todoRead(id: integer; out rec: TTodo): boolean;
begin
  FDQRead.ParamByName('ID').AsInteger := id;
  FDQRead.Open;
  try
    if FDQRead.RecordCount > 0 then
    begin
      rec.ID := FDQRead.FieldByName('ID').AsInteger;
      rec.Isdone := FDQRead.FieldByName('isDone').AsInteger;
      rec.Title := FDQRead.FieldByName('Title').AsString;
      rec.Category := FDQRead.FieldByName('Category').AsString;
      Result:= True;
    end
    else
      Result:= False;
  finally
    FDQRead.Close;
  end;
end;

function TdataM.todoUpdate(const rec: TTodo): boolean;
begin
  FDQUpdate.ParamByName('ID').AsInteger := rec.ID;
  FDQUpdate.ParamByName('Title').AsString := rec.Title;
  FDQUpdate.ParamByName('Category').AsString := rec.Category;
  FDQUpdate.ParamByName('Done').AsInteger := rec.Isdone;
  try
    FDQUpdate.ExecSQL;
    Result := True;
  except
    Result := False ;
  end;
end;

end.
