import 'dart:typed_data';
import 'package:cedra_basic_sdk/src/bcs/serializer.dart';
import 'package:cedra_basic_sdk/src/models/raw_transaction.dart';

/// Represent a signed transaction
class SignedTransaction {
  final RawTransaction rawTransaction;
  final Authenticator authenticator;

  SignedTransaction({
    required this.rawTransaction,
    required this.authenticator,
  });

  /// Serialize the signed transaction to BCS bytes
  Uint8List toBCS() {
    final serializer = Serializer();
    rawTransaction.serialize(serializer);
    authenticator.serialize(serializer);
    return serializer.getBytes();
  }
}

/// Authenticator class (only Ed25519 supported here)
class Authenticator {
  final Uint8List publicKey;
  final Uint8List signature;

  Authenticator.ed25519(this.publicKey, this.signature);

  /// BCS serialization of the authenticator
  void serialize(Serializer serializer) {
    serializer.serializeU8(0); // Variant index for Ed25519
    serializer.serializeBytes(publicKey);
    serializer.serializeBytes(signature);
  }
}
