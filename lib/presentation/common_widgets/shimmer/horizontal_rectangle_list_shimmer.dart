import 'package:flutter/material.dart';
import 'package:trips/presentation/common_widgets/shimmer/shimmer_widget.dart';

class HomeShimmerWidget extends StatelessWidget {
  const HomeShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
         shrinkWrap: true,
        itemBuilder: (context, index) =>ShimmerWidget.rectangle(
         width:MediaQuery.of(context).size.width*0.5, height: 0,
        ),
        separatorBuilder: (context, index) =>const SizedBox(width: 18,) ,
        itemCount: 6);
  }
}
