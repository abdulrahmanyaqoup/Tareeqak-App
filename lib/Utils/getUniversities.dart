import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Provider/universityProvider.dart';Future<void> getUniversities(WidgetRef ref) async {  await ref.read(universityProvider.notifier).getUniversities();}