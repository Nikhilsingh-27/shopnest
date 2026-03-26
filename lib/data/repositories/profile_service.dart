import 'dart:io';

import 'package:dio/dio.dart' as dio;

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';

class ProfileService {
  final dio.Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> submitKycForm({
    required String idType,
    required String documentNumber,
    required String fullName,
    required String dob,
    required File frontImage,
  }) async {
    try {
      String fileName = frontImage.path.split('/').last;
      print(fileName);
      final dio.FormData formData = dio.FormData.fromMap({
        "id_type": idType,
        "document_number": documentNumber,
        "full_name": fullName,
        "dob": dob,
        "front_image": await dio.MultipartFile.fromFile(
          frontImage.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        ApiConstants.useridverfiy,
        data: formData,
        options: dio.Options(
          headers: {"Content-Type": "multipart/form-data"},
          extra: {"requiresToken": true},
        ),
      );
      print(response);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message ?? "API error");
    }
  }
}
