module Settings = {
  type t = Default | FullSnippet | VSCode

  let key = "copy-type"

  let fromString = value =>
    switch value {
    | Some("default") => Default
    | Some("full-snippet") => FullSnippet
    | Some("vscode") => VSCode
    | Some(_)
    | None =>
      Default
    }

  let toString = value =>
    switch value {
    | Default => "default"
    | FullSnippet => "full-snippet"
    | VSCode => "vscode"
    }
}

type t = Code | Settings

module SettingsStorage = Storage.Make(Settings)

@react.component
let make = (~data: Api.Snippet.t) => {
  let (display, setDisplay) = React.useState(() => Code)
  let (copyType, setCopyType) = SettingsStorage.useLocalStorage()
  let {body} = data

  <div className="mb-20">
    <div className="text-white bg-coolGray-700 rounded-t">
      {switch display {
      | Code =>
        <pre className="py-4 pl-4 pr-8 text-sm overflow-x-auto">
          <code> {React.string(body->Js.Array2.joinWith("\n"))} </code>
        </pre>
      | Settings =>
        <div className="p-4 space-y-4">
          <Form.RadioButtonGroup
            label="How to copy the snippet"
            name="copy-type"
            onChange={value => {setCopyType(Settings.fromString(value))}}>
            <Form.RadioButton
              checked={switch copyType {
              | Default => true
              | FullSnippet
              | VSCode => false
              }}
              id={Settings.toString(Default)}
              label="Default (snippet only)"
              name="copy-type"
              value={Settings.toString(Default)}
            />
            <Form.RadioButton
              checked={switch copyType {
              | FullSnippet => true
              | Default
              | VSCode => false
              }}
              id={Settings.toString(FullSnippet)}
              label="Full snippet (with UltiSnips start and end)"
              name="copy-type"
              value={Settings.toString(FullSnippet)}
            />
            <Form.RadioButton
              checked={switch copyType {
              | VSCode => true
              | FullSnippet
              | Default => false
              }}
              id={Settings.toString(VSCode)}
              label="VSCode snippet (some snippets won't work out of the box)"
              name="copy-type"
              value={Settings.toString(VSCode)}
            />
          </Form.RadioButtonGroup>
        </div>
      }}
    </div>
    <div className="bg-coolGray-900 rounded-b flex justify-end p-2 gap-x-4 items-center">
      <button
        className="text-gray-500 w-6 h-6 focus:ring-2 focus:ring-offset-2 focus:ring-green-200 focus:outline-none dark:focus:ring-offset-coolGray-900 rounded hover:ring-offset-2 hover:ring-2 hover:ring-green-200 hover:ring-offset-coolGray-900"
        onClick={_ =>
          setDisplay(_ =>
            switch display {
            | Code => Settings
            | Settings => Code
            }
          )}>
        {switch display {
        | Code =>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor">
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
            />
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
            />
          </svg>
        | Settings =>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor">
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
            />
          </svg>
        }}
      </button>
      <Lib.CopyToClipboard
        text={switch copyType {
        | FullSnippet => {
            let snippetHeader =
              "snippet " ++
              data.prefix ++
              " \"" ++
              data.title ++
              "\"" ++
              switch data.options->Js.Array2.length {
              | 0 => ""
              | _ => " " ++ data.options->Js.Array2.joinWith("")
              }
            let body = body->Js.Array2.joinWith("\n")

            `${snippetHeader}
${body}
endsnippet
`
          }
        | VSCode => {
            let body =
              body
              ->Js.Array2.map(row => {
                let row = row->Js.String2.replaceByRe(%re("/\t/g"), "\\t")
                `"${row}",`
              })
              ->Js.Array2.joinWith("\n")

            `"${data.title}": {
  "prefix": "${data.prefix}",
  "body": [${body}]
}`
          }
        | Default => body->Js.Array2.joinWith("\n")
        }}
        onCopy={_ => Lib.HotToast.make->Lib.HotToast.success("Snippet copied!")}>
        <button
          className="bg-green-300 text-green-900 px-2 py-1 rounded text-sm shadow-sm hover:ring-2 hover:ring-offset-2 hover:ring-green-200 dark:hover:ring-offset-coolGray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-200 dark:focus:ring-offset-coolGray-800">
          {React.string("Copy")}
        </button>
      </Lib.CopyToClipboard>
    </div>
  </div>
}
