import 'package:flutter_riverpod/flutter_riverpod.dart';import '../provider/universityProvider.dart';Future<void> getUniversities(WidgetRef ref) async {  await ref.read(universityProvider.notifier).getUniversities();}