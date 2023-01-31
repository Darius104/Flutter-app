import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageClass {
  final storage = FlutterSecureStorage();

  Future<String?> getJWT() async {
    String? value = await storage.read(key: 'jwt');

    return value;
  }

  Future<void> createJWT(token) async {
    await storage.write(key: 'jwt', value: token);
  }
}
