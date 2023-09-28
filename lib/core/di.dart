import 'package:get_it/get_it.dart';

import '../cubit/booking/booking_cubit.dart';
import '../cubit/evaluation/evaluation_cubit.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/main/main_cubit.dart';
import '../cubit/onboarding/onboarding_cubit.dart';
import '../cubit/otp_cubit/otp_cubit.dart';
import '../cubit/passenger_cubit/passenger_cubit.dart';
import '../cubit/profile/profile_cubit.dart';
import '../cubit/result_search_card/result_search_cubit.dart';
import '../cubit/reverse_trip/reserve_trip_cubit.dart';
import '../cubit/root/root_cubit.dart';
import '../cubit/seats/seats_cubit.dart';
import '../data/data_resource/remote_resource/repo/profile_repo.dart';
import '../data/data_resource/remote_resource/repo/rate_repo.dart';
import '../data/data_resource/remote_resource/repo/trips_repo.dart';

final getIt = GetIt.instance;

void setUp() {
  //blocs
  getIt.registerLazySingleton(()=> OnBoardingCubit());
  getIt.registerLazySingleton(()=> RootPageCubit(tripsRepo: getIt<TripsRepo>(),rateRepo: getIt<RateRepo>() ));
  getIt.registerLazySingleton(()=> HomeCubit(tripsRepo: getIt<TripsRepo>())..getCities());
  getIt.registerLazySingleton(()=> ProfileCubit(profileRepo: getIt<ProfileRepo>(),tripsRepo: getIt<TripsRepo>()));
  getIt.registerFactory(()=> BookingCubit(tripsRepo: getIt<TripsRepo>())..getBookingList());
  getIt.registerLazySingleton(()=> EvaluationCubit(rateRepo: getIt<RateRepo>()));
  getIt.registerLazySingleton(()=> OtpCubit(tripsRepo: getIt<TripsRepo>()));
  getIt.registerFactory(()=> ReserveTripCubit(tripsRepo: getIt<TripsRepo>()));
  getIt.registerFactory(()=> SeatsCubit(tripsRepo: getIt<TripsRepo>()));
  getIt.registerLazySingleton(()=> MainCubit(rateRepo: getIt<RateRepo>() ));
  getIt.registerLazySingleton(()=> ResultSearchCubit(tripsRepo: getIt<TripsRepo>()));
  getIt.registerLazySingleton(()=> PassengerCubit(tripsRepo: getIt<TripsRepo>()));
 //repo
  getIt.registerLazySingleton(()=> TripsRepo());
  getIt.registerLazySingleton(()=> ProfileRepo());
  getIt.registerLazySingleton(()=> RateRepo());

}