defmodule Stellar.Horizon.Operation.SetOptions do
  @moduledoc """
  Represents a `SetOptions` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type weight :: 0..255

  @type t :: %__MODULE__{
          signer_key: String.t(),
          signer_weight: weight(),
          master_key_weight: weight(),
          low_threshold: weight(),
          med_threshold: weight(),
          high_threshold: weight(),
          home_domain: String.t(),
          set_flags: list(),
          set_flags_s: list(),
          clear_flags: list(),
          clear_flags_s: list()
        }

  defstruct [
    :signer_key,
    :signer_weight,
    :master_key_weight,
    :low_threshold,
    :med_threshold,
    :high_threshold,
    :home_domain,
    :set_flags,
    :set_flags_s,
    :clear_flags,
    :clear_flags_s
  ]

  @mapping [
    signer_weight: :integer,
    master_key_weight: :integer,
    low_threshold: :integer,
    med_threshold: :integer,
    high_threshold: :integer
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
