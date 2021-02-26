@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  let (language, selectedSnippet) = switch Route.fromPath(url.path) {
  | Home((Some(language), Some(snippet))) => (language, snippet)
  | Home((Some(language), None)) => (language, "")
  | Home((None, Some(snippet))) => ("javascript", snippet)
  | Home((None, None))
  | NotFoundRoute => ("javascript", "")
  }

  let {data, isLoading} = ReactQuery.useQuery(["snippets", language], () => Snippets.get(language))

  <div className="max-w-xl mx-auto my-20 px-5 md:px-0">
    <h1 className="text-6xl font-extrabold mb-12"> {React.string("Snippets")} </h1>
    <div className="relative mb-12">
      <select
        className="border-2 border-coolGray-300 py-2 px-8 rounded-full w-full
        appearance-none bg-transparent dark:border-coolGray-600"
        onChange={e => {
          let language = (e->ReactEvent.Form.target)["value"]
          Route.go(Home((Some(language), None)))
        }}
        value={language}>
        <option value="elixir"> {React.string("Elixir")} </option>
        <option value="elm"> {React.string("Elm")} </option>
        <option value="rails"> {React.string("Ruby on Rails")} </option>
        <option value="ruby"> {React.string("Ruby")} </option>
        <option value="javascript"> {React.string("JavaScript")} </option>
        <option value="snippets"> {React.string("Snippets")} </option>
      </select>
      <div
        className="absolute inset-y-0 right-0 flex items-center px-8
        text-gray-700 dark:text-coolGray-100 pointer-events-none">
        <svg
          className="w-4 h-4 fill-current" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
          <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
        </svg>
      </div>
    </div>
    {switch (isLoading, Js.Undefined.toOption(data)) {
    | (true, _) => <div> {React.string("Loading")} </div>
    | (false, Some(data)) => <SnippetSearch data selectedSnippet language />
    | (false, None) => <div> {React.string("No data")} </div>
    }}
  </div>
}
