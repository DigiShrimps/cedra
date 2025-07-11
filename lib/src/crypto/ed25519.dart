import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class Ed25519KeyPair {
  final SimpleKeyPair keyPair;
  final SimplePublicKey publicKey;
  final Uint8List privateKeyBytes;
  final Uint8List publicKeyBytes;

  Ed25519KeyPair({
    required this.keyPair,
    required this.publicKey,
    required this.privateKeyBytes,
    required this.publicKeyBytes,
  });
}

class Ed25519Crypto {
  static final _ed25519 = Ed25519();

  /// Generate a new Ed25519 key pair
  static Future<Ed25519KeyPair> generateKey() async {
    final keyPair = await _ed25519.newKeyPair();
    final publicKey = await keyPair.extractPublicKey();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();

    return Ed25519KeyPair(
      keyPair: keyPair,
      publicKey: publicKey,
      privateKeyBytes: Uint8List.fromList(privateKeyBytes),
      publicKeyBytes: Uint8List.fromList(publicKey.bytes),
    );
  }

  /// Sign a message with the private key from the key pair
  static Future<Uint8List> sign(Uint8List message, Ed25519KeyPair keyPair) async {
    var sign = _ed25519.sign(
      message,
      keyPair: keyPair.keyPair,
    );
    final signature = await sign;
    return Uint8List.fromList(signature.bytes);
  }

  /// Verify a signature for a given message and public key
  static Future<bool> verify(
    Uint8List message,
    Uint8List signature,
    SimplePublicKey publicKey,
  ) async {
    return _ed25519.verify(
      message,
      signature: Signature(signature, publicKey: publicKey),
    );
  }
}
