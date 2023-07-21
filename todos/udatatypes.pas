unit udatatypes;

interface

uses
  System.Generics.Collections;

type

  TTodo = record
    ID: integer;
    Title: string;
    Category: string;
    Isdone: integer;
  end;

  TTodos = TList<TTodo>;


  IADCRUDL = interface
    function todoCreate(const rec: TTodo): integer;
    function todoRead(id: integer; out rec: TTodo): boolean;
    function todoUpdate(const rec: TTodo): boolean;
    function todoDelete(const id: integer): boolean;
    procedure todoList(store: TTodos);
  end;

implementation

end.
