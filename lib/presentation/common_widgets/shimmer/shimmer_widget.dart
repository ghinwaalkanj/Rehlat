import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../style/app_colors.dart';


class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final ShapeBorder shapeBorder;
  const  ShimmerWidget({Key? key,required this.height,required this.width,required this.shapeBorder}) : super(key: key);

   const ShimmerWidget.circular({super.key, required this.height,required this.width,}):shapeBorder=const CircleBorder();
   const ShimmerWidget.rectangle({super.key, required this.height,required this.width, }):shapeBorder=const RoundedRectangleBorder(
     borderRadius: BorderRadius.all(Radius.circular(16))
   );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.white,
      highlightColor: AppColors.gray,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.grey.shade400,
          shape: shapeBorder
        ),
      ),
       );
  }
}
