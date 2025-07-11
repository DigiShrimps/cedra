import 'dart:typed_data';
import 'package:cedra_basic_sdk/cedra.dart';
import 'package:cedra_basic_sdk/src/crypto/ed25519.dart';
import 'package:cedra_basic_sdk/src/utils/hex.dart';
import 'package:cryptography/cryptography.dart';

class CedraAccount {
  final CedraClient client;
  late final Ed25519KeyPair keyPair;
  late final String address;

  CedraAccount(this.client);

  Future<void> create() async {
    keyPair = await Ed25519Crypto.generateKey();
    address = bytesToHex(keyPair.publicKeyBytes);
  }

  Future<void> loadFromPrivateKey(String privateKeyHex) async {
    final privateKeyBytes = hexToBytes(privateKeyHex);

    final reconstructed = await Ed25519().newKeyPairFromSeed(privateKeyBytes);
    final publicKey = await reconstructed.extractPublicKey();

    final simpleKeyPair = SimpleKeyPairData(
      privateKeyBytes,
      type: KeyPairType.ed25519,
      publicKey: publicKey,
    );

    keyPair = Ed25519KeyPair(
      keyPair: simpleKeyPair,
      publicKey: publicKey,
      privateKeyBytes: privateKeyBytes,
      publicKeyBytes: Uint8List.fromList(publicKey.bytes),
    );

    address = bytesToHex(publicKey.bytes);
  }

Future<Map<String, dynamic>> fetchInfo() async {
    if (address.isEmpty) {
      throw Exception('Address is not set.');
    }
    return await client.get('account/$address');
  }

  String get publicKeyHex => bytesToHex(keyPair.publicKeyBytes);
  String get privateKeyHex => bytesToHex(keyPair.privateKeyBytes);
}
