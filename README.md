# Elixir Stellar SDK
![Build Badge](https://img.shields.io/github/workflow/status/kommitters/stellar_sdk/StellarSDK%20CI/main?style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/stellar_sdk?style=for-the-badge)](https://coveralls.io/github/kommitters/stellar_sdk)
[![Version Badge](https://img.shields.io/hexpm/v/stellar_sdk?style=for-the-badge)](https://hexdocs.pm/stellar_sdk)
![Downloads Badge](https://img.shields.io/hexpm/dt/stellar_sdk?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/stellar_sdk.svg?style=for-the-badge)](https://github.com/kommitters/stellar_sdk/blob/main/LICENSE.md)

### ⚠️ Warning! This library is under active development. DO NOT use it in production environments.

`stellar_sdk` is an **Elixir library** that provides a client for interfacing with **Horizon** server REST endpoints to retrieve ledger information, and to submit transactions. `stelar_sdk` uses the [stellar_base][base] library to enable the construction, signing and encoding of Stellar primitive XDR constructs.

This library is aimed at developers building Elixir applications that interact with the [Stellar network][stellar].

## Installation
[Available in Hex][hex], add `stellar_sdk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stellar_sdk, "~> 0.1.0"}
  ]
end
```

## Development
* Install any Elixir version above 1.10.
* Compile dependencies: `mix deps.get`.
* Run tests: `mix test`.

## Code of conduct
We welcome everyone to contribute. Make sure you have read the [CODE_OF_CONDUCT][coc] before.

## Contributing
For information on how to contribute, please refer to our [CONTRIBUTING][contributing] guide.

## Changelog
Features and bug fixes are listed in the [CHANGELOG][changelog] file.

## License
This library is licensed under an MIT license. See [LICENSE][license] for details.

## Acknowledgements
Made with 💙 by [kommitters Open Source](https://kommit.co)

[license]: https://github.com/kommitters/stellar_sdk/blob/main/LICENSE.md
[coc]: https://github.com/kommitters/stellar_sdk/blob/main/CODE_OF_CONDUCT.md
[changelog]: https://github.com/kommitters/stellar_sdk/blob/main/CHANGELOG.md
[contributing]: https://github.com/kommitters/stellar_sdk/blob/main/CONTRIBUTING.md
[base]: https://github.com/kommitters/stellar_base
[sdk]: https://github.com/kommitters/stellar_sdk
[hex]: https://hex.pm/packages/stellar_sdk
[stellar]: https://www.stellar.org/
