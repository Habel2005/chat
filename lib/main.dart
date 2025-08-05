
import 'package:chat/firebase_options.dart';
import 'package:chat/pages/intro.dart';
import 'package:chat/services/auth/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  //await FirebaseApi().initNotifications();
  runApp(
    ChangeNotifierProvider(create: (context) => AuthService(),
    child:  const MyApp(),),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}
class MyApp extends StatelessWidget {
   const MyApp({super.key});
  Future<bool> _getIntroShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('introShown') ?? false;
  }

  Future<void> _setIntroShown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introShown', value);
  }
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Namer App',
          home: Consumer<MyAppState>(
            builder: (context, appState, _) => FutureBuilder<bool>(
              future: _getIntroShown(),
              builder: (context, snapshot) {
                final introShown = snapshot.data ?? false;
                if (!introShown) {
                  return SafeArea(
                    child: IntroductionSliderScreen(
                      contentConfigs: [
                        const ContentConfig(
                          title: 'HOME',
                          description:
                              'A Place for All,Containing Millions of Options for Anything!!',
                          descriptionWidget: Text(
                            'A Place for Everyone,Containing Millions of Options for Anything!!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 156, 155, 155),
                              fontSize: 16,
                              fontFamily: 'Futura',
                            ),
                          ),
                          pathImage: 'assets/image1.jpeg',
                          backgroundColor: Color.fromARGB(255, 5, 3, 49),
                          titleWidget: Text(
                            'Home',
                            style: TextStyle(
                              color: Color.fromARGB(255, 251, 250, 251),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Baskerville',
                            ),
                          ),
                        ),
                        ContentConfig(
                          title: 'Favourite',
                          description:
                              'Perfect Place to Select and Play with your Favourites',
                          descriptionWidget: Text(
                            'Perfect Place to Play and Pick with your Favourites..',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 18,
                              fontFamily: 'Arial Bold Italic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          pathImage: 'assets/imag2.jpeg',
                          backgroundColor:
                              const Color.fromARGB(255, 175, 191, 220),
                          titleWidget: const Text(
                            'Favourite',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Optima',
                            ),
                          ),
                        ),
                        const ContentConfig(
                          title: 'Chat',
                          description: 'Virtual Center of Chats and Messages',
                          descriptionWidget: Text(
                            'Virtual Center of Chats and Messages',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 187, 185, 185),
                              fontSize: 18,
                              fontFamily: 'Marion',
                            ),
                          ),
                          pathImage: 'assets/image3.jpeg',
                          backgroundColor: Color.fromARGB(255, 20, 60, 147),
                          titleWidget: Text(
                            'Chat',
                            style: TextStyle(
                              color: Color.fromARGB(255, 253, 254, 254),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BigCaslon',
                            ),
                          ),
                        ),
                      ],
                      onDonePress: () {
                        _setIntroShown(true);
                        appState.showIntro = false;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const MyHomePage();
                }
              },
            ),
          ),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 20, 13, 35)),
          ),
          navigatorKey: navigatorKey,
          routes: {
            '/notification_screen':(context) => const MyHomePage()
          },
        ),
      );
}
