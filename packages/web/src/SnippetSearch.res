@react.component
let make = (~data: array<Snippets.snippet>) => {
  let (query, setQuery) = React.useState(() => "")

  <>
    {switch query {
    | "" => <div />
    | q =>
      let snippet = data->Js.Array2.find(({prefix}) => prefix == q)

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
    }}
    <ul className="flex flex-wrap justify-center">
      {data
      ->Belt.SortArray.stableSortBy((a, b) =>
        a.prefix->Js.String2.localeCompare(b.prefix)->Belt.Int.fromFloat
      )
      ->Belt.Array.map(({prefix, title}) => {
        <li key={title}>
          <button
            className={Cn.fromList(list{
              "mb-2 mr-2 px-4 py-2 text-left rounded focus:outline-none
              focus:ring-2 focus:ring-offset-2 focus:ring-pink-300
              dark:focus:ring-offset-coolGray-800",
              | true => "bg-pink-600 text-white"
              | false => "bg-coolGray-600 text-coolGray-200"
              },
            })}
            onClick={_ => setQuery(_ => prefix)}>
            <div className="font-bold text-sm"> {React.string(prefix)} </div>
          </button>
        </li>
      })
      ->React.array}
    </ul>
  </>
}
