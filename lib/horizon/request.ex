defmodule Stellar.Horizon.Request do
  @moduledoc """
  A module for working with requests to the Horizon API.

  Requests are composed in a functional manner. The request does not happen
  until it is configured and passed to `perform/1`.

  Generally intended to be used internally, but can also be used by end-users
  to work around missing endpoints (if any).

  At a minimum, a request must have the endpoint and method specified to be valid.
  """

  alias Stellar.Horizon.{Collection, Server}
  alias Stellar.Horizon.Client, as: Horizon

  @type server :: Server.t()
  @type method :: :get | :post
  @type headers :: [{binary(), binary()}, ...] | []
  @type body :: Keyword.t()
  @type query :: Keyword.t()
  @type encoded_query :: String.t() | nil
  @type endpoint :: String.t() | nil
  @type path :: String.t() | nil
  @type segment :: String.t() | nil
  @type opts :: Keyword.t()
  @type params :: Keyword.t()
  @type query_params :: list(atom())
  @type response :: {:ok, map()} | {:error, struct()}
  @type parsed_response :: {:ok, struct()} | {:error, struct()}

  @type t :: %__MODULE__{
          method: method(),
          endpoint: endpoint(),
          path: path(),
          segment: segment(),
          segment_path: path(),
          query: query(),
          headers: headers(),
          body: body(),
          encoded_query: encoded_query()
        }

  defstruct [
    :server,
    :method,
    :headers,
    :body,
    :endpoint,
    :path,
    :segment,
    :segment_path,
    :query,
    :encoded_query
  ]

  @default_query_params ~w(cursor order limit)a

  @spec new(server :: server(), method :: method(), endpoint :: endpoint(), opts :: opts()) :: t()
  def new(%Server{} = server, method, endpoint, opts \\ []) when method in [:get, :post] do
    path = Keyword.get(opts, :path)
    segment = Keyword.get(opts, :segment)
    segment_path = Keyword.get(opts, :segment_path)

    %__MODULE__{
      server: server,
      method: method,
      endpoint: endpoint,
      path: path,
      segment: segment,
      segment_path: segment_path,
      query: [],
      headers: [],
      body: []
    }
  end

  @spec add_body(request :: t(), body :: body()) :: t()
  def add_body(%__MODULE__{} = request, body) do
    %{request | body: body}
  end

  def add_body(_request, _body), do: {:error, :invalid_request_body}

  @spec add_headers(request :: t(), headers :: headers()) :: t()
  def add_headers(%__MODULE__{} = request, headers) do
    %{request | headers: headers}
  end

  @spec add_query(request :: t(), params :: params(), opts :: opts()) :: t()
  def add_query(request, params \\ [], opts \\ [])

  def add_query(%__MODULE__{} = request, params, opts) do
    extra_params = Keyword.get(opts, :extra_params, [])
    query_params = @default_query_params ++ extra_params

    %{request | query: params, encoded_query: build_query_string(params, query_params)}
  end

  @spec perform(request :: t()) :: response()
  def perform(%__MODULE__{server: server, method: method, headers: headers, body: body} = request) do
    encoded_body = URI.encode_query(body)

    request
    |> build_request_url()
    |> (&Horizon.request(server, method, &1, headers, encoded_body)).()
  end

  @spec results(response :: response(), resource :: Keyword.t()) :: parsed_response()
  def results({:ok, results}, collection: {resource, paginate_fun}) do
    {:ok, Collection.new(results, {resource, paginate_fun})}
  end

  def results({:ok, %{_embedded: embedded}}, as: resource) when not is_nil(embedded) do
    {:ok, resource.new(embedded)}
  end

  def results({:ok, results}, as: resource), do: {:ok, resource.new(results)}

  def results({:error, error}, _resource), do: {:error, error}

  @spec build_request_url(request :: t()) :: binary()
  defp build_request_url(%__MODULE__{
         endpoint: endpoint,
         path: path,
         segment: segment,
         segment_path: segment_path,
         encoded_query: encoded_query
       }) do
    IO.iodata_to_binary([
      if(endpoint, do: ["/" | to_string(endpoint)], else: []),
      if(path, do: ["/" | to_string(path)], else: []),
      if(segment, do: ["/" | to_string(segment)], else: []),
      if(segment_path, do: ["/" | to_string(segment_path)], else: []),
      if(encoded_query, do: ["?" | encoded_query], else: [])
    ])
  end

  @spec build_query_string(params :: params(), query_params :: query_params()) :: encoded_query()
  defp build_query_string(params, query_params) do
    params
    |> Keyword.take(query_params)
    |> Enum.reject(&is_empty_param/1)
    |> encode_query()
  end

  @spec encode_query(query :: query()) :: encoded_query()
  defp encode_query([]), do: nil
  defp encode_query(query), do: URI.encode_query(query)

  @spec is_empty_param(param :: {atom(), any()}) :: boolean()
  defp is_empty_param({_key, nil}), do: true
  defp is_empty_param({_key, value}), do: to_string(value) == ""
end
