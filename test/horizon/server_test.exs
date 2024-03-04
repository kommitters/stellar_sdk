defmodule Stellar.Horizon.ServerTest do
  use ExUnit.Case

  alias Stellar.Horizon.Server

  test "new/1" do
    %Server{url: "https://horizon-standalone.com"} = Server.new("https://horizon-standalone.com")
  end

  test "public/0" do
    %Server{url: "https://horizon.stellar.org"} = Server.public()
  end

  test "testnet/0" do
    %Server{url: "https://horizon-testnet.stellar.org"} = Server.testnet()
  end

  test "futurenet/0" do
    %Server{url: "https://horizon-futurenet.stellar.org"} = Server.futurenet()
  end

  test "local/0" do
    %Server{url: "http://localhost:8000"} = Server.local()
  end
end
