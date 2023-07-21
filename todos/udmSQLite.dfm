object dataM: TdataM
  OnCreate = DataModuleCreate
  Height = 411
  Width = 582
  object Sqlite_demoConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=SQLite_Demo')
    Connected = True
    LoginPrompt = False
    AfterConnect = Sqlite_demoConnectionAfterConnect
    BeforeConnect = Sqlite_demoConnectionBeforeConnect
    Left = 76
    Top = 41
  end
  object TodosTable: TFDQuery
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'SELECT * FROM ToDOs')
    Left = 76
    Top = 121
  end
  object FDQGetMaxID: TFDQuery
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'select max(ID) as MaxID from ToDOs;')
    Left = 200
    Top = 41
  end
  object FDQInsert: TFDQuery
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'insert into ToDOs (ID, Title, Category, isDone) '
      '    values (:Id, :title, :category, 0)')
    Left = 296
    Top = 40
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'TITLE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'CATEGORY'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDQUpdate: TFDQuery
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'Update ToDOs set (ID = :Id, Title=:title, '
      ' Category=:category, isDone=:done);')
    Left = 296
    Top = 176
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'TITLE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'CATEGORY'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DONE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDQRead: TFDQuery
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'select ID, Title, Category, isDone '
      ' from ToDOs where ID = :id')
    Left = 296
    Top = 104
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDQDelete: TFDQuery
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'delete from ToDOs where ID = :id ;')
    Left = 296
    Top = 248
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDQList: TFDQuery
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'select ID, Title, Category, isDone from ToDOs;')
    Left = 296
    Top = 320
  end
end
