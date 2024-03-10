import 'package:flutter/material.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/presentation/common_widgets/cached_image.dart';
import 'package:trips/presentation/screens/payment_mothod/screens/fatora_web_view.dart';

import '../../../../data/model/payment_model.dart';
import '../../../style/app_text_style.dart';
import 'banks_card.dart';

class PaymentMethodCard extends StatelessWidget {
  final int reservationId;
  final PaymentMethodsModel paymentMethodsModel;
  const PaymentMethodCard({Key? key, required this.paymentMethodsModel, required this.reservationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>AppRouter.navigateTo(context: context, destination:  FatoraWebView(reservationId:  reservationId,)),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
          // height: 200,
            decoration: BoxDecoration(
              borderRadius:  const BorderRadius.all(Radius.circular(14)),
              color: Colors.grey.withOpacity(0.1),
                border: Border.all(color: Colors.grey)
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: CachedImage(imageUrl:paymentMethodsModel.logo??'',height: 50,width: 50)),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:(paymentMethodsModel.disable==0)?MainAxisAlignment.start:MainAxisAlignment.center ,
                      children: [
                        Text(paymentMethodsModel.name??'',style: AppTextStyle.lightBlackW400_16,),
                        if(paymentMethodsModel.disable==0)
                        const Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text('inactivated now',style: AppTextStyle.lightGrey1W400_14,),
                        ),
                        if((paymentMethodsModel.banks?.isNotEmpty??false)&&(paymentMethodsModel.disable!=0))
                         BanksListWidget(bankList: paymentMethodsModel.banks!),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if(paymentMethodsModel.disable==0)
          Container(
            width: double.infinity,
              height: 80,
              decoration: const BoxDecoration(
                borderRadius:  BorderRadius.all(Radius.circular(14)),
                color: Colors.white30,
                ),),
        ],
      ),
    );
  }
}