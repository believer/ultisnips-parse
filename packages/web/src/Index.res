let client = ReactQuery.QueryClient.make()

switch ReactDOM.querySelector("#root") {
| Some(root) =>
  ReactDOM.render(
    <ReactQuery.QueryClientProvider client> <App /> </ReactQuery.QueryClientProvider>,
    root,
  )
| None => () // do nothing
}
