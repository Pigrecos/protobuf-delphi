unit TestSGL;

interface

uses
  System.SysUtils, System.TypInfo, PersonSGL, Oz.Pb.StrBuffer, Oz.Pb.Classes;

{$T+}

procedure RunTest;

implementation

// generate data
procedure GenData(var AddressBook: TAddressBook);
var
  Person: TPerson;
  Phone: TPhoneNumber;
begin
  // data
  Person.Init;
  Person.Name := 'Oz Grock';
  Person.Id := 1;
  Person.Email := 'oz@mail.com';

  // home phones
  Phone.Init;
  Phone.&Type := TPhoneType.HOME;
  Phone.Number := '+7 382 224 99999';
  Person.Phones.Add(@Phone);

  Phone.Init;
  Phone.&Type := TPhoneType.MOBILE;
  Phone.Number := '999999';
  Person.Phones.Add(@Phone);
  AddressBook.Peoples.Add(@Person);

  // data
  Person.Init;
  Person.Name := 'Marat Shaimardanov';
  Person.Id := 2;
  Person.Email := 'marat.sh.1961@gmail.com';

  // single message
  Phone.Init;
  Phone.Number := 'qwerty';
  Person.MyPhone := Phone;

  // home phones
  Phone.Init;
  Phone.&Type := TPhoneType.HOME;
  Phone.Number := '+7 382 224 3699';

  // mobile phone
  Phone.Init;
  Phone.&Type := TPhoneType.MOBILE;
  Phone.Number := '+7 913 826 2144';
  Person.Phones.Add(@Phone);
  AddressBook.Peoples.Add(@Person);
end;

// save data to proto file
procedure SaveData(var AddressBook: TAddressBook);
var
  Saver: TpbSaver;
begin
  // save data
  Saver.Init;
  try
    TpbSaver.SaveAddressBook(Saver, AddressBook);
    Saver.Pb.SaveToFile('peoples.pb');
  finally
    Saver.Free;
  end;
end;

procedure ReadDataAndDump;
var
  AddressBook: TAddressBook;
  Person: PPerson;
  PhoneNumber: PPhoneNumber;
  Loader: TpbLoader;
  i: Integer;
begin
  Loader.Init;
  try
    Loader.Pb.LoadFromFile('peoples.pb');
    try
      Loader.LoadAddressBook(AddressBook);
      for i := 0 to AddressBook.Peoples.Count - 1 do
      begin
        Person := AddressBook.Peoples.Items[i];
        // write to console
        Writeln('Name   : ', Person.Name);
        Writeln('Id     : ', IntToStr(Person.Id));
        Writeln('e-mail : ', Person.Email);
        Writeln('phone  : ', Person.MyPhone.Number);
        for PhoneNumber in Person.Phones do
        begin
          Writeln('  Number: ', PhoneNumber.Number);
          Writeln('  Type: ', GetEnumName(TypeInfo(TPhoneType),
            Integer(PhoneNumber.&Type)));
        end;
      end;
      Readln;
    finally
      AddressBook.Free;
    end;
  finally
    Loader.Free;
  end;
end;

procedure TestPerson;
var
  AddressBook: TAddressBook;
begin
  AddressBook.Init;
  try
    Writeln('Run Protocol Buffer Tests');
    GenData(AddressBook);
    SaveData(AddressBook);
  finally
    AddressBook.Free;
  end;
  ReadDataAndDump;
end;

procedure RunTest;
begin
  TestPerson;
end;

end.
