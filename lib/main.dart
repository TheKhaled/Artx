import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/ProfileProvider.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/presentation/screens/Login/login_screen.dart';
import 'package:flutter_application_1/presentation/screens/Onboarding_Screen.dart';
import 'package:flutter_application_1/presentation/screens/event_provider.dart';
import 'package:flutter_application_1/provider/app_state_provider.dart';
import 'package:flutter_application_1/provider/cart_provider.dart'; // Import CartProvider here
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'your-publishable-key';

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  authToken = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                AppStateProvider(hasSeenOnboarding: hasSeenOnboarding)),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(
            create: (context) => CartProvider()), // Add CartProvider here
      ],
      child: ArtStore(),
    ),
  );
}

class ArtStore extends StatelessWidget {
  const ArtStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appStateProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: appStateProvider.showIntro ? OnBoardingPage() : Login(),
        );
      },
    );
  }
}
