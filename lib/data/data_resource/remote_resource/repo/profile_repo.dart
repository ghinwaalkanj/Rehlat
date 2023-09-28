import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../domain/models/profile_param.dart';
import '../../../model/trip_model.dart';
import '../api_handler/base_api_client.dart';
import '../links.dart';

class ProfileRepo {

  Future<Either<String, ProfileParamModel>> getProfile() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.profile}',
        converter: (value) {
          return ProfileParamModel.fromJson(value['data']['profile']);
        });
  }

  Future<Either<String, bool>> updateProfile({required ProfileParamModel profileParamModel}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.profile}',
        queryParameters: profileParamModel.toJson(),
        converter: (value) {
          return true;
        });
  }

  Future<Either<String, bool>> requestUpdateProfile() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.requestUpdateProfile}',
        converter: (value) {
          return true;
        });
  }

  Future<Either<String, bool>> verifyOtpProfile({required String phone,required String code}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.updatePhone}',
        formData:  FormData.fromMap({
          "phone": phone,
          "code":code,
        }),
        converter: (value) {
          return true;
        });
  }
}