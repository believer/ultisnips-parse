@react.component
let make = (~selectedSnippet, ~snippets: array<SnippetData.Snippet.t>) => {
  switch selectedSnippet {
  | "" => React.null
  | q =>
    let snippet = snippets->Js.Array2.find(({prefix}) => prefix == q)

    switch snippet {
    | None => React.null
    | Some({description, title, prefix, body, options}) =>
      <div className="mb-20 prose dark:prose-dark">
        <h2>
          {React.string(title)}
          <span className="text-coolGray-400 ml-2 text-sm"> {React.string(`(${prefix})`)} </span>
        </h2>
        <Lib.Markdown className="mb-8">
          {description->Belt.Array.joinWith("\n", v => v)}
        </Lib.Markdown>
        {switch options->Belt.Array.length {
        | 0 => React.null
        | _ => <>
            <strong> {React.string("Options:")} </strong>
            <ul>
              {options
              ->Belt.Array.map(val => {
                switch val->Ultisnips.Options.fromString->Ultisnips.Options.toString {
                | Some(v) =>
                  <li key={val}>
                    <strong> {React.string(`\`${val}\``)} </strong> {React.string(` - ${v}`)}
                  </li>
                | None => React.null
                }
              })
              ->React.array}
            </ul>
          </>
        }}
        <pre className="text-xs">
          <code> {React.string(body->Belt.Array.joinWith("\n", v => v))} </code>
        </pre>
      </div>
    }
  }
}
