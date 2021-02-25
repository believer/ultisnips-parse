module Object = {
  @val external values: Js.t<'a> => Js.Array.t<'a> = "Object.values"
}
