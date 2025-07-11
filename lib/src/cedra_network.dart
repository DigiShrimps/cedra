enum CedraNetwork {
  testnet,
  mainnet,
  custom,
}

extension CedraNetworkUrl on CedraNetwork {
  String get url {
    return switch (this) {
      CedraNetwork.testnet => 'https://testnet.cedra.dev/v1',
      CedraNetwork.mainnet => 'https://mainnet.cedra.dev/v1',
      CedraNetwork.custom => '' // Custom URL should be provided by the user
    };
  }

  static get testnet => CedraNetwork.testnet.url;

  static get mainnet => CedraNetwork.mainnet.url;

  static get custom => CedraNetwork.custom.url;
}