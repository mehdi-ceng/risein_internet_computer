import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Option "mo:base/Option";
import List "mo:base/List";
import Text "mo:base/Text";


actor Superheroes{
  public type SuperheroId = Nat32;

  public type Superhero = {
    name: Text;
    superpowers: List.List<Text>;
  };

  private stable var next: SuperheroId = 0;

  private stable var superheroes: Trie.Trie<SuperheroId, Superhero> = Trie.empty();


  //hash is simple here. But we can write cusotom hash function for the Superhero type then use that
  //If 'x' was primitive type, let's say Text, then 'hash = Text.hash x' can be used(functions with single
  // argument can omit argument parantheses i.e. 'hash = Text.hash x' is same as 'hash = Text.hash(x)')
  private func key(x: SuperheroId): Trie.Key<SuperheroId>{
    {hash = x; key = x}
  };
  

  //Trie data structure is used.
  //Here key(superheroId) is paired with superhero.
  //Trie.replace(superheroes,key(superheroId),Nat32.equal,?superhero).0 returns tuple (Trie<SuperheroId, Superhero>, Superhero)
  //and we access first element of the tuple by .0 notation
  public func create(superhero: Superhero) : async SuperheroId {
    let superheroId = next;
    next+=1;
    superheroes:=Trie.replace(
      superheroes,
      key(superheroId),
      Nat32.equal,
      ?superhero
    ).0;
    superheroId
  };


  public query func read(superheroId: SuperheroId): async ?Superhero{
    let result  = Trie.find(superheroes, key(superheroId), Nat32.equal);
    result
  };


  public func update(superheroId: SuperheroId, superhero: Superhero): async Bool{
    let result = Trie.find(superheroes, key(superheroId), Nat32.equal);
    let exists = Option.isSome(result);
    if(exists){
      superheroes:=Trie.replace(
        superheroes,
        key(superheroId),
        Nat32.equal,
        ?superhero
      ).0;
    };
    exists
  };


  public func delete(superheroId: SuperheroId): async Bool{
    let result = Trie.find(superheroes, key(superheroId), Nat32.equal);
    let exists = Option.isSome(result);
    if(exists){
      superheroes:=Trie.replace(
        superheroes,
        key(superheroId),
        Nat32.equal,
        null
      ).0;
    };
    exists
  };


};
