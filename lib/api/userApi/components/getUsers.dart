part of '../userApi.dart';extension GetUsers on UserApi {  Future<List<User>> getUsers() async {    try {      final response = await dio.get<dynamic>(        'api/users',      );      final userList = response.data as List<dynamic>;      return userList          .map((user) => User.fromMap(user as Map<String, dynamic>))          .toList();    } on DioException catch (e) {      throw CustomException(e.error);    }  }}