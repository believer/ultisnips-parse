@react.component
let make = (~snippets: array<Api.Snippet.t>, ~language, ~selectedSnippet) => {
  let selectSnippet = prefix => {
    Route.go(Home(Some(language), Some(prefix)))
  }

  <ul className="flex flex-wrap justify-center">
    {snippets
    ->Belt.SortArray.stableSortBy((a, b) =>
      a.prefix->Js.String2.localeCompare(b.prefix)->Belt.Int.fromFloat
    )
    ->Belt.Array.map(({prefix, title}) => {
      <li key={title}>
        <button
          className={Cn.fromList(list{
            "mb-2 mr-2 px-4 py-2 text-left rounded focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-300 dark:focus:ring-offset-coolGray-800 hover:ring-offset-2 hover:ring-pink-300 hover:ring-2 dark:hover:ring-offset-coolGray-800",
            switch prefix == selectedSnippet {
            | true => "bg-pink-600 text-white"
            | false => "bg-coolGray-600 text-coolGray-200"
            },
          })}
          onClick={_ => selectSnippet(prefix)}>
          <div className="font-bold text-sm"> {React.string(prefix)} </div>
        </button>
      </li>
    })
    ->React.array}
  </ul>
}
