defmodule Stellar.Test.Fixtures.XDR.Predicate do
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

  @type value :: list(TxClaimPredicate.t()) | TxClaimPredicate.t() | pos_integer()

  @spec predicate_unconditional(predicate :: atom()) :: ClaimPredicate.t()
  def predicate_unconditional(:unconditional) do
    %ClaimPredicate{
      predicate: %Void{value: nil},
      type: %ClaimPredicateType{
        identifier: :CLAIM_PREDICATE_UNCONDITIONAL
      }
    }
  end

  @spec predicate_and(value :: value(), type :: atom()) :: ClaimPredicate.t()
  def predicate_and(
        [
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
            time_type: nil,
            type: :or,
            value: [
              %TxClaimPredicate{
                predicate: :unconditional,
                time_type: nil,
                type: nil,
                value: nil
              },
              %TxClaimPredicate{
                predicate: :conditional,
                time_type: :relative,
                type: :time,
                value: 2
              }
            ]
          }
        ],
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
            predicate: %ClaimPredicates{
              predicates: [
                %ClaimPredicate{
                  predicate: %Void{value: nil},
                  type: %ClaimPredicateType{
                    identifier: :CLAIM_PREDICATE_UNCONDITIONAL
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
            type: %ClaimPredicateType{
              identifier: :CLAIM_PREDICATE_OR
            }
          }
        ]
      },
      type: %ClaimPredicateType{identifier: :CLAIM_PREDICATE_AND}
    }
  end

  @spec predicate_or(value :: value(), type :: atom()) :: ClaimPredicate.t()
  def predicate_or(
        [
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
            time_type: nil,
            type: :or,
            value: [
              %TxClaimPredicate{
                predicate: :unconditional,
                time_type: nil,
                type: nil,
                value: nil
              },
              %TxClaimPredicate{
                predicate: :conditional,
                time_type: :relative,
                type: :time,
                value: 2
              }
            ]
          }
        ],
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
            predicate: %ClaimPredicates{
              predicates: [
                %ClaimPredicate{
                  predicate: %Void{value: nil},
                  type: %ClaimPredicateType{
                    identifier: :CLAIM_PREDICATE_UNCONDITIONAL
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
            type: %ClaimPredicateType{
              identifier: :CLAIM_PREDICATE_OR
            }
          }
        ]
      },
      type: %ClaimPredicateType{identifier: :CLAIM_PREDICATE_OR}
    }
  end

  @spec predicate_not(value :: value(), type :: atom()) :: ClaimPredicate.t()
  def predicate_not(
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
        :not
      ) do
    %ClaimPredicate{
      predicate: %OptionalClaimPredicate{
        predicate: %ClaimPredicate{
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
        }
      },
      type: %ClaimPredicateType{identifier: :CLAIM_PREDICATE_NOT}
    }
  end

  @spec predicate_time_absolute(value :: value(), type :: atom(), time_type :: atom()) ::
          ClaimPredicate.t()
  def predicate_time_absolute(1, :time, :absolute) do
    %ClaimPredicate{
      predicate: %Int64{datum: 1},
      type: %ClaimPredicateType{
        identifier: :CLAIM_PREDICATE_BEFORE_ABSOLUTE_TIME
      }
    }
  end

  @spec predicate_time_relative(value :: value(), type :: atom(), time_type :: atom()) ::
          ClaimPredicate.t()
  def predicate_time_relative(1, :time, :relative) do
    %ClaimPredicate{
      predicate: %Int64{datum: 1},
      type: %ClaimPredicateType{
        identifier: :CLAIM_PREDICATE_BEFORE_RELATIVE_TIME
      }
    }
  end

  @spec predicates(value :: value()) :: ClaimPredicates.t()
  def predicates([
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
