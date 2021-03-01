let baseUrl = "https://snippets-parser.willcodefor.beer/api"

type t<'a> = Loading | Data('a) | NoData

module Response = {
  type t<'data>
  @send external json: t<'data> => Promise.t<'data> = "json"
}

type response = {"token": Js.Nullable.t<string>, "error": Js.Nullable.t<string>}

module Snippet = {
  type t = {
    body: array<string>,
    description: array<string>,
    options: array<string>,
    prefix: string,
    title: string,
  }
}

module Snippets = {
  @val @scope("globalThis")
  external fetch: string => Promise.t<Response.t<array<Snippet.t>>> = "fetch"

  let get = language => {
    open Promise

    fetch(`${baseUrl}/snippet?language=${language}`)
    ->then(res => Response.json(res))
    ->then(data => resolve(data))
  }

  let useSnippets = language => {
    let {data, isLoading} = ReactQuery.useArrayQuery(["snippets", language], () => get(language))

    switch (isLoading, Js.Undefined.toOption(data)) {
    | (true, _) => Loading
    | (false, Some(data)) => Data(data)
    | (false, None) => NoData
    }
  }
}

module Language = {
  type t = {
    id: string,
    name: string,
  }
}

module Langauges = {
  @val @scope("globalThis")
  external fetch: string => Promise.t<Response.t<array<Language.t>>> = "fetch"

  let get = () => {
    open Promise

    fetch(`${baseUrl}/languages`)->then(res => Response.json(res))->then(data => resolve(data))
  }

  let useLanguages = () => {
    let {data, isLoading} = ReactQuery.useQuery("languages", () => get())

    switch (isLoading, Js.Undefined.toOption(data)) {
    | (true, _) => Loading
    | (false, Some(data)) => Data(data)
    | (false, None) => NoData
    }
  }
}
