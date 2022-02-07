defmodule Stellar.Horizon.Account.Thresholds do
  @moduledoc """
  Represents `Thresholds` for an account.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type weight :: 0..255

  @type t :: %__MODULE__{
          low_threshold: weight(),
          med_threshold: weight(),
          high_threshold: weight()
        }

  defstruct low_threshold: 0, med_threshold: 0, high_threshold: 0

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
