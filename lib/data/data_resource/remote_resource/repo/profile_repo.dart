import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:trips/data/model/claim_model.dart';

import '../../../../domain/models/profile_param.dart';
import '../../../../domain/models/support_model.dart';
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

  Future<Either<String, bool>> verifyOtpProfile({required String phone,required String code,required Function(Headers) getHeaders}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.updatePhone}',
        getHeaders11: (p0) =>getHeaders(p0),
        formData:  FormData.fromMap({
          "phone": phone,
          "code":code,
        }),
        converter: (value) {
          return true;
        });
  }

  Future<Either<String, bool>> sendClaim({required SupportModel supportModel}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.sendClaim}',
        formData: supportModel.toJson(),
        converter: (value) {
          return true;
        });
  }

  Future<Either<String, List<ClaimModel>>> getClaims() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.getClaim}',
        converter: (value) {
          return List<ClaimModel>.from(value["data"]['claims']!.map((x) => ClaimModel.fromJson(x)));
        });
  }

  Future<Either<String, dynamic>> getPrivacy() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.privacy}',
        converter: (value) {
          return value;
        });
  }

  Future<Either<String, dynamic>> getTerms() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.terms}',
        converter: (value) {
          return value;
        });
  }



}