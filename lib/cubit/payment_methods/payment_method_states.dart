abstract class PaymentMethodStates{}
class PaymentMethodInitialState extends PaymentMethodStates{}

class LoadingGetPaymentMethodsState extends PaymentMethodStates{}
class SuccessGetPaymentMethodsState extends PaymentMethodStates{}
class ErrorGetPaymentMethodsState extends PaymentMethodStates{
  final String error;

  ErrorGetPaymentMethodsState({required this.error});
}

