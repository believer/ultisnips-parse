let defaultLanguage = "javascript"

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  let (language, selectedSnippet) = switch Route.fromPath(url.path) {
  | Home((Some(language), Some(snippet))) => (language, snippet)
  | Home((Some(language), None)) => (language, "")
  | Home((None, Some(snippet))) => (defaultLanguage, snippet)
  | Home((None, None))
  | NotFoundRoute => (defaultLanguage, "")
  }

  let snippets = Api.Snippets.useSnippets(language)

  <div className="max-w-xl mx-auto my-20 px-5 md:px-0">
    <h1 className="text-6xl font-extrabold mb-12"> {React.string("Snippets")} </h1>
    <LanguageSelect language />
    {switch snippets {
    | Loading => <div> {React.string(`Fetching the awesome ${language} snippets`)} </div>
    | NoData => <div> {React.string("No data")} </div>
    | Data(snippets) =>
      switch snippets->Belt.Array.length {
      | 0 =>
        <div>
          {React.string("The snippets exist in the ")}
          <a
            className="dark:text-pink-300 text-pink-800"
            href={`https://github.com/believer/dotfiles/blob/master/coc/ultisnips/${language}.snippets`}
            target="_blank"
            rel="noopener noreferrer">
            {React.string("original file")}
          </a>
          {React.string(
            ". They aren't shown here because they haven't been properly documented yet.",
          )}
        </div>
      | _ => <>
          <Snippet selectedSnippet snippets />
          <SnippetSelection language selectedSnippet snippets />
        </>
      }
    }}
  </div>
}
