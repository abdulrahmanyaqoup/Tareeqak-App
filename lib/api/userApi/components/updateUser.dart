part of '../userApi.dart';extension UpdateUser on UserApi {  Future<Map<String, dynamic>> updateUser({    required User user,    required String token,  }) async {    try {      final formData = FormData.fromMap({        'name': user.name,        'university': user.userProps.university,        'school': user.userProps.school,        'major': user.userProps.major,        'contact': user.userProps.contact,        'image': user.userProps.image,      });      if (user.userProps.image.isNotEmpty) {        formData.files.add(          MapEntry(            'image',            await MultipartFile.fromFile(              user.userProps.image,              filename: user.userProps.image,              contentType: MediaType('image', 'jpg/jpeg/webp/png'),            ),          ),        );      }      final options = Options(        headers: {          HttpHeaders.authorizationHeader: 'Bearer $token',          'Content-Type': 'multipart/form-data',        },      );      final response = await dio.patch<dynamic>(        'api/users/update',        data: formData,        options: options,      );      return response.data as Map<String, dynamic>;    } on DioException catch (e) {      throw CustomException(e.error);    }  }}