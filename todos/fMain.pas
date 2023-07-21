unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs
  , udatatypes, System.Actions, FMX.ActnList, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit;

type
  TForm5 = class(TForm)
    tbcMain: TTabControl;
    tbItem: TTabItem;
    tbList: TTabItem;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ActionList1: TActionList;
    ctaList: TChangeTabAction;
    ctaItem: TChangeTabAction;
    lvwToDOs: TListView;
    sbAdd: TSpeedButton;
    sbBack: TSpeedButton;
    sbSave: TSpeedButton;
    sbDelete: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    edTitle: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edCategory: TEdit;
    CheckBox1: TCheckBox;
    acAdd: TAction;
    acDelete: TAction;
    acSave: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure lvwToDOsDeleteItem(Sender: TObject; AIndex: Integer);
    procedure lvwToDOsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    FTodos: TToDOs;
    FCurrentID: integer;
    function getToDoData: IADCRUDL;
  public
    { Public declarations }
    procedure RefreshList;
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

uses udmSQLite;


{ TForm5 }

procedure TForm5.acAddExecute(Sender: TObject);
begin
  FCurrentID := -1;
  edTitle.Text := '';
  edCategory.Text := '';
  CheckBox1.IsChecked := False;
  ctaItem.ExecuteTarget(self);
end;

procedure TForm5.acDeleteExecute(Sender: TObject);
begin
  if FCurrentID > 0 then
  begin
    getToDoData.todoDelete(FCurrentID);
    RefreshList;

  end;
  if tbcMain.ActiveTab <> tbList then
    ctaList.ExecuteTarget(self);
end;

procedure TForm5.acSaveExecute(Sender: TObject);
var
  todo: TToDO;
begin
  todo.Title := edTitle.Text;
  todo.Category := edCategory.Text;
  if CheckBox1.IsChecked then todo.Isdone := 1 else todo.Isdone := 0;
  if FCurrentID < 0 then
    getToDoData.todoCreate(todo)
  else begin
    todo.ID := FCurrentID;
    getToDoData.todoUpdate(todo);
  end;
  RefreshList;
  ctaList.ExecuteTarget(self);
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  FTodos := TTodos.Create;
  tbcMain.ActiveTab := tbList;
  RefreshList;
end;

procedure TForm5.FormDestroy(Sender: TObject);
begin
  FTodos.Free;
end;

function TForm5.getToDoData: IADCRUDL;
begin
  if dataM = nil then
    dataM := TdataM.Create(application);
  Result:= dataM;
end;

procedure TForm5.lvwToDOsDeleteItem(Sender: TObject; AIndex: Integer);
begin
  FCurrentID := FTodos[AIndex].ID;
  acDelete.Execute;
end;

procedure TForm5.lvwToDOsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var todo: TTodo;
begin
  FCurrentID := AItem.Tag;
  getToDoData.todoRead(FCurrentID, todo);
  edTitle.Text := todo.Title;
  edCategory.Text := todo.Category;
  CheckBox1.IsChecked := todo.Isdone > 0;
  ctaItem.ExecuteTarget(self);
end;

procedure TForm5.RefreshList;
var
  todo: TTodo;
  item: TListViewItem;
begin
  getToDoData.todoList(FTodos);
  lvwToDOs.BeginUpdate;
  try
    lvwToDOs.Items.Clear;
    for todo in FTodos do
    begin
      item := lvwToDOs.Items.Add;
      item.Tag := todo.ID;
      item.Objects.FindObjectT<TListItemText>('Title').Text := todo.Title;
      item.Objects.FindObjectT<TListItemText>('Category').Text := todo.Category;
    end;
  finally
    lvwToDOs.EndUpdate;
  end;
end;

end.
