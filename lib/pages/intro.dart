import 'package:chat/services/auth/auth_gate.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});
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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          ),
        ),
      );
}

class MyAppState extends ChangeNotifier {
  bool showIntro = true;

  List<WordPair> favorites = <WordPair>[];
  WordPair current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ignore: type_annotate_public_apis
  void toggleFavorite(current) {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IconData fav = Icons.favorite_border;
  IconData home = Icons.home_rounded;
  IconData mess = Icons.message_outlined;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        home = Icons.home_rounded;
        fav = Icons.favorite_border;
        mess = Icons.message_outlined;
        break;
      case 1:
        fav = Icons.favorite;
        home = Icons.home_outlined;
        mess = Icons.message_outlined;
        break;
      case 2:
        mess = Icons.message;
        fav = Icons.favorite_border;
        home = Icons.home_outlined;
        break;

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: const GeneratorPage(),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: const Placeholder(),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: const AuthGate(),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              haptic: true,
              activeColor: const Color.fromARGB(255, 40, 17, 110),
              iconSize: 26,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color.fromARGB(255, 221, 221, 221),
              color: const Color.fromARGB(186, 255, 255, 255),
              tabs: [
                GButton(
                  icon: home,
                  text: 'Home',
                ),
                GButton(
                  icon: fav,
                  text: 'Favourites',
                ),
                GButton(
                  icon: mess,
                  text: 'Message',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ContentConfig {
  const ContentConfig({
    required this.title,
    required this.description,
    required this.pathImage,
    required this.descriptionWidget,
    required this.backgroundColor,
    required this.titleWidget,
  });

  final String title;
  final String description;
  final String pathImage;
  final Text descriptionWidget;
  final Color backgroundColor;
  final Text titleWidget;
}

class IntroductionSliderScreen extends StatefulWidget {
  final List<ContentConfig> contentConfigs;
  final VoidCallback onDonePress;

  const IntroductionSliderScreen({
    super.key,
    required this.contentConfigs,
    required this.onDonePress,
  });

  @override
  // ignore: library_private_types_in_public_api
  _IntroductionSliderScreenState createState() =>
      _IntroductionSliderScreenState();
}

class _IntroductionSliderScreenState extends State<IntroductionSliderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.contentConfigs.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) => Container(
                color: widget.contentConfigs[index].backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(widget.contentConfigs[index].pathImage),
                    const SizedBox(height: 16),
                    widget.contentConfigs[index].titleWidget,
                    const SizedBox(height: 8),
                    widget.contentConfigs[index].descriptionWidget,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.contentConfigs.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? const Color.fromARGB(255, 28, 28, 80)
                          : const Color.fromARGB(154, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: TextButton(
                onPressed: _currentPage == widget.contentConfigs.length - 1
                    ? widget.onDonePress
                    : () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                child: Text(
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 202, 232, 250),
                  ),
                  _currentPage == widget.contentConfigs.length - 1
                      ? 'Done'
                      : 'Next',
                ),
              ),
            ),
          ],
        ),
      );
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BigCard(pair: pair),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleFavorite(appState.current);
                    },
                    icon: Icon(icon),
                    label: const Text('Like'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Text(
              '©Habel',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.w100,
    );

    return Card(
      elevation: 5,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: '${pair.first} ${pair.second}',
        ),
      ),
    );
  }
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    const ic = Icons.star_border_rounded;
    if (appState.favorites.isEmpty) {
      return Center(
        child: GestureDetector(
          child: const Text('No favourites yet'),
          onVerticalDragEnd: (details) {
            const snackBar =
                SnackBar(content: Text('No Favourites to Remove..'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ${appState.favorites.length} Favorites:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        for (var word in appState.favorites)
          Card(
            child: ListTile(
              leading: const Icon(ic),
              title: Text(
                word.asPascalCase,
                style: const TextStyle(color: Color.fromARGB(255, 53, 24, 15)),
              ),
              onTap: () {
                appState.toggleFavorite(word);
              },
            ),
          ),
      ],
    );
  }
}
