defmodule Stellar.TxBuild.SorobanAuthorizationEntry do
  @moduledoc """
  `SorobanAuthorizationEntry` struct definition.
  """

  alias Stellar.TxBuild.{
    SorobanCredentials,
    SorobanAuthorizedInvocation
  }

  alias StellarBase.XDR.SorobanAuthorizationEntry

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type credentials :: SorobanCredentials.t()
  @type root_invocation :: SorobanAuthorizedInvocation.t()

  @type t :: %__MODULE__{
          credentials: credentials(),
          root_invocation: root_invocation()
        }

  defstruct [:credentials, :root_invocation]

  @impl true
  def new(value, opts \\ [])

  def new(args, _opts) when is_list(args) do
    credentials = Keyword.get(args, :credentials)
    root_invocation = Keyword.get(args, :root_invocation)

    with {:ok, credentials} <- validate_credentials(credentials),
         {:ok, root_invocation} <- validate_root_invocation(root_invocation) do
      %__MODULE__{
        credentials: credentials,
        root_invocation: root_invocation
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_auth_entry_args}

  @impl true
  def to_xdr(%__MODULE__{
        credentials: credentials,
        root_invocation: root_invocation
      }) do
    root_invocation = SorobanAuthorizedInvocation.to_xdr(root_invocation)

    credentials
    |> SorobanCredentials.to_xdr()
    |> SorobanAuthorizationEntry.new(root_invocation)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_credentials(credentials :: credentials()) :: validation()
  defp validate_credentials(%SorobanCredentials{} = credentials), do: {:ok, credentials}
  defp validate_credentials(_credentials), do: {:error, :invalid_credentials}

  @spec validate_root_invocation(root_invocation :: root_invocation()) :: validation()
  defp validate_root_invocation(%SorobanAuthorizedInvocation{} = root_invocation),
    do: {:ok, root_invocation}

  defp validate_root_invocation(_root_invocation), do: {:error, :invalid_root_invocation}
end
