defmodule Stellar.Horizon.Error do
  @moduledoc """
  Represents an error which occurred during a Horizon API call.
  """

  @type type :: String.t() | nil
  @type title :: String.t() | nil
  @type status_code :: 200 | 400 | 404 | 406 | 422 | 500 | :network_error
  @type detail :: String.t() | nil
  @type base64_xdr :: String.t()
  @type result_code :: String.t()
  @type error_result_xdr :: String.t() | nil
  @type tx_status :: String.t() | nil
  @type hash :: String.t() | nil

  @type result_codes :: %{
          optional(:transaction) => result_code(),
          optional(:operations) => list(result_code())
        }
  @type extras :: %{
          optional(:envelope_xdr) => base64_xdr(),
          optional(:result_codes) => result_codes(),
          optional(:result_xdr) => base64_xdr()
        }

  @type error_source :: :horizon | :network
  @type error_body :: map() | atom() | String.t()
  @type error :: {error_source(), error_body()}

  @type t :: %__MODULE__{
          type: type(),
          title: title(),
          status_code: status_code(),
          detail: detail(),
          error_result_xdr: error_result_xdr(),
          hash: hash(),
          tx_status: tx_status(),
          extras: extras()
        }

  defstruct [
    :type,
    :title,
    :status_code,
    :detail,
    :error_result_xdr,
    :hash,
    :tx_status,
    extras: %{}
  ]

  @spec new(error :: error()) :: t()
  def new({:horizon, %{type: type, title: title, status: status_code, detail: detail} = error}) do
    %__MODULE__{
      type: type,
      title: title,
      status_code: status_code,
      detail: detail,
      extras: error[:extras]
    }
  end

  def new({:horizon, %{hash: hash, errorResultXdr: error_result_xdr, tx_status: tx_status}}) do
    %__MODULE__{
      error_result_xdr: error_result_xdr,
      hash: hash,
      tx_status: tx_status
    }
  end

  def new({:horizon, %{hash: hash, tx_status: tx_status}}) do
    %__MODULE__{
      hash: hash,
      tx_status: tx_status
    }
  end

  def new({:network, error}) do
    %__MODULE__{
      title: "Network error",
      status_code: :network_error,
      detail: "An error occurred while making the network request: #{inspect(error)}"
    }
  end
end
