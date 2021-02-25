module Markdown = {
  @react.component @module("react-markdown")
  external make: (~children: string, ~className: string=?) => React.element = "default"
}
