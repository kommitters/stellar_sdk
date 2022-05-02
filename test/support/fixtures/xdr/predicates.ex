defmodule Stellar.Test.Fixtures.XDR.Predicates do
  @moduledoc """
  XDR constructions for Predicate.
  """
  alias StellarBase.XDR.{
    ClaimPredicate,
    ClaimPredicates,
    ClaimPredicateType,
    Int64,
    OptionalClaimPredicate,
    Void
  }

  alias Stellar.TxBuild.ClaimPredicate, as: TxClaimPredicate
  alias Stellar.TxBuild.ClaimPredicates, as: TxClaimPredicates

  @type value ::
          TxClaimPredicate.t()
          | pos_integer()
          | TxClaimPredicates.t()

  @spec claim_predicate_unconditional(predicate :: atom()) :: ClaimPredicate.t()
  def claim_predicate_unconditional(:unconditional) do
    %ClaimPredicate{
      predicate: %Void{value: nil},
      type: %ClaimPredicateType{
        identifier: :CLAIM_PREDICATE_UNCONDITIONAL
      }
    }
  end

  @spec claim_predicate_and(value :: value(), type :: atom()) :: ClaimPredicate.t()
  def claim_predicate_and(
        %TxClaimPredicates{
          value: [
            %TxClaimPredicate{
              predicate: :conditional,
              time_type: nil,
              type: :not,
              value: %TxClaimPredicate{
                predicate: :conditional,
                time_type: :absolute,
                type: :time,
                value: 1
              }
            },
            %TxClaimPredicate{
              predicate: :conditional,
              time_type: :relative,
              type: :time,
              value: 2
            }
          ]
        },
        :and
      ) do
    %ClaimPredicate{
      predicate: %ClaimPredicates{
        predicates: [
          %ClaimPredicate{
            predicate: %OptionalClaimPredicate{
              predicate: %ClaimPredicate{
                predicate: %Int64{datum: 1},
                type: %ClaimPredicateType{
                  identifier: :CLAIM_PREDICATE_BEFORE_ABSOLUTE_TIME
                }
              }
            },
            type: %ClaimPredicateType{
              identifier: :CLAIM_PREDICATE_NOT
            }
          },
          %ClaimPredicate{
            predicate: %Int64{datum: 2},
            type: %ClaimPredicateType{
              identifier: :CLAIM_PREDICATE_BEFORE_RELATIVE_TIME
            }
          }
        ]
      },
      type: %ClaimPredicateType{identifier: :CLAIM_PREDICATE_AND}
    }
  end

  @spec claim_predicate_or(value :: value(), type :: atom()) :: ClaimPredicate.t()
  def claim_predicate_or(
        %TxClaimPredicates{
          value: [
            %TxClaimPredicate{
              predicate: :conditional,
              time_type: nil,
              type: :not,
              value: %TxClaimPredicate{
                predicate: :conditional,
                time_type: :absolute,
                type: :time,
                value: 1
              }
            },
            %TxClaimPredicate{
              predicate: :conditional,
              time_type: :relative,
              type: :time,
              value: 2
            }
          ]
        },
        :or
      ) do
    %ClaimPredicate{
      predicate: %ClaimPredicates{
        predicates: [
          %ClaimPredicate{
            predicate: %OptionalClaimPredicate{
              predicate: %ClaimPredicate{
                predicate: %Int64{datum: 1},
                type: %ClaimPredicateType{
                  identifier: :CLAIM_PREDICATE_BEFORE_ABSOLUTE_TIME
                }
              }
            },
            type: %ClaimPredicateType{
              identifier: :CLAIM_PREDICATE_NOT
            }
          },
          %ClaimPredicate{
            predicate: %Int64{datum: 2},
            type: %ClaimPredicateType{
              identifier: :CLAIM_PREDICATE_BEFORE_RELATIVE_TIME
            }
          }
        ]
      },
      type: %ClaimPredicateType{identifier: :CLAIM_PREDICATE_OR}
    }
  end

  @spec claim_predicate_not(value :: value(), type :: atom()) :: ClaimPredicate.t()
  def claim_predicate_not(
        %TxClaimPredicate{
          predicate: :unconditional,
          time_type: nil,
          type: nil,
          value: nil
        },
        :not
      ) do
    %ClaimPredicate{
      predicate: %OptionalClaimPredicate{
        predicate: %ClaimPredicate{
          predicate: %Void{value: nil},
          type: %ClaimPredicateType{
            identifier: :CLAIM_PREDICATE_UNCONDITIONAL
          }
        }
      },
      type: %ClaimPredicateType{identifier: :CLAIM_PREDICATE_NOT}
    }
  end

  @spec claim_predicate_time_absolute(value :: value(), type :: atom(), time_type :: atom()) ::
          ClaimPredicate.t()
  def claim_predicate_time_absolute(1, :time, :absolute) do
    %ClaimPredicate{
      predicate: %Int64{datum: 1},
      type: %ClaimPredicateType{
        identifier: :CLAIM_PREDICATE_BEFORE_ABSOLUTE_TIME
      }
    }
  end

  @spec claim_predicate_time_relative(value :: value(), type :: atom(), time_type :: atom()) ::
          ClaimPredicate.t()
  def claim_predicate_time_relative(1, :time, :relative) do
    %ClaimPredicate{
      predicate: %Int64{datum: 1},
      type: %ClaimPredicateType{
        identifier: :CLAIM_PREDICATE_BEFORE_RELATIVE_TIME
      }
    }
  end

  @spec claim_predicates(value :: value()) :: ClaimPredicates.t()
  def claim_predicates([
        %TxClaimPredicate{
          predicate: :unconditional,
          time_type: nil,
          type: nil,
          value: nil
        },
        %TxClaimPredicate{
          predicate: :conditional,
          time_type: :absolute,
          type: :time,
          value: 1
        }
      ]) do
    %ClaimPredicates{
      predicates: [
        %ClaimPredicate{
          predicate: %Void{value: nil},
          type: %ClaimPredicateType{
            identifier: :CLAIM_PREDICATE_UNCONDITIONAL
          }
        },
        %ClaimPredicate{
          predicate: %Int64{datum: 1},
          type: %ClaimPredicateType{
            identifier: :CLAIM_PREDICATE_BEFORE_ABSOLUTE_TIME
          }
        }
      ]
    }
  end

  @spec optional_predicate(value :: value()) :: OptionalClaimPredicate.t()
  def optional_predicate(%TxClaimPredicate{
        predicate: :unconditional,
        time_type: nil,
        type: nil,
        value: nil
      }) do
    %OptionalClaimPredicate{
      predicate: %ClaimPredicate{
        predicate: %Void{value: nil},
        type: %ClaimPredicateType{
          identifier: :CLAIM_PREDICATE_UNCONDITIONAL
        }
      }
    }
  end
end
