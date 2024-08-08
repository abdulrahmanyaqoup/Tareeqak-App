import 'package:dio/dio.dart';
import 'package:finalproject/Models/University/major.dart';
import 'package:finalproject/Models/University/school.dart';
import 'package:finalproject/Models/University/university.dart';
import 'package:finalproject/api/universityApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UniversityState {
  final List<University> universities;
  final List<University> filteredUniversities;
  final List<School> schools;
  final List<Major> majors;

  UniversityState({
    this.universities = const [],
    this.filteredUniversities = const [],
    this.schools = const [],
    this.majors = const [],
  });

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

    try {
      List<University> universities = await UniversityApi().getUniversities();
      List<School> allSchools =
          universities.expand((university) => university.schools).toList();
      List<Major> allMajors =
          allSchools.expand((school) => school.majors).toList();

      state = await AsyncValue.guard(() async {
        return state.valueOrNull!.copyWith(
          universities: universities,
          filteredUniversities: universities,
          schools: allSchools,
          majors: allMajors,
        );
      });
    } on DioException catch (error) {
      throw error.message!;
    }
  }

  Future<void> filterUniversities(String query) async {
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) {
        return state.valueOrNull!.copyWith(
          filteredUniversities: state.valueOrNull!.universities,
        );
      } else {
        List<University> filteredUniversities = state.valueOrNull!.universities
            .where((university) =>
                university.name.toLowerCase().contains(query.toLowerCase()))
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
        UniversityNotifier.new);
