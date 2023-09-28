// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:trips/cubit/home/home_cubit.dart';
// import 'package:trips/cubit/home/home_states.dart';
// import '../../../../common_widgets/auth_text_form_field.dart';
// import '../../../../style/app_colors.dart';
// import '../../../../style/app_text_style.dart';
//
// class SearchScreen extends StatelessWidget {
//   final TextEditingController searchController;
//   const SearchScreen({Key? key, required this.searchController}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit,HomePageStates>(
//       builder: (context, state) =>  Scaffold(
//           body: SafeArea(
//               child: Column(children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12),
//             child: AuthTextFormField(
//               height: 40,
//               borderWidth: 3,
//               borderRadius:12 ,
//               borderColor: AppColors.darkYellow,
//               prefixIcon:   IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_rounded,
//                     color:Colors.black
//                 ),
//               ),
//               suffixIcon:searchController.text==''?
//                 const Icon(
//                 Icons.search_rounded,
//                 color:AppColors.darkGray
//             ):
//               IconButton(
//                 onPressed: () {
//                   searchController.clear();
//                   context.read<HomeCubit>().resultList = [];
//                 },
//                 icon: const Icon(
//                   Icons.close_rounded,
//                     color:AppColors.darkGray
//                 ),
//               ),
//               hintText: 'search',
//               onChanged: (value) async => context.read<HomeCubit>().findResult(searchController: searchController ),
//               onComplete: () async => context.read<HomeCubit>().findResult(searchController: searchController),
//             ),
//           ),
//         ),
//          searchController.text==''
//           ? ListView.builder(
//         shrinkWrap: true,
//         itemBuilder: (context, index) =>  Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Padding(
//             padding: const EdgeInsets.all(3.0),
//             child: Text(context.read<HomeCubit>().searchSuggestionList[index],
//               style: AppTextStyle.darkXXGrayW300_16,
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//           ),
//         ),
//         itemCount:context.read<HomeCubit>().searchSuggestionList.length,
//       )
//           : context.read<HomeCubit>().resultList.isNotEmpty
//           ?ListView.builder(
//         shrinkWrap: true,
//         itemBuilder: (context, index) =>  Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Padding(
//             padding: const EdgeInsets.all(3.0),
//             child: Text(context.read<HomeCubit>().resultList[index],style: AppTextStyle.darkXXGrayW300_16,
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//           ),
//         ),
//         itemCount:context.read<HomeCubit>().resultList.length,
//       )
//           :Container(
//           width: double.infinity,
//           height:double.infinity,
//           color: AppColors.primary,
//           child: const Center(child: Text('No Result Found',style: AppTextStyle.whiteW300_16,)))
//       ]))),
//     );
//   }
// }
