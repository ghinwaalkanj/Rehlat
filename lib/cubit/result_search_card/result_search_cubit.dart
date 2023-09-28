import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/cubit/result_search_card/result_search_state.dart';
import '../../core/utils/enums.dart';
import '../../data/data_resource/local_resource/data_store.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/trip_model.dart';
import '../../domain/models/sort_model.dart';
import '../../presentation/screens/root_screens/home_screen/widgets/companies_dialog.dart';

class ResultSearchCubit extends Cubit<ResultSearchStates> {
  TripsRepo tripsRepo;
  String? selectedCompany;
  List<SortModel> sortByList=[
    SortModel(title: 'lowest_price', sort: Sort.lowPrice),
    SortModel(title: 'highest_price', sort: Sort.highPrice),
    SortModel(title: 'earliest', sort: Sort.earliest),
    SortModel(title: 'late_time', sort: Sort.lateTime),
    SortModel(title: 'available_seats', sort: Sort.seatsLeft),
    SortModel(title: 'company_name', sort: Sort.companyName),

  ];
  Sort? selectedSort;
  List<TripModel> tripsList=[];
  SortModel? sortBy;
  TripModel? selectedTripModel;
  List<TripModel> companyTripsList=[];
  bool goToSendOtp=true;
  ResultSearchCubit({required this.tripsRepo}) : super(ResultSearchInitialState());

  getSortList(){
    if(selectedSort==Sort.lowPrice){
      tripsList.sort((p1, p2){
        if (p1.ticketPrice! < p2.ticketPrice!) {
          return -1;
        } else if (p1.ticketPrice! > p2.ticketPrice!) {
          return 1;
        } else {
          return 0;
        }
      });
    }
    if(selectedSort==Sort.highPrice){
      tripsList.sort((p1, p2){
        if (p1.ticketPrice! < p2.ticketPrice!) {
          return 1;
        } else if (p1.ticketPrice! > p2.ticketPrice!) {
          return -1;
        } else {
          return 0;
        }});
    }
    if(selectedSort==Sort.earliest){
      tripsList.sort((p1, p2){
        if (p1.startDate!.isBefore(p2.startDate!)) {
          return -1;
        } else if (p1.startDate!.isAfter(p2.startDate!)) {
          return 1;
        } else {
          return 0;
        }});
    }
    if(selectedSort==Sort.lateTime){
      tripsList.sort((p1, p2){
        if (p1.startDate!.isBefore(p2.startDate!)) {
          return 1;
        } else if (p1.startDate!.isAfter(p2.startDate!)) {
          return -1;
        } else {
          return 0;
        }});
    }
    if(selectedSort==Sort.seatsLeft){
      tripsList.sort((p1, p2){
        if (p1.seatsLeaft! < p2.seatsLeaft!) {
          return 1;
        } else if (p1.seatsLeaft! > p2.seatsLeaft!) {
          return -1;
        } else {
          return 0;
        }
      });
    }
    if(selectedSort==Sort.companyName){
      companyTripsList=[];
      for (var element in tripsList) {
        if(element.company?.id.toString()==selectedCompany){
          companyTripsList.add(element);
        }
      }
    }
    emit(SortState());
  }

  onSelectSort(SortModel? value,Sort sort,context){
    sortBy = value;
    selectedSort=sort;
    (selectedSort==Sort.companyName)
        ? companiesFilterDialog(context: context,onConfirm: () {
      getSortList();
      Navigator.pop(context);
    })
        :  {
      getSortList(),
      Navigator.pop(context),};
  }

  navigateToSeats(){
    if(DataStore.instance.token!=null){
      goToSendOtp=false;
    }
    if(DataStore.instance.token==null){
      print('tttt');
      goToSendOtp=true;
    }
  }


  Future<void> getTripDetails() async {
    emit(LoadingGetTripDetailsState());
    (await tripsRepo.getTrip(selectedTripModel!.id!)).fold((l) => emit(ErrorGetTripDetailsState(error: l)),
            (r) {
      selectedTripModel=r;
          emit(SuccessGetTripDetailsState());
         navigateToSeats();
        });
  }
  afterSearchTrip({required  List<TripModel> newTripsList}){
    tripsList=newTripsList;
    emit(SortState());
  }

}