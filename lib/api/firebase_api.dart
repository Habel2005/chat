import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat/main.dart';

class FirebaseApi{
  //create instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to intialize notifications
  Future<void> initNotifications() async
  {
    //request permission from user (prompt user)
    await _firebaseMessaging.requestPermission();

    //fetch the FOM token from device
   final FOMToken = await _firebaseMessaging.getToken();

    //print the token (normally send to server)
    print('token $FOMToken');

    //intialize settings for push notfi
    initPushNot();
  }


//funtion to handle recieved messages
void hnadleMessage (RemoteMessage? message)
{
  if(message==null) return;

  //navigate to new screen when message is recevied and user taps notification
  navigatorKey.currentState?.pushNamed(
    '/notification_screen',
    arguments: message,
  );
}

//function to initalize foreground and background settings
Future initPushNot() async{
  //handle not if  app was terminated and now opned
  FirebaseMessaging.instance.getInitialMessage().then(hnadleMessage);

  // attach event listeners for when a notification opens the app
  FirebaseMessaging.onMessageOpenedApp.listen(hnadleMessage);
}
}