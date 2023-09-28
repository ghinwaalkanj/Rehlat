import 'package:flutter/material.dart';
import 'package:trips/presentation/common_widgets/shimmer/shimmer_widget.dart';

class VerticalShimmerListWidget extends StatelessWidget {
  const VerticalShimmerListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) =>ShimmerWidget.rectangle(
          width:MediaQuery.of(context).size.width*0.5,height: 170,
        ),
        separatorBuilder: (context, index) =>const SizedBox(height: 18,) ,
        itemCount: 6);
  }
}
