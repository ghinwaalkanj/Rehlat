import 'package:flutter/material.dart';

import 'common_widgets/search_drop_down.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: SearchDropDownAppWidget()));
  }
}
