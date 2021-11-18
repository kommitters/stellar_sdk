defmodule Stellar.TxBuilder.Spec do
  @moduledoc """
  Specifies the behaviour for the Transaction builder.
  """
  alias Stellar.Builder.Structs.{Account, Memo, TxBuild, TxEnvelope}

  @callback new(Account.t(), Keyword.t()) :: TxBuild.t()

  @callback add_memo(TxBuild.t(), Memo.t()) :: TxBuild.t()

  @callback set_timeout(TxBuild.t(), non_neg_integer()) :: TxBuild.t()

  @callback add_operation(TxBuild.t(), list()) :: TxBuild.t()

  @callback sign(TxBuild.t(), tuple()) :: TxBuild.t()

  @callback build(TxBuild.t()) :: TxEnvelope.t()

  @callback to_base64(struct()) :: String.t()
end
