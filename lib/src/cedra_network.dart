enum CedraNetwork {
  testnet,
  mainnet,
  faucet,
  custom,
}

extension CedraNetworkUrl on CedraNetwork {
  String get url {
    return switch (this) {
      CedraNetwork.testnet => 'https://testnet.cedra.dev/v1',
      CedraNetwork.mainnet => 'https://mainnet.cedra.dev/v1',
      CedraNetwork.faucet => 'https://faucet.testnet.cedra.dev',
      CedraNetwork.custom => '' // Custom URL should be provided by the user
    };
  }

  static get testnet => CedraNetwork.testnet.url;

  static get mainnet => CedraNetwork.mainnet.url;

  static get faucet => CedraNetwork.faucet.url;

  static get custom => CedraNetwork.custom.url;
}