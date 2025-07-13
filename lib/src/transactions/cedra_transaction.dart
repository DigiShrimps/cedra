import 'dart:convert';

import 'package:cedra_basic_sdk/cedra.dart';
import 'package:cedra_basic_sdk/src/crypto/ed25519.dart';
import 'package:cedra_basic_sdk/src/utils/hex.dart';

import 'dart:typed_data';

class CedraTransaction {
  final CedraClient client;
  final Map<String, dynamic> transactionData;
  Map<String, dynamic>? signature;

  CedraTransaction({
    required this.client,
    required this.transactionData,
  });

  Future<void> sign(Map<String, dynamic> txData, Ed25519KeyPair keyPair) async {
    final message = utf8.encode(jsonEncode(transactionData));
  final sigBytes = await Ed25519Crypto.sign(Uint8List.fromList(message), keyPair);

  signature = {
    "type": "ed25519_signature",
    "public_key": bytesToHex(keyPair.publicKeyBytes),
    "signature": bytesToHex(sigBytes),
  };

  transactionData["signature"] = signature;
}


  Future<Map<String, dynamic>> send() async {
    if (signature == null) {
      throw Exception('Transaction must be signed before sending');
    }
    return await client.post('transactions', transactionData);
  }
}