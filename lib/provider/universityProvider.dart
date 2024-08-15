import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/universityApi.dart';
import '../model/models.dart';

class UniversityState {
  UniversityState({
    this.universities = const [],
    this.filteredUniversities = const [],
    this.schools = const [],
    this.majors = const [],
    this.isSearching = false,
  });

  final List<University> universities;
  final List<University> filteredUniversities;
  final List<School> schools;
  final List<Major> majors;
  final bool isSearching;

  UniversityState copyWith({
    List<University>? universities,
    List<University>? filteredUniversities,
    List<School>? schools,
    List<Major>? majors,
    bool isSearching = false,
  }) {
    return UniversityState(
      universities: universities ?? this.universities,
      filteredUniversities: filteredUniversities ?? this.filteredUniversities,
      schools: schools ?? this.schools,
      majors: majors ?? this.majors,
      isSearching: isSearching,
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
      return state.requireValue.copyWith(
        universities: universities,
        schools: allSchools,
        majors: allMajors,
      );
    });
  }

  Future<void> filterUniversities(String query) async {
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) {
        return state.requireValue.copyWith(
          filteredUniversities: <University>[],
        );
      } else {
        final filteredUniversities = state.requireValue.universities
            .where(
              (university) =>
                  university.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        return state.requireValue.copyWith(
          filteredUniversities: filteredUniversities,
          isSearching: true,
        );
      }
    });
  }
}

final universityProvider =
    AsyncNotifierProvider<UniversityNotifier, UniversityState>(
  UniversityNotifier.new,
);
