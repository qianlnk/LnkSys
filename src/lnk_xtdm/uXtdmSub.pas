unit uXtdmSub;

interface

uses
  Winapi.Windows, Winapi.Messages, MyPub,System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,Data.DB, Data.Win.ADODB,
  Vcl.ComCtrls;

type
  TfrmXtdmSub = class(TForm)
    pnl4: TPanel;
    btnSave: TBitBtn;
    btnClose: TBitBtn;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    cbbType: TComboBox;
    edtValue: TEdit;
    edtSort: TEdit;
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    m_umState: char; //主界面操作标志
    m_cdsOther :TAdoDataSet;
    m_qryOperate : TAdoQuery;//用于校验
    m_cmd: TAdoCommand;  //用于操作的
    m_qryUser: TAdoQuery; //传入一条操作信息
    m_User : Integer;
  end;

var
  frmXtdmSub: TfrmXtdmSub;

implementation

{$R *.dfm}

procedure TfrmXtdmSub.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmXtdmSub.btnSaveClick(Sender: TObject);
var sLog: string;
begin
  if Trim(cbbType.Text) = '' then
  begin
    ShowMsg('提示','请输入代码类型！',self);
    cbbType.SetFocus;
    Exit;
  end;
  if EditValid(edtValue,'代码值',Self) or EditValid(edtSort,'显示顺序',Self) then
  begin
    Exit;
  end;
  if m_umState = 'A' then
  begin
    try
      with m_cmd do
      begin
        Connection.BeginTrans;
        CommandText := 'Insert into tCodeList( FType, FValue, FSort, FISExpired) '
                     + 'values(:FType, :FValue, :FSort, ''False'' )';
        //Parameters.ParamByName('FID').Value := GetNextID(m_qryOperate,'tCodeList');
        Parameters.ParamByName('FType').Value := Trim(cbbType.Text);
        Parameters.ParamByName('FValue').Value := Trim(edtValue.Text);
        Parameters.ParamByName('FSort').Value := Trim(edtSort.Text);
        Execute;
        Connection.CommitTrans;
      end;

      sLog := '表tCodeList插入数据：' + inttostr(GetNextID(m_qryOperate,'tUser') - 1) + ','
            + cbbType.Text + ',' + edtValue.Text + ',' + edtSort.Text + ',False';
      MakeLog(m_qryOperate,m_User,'系统代码添加','添加',sLog);
      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMsg('错误','错误是' + E.ClassName + '!  错误信息' + E.Message,self);

    end;
  end;
  if m_umState = 'M' then
  begin
    try
      with m_cmd do
      begin
        Connection.BeginTrans;
        CommandText := 'update tCodeList set FType = :FType, FValue = :FValue, FSort = :FSort '
                     + 'where FID = :FID';
        Parameters.ParamByName('FID').Value := Trim(m_qryUser.FieldByName('FID').AsString);
        Parameters.ParamByName('FType').Value := Trim(cbbType.Text);
        Parameters.ParamByName('FValue').Value := Trim(edtValue.Text);
        Parameters.ParamByName('FSort').Value := Trim(edtSort.Text);
        Execute;
        Connection.CommitTrans;
      end;
      sLog := '表tCodeList修改数据：' + Trim(m_qryUser.FieldByName('FID').AsString) + ','
            + cbbType.Text + ',' + edtValue.Text + ',' + edtSort.Text;
      MakeLog(m_qryOperate,m_User,'系统代码修改','修改',sLog);
      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMsg('错误','错误是' + E.ClassName + '!  错误信息' + E.Message,self);

    end;
  end;
end;

procedure TfrmXtdmSub.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ControlKey(key,Shift);
end;

procedure TfrmXtdmSub.FormShow(Sender: TObject);
var sqltxt: string;
begin
  //加载已有代码类别供选择
  sqltxt := 'select distinct FType from tCodeList';
  OpenAdoQuery(m_qryOperate,sqltxt);
  cbbType.Items.Add('');
  AddItemToCommbox(m_qryOperate,'FType',cbbType,False);
  if m_umState = 'A' then
  begin
    cbbType.SetFocus;
    Exit;
  end;
  if m_umState = 'M' then
  begin
    cbbType.SetFocus;
  end;
  if m_umState = 'V' then
  begin
    SetReadOnly(self);
    btnSave.Enabled := not btnSave.Enabled;
  end;

  with m_qryUser do
  begin
    cbbType.Text := Trim(FieldByName('FType').AsString);
    edtValue.Text := Trim(FieldByName('FValue').AsString);
    edtSort.Text := Trim(FieldByName('FSort').AsString);
  end;
end;

end.
