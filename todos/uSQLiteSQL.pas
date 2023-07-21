unit uSQLiteSQL;

interface

const
  // �������� �������
  Todos_Create =
    'create table if not exists ToDOs (' +
    '  ID integer not null prymary key, ' +
    '  Title text, ' +
    '  Category text, ' +
    '  isDone integer NOT NULL CHECK (isDone IN (0, 1)) ' +
    '); ';

  // ����� ������������� ID  � �������
  Todos_MaxID = 'select max(ID) as MaxID from ToDOs;' ;

  // ���������� ����� ������
  Todos_Insert =
    'insert into ToDOs (ID, Title, Category, isDone) ' +
    '  values (:Id, :title, :category, 0) ';

  // �������� ������ � ��������� ID
  Todos_Delete = 'delete from ToDOs where ID = :id ; ' ;

  // ����� ������ � ��������� ID
  Todos_Read = 'select ID, Title, Category, isDone ' +
    ' from ToDOs where ID = :id ;' ;

  // ������ ���� �������
  Todos_List = 'select ID, Title, Category, isDone from ToDOs;' ;

  // ��������� ������ � ��������� ID
  Todos_Update = 'Update ToDOs set (ID = :Id, Title=:title, ' +
    ' Category=:category, isDone=:done) ' ;

implementation

end.
