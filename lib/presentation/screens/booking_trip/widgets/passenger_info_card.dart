import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/home/home_cubit.dart';
import 'package:trips/data/model/company_model.dart';
import 'package:trips/domain/models/passenger_model.dart';

import '../../../../cubit/passenger_cubit/passenger_cubit.dart';
import '../../../../cubit/passenger_cubit/passenger_states.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/auth_text_form_field.dart';
import '../../../common_widgets/gender_drop_down.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';

class PassengerInfoCard extends StatefulWidget {
   final int index ;
   final  PassengerModel? passengerModel;
   const PassengerInfoCard({Key? key,   required this.index,required this.passengerModel}) : super(key: key);

  @override
  State<PassengerInfoCard> createState() => _PassengerInfoCardState();
}

class _PassengerInfoCardState extends State<PassengerInfoCard> {
  String name='';
  TextEditingController? nameController;
  TextEditingController? ageController;
  TextEditingController? numberController;
  String? gender;

  @override
  void initState() {
    super.initState();
    nameController=TextEditingController(text: widget.passengerModel!.name??'');
    ageController=TextEditingController(text: widget.passengerModel!.age==null?'': widget.passengerModel!.age.toString());
    numberController=TextEditingController(text: widget.passengerModel!.number==null?'': widget.passengerModel!.number.toString());
    gender= widget.passengerModel!.gender;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PassengerCubit,PassengerStates>(
      builder: (context, state) =>  Padding(
        padding: const EdgeInsets.only(bottom:20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:const BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkXGray.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0,4),
              )
            ]
          ),

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     Text('${'passenger'.translate()} ${widget.index+1} ',style: AppTextStyle2.getSemiBoldStyle(
                       fontSize: AppFontSize.size_14,
                       color: Colors.black,
                       fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                    const SizedBox(width: 18,),
                     Text('${'seat'.translate()} ${context.read<SeatsCubit>().seatsIds[widget.index].number}',style:   AppTextStyle2.getBoldStyle(
                      fontSize: AppFontSize.size_14,
                      color:  Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',).copyWith(
                       fontFamily: DataStore.instance.lang=='ar'? 'Tajawal-Medium':'Poppins-Medium',
                     ),),
                    const Spacer(),
                  //  if(!context.read<PassengerCubit>().isSamePrimaryPassenger)
                    // CustomButton(
                    //   h: 38,
                    //   w: 92,
                    //   radius: 32,
                    //   color: AppColors.darkGreen,
                    //   text: 'add'.translate(),
                    //    textStyle: AppTextStyle2.getSemiBoldStyle(
                    // fontSize: AppFontSize.size_14,
                    // color: Colors.white,
                    // fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                    //   onPressed: () {
                    //     context.read<PassengerCubit>().addPassenger(index: widget.index);
                    //   },),
                  ],
                ),
                const SizedBox(height: 20),
                AuthTextFormField(
                   controller: nameController ,
                    errorText:  widget.passengerModel!.nameError ,
                   labelText: 'name'.translate(),labelStyle: AppTextStyle.darkGreyNormal_16,borderColor:AppColors.darkGrey ,enableColor: AppColors.darkGreen,
                  onChanged: (value) {widget.passengerModel!.name=nameController?.text??'';}
                ),
                const SizedBox(height: 16,),
                AuthTextFormField(
                  controller: ageController ,
                 errorText: widget.passengerModel!.ageError ,
                  labelText: 'age'.translate(),labelStyle: AppTextStyle.darkGreyNormal_16,keyboardType: TextInputType.phone,borderColor:AppColors.darkGrey ,enableColor: AppColors.darkGreen,
                  onChanged: (value) => widget.passengerModel!.age=int.parse(value),
                ),
                const SizedBox(height: 16,),
                AuthTextFormField(
                  errorText: widget.passengerModel!.phoneError ,
                  controller: numberController ,
                  hintText: '09XXXXXXXX',
                  labelText: 'number'.translate(),
                  labelStyle: AppTextStyle.darkGreyNormal_16,keyboardType: TextInputType.phone,borderColor:AppColors.darkGrey ,enableColor: AppColors.darkGreen,
                  onChanged: (value) => widget.passengerModel!.number=value,
                ),
                const SizedBox(height: 16,),
                DropDownAppWidget(
                  dropDownList: [CompanyModel(name: 'male',id: 0),CompanyModel(name:'female',id: 1)],
                  chooseTitle: 'choose_gender'.translate(),
                  getSelectionId: (id) {
                    widget.passengerModel!.gender=id=='0'?'male':'female';
                },
                selectionItem:(widget.passengerModel!.gender!=null)? widget.passengerModel!.gender=='male'?'0':'1' :null,
                ),
                 const SizedBox(height: 22,),
                if(widget.index==0&&(context.read<HomeCubit>().searchTripParam.passenger!='1'))
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: const Icon(Icons.info_outline_rounded,color: AppColors.darkXGray),
                  title: Text('same_primary'.translate(),
                  style: AppTextStyle.darkGreyNormal_16,
                  ),
                  value:  context.read<PassengerCubit>().isSamePrimaryPassenger,
                  onChanged: (value) {
                    context.read<PassengerCubit>().changeSamePrimary(value??false,widget.passengerModel!,int.parse(context.read<HomeCubit>().passengers));
                  },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}