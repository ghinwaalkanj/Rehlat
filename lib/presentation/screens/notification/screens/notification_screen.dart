import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';

import '../../../../core/di.dart';
import '../../../../cubit/notification_cubit/notification_cubit.dart';
import '../../../../cubit/notification_cubit/notification_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
import '../widgets/notification_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..getNotification(),
      child: BlocConsumer<NotificationCubit,NotificationStates>(
          listener: (context, state) {},
          builder: (context, state) => BaseAppBar(
              titleScreen: 'notification'.translate(),
              child:
              state is GetNotificationErrorState
                    ? CustomErrorScreen(onTap: () =>context.read<NotificationCubit>().getNotification(),)
                    : context.read<NotificationCubit>().isFirstLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary,))
                    :   LazyLoadScrollView(
                          isLoading: context.read<NotificationCubit>().isLoading,
                          onEndOfPage: () =>  context.read<NotificationCubit>().isLast
                              ? print('test done')
                              : context.read<NotificationCubit>().getNotification(),
                          child: context.read<NotificationCubit>().notificationList.isNotEmpty
                              ? RefreshIndicator(
                            onRefresh: () => context.read<NotificationCubit>().refresh(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: ListView.separated(
                                   //physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) =>  NotificationCardWidget(notificationModel: context.read<NotificationCubit>().notificationList[index]),
                                    separatorBuilder: (context, index) => const Divider(),
                                    itemCount: context.read<NotificationCubit>().notificationList.length),
                                        ),
                                ),
                                if(context.read<NotificationCubit>().isLoading)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: CircularProgressIndicator(color: AppColors.primary),
                                  )
                              ],
                            ),
                          )
                              : Text('data', style:AppTextStyle2.getBoldStyle(
                                  fontSize: AppFontSize.size_12,
                                  color:  Colors.black,
                                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),)
                    ),
      ),
    ));
  }
}