let renderers: Lib.Markdown.Renderers.t = {
  link: data => {
    switch data.href->Js.String2.split("/")->Js.Array2.filter(v => v !== "") {
    | [language, snippet] =>
      <Route.Link to_={Route.Home((Some(language), Some(snippet)))}> {data.children} </Route.Link>
    | _ => <a href={data.href}> {data.children} </a>
    }
  },
}

@react.component
let make = (~selectedSnippet, ~snippets: array<Api.Snippet.t>) => {
  switch selectedSnippet {
  | "" => React.null
  | q =>
    let snippet = snippets->Js.Array2.find(({prefix}) => prefix == q)

    switch snippet {
    | None => React.null
    | Some({description, title, prefix, options} as data) =>
      let optionsAsText =
        options
        ->Js.Array2.map(val => {
          switch val->Ultisnips.Options.fromString->Ultisnips.Options.toString {
          | Some(v) => `- \`${val}\` - ${v}`
          | None => ""
          }
        })
        ->Js.Array2.joinWith("\n")

      <>
        <div className="mb-8 prose dark:prose-dark">
          <h2>
            {React.string(title)}
            <span className="text-coolGray-400 ml-2 text-sm"> {React.string(`(${prefix})`)} </span>
          </h2>
          <Lib.Markdown className="mb-8" renderers>
            {description->Js.Array2.joinWith("\n")}
          </Lib.Markdown>
          {switch options->Belt.Array.length {
          | 0 => React.null
          | _ => <>
              <Lib.Markdown>
                {`**Options:**

${optionsAsText}
          `}
              </Lib.Markdown>
            </>
          }}
        </div>
        <SnippetCode data />
      </>
    }
  }
}
