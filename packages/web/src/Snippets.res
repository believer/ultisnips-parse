module Response = {
  type t<'data>
  @send external json: t<'data> => Promise.t<'data> = "json"
}

type response = {"token": Js.Nullable.t<string>, "error": Js.Nullable.t<string>}

type snippet = {
  body: array<string>,
  description: array<string>,
  options: array<string>,
  prefix: string,
  title: string,
}

@val @scope("globalThis")
external fetch: string => Promise.t<Response.t<array<snippet>>> = "fetch"

let get = language => {
  open Promise

  fetch(`https://ultisnips-parse.vercel.app/api?language=${language}`)
  ->then(res => Response.json(res))
  ->then(data => resolve(data))
}
