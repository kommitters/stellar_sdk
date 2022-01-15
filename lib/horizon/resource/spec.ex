defmodule Stellar.Horizon.Resource.Spec do
  @moduledoc """
  Specifies contracts to build Horizon resources.
  """

  alias Stellar.Horizon.Resource.Transaction

  @type attrs :: map()
  @type options :: Keyword.t()
  @type resource :: Transaction.t()

  @callback new(attrs(), options()) :: resource()
end
