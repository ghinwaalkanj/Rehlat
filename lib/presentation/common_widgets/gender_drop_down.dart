import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/presentation/common_widgets/shimmer/shimmer_widget.dart';

import '../../data/data_resource/local_resource/data_store.dart';
import '../style/app_colors.dart';
import '../style/app_text_style.dart';

// ignore: must_be_immutable
class DropDownAppWidget extends StatefulWidget {
  final List dropDownList;
  final String chooseTitle;
  String? selectionItem;
  bool isSearch;
  bool isBooking;
  bool isSource;
  Color? borderSideColor;
  Color? fillColor;
  TextStyle? textStyle;
  final Function(String? id ) getSelectionId;

  DropDownAppWidget({Key? key, required this.dropDownList, this.selectionItem,this.isSource=false,
     required this.chooseTitle,required this.getSelectionId,this.isSearch=false,this.isBooking=false,this.borderSideColor,this.fillColor,this.textStyle}) : super(key: key);

  @override
  State<DropDownAppWidget> createState() => _DropDownAppWidgetState();
}

class _DropDownAppWidgetState extends State<DropDownAppWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dropDownList.isNotEmpty) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color:widget.borderSideColor?? AppColors.darkGrey,
            ),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: DropdownButton2(
          isExpanded: true,
          underline: Container(),
          hint: Row(
            children: [
             if(widget.isSearch)Padding(
               padding: const EdgeInsets.symmetric(horizontal: 2.0),
               child:  Container(
                 width: 16,
                 height: 16,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                     border: Border.all(color: AppColors.darkGreen,width: 2),
                     color: widget.isSource?Colors.transparent:AppColors.darkGreen,
                 ),
               ),
             ),
              SizedBox(width:(widget.isSearch)?20: 15,),
              Text(widget.chooseTitle,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style:widget.textStyle??AppTextStyle.darkGreyNormal_16),
            ],
          ),
          items: widget.dropDownList.map((item) {
            return DropdownMenuItem(
              value: item.id.toString(),
              child: Row(
                children: [
                  (widget.isSearch)? Padding(
                    padding: const EdgeInsets.symmetric(horizontal:0.0),
                    child:  Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.darkGreen,width: 2),
                        color: widget.isSource?Colors.transparent:AppColors.darkGreen,
                      ),
                    ),
                  ): const SizedBox(width: 15,),
                  Padding(
                        padding:DataStore.instance.lang=='en'?
                        EdgeInsets.only(left:(widget.isSearch)?25: 15): EdgeInsets.only(right:(widget.isSearch)?25: 15),
                        child: Text(widget.isSearch
                            ? (DataStore.instance.lang=='en'?item.nameEn:item.nameAr)
                            : (widget.isBooking==false)?item.name:item.reservationNumber,
                          style:widget.textStyle?? AppTextStyle.darkGreyNormal_16,),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: ( newVal) {
            setState(() {
              widget.selectionItem = newVal.toString();
              widget.getSelectionId(widget.selectionItem);
            });
          },
          value: widget.selectionItem,
        ),
      );
    }
    else {
      return  ShimmerWidget.rectangle(width: double.infinity,height: 65.h, );
    }
  }
}

