import 'package:cedra_basic_sdk/src/bcs/helper.dart';
import 'package:cedra_basic_sdk/src/bcs/serializer.dart';
import 'package:cedra_basic_sdk/src/models/payload.dart';

class RawTransaction implements Serializable {
  final String sender;
  final BigInt sequenceNumber;
  final Payload payload;
  final BigInt maxGasAmount;
  final BigInt gasUnitPrice;
  final BigInt expirationTimestampSecs;
  final int chainId;

  RawTransaction({
    required this.sender,
    required this.sequenceNumber,
    required this.payload,
    required this.maxGasAmount,
    required this.gasUnitPrice,
    required this.expirationTimestampSecs,
    required this.chainId,
  });

  @override
  void serialize(Serializer serializer) {
    serializer.serializeAddress(sender);
    serializer.serializeU64(sequenceNumber);
    payload.serialize(serializer);
    serializer.serializeU64(maxGasAmount);
    serializer.serializeU64(gasUnitPrice);
    serializer.serializeU64(expirationTimestampSecs);
    serializer.serializeU8(chainId);
  }
}
