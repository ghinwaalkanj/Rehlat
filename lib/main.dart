import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/cubit/payment_methods/payment_method_cubit.dart';
import 'package:trips/cubit/support/support_cubit.dart';
import 'package:trips/presentation/screens/onboarding_screens/splash_screen.dart';

import 'core/di.dart';
import 'core/localization/app_localization.dart';
import 'core/notifications/message_notification_hundler.dart';
import 'core/utils/global.dart';
import 'core/utils/utils_functions.dart';
import 'cubit/booking/booking_cubit.dart';
import 'cubit/cash_cubit/cash_cubit.dart';
import 'cubit/evaluation/evaluation_cubit.dart';
import 'cubit/fatora/fatora_cubit.dart';
import 'cubit/home/home_cubit.dart';
import 'cubit/main/main_cubit.dart';
import 'cubit/main/main_states.dart';
import 'cubit/onboarding/onboarding_cubit.dart';
import 'cubit/otp_cubit/otp_cubit.dart';
import 'cubit/passenger_cubit/passenger_cubit.dart';
import 'cubit/profile/profile_cubit.dart';
import 'cubit/result_search_card/result_search_cubit.dart';
import 'cubit/reverse_trip/reserve_trip_cubit.dart';
import 'cubit/root/root_cubit.dart';
import 'cubit/seats/seats_cubit.dart';
import 'data/data_resource/local_resource/data_store.dart';
import 'data/data_resource/remote_resource/api_handler/base_api_client.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await DataStore.instance.init();
  setUp();
  BaseApiClient();
  await Firebase.initializeApp();
  await FunctionUtils().getNotificationPermission();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
        BlocProvider(create: (context) => getIt<OnBoardingCubit>()),
        BlocProvider(create: (context) => getIt<RootPageCubit>()),
        BlocProvider(create: (context) => getIt<HomeCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<EvaluationCubit>()),
        BlocProvider(create: (context) => getIt<OtpCubit>()),
        BlocProvider(lazy: false, create: (context) => getIt<ReserveTripCubit>()),
        BlocProvider(create: (context) => getIt<SeatsCubit>()),
        BlocProvider(create: (context) => getIt<MainCubit>()),
        BlocProvider(create: (context) => getIt<ResultSearchCubit>()),
        BlocProvider(create: (context) => getIt<PassengerCubit>()),
        BlocProvider(create: (context) => getIt<BookingCubit>()..getBookingList()),
        BlocProvider(create: (context) => getIt<SupportCubit>()),
        BlocProvider(create: (context) => getIt<PaymentMethodCubit>()),
        BlocProvider(create: (context) => getIt<FatoraCubit>()),
        BlocProvider(create: (context) => getIt<CashCubit>()),
   ],
    child: ScreenUtilInit(
        designSize: const Size(429, 932),
    minTextAdapt: true,
    useInheritedMediaQuery: true,
    splitScreenMode: false,
    builder: (BuildContext context, Widget? child) {
      return BlocConsumer<MainCubit,MainStates>(
        listener: (context, state) {},
          builder: (context, state) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'رحلات',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MessageHandlerWidget(child: SplashScreen()),
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale:  Locale(DataStore.instance.lang),
            localeResolutionCallback: (locale, locales) {
              for (Locale supportedLocale in locales) {
                if (supportedLocale.languageCode == locale!.languageCode) {
                  return supportedLocale;
                }
              }
              return locales.first;
            }),
      );
    }),
      );
  }
}