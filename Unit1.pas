unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  ComCtrls, ShellApi;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ icoShell Index
function Shell_ico_Index(FullPath: string): integer;
//uses ShellApi
var ShInfo: TSHFileInfo;
begin

SHGetFileInfo( PChar(FullPath), 0, ShInfo, SizeOf(ShInfo), SHGFI_TYPENAME or SHGFI_SYSICONINDEX );
Result := ShInfo.iIcon;

end;



//------------------------------------------------------------------------------ icoShell Load All
procedure Shell_ico_LoadAll(MyImageList: TImageList; icoSmall: Boolean);
//загружаем системные иконки типов файлов в ImageListы
//uses ShellApi
var
 SysImageList: uint;
 Flags: Cardinal;
 ShInfo: ShFileInfo;

begin

if icoSmall
then Flags := SHGFI_SYSICONINDEX or SHGFI_SMALLICON {or SHGFI_USEFILEATTRIBUTES}
else Flags := SHGFI_SYSICONINDEX or SHGFI_LARGEICON {or SHGFI_USEFILEATTRIBUTES};


//Запрашиваем иконки
SysImageList := SHGetFileInfo('', 0, ShInfo, SizeOf(TSHFileInfo), Flags);


if SysImageList <> 0
then MyImageList.Handle := SysImageList;

end;



//------------------------------------------------------------------------------ LV as Explorer
procedure LVasExplorer(LV: TListView; Path: string; HideShow: Boolean);
var
  sr: TSearchRec;
  xItem: TListItem;
  icoListSmall, icoListLarge: TImageList;
  Atrib: integer;

begin

if Length(Path) = 1
then Path := Path + ':\'
else Path := IncludeTrailingBackSlash(Path);


if not DirectoryExists(Path) then exit;


if HideShow
then Atrib := faDirectory + faAnyFile + faVolumeID
else Atrib := faDirectory + faAnyFile + faVolumeID - faHidden - faSysFile;

if FindFirst(Path + '*.*', Atrib, sr) <> 0
then
begin
//  ShowMessage(Path+' - ПАПКИ НЕ СУЩЕСТВУЕТ!'); //uses Dialogs
  exit;
end;


LV.Cursor := crHourGlass;

LV.Items.BeginUpdate;

while LV.Columns.Count < 3 do
 LV.Columns.Add;



{$REGION ' Icons '}


//Создаем списки маленьких иконок типов файлов
if LV.SmallImages = nil

then
begin
  icoListSmall := TImageList.Create(LV.Owner);
  LV.SmallImages := icoListSmall;
end

else icoListSmall := LV.SmallImages as TImageList;


//Создаем списки больших иконок типов файлов
if LV.LargeImages = nil

then
begin
  icoListLarge := TImageList.Create(LV.Owner);
  LV.LargeImages := icoListLarge;
end

else icoListLarge := LV.LargeImages as TImageList;

Shell_ico_LoadAll(LV.SmallImages as TImageList, True);
Shell_ico_LoadAll(LV.LargeImages as TImageList, False);


{$ENDREGION}



LV.Items.Clear;

repeat
      if sr.Name = ''   then Continue;
      if sr.Name = '.'  then Continue;
      if sr.Name = '..' then Continue;

      if sr.Attr and faDirectory = faDirectory

      then//папка
      begin
          xItem := LV.Items.Add;
          xItem.Caption := (sr.Name);          //Name
          xItem.SubItems.Add('\Folder'); //Folder type
          xItem.SubItems.Add( inttostr(sr.Size) );
          xItem.ImageIndex := Shell_ico_Index(Path + sr.Name); //ico
      end

      else//файл
      begin
          xItem := LV.Items.Add;
          xItem.Caption := sr.Name;  //Name
          xItem.SubItems.Add( Copy(ExtractFileExt(sr.Name), 2) ); //Ext
          xItem.SubItems.Add( inttostr(sr.Size) ); //Size
          xItem.ImageIndex := Shell_ico_Index(Path + sr.Name); //ico
      end;

until FindNext(sr) <> 0;

FindClose(sr);

LV.Items.EndUpdate;

LV.Cursor := crDefault;
end;




procedure TForm1.Button1Click(Sender: TObject);
begin
LVasExplorer(ListView1, 'D:\', True)
end;



end.
