type t =
  | Home((option<string>, option<string>))
  | NotFoundRoute

let fromPath = path =>
  switch path {
  | list{language, snippet} => Home((Some(language), Some(snippet)))
  | list{language} => Home((Some(language), None))
  | list{} => Home((None, None))
  | _ => NotFoundRoute
  }

let toPath = route =>
  switch route {
  | Home((None, None)) => "/"
  | Home((Some(language), Some(snippet))) => "/" ++ language ++ "/" ++ snippet
  | Home((Some(language), None)) => "/" ++ language
  | Home((None, Some(snippet))) => "/" ++ snippet
  | NotFoundRoute => "/"
  }

let go = path => path->toPath->RescriptReactRouter.push
