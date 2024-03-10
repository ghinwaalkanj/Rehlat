abstract class FatoraStates{}
class FatoraInitialState extends FatoraStates{}
class LoadingFatoraState extends FatoraStates{}
class SuccessFatoraState extends FatoraStates{}
class ErrorFatoraState extends FatoraStates{
  final String error;
  ErrorFatoraState({required this.error});
}