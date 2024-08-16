part of '../userApi.dart';extension DeleteUser on UserApi {  Future<String> deleteUser({    required String token,  }) async {    try {      final options = Options(        headers: {          HttpHeaders.authorizationHeader: 'Bearer $token',        },      );      final response = await dio.delete<dynamic>(        'api/users/delete',        options: options,        data: {},      );      return response.data as String;    } on DioException catch (e) {      throw CustomException(e.error);    }  }}