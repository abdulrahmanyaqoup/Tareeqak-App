import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/University/major.dart';
import '../Models/University/school.dart';
import '../Models/University/university.dart';
import '../api/universityApi.dart';

class UniversityState {
  UniversityState({
    this.universities = const [],
    this.filteredUniversities = const [],
    this.schools = const [],
    this.majors = const [],
  });

  final List<University> universities;
  final List<University> filteredUniversities;
  final List<School> schools;
  final List<Major> majors;

  UniversityState copyWith({
    List<University>? universities,
    List<University>? filteredUniversities,
    List<School>? schools,
    List<Major>? majors,
  }) {
    return UniversityState(
      universities: universities ?? this.universities,
      filteredUniversities: filteredUniversities ?? this.filteredUniversities,
      schools: schools ?? this.schools,
      majors: majors ?? this.majors,
    );
  }
}

class UniversityNotifier extends AsyncNotifier<UniversityState> {
  @override
  UniversityState build() {
    return UniversityState();
  }

  Future<void> getUniversities() async {
    state = const AsyncLoading();

    final universities = await UniversityApi().getUniversities();
    final allSchools =
        universities.expand((university) => university.schools).toList();
    final allMajors = allSchools.expand((school) => school.majors).toList();

    state = await AsyncValue.guard(() async {
      return state.valueOrNull!.copyWith(
        universities: universities,
        filteredUniversities: universities,
        schools: allSchools,
        majors: allMajors,
      );
    });
  }

  Future<void> filterUniversities(String query) async {
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) {
        return state.valueOrNull!.copyWith(
          filteredUniversities: state.valueOrNull!.universities,
        );
      } else {
        final filteredUniversities = state.valueOrNull!.universities
            .where(
              (university) =>
                  university.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        return state.valueOrNull!.copyWith(
          filteredUniversities: filteredUniversities,
        );
      }
    });
  }
}

final universityProvider =
    AsyncNotifierProvider<UniversityNotifier, UniversityState>(
  UniversityNotifier.new,
);
