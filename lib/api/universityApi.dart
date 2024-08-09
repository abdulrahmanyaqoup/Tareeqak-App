import '../Models/University/university.dart';
import 'dioClient.dart';

class UniversityApi {
  Future<List<University>> getUniversities() async {
    final response = await dio.get<dynamic>('api/universities');

    final universityList = response.data as List<dynamic>;
    return universityList
        .map((university) =>
            University.fromMap(university as Map<String, dynamic>),)
        .toList();
  }
}
