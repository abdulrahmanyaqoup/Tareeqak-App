// ignore_for_file: constant_identifier_names

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'URI', obfuscate: true)
  static final String URI = _Env.URI;
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String API_KEY = _Env.API_KEY;
}
