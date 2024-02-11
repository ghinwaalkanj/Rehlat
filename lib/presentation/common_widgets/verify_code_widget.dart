import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyCodeWidget extends StatefulWidget {
  const VerifyCodeWidget({Key? key}) : super(key: key);

  @override
  State<VerifyCodeWidget> createState() => _VerifyCodeWidgetState();
}

class _VerifyCodeWidgetState extends State<VerifyCodeWidget> {
  String? appSignature;
  String? otpCode;

  codeListen() async {
   await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    super.initState();
    codeListen();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    SmsAutoFill().unregisterListener();
  }

  @override
  Widget build(BuildContext context) {
    return  const SizedBox();
  }
}