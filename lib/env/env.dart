// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'URI')
  static String URI = _Env.URI;
  @EnviedField(varName: 'API_KEY')
  static String API_KEY = _Env.API_KEY;
}
