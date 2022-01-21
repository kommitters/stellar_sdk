defmodule Stellar.Horizon.Resource do
  @moduledoc """
  Specifies contracts to build Horizon resources.
  """

  @type attrs :: map()
  @type options :: Keyword.t()
  @type resource :: struct()

  @callback new(attrs(), options()) :: resource()
end
