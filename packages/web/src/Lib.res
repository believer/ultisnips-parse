module CopyToClipboard = {
  @react.component @module("react-copy-to-clipboard")
  external make: (~text: string, ~children: React.element) => React.element = "CopyToClipboard"
}

module Markdown = {
  @react.component @module("react-markdown")
  external make: (~children: string, ~className: string=?) => React.element = "default"
}
