import Map "mo:base/HashMap";
import Text "mo:base/Text";


//actor->canister->smart contract

actor{
  //Motoko is typed language

  type Name = Text;
  type Phone = Text;

  type Entry = {
    desc: Text;
    phone: Phone;
  };

  //let for unmutable variables
  //phonebook varibale is our storage
  //0 is the id of stored data and as we add data it is incremented
  //
  let phonebook = Map.HashMap<Name, Entry>(0, Text.equal, Text.hash);

  //Functions:
  //query functions: to check data 
  //update functions: to update data

  //insert is update function
  public func insert(name: Name, entry: Entry): async(){
    phonebook.put(name, entry);
  };


  //? is for optioanl type. in our case it means returned value is either null or Entry type
  public query func lookup(name: Name): async ?Entry{
    phonebook.get(name) //last expression in the function body is returned. return keyword and semicolon(;) is optional
  };

};