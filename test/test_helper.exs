# Mocks
Mox.defmock(StellarSDK.Horizon.HackneyMock, for: StellarSDK.Horizon.Client)
Mox.defmock(StellarSDK.Horizon.HTTPoitionMock, for: StellarSDK.Horizon.Client)

ExUnit.start()
