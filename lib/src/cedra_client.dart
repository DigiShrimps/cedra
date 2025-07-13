import 'dart:convert';
import 'package:cedra_basic_sdk/src/cedra_network.dart';
import 'package:http/http.dart' as http;

class CedraClient {
  final String baseUrl;

  CedraClient._(this.baseUrl);

 /// Factory constructor to create a CedraClient instance based on the network type.
  factory CedraClient({CedraNetwork network = CedraNetwork.testnet, String? customUrl}) {
    switch (network) {
      case CedraNetwork.testnet:
        return CedraClient._(CedraNetworkUrl.testnet);
      case CedraNetwork.mainnet:
        return CedraClient._(CedraNetworkUrl.mainnet);
      case CedraNetwork.faucet:
        return CedraClient._(CedraNetworkUrl.faucet);
      case CedraNetwork.custom:
        if (customUrl == null || customUrl.isEmpty) {
          throw ArgumentError('Custom URL must be provided for CedraNetwork.custom');
        }
        return CedraClient._(customUrl);
    }
  }

  /// Get the base URL for the Cedra client
  Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Request failed with status: ${response.statusCode}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// Post data to the Cedra client
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }
}


extension CedraClientPing on CedraClient {
  Future<bool> ping() async {
    try {
      // ignore: unused_local_variable
      final response = await get('');
      return true;
    } catch (e) {
      if (e.toString().contains('404')) return true;
      return false;
    }
  }
}

