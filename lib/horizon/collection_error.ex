defmodule Stellar.Horizon.CollectionError do
  @moduledoc """
  Handle exceptions that may arise from the `Stellar.Horizon.Collection`.
  """
  @type t :: %__MODULE__{message: String.t()}

  defexception [:message]

  @spec exception(type :: atom()) :: no_return()
  def exception(:invalid_collection),
    do: %__MODULE__{message: "can't parse response as a collection"}

  def exception(message), do: %__MODULE__{message: message}
end
