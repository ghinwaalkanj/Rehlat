import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/cubit/privacy_cubit/privacy_states.dart';
import 'package:trips/data/data_resource/remote_resource/repo/profile_repo.dart';

class PrivacyCubit extends Cubit<PrivacyStates> {
  ProfileRepo profileRepo;
   dynamic privacyContent;
   dynamic termsContent;
  PrivacyCubit({required this.profileRepo}) : super(PrivacyInitialState());

  getPrivacy() async {
    emit(LoadingGetPrivacyState());
    (await profileRepo.getPrivacy()).fold((l) => emit(ErrorGetPrivacyState(error: l)),
            (r) {
              privacyContent=r;
          emit(SuccessGetPrivacyState());
        });
  }

  getTerms() async {
    emit(LoadingGetTermsState());
    (await profileRepo.getTerms()).fold((l) => emit(ErrorGetTermsState(error: l)),
            (r) {
              termsContent=r;
          emit(SuccessGetTermsState());
        });
  }

}