# Mocks
Mox.defmock(Stellar.Horizon.HackneyMock, for: Stellar.Horizon.Client)
Mox.defmock(Stellar.Horizon.HTTPoitionMock, for: Stellar.Horizon.Client)

ExUnit.start()
