import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/cubit/seats/seats_cubit.dart';
import 'package:trips/domain/models/seat_model.dart';
import 'package:trips/presentation/common_widgets/socket_io/socket_logic.dart';

class SocketWidget extends StatefulWidget {
  final int tripId;
  const SocketWidget({Key? key, required this.tripId}) : super(key: key);

  @override
  State<SocketWidget> createState() => _SocketWidgetState();
}

class _SocketWidgetState extends State<SocketWidget> {
  late  ChatSocket _chatSocket;
  @override
  void initState() {
    super.initState();
    _chatSocket = ChatSocket(
        tripId:widget.tripId ,
        onConnectError: (p0) => debugPrint('sockeeeeet_onConnectError $p0'),
        onConnect: (p0) => debugPrint('sockeeeeet_onConnect $p0'),
        onReceivedMessage: (p0) {
          debugPrint('onReceivedMessage');
          debugPrint(p0['seat_status']);
          debugPrint(p0['seat_id'].toString());
         context.read<SeatsCubit>().updateSelectSocket(SeatModel(
           status: p0['seat_status'],
           number:p0['seat_id'],
         ));
         if (mounted) {
           setState(() {});
         }
        });
    _chatSocket.initSocket();
    _chatSocket.listenToChannel();
    _chatSocket.connect();
  }

  @override
  void dispose() async {
    _chatSocket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
