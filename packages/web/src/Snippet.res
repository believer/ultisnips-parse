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
    | Some({description, title, prefix, body, options}) =>
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
        <div className="mb-20 prose dark:prose-dark">
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
          <pre className="text-xs relative">
            <Lib.CopyToClipboard
              text={body->Js.Array2.joinWith("\n")}
              onCopy={_ => Lib.HotToast.make->Lib.HotToast.success("Snippet copied!")}>
              <button
                className="absolute top-2 right-2 bg-green-300 text-green-900 px-2 py-1 rounded text-sm shadow-sm hover:ring-2 hover:ring-offset-2 hover:ring-green-200 dark:hover:ring-offset-coolGray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-200 dark:focus:ring-offset-coolGray-800">
                {React.string("Copy")}
              </button>
            </Lib.CopyToClipboard>
            <code> {React.string(body->Js.Array2.joinWith("\n"))} </code>
          </pre>
        </div>
      </>
    }
  }
}
