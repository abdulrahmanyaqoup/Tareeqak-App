import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/universityApi.dart';
import '../model/models.dart';

@immutable
class UniversityState {
  const UniversityState({
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

@immutable
class UniversityProvider extends AsyncNotifier<UniversityState> {
  UniversityProvider({required this.universityApi});

  final UniversityApi universityApi;

  @override
  UniversityState build() {
    return const UniversityState();
  }

  Future<void> getUniversities() async {
    state = const AsyncLoading();

    final universities = await universityApi.getUniversities();
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
    AsyncNotifierProvider<UniversityProvider, UniversityState>(
  () => UniversityProvider(
    universityApi: UniversityApi(),
  ),
);
