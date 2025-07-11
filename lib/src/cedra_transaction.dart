import 'dart:convert';

import 'package:cedra_basic_sdk/src/crypto/ed25519.dart';

import '../cedra.dart';

import 'dart:typed_data';

class CedraTransaction {
  final CedraClient client;
  final Map<String, dynamic> txData;
  Uint8List? signature;

  CedraTransaction({
    required this.client,
    required this.txData,
  });

Future<void> sign(Ed25519KeyPair keyPair) async {
    final jsonString = json.encode(txData);
    final messageBytes = Uint8List.fromList(utf8.encode(jsonString));

    signature = await Ed25519Crypto.sign(messageBytes, keyPair);
    txData['signature'] = base64Encode(signature!);
  }

  Future<Map<String, dynamic>> send() async {
    if (signature == null) {
      throw Exception('Transaction must be signed before sending');
    }
    return await client.post('tx/send', txData);
  }
}