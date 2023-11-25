import 'package:flutter/material.dart';

import '../../../../style/app_colors.dart';

class DateTimeWidget {
 static DateTime selectedDate = DateTime.now();

    static Future<void> selectDate(BuildContext context,Function(DateTime dateTime) onConfirm,
        {DateTime? lastDate,DateTime? firstDate}) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          builder: (context, child) => Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.darkGreen,
                    brightness: Brightness.light,// header background color
                    onPrimary: AppColors.white, // body text color
                  ),),
                  child:child!,),
          initialDate:selectedDate,
          firstDate:firstDate?? DateTime(2023, 1,3, 17, 30),
          lastDate:lastDate?? DateTime(2101));
        if (picked != null && picked != selectedDate
            //&& !picked.isBefore(selectedDate)
        ) {
        // final  time= await showTimePicker(
        //   context: context,
        //   initialTime: const TimeOfDay(hour: 2,minute: 0),
        //   builder: (context, child) => Theme(
        //     data: Theme.of(context).copyWith(
        //       colorScheme: const ColorScheme.light(
        //         primary: AppColors.darkGreen,
        //         brightness: Brightness.light,// header background color
        //         onPrimary: AppColors.white, // body text color
        //       ),),
        //     child: child!,
        //   ),
        // );
     //   if(time!=null){
        DateTime x=DateTime(picked.year,picked.month,picked.day,);
        onConfirm(x);
    //    }
      }
    }
  }
