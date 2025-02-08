import 'package:box_delivery_app/controllers/home_controller.dart';
import 'package:box_delivery_app/controllers/location_mang_controller.dart';
import 'package:box_delivery_app/controllers/login_controller.dart';
import 'package:box_delivery_app/controllers/onboarding_provider.dart';
import 'package:box_delivery_app/controllers/otp_controller.dart';
import 'package:box_delivery_app/controllers/qr_scan_controller.dart';
import 'package:box_delivery_app/controllers/signupcomp_controller.dart';
import 'package:box_delivery_app/firebase_options.dart';
import 'package:box_delivery_app/views/add_boxes_view.dart';
import 'package:box_delivery_app/views/add_item_view.dart';
import 'package:box_delivery_app/views/add_location_view.dart';
import 'package:box_delivery_app/views/auth/forget_pass/for_success.dart';
import 'package:box_delivery_app/views/box_management_view.dart';
import 'package:box_delivery_app/views/boxes_screen.dart';
import 'package:box_delivery_app/views/edit_boxes_view.dart';
import 'package:box_delivery_app/views/edit_items_view.dart';
import 'package:box_delivery_app/views/edit_location_view.dart';
import 'package:box_delivery_app/views/home_screen.dart';
import 'package:box_delivery_app/views/invalid_qr_view.dart';
import 'package:box_delivery_app/views/item_management_view.dart';
import 'package:box_delivery_app/views/items_screen.dart';
import 'package:box_delivery_app/views/location_management_view.dart';
import 'package:box_delivery_app/views/profile_image.dart';
import 'package:box_delivery_app/views/qr_scan_view.dart';
import 'package:box_delivery_app/views/simple_profile.dart';

import 'package:box_delivery_app/views/thankYou_view.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:box_delivery_app/views/splash_screen.dart';
import 'package:provider/provider.dart';

import 'controllers/for_otp.dart';
import 'controllers/item_controller.dart';
import 'controllers/profile_image_controller.dart';
import 'controllers/signup_controller.dart';
import 'controllers/user_controller_for.dart';
import 'controllers/verification_controller.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 //  await FirebaseAppCheck.instance.activate(
 //    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
 //    androidProvider: AndroidProvider.debug,
 // appleProvider: AppleProvider.appAttest,
 //  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => OTPController()),
        ChangeNotifierProvider(create: (_) => UserController1()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => VerificationController()),
        ChangeNotifierProvider(create: (_) => OtpController()),
        ChangeNotifierProvider(create: (_) => SignUpController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => QRScanController()),
        ChangeNotifierProvider(create: (_) => ItemsController()),
        ChangeNotifierProvider(create: (_) => ProfileController())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        title: 'Finditorium',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color(0xFFE25E00),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE25E00),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE25E00),
            primary: const Color(0xFFE25E00),
            secondary: const Color(0xFF76889A),
            background: Colors.white,
          ),
        ),
        initialRoute: FirebaseAuth.instance.currentUser!=null ? "/home":'/splash',
        routes: {
          '/add_location': (context) => AddLocationView(),
          '/add_box': (context) => AddBoxView(),
          '/items': (context) => AddItemsView(),
          '/home': (context) => HomeScreen(),
          '/splash': (context) => SplashScreen(),
          '/thank_you': (context) => ThankYouScreen(),
          '/manage_boxes': (context) => BoxManagementScreen(),
          '/manage_location': (context) => LocationManagementScreen(),
          '/manage_items': (context) => ItemManagementScreen(),
          '/edit_boxes': (context) => EditBoxesScreen(),
          '/edit_location': (context) => EditLocationScreen(),
          '/edit_items': (context) => EditItemScreen(),
        },
        // home: BoxesView(),
      ),
    );
  }
}

// Boxes view
