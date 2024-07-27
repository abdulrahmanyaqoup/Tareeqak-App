import 'package:finalproject/Models/University/university.dart';
import 'package:finalproject/api/dioClient.dart';

class UniversityApi {
  Future<List<University>> getUniversities() async {
    final response = await dio.get('api/universities');

    List<dynamic> universityList = response.data;
    return universityList
        .map((university) => University.fromMap(university))
        .toList();
  }
}
