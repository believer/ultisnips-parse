module CopyToClipboard = {
  @react.component @module("react-copy-to-clipboard")
  external make: (~text: string, ~children: React.element) => React.element = "CopyToClipboard"
}

module Markdown = {
  module Renderers = {
    module Link = {
      type t = {children: React.element, href: string}
    }

    type t = {link: Link.t => React.element}
  }

  @react.component @module("react-markdown")
  external make: (
    ~children: string,
    ~className: string=?,
    ~renderers: Renderers.t=?,
  ) => React.element = "default"
}
