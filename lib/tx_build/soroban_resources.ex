defmodule Stellar.TxBuild.SorobanResources do
  @moduledoc """
  `SorobanResources` struct definition.
  """
  alias StellarBase.XDR.{SorobanResources, UInt32}
  alias Stellar.TxBuild.LedgerFootprint

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type footprint :: LedgerFootprint.t()
  @type instructions :: integer()
  @type read_bytes :: integer()
  @type write_bytes :: integer()

  @type t :: %__MODULE__{
          footprint: footprint(),
          instructions: instructions(),
          read_bytes: read_bytes(),
          write_bytes: write_bytes()
        }

  defstruct [
    :footprint,
    :instructions,
    :read_bytes,
    :write_bytes
  ]

  @impl true
  def new(args, opts \\ [])

  def new(
        [
          {:footprint, footprint},
          {:instructions, instructions},
          {:read_bytes, read_bytes},
          {:write_bytes, write_bytes}
        ],
        _opts
      )
      when is_integer(instructions) and is_integer(read_bytes) and is_integer(write_bytes) do
    with {:ok, footprint} <- validate_footprint(footprint) do
      %__MODULE__{
        footprint: footprint,
        instructions: instructions,
        read_bytes: read_bytes,
        write_bytes: write_bytes
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_soroban_resources_args}

  @impl true
  def to_xdr(%__MODULE__{
        footprint: footprint,
        instructions: instructions,
        read_bytes: read_bytes,
        write_bytes: write_bytes
      }) do
    instructions = UInt32.new(instructions)
    read_bytes = UInt32.new(read_bytes)
    write_bytes = UInt32.new(write_bytes)

    footprint
    |> LedgerFootprint.to_xdr()
    |> SorobanResources.new(
      instructions,
      read_bytes,
      write_bytes
    )
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_footprint(footprint :: footprint()) :: validation()
  defp validate_footprint(%LedgerFootprint{} = footprint), do: {:ok, footprint}
  defp validate_footprint(_footprint), do: {:error, :invalid_footprint}
end
