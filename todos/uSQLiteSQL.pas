unit uSQLiteSQL;

interface

const
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
  Todos_List = 'select ID, Title, Category, isDone from ToDOs;' ;

  // Изменение записи с указанным ID
  Todos_Update = 'Update ToDOs set (ID = :Id, Title=:title, ' +
    ' Category=:category, isDone=:done) ' ;

implementation

end.
