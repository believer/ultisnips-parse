@val @scope("localStorage") external setItem: (string, string) => unit = "setItem"
@val @scope("localStorage") external getItem: string => Js.Nullable.t<string> = "getItem"
@val @scope("localStorage") external removeItem: string => unit = "removeItem"

module type Config = {
  type t

  let key: string
  let fromString: option<string> => t
  let toString: t => string
}

module Make = (Config: Config) => {
  let useLocalStorage = () => {
    let internalKey = `snippets-${Config.key}`
    let (state, setState) = React.useState(() => getItem(internalKey))

    let setValue = value => {
      setItem(internalKey, value->Config.toString)
      setState(_ => getItem(internalKey))
    }

    (state->Js.Nullable.toOption->Config.fromString, setValue)
  }
}
