%{
  configs: [
    %{
      name: "default",
      strict: true,
      files: %{
        included: ["lib/", "test/"]
      },
      checks: [
        {Credo.Check.Readability.AliasOrder, false},
        {Credo.Check.Readability.Specs, []},
        {Credo.Check.Refactor.FunctionArity, max_arity: 10}
      ]
    }
  ]
}
