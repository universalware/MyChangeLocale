unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  Vcl.Samples.Spin, Vcl.StdCtrls, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.ComCtrls;

type
  TForm_Main = class(TForm)
    FDConnection1: TFDConnection;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit_Hostname: TEdit;
    Edit_Username: TEdit;
    Edit_Password: TEdit;
    Label4: TLabel;
    ComboBox_Database: TComboBox;
    Label5: TLabel;
    SpinEdit_Port: TSpinEdit;
    Button_Connect: TButton;
    FDQuery1: TFDQuery;
    Label6: TLabel;
    ComboBox_Collations: TComboBox;
    Button_Change: TButton;
    ProgressBar1: TProgressBar;
    FDQuery2: TFDQuery;
    Label7: TLabel;
    Button1: TButton;
    procedure Button_ConnectClick(Sender: TObject);
    procedure ComboBox_DatabaseChange(Sender: TObject);
    procedure Button_ChangeClick(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit_HostnameChange(Sender: TObject);
    procedure Edit_UsernameChange(Sender: TObject);
    procedure Edit_PasswordChange(Sender: TObject);
    procedure ComboBox_CollationsChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure CheckButtons;
  public
    { Public-Deklarationen }
  end;

var
  Form_Main: TForm_Main;

implementation

uses
   Winapi.ShellAPI;

{$R *.dfm}

procedure TForm_Main.Button_ConnectClick(Sender: TObject);
var
  p: TFDPhysMySQLConnectionDefParams;
begin
  try
    FDConnection1.Close;
    p:=TFDPhysMySQLConnectionDefParams(FDConnection1.Params);
    p.Server:=Edit_Hostname.Text;
    p.Port:=SpinEdit_Port.Value;
    p.UserName:=Edit_Username.Text;
    p.Password:=Edit_Password.Text;
    FDConnection1.Open;

    ComboBox_Database.Items.Clear;
    FDQuery1.SQL.Text:='SHOW DATABASES';
    FDQuery1.Open;
    while not FDQuery1.Eof do begin
      ComboBox_Database.Items.Add(FDQuery1.Fields[0].AsString);
      FDQuery1.Next;
    end;
    FDQuery1.Close;
    ComboBox_Database.Enabled:=ComboBox_Database.Items.Count>0;

    ComboBox_Collations.Items.Clear;
    FDQuery1.SQL.Text:='SHOW COLLATION';
    FDQuery1.Open;
    while not FDQuery1.Eof do begin
      ComboBox_Collations.Items.Add(FDQuery1.Fields[0].AsString);
      FDQuery1.Next;
    end;
    FDQuery1.Close;
    ComboBox_Collations.Enabled:=ComboBox_Collations.Items.Count>0;
  except
    FDConnection1.Close;
    ComboBox_Database.Items.Clear;
    ComboBox_Database.Enabled:=false;
    ComboBox_Collations.Items.Clear;
    ComboBox_Collations.Enabled:=false;
  end;
end;

procedure TForm_Main.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm_Main.Button_ChangeClick(Sender: TObject);
var
  database: String;
  collation: String;
  table_name: String;
  column_name: String;
  column_type: String;
  sql: TStrings;
begin
  Button_Change.Enabled:=false;

  database:=ComboBox_Database.Text;
  collation:=ComboBox_Collations.Text;

  FDConnection1.ExecSQL('ALTER DATABASE `'+database+'` COLLATE '''+collation+'''');

  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT `TABLE_NAME`');
  FDQuery1.SQL.Add('FROM `information_schema`.`TABLES`');
  FDQuery1.SQL.Add('WHERE `TABLE_SCHEMA`=:database');
  FDQuery1.SQL.Add('AND `TABLE_COLLATION`!=:collation');

  FDQuery2.SQL.Clear;
  FDQuery2.SQL.Add('SELECT `COLUMN_NAME`,`COLUMN_TYPE`');
  FDQuery2.SQL.Add('FROM `information_schema`.`COLUMNS`');
  FDQuery2.SQL.Add('WHERE `TABLE_SCHEMA`=:database');
  FDQuery2.SQL.Add('AND `TABLE_NAME`=:table_name');
  FDQuery2.SQL.Add('AND `COLLATION_NAME` IS NOT NULL');
  FDQuery2.SQL.Add('AND `COLLATION_NAME`!=:collation');

  FDQuery1.ParamByName('database').AsString := database;
  FDQuery1.ParamByName('collation').AsString := collation;
  FDQuery1.Open;
  try
    ProgressBar1.Min:=0;
    ProgressBar1.Max:=FDQuery1.RecordCount;
    ProgressBar1.Position:=0;

    while not FDQuery1.Eof do begin
      table_name:=FDQuery1.Fields[0].AsString;

      sql:=TStringList.Create;
      sql.Add('ALTER TABLE `'+database+'`.`'+table_name+'`');
      sql.Add('COLLATE='''+collation+'''');

      FDQuery2.ParamByName('database').AsString := database;
      FDQuery2.ParamByName('table_name').AsString := table_name;
      FDQuery2.ParamByName('collation').AsString := collation;
      FDQuery2.Open;
      while not FDQuery2.Eof do begin
        column_name:=FDQuery2.Fields[0].AsString;
        column_type:=FDQuery2.Fields[1].AsString;
        sql.Add(',CHANGE COLUMN `'+column_name+'` `'+column_name+'` '+column_type+' COLLATE '''+collation+'''');
        FDQuery2.Next;
      end;
      FDQuery2.Close;

      FDConnection1.ExecSQL(sql.Text);

      ProgressBar1.Position:=ProgressBar1.Position+1;
      Application.ProcessMessages;

      FDQuery1.Next;
    end;
  finally
    FDQuery1.Close;
    ProgressBar1.Position:=0;
    Button_Change.Enabled:=true;
  end;
end;

procedure TForm_Main.ComboBox_CollationsChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm_Main.ComboBox_DatabaseChange(Sender: TObject);
begin
  try
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('SELECT DEFAULT_COLLATION_NAME');
    FDQuery1.SQL.Add('FROM information_schema.SCHEMATA');
    FDQuery1.SQL.Add('WHERE SCHEMA_NAME=:SCHEMA_NAME');
    FDQuery1.ParamByName('SCHEMA_NAME').AsString := ComboBox_Database.Text;
    FDQuery1.Open;
    ComboBox_Collations.ItemIndex:=ComboBox_Collations.Items.IndexOf(FDQuery1.Fields[0].AsString);
  finally
    FDQuery1.Close;
  end;
  CheckButtons;
end;

procedure TForm_Main.Edit_HostnameChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm_Main.Edit_PasswordChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm_Main.Edit_UsernameChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm_Main.FormCreate(Sender: TObject);
begin
  Button_Connect.Enabled:=false;
  Button_Change.Enabled:=false;
end;

procedure TForm_Main.Label7Click(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', PChar('https://www.universalware.de'), '', '', SW_SHOWNORMAL);
end;

procedure TForm_Main.CheckButtons;
begin
  Button_Connect.Enabled:=(Length(Edit_Hostname.Text)>0) and (Length(Edit_Username.Text)>0);
  Button_Change.Enabled:=(ComboBox_Database.ItemIndex<>-1) and (ComboBox_Collations.ItemIndex<>-1);
end;

end.

