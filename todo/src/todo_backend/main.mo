import Map "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";


actor Assistant {
  type ToDo = {
    description: Text;
    completed: Bool;
  };

  //In order to declare private function we omit "public" keyword
  func natHash(n: Nat): Hash.Hash {
    Text.hash(Nat.toText(n))
  };



  //In (0, Nat.equal, natHash):
  // 0 means hash map has capacity of zero(i.e. empty)
  // Nat.equal means how hash internally resolves collision: when two numbers n1 and n2 hashes two same bucket,
  // then equality n1=n2 is checked, if true that means keys are same and we accessed same value, otherwise not.
  // If our keys were non-primitive types then we might want to specify custom equality function. 
  var todos =  Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId: Nat = 0;

  public query func getTodos(): async [ToDo]{
    //Values in todos are put into array 
    Iter.toArray(todos.vals());
  };

  public func addTodo(description: Text) : async Nat{
    let id = nextId;
    todos.put(id, {description = description; completed = false});
    nextId +=1;
    id
  };

  public func completeTodo(id: Nat): async(){
    //If todos.get(id) returnd null(i.e. there is no entry with 'id'), then whole 'do' block
    //evaluates to null and that is what we ignore. Otherwise , we change 'completed' field of entry with 'id' to true.
    ignore do ?{
      let description = todos.get(id)!.description;
      todos.put(id, {description; completed=true})
    }
  };


  //Outputs Toddolist in nice way(header, and puts '+'' beside the ones that are completed)
  public query func showTodos(): async Text{
    var output: Text = "\n_____TO-DOs_____";
    for(todo: ToDo in todos.vals()){
      output #= "\n" # todo.description;
      if(todo.completed){
        output #= "  +";
      };
    };
    output # "\n"
  };


  //mapFilter<Nat, ToDo, ToDo> means mapFilter function take map with key type Nat and value type ToDo and converts it to new map 
  //which has value type ToDo(and keys are same type Nat)
  public func clearCompleted(): async(){
    todos:= Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
    func(_,todo){if(todo.completed) null else ?todo});
  }

};