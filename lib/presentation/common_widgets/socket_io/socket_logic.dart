import 'package:flutter/foundation.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocket{
  final String _socketUrl = 'https://rehlat.sy/';
  final String receiveMessageEvent = 'SeatEvent';
  late Echo echo;
  final int tripId;
  final Function(dynamic) onReceivedMessage;
  final Function(dynamic)? onConnect;
  final Function(dynamic)? onConnectError;
  final Function(dynamic)? onDisconnect;
  ChatSocket(
      {
          this.onConnect,
          required this.onReceivedMessage,
          required this.tripId,
        this.onConnectError,
        this.onDisconnect,
      });
  initSocket() async {
    IO.Socket socket =  IO.io(
      _socketUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });
   //   IO.OptionBuilder().disableAutoConnect().setTransports(['websocket']).build(),
   // );
    echo =  Echo(
      broadcaster: EchoBroadcasterType.SocketIO,
      client:  socket,
      // options: {
      //   // 'auth': {
      //   //   'headers': {
      //   //     'Authorization': DataStore.instance.token,
      //   //   }
      //   // },
      // },
    );
    (echo.connector.socket as IO.Socket).onConnect((_) {
      if (kDebugMode) {
        print('socket.io connected $_');
      }
      if(onConnect!=null) {
        onConnect!(_);
      }
    });
    (echo.connector.socket as  IO.Socket).onDisconnect((_) {
      if (kDebugMode) {
        print('socket.io disconnected $_');
      }
      if(onDisconnect!=null) {
      onDisconnect!(_);
      }
    });
    (echo.connector.socket as  IO.Socket).onConnectError((_) {
      if (kDebugMode) {
        print('socket.io disconnected $_');
      }
      if(onConnectError!= null) {
        onConnectError!(_);
      }
    });
  }
  // for public channel use "channel."
  // for private use "private."
  listenToChannel()=>echo.channel('trip.$tripId').listen('SeatEvent', (e) {
    debugPrint('object2222222');
    debugPrint(e.toString());
    onReceivedMessage(e);
  });

  connect()=> echo.connect();
  disconnect() {
    if((echo.connector.socket as  IO.Socket).connected) {
      echo.disconnect();
    }
  }
}
