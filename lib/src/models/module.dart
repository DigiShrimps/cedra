import 'package:cedra_basic_sdk/src/bcs/helper.dart';
import 'package:cedra_basic_sdk/src/bcs/serializer.dart';

class Module implements Serializable {
  final String address;
  final String name;

  Module({
    required this.address,
    required this.name,
  });

  @override
  void serialize(Serializer serializer) {
    serializer.serializeAddress(address);
    serializer.serializeStr(name);
  }
}