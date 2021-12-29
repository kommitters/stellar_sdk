defmodule Stellar.Test.XDRFixtures do
  @moduledoc """
  Stellar's XDR data for test constructions.
  """
  alias Stellar.KeyPair
  alias Stellar.TxBuild.TransactionSignature
  alias Stellar.TxBuild.Transaction, as: Tx

  alias StellarBase.XDR.{
    AccountID,
    AlphaNum12,
    AlphaNum4,
    Asset,
    Assets,
    AssetCode4,
    AssetCode12,
    AssetType,
    ChangeTrustAsset,
    ClaimableBalanceID,
    ClaimableBalanceIDType,
    CryptoKeyType,
    DataValue,
    DecoratedSignature,
    EnvelopeType,
    Ext,
    Hash,
    Int32,
    Int64,
    Memo,
    MemoType,
    MuxedAccount,
    OperationType,
    OperationBody,
    Operation,
    Operations,
    OptionalAccountID,
    OptionalDataValue,
    OptionalMuxedAccount,
    OptionalSigner,
    OptionalString32,
    OptionalTimeBounds,
    OptionalUInt32,
    Price,
    PublicKey,
    PublicKeyType,
    SequenceNumber,
    Signature,
    SignatureHint,
    String28,
    String32,
    String64,
    Signer,
    SignerKey,
    SignerKeyType,
    Transaction,
    TransactionV1Envelope,
    TransactionEnvelope,
    UInt32,
    UInt64,
    UInt256,
    Void
  }

  alias StellarBase.XDR.Operations.{
    AccountMerge,
    BeginSponsoringFutureReserves,
    BumpSequence,
    ChangeTrust,
    Clawback,
    ClawbackClaimableBalance,
    CreateAccount,
    ManageData,
    CreatePassiveSellOffer,
    ManageBuyOffer,
    ManageSellOffer,
    Payment,
    PathPaymentStrictSend,
    PathPaymentStrictReceive,
    SetOptions
  }

  @type optional_account_id :: String.t() | nil
  @type raw_asset :: atom() | {String.t(), String.t()}
  @type signer_type :: :ed25519 | :sha256_hash | :pre_auth_tx
  @type weight :: pos_integer() | nil
  @type flags :: list(atom()) | nil
  @type optional_signer :: Keyword.t() | nil
  @type optional_string32 :: String.t() | nil

  @unit 10_000_000

  @spec muxed_account_xdr(account_id :: String.t()) :: MuxedAccount.t()
  def muxed_account_xdr(account_id) do
    type = CryptoKeyType.new(:KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_public_key()
    |> UInt256.new()
    |> MuxedAccount.new(type)
  end

  @spec account_id_xdr(account_id :: String.t()) :: MuxedAccount.t()
  def account_id_xdr(account_id) do
    type = PublicKeyType.new(:PUBLIC_KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_public_key()
    |> UInt256.new()
    |> PublicKey.new(type)
    |> AccountID.new()
  end

  @spec signer_xdr(signer :: Keyword.t()) :: Signer.t()
  def signer_xdr(ed25519: key, weight: weight) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_ED25519)
    weight = UInt32.new(weight)

    key
    |> KeyPair.raw_public_key()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
    |> Signer.new(weight)
  end

  def signer_xdr(sha256_hash: key, weight: weight) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_HASH_X)
    weight = UInt32.new(weight)

    key
    |> (&:crypto.hash(:sha256, &1)).()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
    |> Signer.new(weight)
  end

  def signer_xdr(pre_auth_tx: key, weight: weight) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_PRE_AUTH_TX)
    weight = UInt32.new(weight)

    key
    |> (&:crypto.hash(:sha256, &1)).()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
    |> Signer.new(weight)
  end

  @spec memo_xdr(type :: atom(), value :: any()) :: Memo.t()
  def memo_xdr(type, value) do
    memo_type = MemoType.new(type)

    value
    |> memo_xdr_value(type)
    |> Memo.new(memo_type)
  end

  @spec transaction_xdr(account_id :: String.t()) :: Transaction.t()
  def transaction_xdr(account_id) do
    muxed_account = muxed_account_xdr(account_id)
    base_fee = UInt32.new(100)
    seq_number = SequenceNumber.new(4_130_487_228_432_385)
    time_bounds = OptionalTimeBounds.new(nil)
    memo_type = MemoType.new(:MEMO_NONE)
    memo = Memo.new(nil, memo_type)
    operations = Operations.new([])

    Transaction.new(
      muxed_account,
      base_fee,
      seq_number,
      time_bounds,
      memo,
      operations,
      Ext.new()
    )
  end

  @spec transaction_envelope_xdr(tx :: Tx.t(), signatures :: list(Signature.t())) ::
          TransactionEnvelope.t()
  def transaction_envelope_xdr(tx, signatures) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_TX)
    decorated_signatures = TransactionSignature.sign(tx, signatures)

    tx
    |> Tx.to_xdr()
    |> TransactionV1Envelope.new(decorated_signatures)
    |> TransactionEnvelope.new(envelope_type)
  end

  @spec decorated_signature_xdr(raw_secret :: binary(), hint :: binary(), payload :: binary()) ::
          DecoratedSignature.t()
  def decorated_signature_xdr(raw_secret, hint, payload) do
    payload
    |> KeyPair.sign(raw_secret)
    |> decorated_signature_xdr(hint)
  end

  @spec decorated_signature_xdr(raw_secret :: binary(), hint :: binary()) ::
          DecoratedSignature.t()
  def decorated_signature_xdr(raw_secret, hint) do
    signature = Signature.new(raw_secret)

    hint
    |> SignatureHint.new()
    |> DecoratedSignature.new(signature)
  end

  @spec operation_xdr(op_body :: struct(), source_account :: optional_account_id()) ::
          Operation.t()
  def operation_xdr(%OperationBody{} = op_body, source_account \\ nil) do
    account = if is_nil(source_account), do: nil, else: muxed_account_xdr(source_account)
    source_account = OptionalMuxedAccount.new(account)
    Operation.new(op_body, source_account)
  end

  @spec create_account_op_xdr(destination :: String.t(), amount :: non_neg_integer()) ::
          CreateAccount.t()
  def create_account_op_xdr(destination, amount) do
    op_type = OperationType.new(:CREATE_ACCOUNT)
    amount = Int64.new(amount * @unit)

    destination
    |> account_id_xdr()
    |> CreateAccount.new(amount)
    |> OperationBody.new(op_type)
  end

  @spec account_merge_op_xdr(destination :: String.t()) :: AccountMerge.t()
  def account_merge_op_xdr(destination) do
    op_type = OperationType.new(:ACCOUNT_MERGE)

    destination
    |> muxed_account_xdr()
    |> AccountMerge.new()
    |> OperationBody.new(op_type)
  end

  @spec payment_op_xdr(
          destination :: String.t(),
          asset :: raw_asset(),
          amount :: non_neg_integer()
        ) :: Payment.t()
  def payment_op_xdr(destination, asset, amount) do
    op_type = OperationType.new(:PAYMENT)
    amount = Int64.new(amount * @unit)
    asset = build_asset_xdr(asset)

    destination
    |> muxed_account_xdr()
    |> Payment.new(asset, amount)
    |> OperationBody.new(op_type)
  end

  @spec path_payment_strict_send_op_xdr(
          destination :: String.t(),
          send_asset :: raw_asset(),
          send_amount :: non_neg_integer(),
          dest_asset :: raw_asset(),
          dest_min :: non_neg_integer(),
          path :: list(raw_asset())
        ) :: PathPaymentStrictSend.t()
  def path_payment_strict_send_op_xdr(
        destination,
        send_asset,
        send_amount,
        dest_asset,
        dest_min,
        path
      ) do
    op_type = OperationType.new(:PATH_PAYMENT_STRICT_SEND)
    destination = muxed_account_xdr(destination)
    send_asset = build_asset_xdr(send_asset)
    send_amount = Int64.new(send_amount * @unit)
    dest_asset = build_asset_xdr(dest_asset)
    dest_min = Int64.new(dest_min * @unit)
    path = assets_path_xdr(path)

    path_payment =
      PathPaymentStrictSend.new(
        send_asset,
        send_amount,
        destination,
        dest_asset,
        dest_min,
        path
      )

    OperationBody.new(path_payment, op_type)
  end

  @spec path_payment_strict_receive_op_xdr(
          destination :: String.t(),
          send_asset :: raw_asset(),
          send_max :: non_neg_integer(),
          dest_asset :: raw_asset(),
          dest_amount :: non_neg_integer(),
          path :: list(raw_asset())
        ) :: PathPaymentStrictReceive.t()
  def path_payment_strict_receive_op_xdr(
        destination,
        send_asset,
        send_max,
        dest_asset,
        dest_amount,
        path
      ) do
    op_type = OperationType.new(:PATH_PAYMENT_STRICT_RECEIVE)
    destination = muxed_account_xdr(destination)
    send_asset = build_asset_xdr(send_asset)
    send_max = Int64.new(send_max * @unit)
    dest_asset = build_asset_xdr(dest_asset)
    dest_amount = Int64.new(dest_amount * @unit)
    path = assets_path_xdr(path)

    path_payment =
      PathPaymentStrictReceive.new(
        send_asset,
        send_max,
        destination,
        dest_asset,
        dest_amount,
        path
      )

    OperationBody.new(path_payment, op_type)
  end

  @spec manage_sell_offer_op_xdr(
          selling :: raw_asset(),
          buying :: raw_asset(),
          amount :: non_neg_integer(),
          price :: number(),
          offer_id :: non_neg_integer()
        ) :: ManageSellOffer.t()
  def manage_sell_offer_op_xdr(selling, buying, amount, {price_n, price_d}, offer_id) do
    op_type = OperationType.new(:MANAGE_SELL_OFFER)
    selling = build_asset_xdr(selling)
    buying = build_asset_xdr(buying)
    amount = Int64.new(amount * @unit)
    price = Price.new(Int32.new(price_n), Int32.new(price_d))
    offer_id = Int64.new(offer_id)

    manage_sell_offer =
      ManageSellOffer.new(
        selling,
        buying,
        amount,
        price,
        offer_id
      )

    OperationBody.new(manage_sell_offer, op_type)
  end

  @spec manage_buy_offer_op_xdr(
          selling :: raw_asset(),
          buying :: raw_asset(),
          amount :: non_neg_integer(),
          price :: number(),
          offer_id :: non_neg_integer()
        ) :: ManageBuyOffer.t()
  def manage_buy_offer_op_xdr(selling, buying, amount, {price_n, price_d}, offer_id) do
    op_type = OperationType.new(:MANAGE_BUY_OFFER)
    selling = build_asset_xdr(selling)
    buying = build_asset_xdr(buying)
    amount = Int64.new(amount * @unit)
    price = Price.new(Int32.new(price_n), Int32.new(price_d))
    offer_id = Int64.new(offer_id)

    manage_buy_offer =
      ManageBuyOffer.new(
        selling,
        buying,
        amount,
        price,
        offer_id
      )

    OperationBody.new(manage_buy_offer, op_type)
  end

  @spec create_passive_sell_offer_op_xdr(
          selling :: raw_asset(),
          buying :: raw_asset(),
          amount :: non_neg_integer(),
          price :: number()
        ) :: CreatePassiveSellOffer.t()
  def create_passive_sell_offer_op_xdr(selling, buying, amount, {price_n, price_d}) do
    op_type = OperationType.new(:CREATE_PASSIVE_SELL_OFFER)
    selling = build_asset_xdr(selling)
    buying = build_asset_xdr(buying)
    amount = Int64.new(amount * @unit)
    price = Price.new(Int32.new(price_n), Int32.new(price_d))

    passive_sell_offer =
      CreatePassiveSellOffer.new(
        selling,
        buying,
        amount,
        price
      )

    OperationBody.new(passive_sell_offer, op_type)
  end

  @spec manage_data_op_xdr(entry_name :: String.t(), entry_value: any()) :: AccountMerge.t()
  def manage_data_op_xdr(entry_name, entry_value) do
    op_type = OperationType.new(:MANAGE_DATA)
    value = if is_nil(entry_value), do: nil, else: DataValue.new(entry_value)
    entry_value_xdr = OptionalDataValue.new(value)

    entry_name
    |> String64.new()
    |> ManageData.new(entry_value_xdr)
    |> OperationBody.new(op_type)
  end

  @spec bump_sequence_op_xdr(bump_to :: pos_integer()) :: BumpSequence.t()
  def bump_sequence_op_xdr(bump_to) do
    op_type = OperationType.new(:BUMP_SEQUENCE)

    bump_to
    |> SequenceNumber.new()
    |> BumpSequence.new()
    |> OperationBody.new(op_type)
  end

  @spec set_options_xdr(
          inflation_destination :: String.t(),
          clear_flags :: flags(),
          set_flags :: flags(),
          master_weight :: weight(),
          tresholds :: Keyword.t(),
          home_domain :: String.t(),
          signer :: Keyword.t()
        ) :: BumpSequence.t()
  def set_options_xdr(
        inflation_destination,
        clear_flags,
        set_flags,
        master_weight,
        tresholds,
        home_domain,
        signer
      ) do
    op_type = OperationType.new(:SET_OPTIONS)
    inflation_destination = optional_account_id_xdr(inflation_destination)
    clear_flags = clear_flags |> flags_bit_mask() |> optional_uint32_xdr()
    set_flags = set_flags |> flags_bit_mask() |> optional_uint32_xdr()
    master_weight = optional_uint32_xdr(master_weight)
    low_threshold = optional_uint32_xdr(tresholds[:low])
    med_threshold = optional_uint32_xdr(tresholds[:med])
    high_threshold = optional_uint32_xdr(tresholds[:high])
    home_domain = optional_string32_xdr(home_domain)
    signer = optional_signer_xdr(signer)

    set_options =
      SetOptions.new(
        inflation_destination,
        clear_flags,
        set_flags,
        master_weight,
        low_threshold,
        med_threshold,
        high_threshold,
        home_domain,
        signer
      )

    OperationBody.new(set_options, op_type)
  end

  @spec change_trust_xdr(asset :: raw_asset(), amount :: non_neg_integer()) :: ChangeTrust.t()
  def change_trust_xdr(asset, amount) do
    op_type = OperationType.new(:CHANGE_TRUST)
    amount = Int64.new(amount * @unit)
    %Asset{asset: asset, type: asset_type} = build_asset_xdr(asset)

    asset
    |> ChangeTrustAsset.new(asset_type)
    |> ChangeTrust.new(amount)
    |> OperationBody.new(op_type)
  end

  @spec begin_sponsoring_future_reserves_op_xdr(sponsored_id :: String.t()) ::
          BeginSponsoringFutureReserves.t()
  def begin_sponsoring_future_reserves_op_xdr(sponsored_id) do
    op_type = OperationType.new(:BEGIN_SPONSORING_FUTURE_RESERVES)

    sponsored_id
    |> account_id_xdr()
    |> BeginSponsoringFutureReserves.new()
    |> OperationBody.new(op_type)
  end

  @spec end_sponsoring_future_reserves_op_xdr() :: EndSponsoringFutureReserves.t()
  def end_sponsoring_future_reserves_op_xdr do
    op_type = OperationType.new(:END_SPONSORING_FUTURE_RESERVES)
    OperationBody.new(Void.new(), op_type)
  end

  @spec clawback_op_xdr(
          asset :: raw_asset(),
          from :: String.t(),
          amount :: non_neg_integer()
        ) :: Clawback.t()
  def clawback_op_xdr(asset, from, amount) do
    op_type = OperationType.new(:CLAWBACK)
    from = muxed_account_xdr(from)
    amount = Int64.new(amount * @unit)

    asset
    |> build_asset_xdr()
    |> Clawback.new(from, amount)
    |> OperationBody.new(op_type)
  end

  @spec clawback_claimable_balance_op_xdr(balance_id :: String.t()) ::
          ClawbackClaimableBalance.t()
  def clawback_claimable_balance_op_xdr(balance_id) do
    op_type = OperationType.new(:CLAWBACK_CLAIMABLE_BALANCE)

    balance_id
    |> claimable_balance_id_xdr()
    |> ClawbackClaimableBalance.new()
    |> OperationBody.new(op_type)
  end

  @spec claimable_balance_id_xdr(balance_id :: String.t()) :: ClaimableBalanceID.t()
  def claimable_balance_id_xdr(balance_id) do
    claimable_balance_id_type = ClaimableBalanceIDType.new(:CLAIMABLE_BALANCE_ID_TYPE_V0)

    claimable_balance_id =
      balance_id
      |> (&:crypto.hash(:sha256, &1)).()
      |> Hash.new()

    ClaimableBalanceID.new(claimable_balance_id, claimable_balance_id_type)
  end

  @spec create_asset_native_xdr() :: Asset.t()
  def create_asset_native_xdr do
    Asset.new(Void.new(), AssetType.new(:ASSET_TYPE_NATIVE))
  end

  @spec create_asset4_xdr(code :: String.t(), issuer :: String.t()) :: Asset.t()
  def create_asset4_xdr(code, issuer) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM4)
    issuer = account_id_xdr(issuer)

    code
    |> AssetCode4.new()
    |> AlphaNum4.new(issuer)
    |> Asset.new(asset_type)
  end

  @spec create_asset12_xdr(code :: String.t(), issuer :: String.t()) :: Asset.t()
  def create_asset12_xdr(code, issuer) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM12)
    issuer = account_id_xdr(issuer)

    code
    |> AssetCode12.new()
    |> AlphaNum12.new(issuer)
    |> Asset.new(asset_type)
  end

  @spec assets_path_xdr(assets :: list(raw_asset())) :: list(Asset.t())
  def assets_path_xdr(assets) do
    assets
    |> Enum.map(&build_asset_xdr/1)
    |> Assets.new()
  end

  @spec optional_account_id_xdr(account_id :: optional_account_id()) :: OptionalAccountID.t()
  def optional_account_id_xdr(nil), do: OptionalAccountID.new()

  def optional_account_id_xdr(account_id) do
    account_id
    |> account_id_xdr()
    |> OptionalAccountID.new()
  end

  @spec optional_signer_xdr(signer :: optional_signer()) :: OptionalSigner.t()
  def optional_signer_xdr(nil), do: OptionalSigner.new()

  def optional_signer_xdr(signer) do
    signer
    |> signer_xdr()
    |> OptionalSigner.new()
  end

  @spec optional_uint32_xdr(value :: weight()) :: OptionalUInt32.t()
  def optional_uint32_xdr(nil), do: OptionalUInt32.new()

  def optional_uint32_xdr(value) do
    value
    |> UInt32.new()
    |> OptionalUInt32.new()
  end

  @spec optional_string32_xdr(value :: optional_string32()) :: OptionalString32.t()
  def optional_string32_xdr(nil), do: OptionalString32.new()

  def optional_string32_xdr(value) do
    value
    |> String32.new()
    |> OptionalString32.new()
  end

  @spec build_asset_xdr(asset :: any()) :: list(Asset.t())
  defp build_asset_xdr(:native), do: create_asset_native_xdr()

  defp build_asset_xdr({code, issuer}) when byte_size(code) < 5,
    do: create_asset4_xdr(code, issuer)

  defp build_asset_xdr({code, issuer}), do: create_asset12_xdr(code, issuer)

  @spec memo_xdr_value(value :: any(), type :: atom()) :: struct()
  defp memo_xdr_value(_value, :MEMO_NONE), do: nil
  defp memo_xdr_value(value, :MEMO_TEXT), do: String28.new(value)
  defp memo_xdr_value(value, :MEMO_ID), do: UInt64.new(value)

  defp memo_xdr_value(value, _type) do
    value
    |> String.upcase()
    |> Base.decode16!()
    |> Hash.new()
  end

  @spec flags_bit_mask(flags :: flags()) :: integer()
  defp flags_bit_mask(nil), do: 0

  defp flags_bit_mask(flags) do
    available_flags = [required: 0x1, revocable: 0x2, inmutable: 0x4, clawback_enabled: 0x8]

    flags
    |> Enum.filter(&is_atom(&1))
    |> Enum.map(&Keyword.get(available_flags, &1, 0x0))
    |> Enum.reduce(0, &(&1 + &2))
  end
end
