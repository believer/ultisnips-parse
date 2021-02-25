module Options = {
  type t =
    | BeginningOfLine
    | ExpandAutomatically
    | ExpandInWord
    | ExpandInMiddleOfWord
    | UnknownOption

  let fromString = value => {
    switch value {
    | "A" => ExpandAutomatically
    | "b" => BeginningOfLine
    | "i" => ExpandInMiddleOfWord
    | "w" => ExpandInWord
    | _ => UnknownOption
    }
  }

  let toString = value => {
    switch value {
    | BeginningOfLine => Some("Only expand in the beginning of a line")
    | ExpandAutomatically => Some("Expands automatically")
    | ExpandInWord => Some("Can be expanded inside Vim's 'word' (check `:help iskeyword`)")
    | ExpandInMiddleOfWord => Some("Can be expanded in the middle of a word")
    | UnknownOption => None
    }
  }
}
