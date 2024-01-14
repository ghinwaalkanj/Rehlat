abstract class PrivacyStates{}
class PrivacyInitialState extends PrivacyStates{}

class LoadingGetPrivacyState extends PrivacyStates{}
class SuccessGetPrivacyState extends PrivacyStates{}
class ErrorGetPrivacyState extends PrivacyStates{
  final String error;
  ErrorGetPrivacyState({required this.error});
}

class LoadingGetTermsState extends PrivacyStates{}
class SuccessGetTermsState extends PrivacyStates{}
class ErrorGetTermsState extends PrivacyStates{
  final String error;

  ErrorGetTermsState({required this.error});
}
