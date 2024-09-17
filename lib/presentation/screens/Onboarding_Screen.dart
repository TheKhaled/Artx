import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/Login/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Login()),
      );
    }
  }

  Future<void> _markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  void _onIntroEnd(context) async {
    await _markOnboardingAsSeen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Login()),
    );
  }

  Widget _buildImage(String assetName) {
    return Image.asset(
      'assets/$assetName',
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final bodyStyle = TextStyle(
      fontSize: screenWidth * 0.05,
      color: Colors.white,
    );

    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: screenWidth * 0.07,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.black,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "Full Screen Page",
          body:
              "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: FullscreenImage(
            imagePath: 'assets/on1.png',
          ),
          decoration: pageDecoration.copyWith(
              contentMargin:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              fullScreen: true,
              bodyFlex: 2,
              imageFlex: 3,
              safeArea: 100,
              pageColor: Colors.black),
        ),
        PageViewModel(
          title: "Full Screen Page",
          body:
              "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: FullscreenImage(
            imagePath: 'assets/Art.png',
          ),
          decoration: pageDecoration.copyWith(
              contentMargin:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              fullScreen: true,
              bodyFlex: 2,
              imageFlex: 3,
              safeArea: 100,
              pageColor: Colors.black),
        ),
        PageViewModel(
          title: "Full Screen Page",
          body:
              "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: FullscreenImage(
            imagePath: 'assets/on3.png',
          ),
          decoration: pageDecoration.copyWith(
              contentMargin:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              fullScreen: true,
              bodyFlex: 2,
              imageFlex: 3,
              safeArea: 100,
              pageColor: Colors.black),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: Icon(Icons.arrow_back, size: screenWidth * 0.07),
      skip: Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 201, 171, 129),
          fontSize: screenWidth * 0.05,
        ),
      ),
      next: Icon(
        Icons.arrow_forward,
        color: Color.fromARGB(255, 201, 171, 129),
        size: screenWidth * 0.07,
      ),
      done: Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 201, 171, 129),
          fontSize: screenWidth * 0.05,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: EdgeInsets.all(screenWidth * 0.04),
      controlsPadding: kIsWeb
          ? EdgeInsets.all(screenWidth * 0.03)
          : EdgeInsets.fromLTRB(screenWidth * 0.02, screenWidth * 0.01,
              screenWidth * 0.02, screenWidth * 0.01),
      dotsDecorator: DotsDecorator(
        size: Size(screenWidth * 0.025, screenWidth * 0.025),
        color: Color.fromARGB(255, 255, 255, 255),
        activeSize: Size(screenWidth * 0.05, screenWidth * 0.025),
        activeColor: Color.fromARGB(255, 201, 171, 129),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.0125)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.01)),
        ),
      ),
    );
  }
}

class FullscreenImage extends StatelessWidget {
  final String imagePath;

  const FullscreenImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Color.fromARGB(105, 0, 0, 0), BlendMode.colorBurn),
        ),
      ),
    );
  }
}
