import 'dart:typed_data';

import 'package:cedra_basic_sdk/src/bcs/helper.dart';
import 'package:cedra_basic_sdk/src/bcs/serializer.dart';
import 'package:cedra_basic_sdk/src/models/module.dart';

class Payload implements Serializable {
  final Module module;
  final String function;
  final List<String> typeArguments;
  final List<Uint8List> arguments;

  Payload({
    required this.module,
    required this.function,
    required this.typeArguments,
    required this.arguments,
  });

  @override
  void serialize(Serializer serializer) {
    // Це "enum variant index" для EntryFunctionPayload у Move – зазвичай 2
    serializer.serializeU8(2);

    module.serialize(serializer);
    serializer.serializeStr(function);

    // Типи аргументів (порожній список тут)
    serializeVectorWithFunc(typeArguments, 'serializeStr');

    // Аргументи — список байтів
    serializer.serializeU32AsUleb128(arguments.length);
    for (var arg in arguments) {
      serializer.serializeBytes(arg);
    }
  }
}
