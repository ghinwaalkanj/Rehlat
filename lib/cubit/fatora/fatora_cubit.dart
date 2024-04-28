import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/cubit/fatora/fatora_state.dart';
import 'package:trips/data/data_resource/remote_resource/repo/payment_repo.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FatoraCubit extends Cubit<FatoraStates> {
  PaymentRepo paymentRepo;
  String? url;
  bool isGoogle=false;
  bool completeDownloading=false;
  WebViewController? webViewController ;
  FatoraCubit({required this.paymentRepo}) : super(FatoraInitialState());


  getFatoraUrl({required int reservationId}) async {
    isGoogle=false;
    completeDownloading=false;
    url=null;
    emit(LoadingFatoraState());
    (await paymentRepo.getFatoraLink(reservationId: reservationId)).fold((l) => emit(ErrorFatoraState(error: l)),
            (r) {
           url=r;
             webViewController= WebViewController()
               ..setJavaScriptMode(JavaScriptMode.unrestricted)
               ..loadRequest(Uri.parse(url!))
               ..setNavigationDelegate(
                   NavigationDelegate(
                     onProgress: (int progress) {
                       print('progress');
                       print(progress);
                       if(progress==50){
                       completeDownloading=true;
                       emit(SuccessFatoraState());}
                     },
                     onPageStarted: (String url) {
                       print('onPageStarted');
                       print(url);
                       completeDownloading=true;
                       emit(SuccessFatoraState());
                     },
                     onPageFinished: (String url) {
                       print('onPageFinished');
                       print(url);
                     },
                     onUrlChange: (change) {

                       print('onUrlChange');
                       print(change.url);
                       if (change.url?.contains('https://www.google.com/')??false){
                         isGoogle=true;
                         emit(IsGoogleState());
                       }
                     },
                     //   onNavigationRequest: (NavigationRequest request) {
                     //   if (request.url.startsWith('https://www.youtube.com/')) {
                     //     print('startsWith googgggle');
                     //     print(request.url);
                     // //  return NavigationDecision.prevent;
                     //   }
                     //   print('withouttt googgggle');
                     //   print(request.url);
                     // //  return NavigationDecision.navigate;
                     //   },
                   )
               );
          emit(SuccessFatoraState());
        });
  }
}