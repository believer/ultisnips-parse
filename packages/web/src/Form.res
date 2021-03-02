module RadioButtonGroup = {
  @react.component
  let make = (~children, ~label, ~name, ~onChange) => {
    <fieldset
      className="space-y-4"
      name
      onChange={e => {
        let value = (e->ReactEvent.Form.target)["value"]
        onChange(value)
      }}>
      <legend className="text-sm font-semibold"> {React.string(label)} </legend> children
    </fieldset>
  }
}

module RadioButton = {
  @react.component
  let make = (~value, ~id, ~name, ~label, ~checked) => {
    <label className="flex gap-x-2 items-center text-sm cursor-pointer group">
      <input
        className="absolute -left-96 sibling-focus"
        checked
        readOnly={true}
        type_="radio"
        name={name}
        id
        value={value}
      />
      <div
        className={Cn.fromList(list{
          "text-white border-2 border-white rounded-full p-1 w-6 h-6 group-hover:ring-2 group-hover:ring-offset-2 group-hover:ring-pink-300 group-hover:ring-offset-coolGray-800",
          switch checked {
          | true => "bg-pink-500 border-pink-900"
          | false => ""
          },
        })}
      />
      {React.string(label)}
    </label>
  }
}
