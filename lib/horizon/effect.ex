defmodule Stellar.Horizon.Effect do
  @moduledoc """
  Represents a `Effect` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          account: String.t(),
          type: String.t(),
          type_i: non_neg_integer(),
          attributes: map(),
          created_at: DateTime.t()
        }

  defstruct [
    :id,
    :paging_token,
    :account,
    :type,
    :type_i,
    :attributes,
    :created_at
  ]

  @mapping [
    type_i: :integer,
    created_at: :date_time
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    effect_attrs = map_effect_attrs(attrs)

    %__MODULE__{}
    |> Mapping.build(effect_attrs)
    |> Mapping.parse(@mapping)
  end

  @spec map_effect_attrs(attrs :: map()) :: map()
  defp map_effect_attrs(attrs) do
    effect_attrs =
      %__MODULE__{}
      |> Map.from_struct()
      |> Map.keys()
      |> (&Map.drop(attrs, &1 ++ [:_links])).()

    Map.put(attrs, :attributes, effect_attrs)
  end
end
