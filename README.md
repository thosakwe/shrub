# shrub
🌳 A high-level, strongly-typed language that compiles to WebAssembly.

## Example
Contrived DOM Example

```shrub
type Pokemon = {name: String, url: String}

let loadPokemonJson () =
  let xhr = Http.request "GET" "https://pokeapi.co/api/v2/pokemon" Dict.empty Body.none;
  let response = Json.decode (Http.getResponseText xhr);
  response
    | Dict -> Dict.getDict "results" response
    | _ -> raise StateError "Server response was not a Dict."

let loadPokemon () =
  let toPokemon obj = Pokemon {
    name: Dict.getString "name" obj,
    url: Dict.getString "url" obj
  };
  List.map toPokemon loadPokemon();

let () =
  let pokemon = loadPokemon();
  let addRow pk =
    let attrs = Dict [["href", pk.url], ["title", pk.name]];
    let a = Dom.createElement "a" attrs [Dom.text pk.name];
    Dom.append (Dom.querySelector "body") a;
  ;
  List.forEach addRow pokemon
```

Functions 
```shrub
let add x y = x + y

let rec fib n =
    if (n == 0 || n == 1)
        n
    else
        fib (n - 1) + fib (n - 2)
```

Types/Matching

```shrub
type Animal = variant
    | Dog { name: String }
    | Human { name: String, thumbCount: Num }

let woof anim = anim
    | Dog -> "Woof, I am " ^ anim.name
    | Human -> "I am a human. I do not woof."

let () =
    let billy = Human {name: "Billy", thumbCount: 2};
    print (woof billy)
```
