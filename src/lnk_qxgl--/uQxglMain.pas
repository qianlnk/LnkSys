unit uQxglMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB;

type
  TQxglMain = class(TForm)
    con1: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    m_user : string;
  end;

var
  QxglMain: TQxglMain;

implementation

{$R *.dfm}

end.
