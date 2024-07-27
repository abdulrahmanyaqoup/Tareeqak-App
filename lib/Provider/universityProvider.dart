import 'package:finalproject/Models/University/major.dart';
import 'package:finalproject/Models/University/school.dart';
import 'package:finalproject/Models/University/university.dart';
import 'package:finalproject/api/universityApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UniversityState {
  final List<University> universities;
  final List<School> schools;
  final List<Major> majors;

  UniversityState({
    this.universities = const [],
    this.schools = const [],
    this.majors = const [],
  });

  UniversityState copyWith({
    List<University>? universities,
    List<School>? schools,
    List<Major>? majors,
  }) {
    return UniversityState(
      universities: universities ?? this.universities,
      schools: schools ?? this.schools,
      majors: majors ?? this.majors,
    );
  }
}

class UniversityNotifier extends StateNotifier<UniversityState> {
  UniversityNotifier() : super(UniversityState());
  final university = UniversityApi();

  Future<void> getUniversities() async {
    List<University> universities = await university.getUniversities();
    List<School> allSchools =
        universities.expand((university) => university.schools).toList();
    List<Major> allMajors =
        allSchools.expand((school) => school.majors).toList();

    state = state.copyWith(
        universities: universities, schools: allSchools, majors: allMajors);
  }
}

final universityProvider =
    StateNotifierProvider<UniversityNotifier, UniversityState>(
  (ref) => UniversityNotifier(),
);
