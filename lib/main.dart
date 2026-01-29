import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:layouts_flutter/repos/local_notifications_repo.dart';
import 'package:layouts_flutter/repos/notifications_repo.dart';
import 'package:layouts_flutter/ui/admin%20panel/create_coffee_ui.dart';
import 'package:layouts_flutter/ui/admin%20panel/notifications_screen.dart';
import 'package:layouts_flutter/ui/admin%20panel/view_order_details.dart';
import 'package:layouts_flutter/ui/bottom_nav_bar.dart';
import 'package:layouts_flutter/ui/cart_screen.dart';
import 'package:layouts_flutter/ui/change_address_user.dart';
import 'package:layouts_flutter/ui/check_out_page.dart';
import 'package:layouts_flutter/ui/favorites_screen.dart';
import 'package:layouts_flutter/ui/my_home%20page.dart';
import 'firebase_options.dart';
import 'models/constant.dart' as AppConstant;
import 'ui/login_screen.dart';
import 'ui/signup.dart';
import 'ui/reset_password_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=AppConstant.stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final localNotificationsService = LocalNotificationsRepo.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseNotificationsRepo.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.red, fontSize: 16.0), // Example for body text
          headlineMedium: TextStyle(color: Color(0xFF313131), fontFamily: 'Sora',fontWeight: FontWeight.w700), // Example for headlines

          displayLarge: TextStyle(fontSize: 72.0,fontFamily: 'Sora', fontWeight: FontWeight.bold, color: Color(0xFF313131)),
          titleLarge: TextStyle(fontSize: 36.0,fontFamily: 'Sora', fontStyle: FontStyle.italic,color: Color(0xFF313131)),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Sora', color: Color(0xFF313131)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Color of title and icons
          titleTextStyle: TextStyle(
            color: Color(0xFF313131),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
              fontFamily: 'Sora'
          ),
          elevation: 4.0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          // Define the default style for all ElevatedButtons
          style: ButtonStyle(
            // Set the background color for all states
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color(0xFFC67C4E),
            ),
            // Set the foreground color (text/icon color)
            foregroundColor: WidgetStateProperty.all<Color>(
              Colors.white,
            ),
            // Define the shape of the button
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
            ),
            // Define the padding
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            // Define the text style
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Define the elevation (shadow)
            elevation: WidgetStateProperty.all<double>(8.0),
            // Define the overlay color on press/hover
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  // Color when the button is pressed
                  return Colors.brown;
                }
                if (states.contains(WidgetState.hovered)) {
                  // Color when the button is hovered
                  return Colors.brown;
                }
                return null; // Defer to the default value
              },
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          // Define the default style for all TextButtons
          style: ButtonStyle(
            // Set the foreground color (text/icon color)
            foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  // Color for the disabled state
                  return Color(0xFFEDD6C8);
                }
                // Default color for enabled states
                return Color(0xFF313131);
              },
            ),

            // Define the overlay color (the ripple effect)
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  // Color when the button is pressed
                  return Color(0xFFEDD6C8);
                }
                if (states.contains(WidgetState.hovered)) {
                  // Color when the button is hovered
                  return Color(0xFF313131);
                }
                return null; // Defer to the default value
              },
            ),

            // Define the text style
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),

            // Define the padding
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),

            // Define the shape of the button
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF313131), // A warm, coffee-like color
          size: 28.0,
          opacity: 0.9,
        ),
      ),



      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      initialBinding: LoginBinding(),
      initialRoute: '/login',
      getPages: [
        // Main App Routes (Outside BottomNavBar)
        GetPage(name: "/login", page: () => LoginScreen(), binding: LoginBinding()),
        GetPage(name: "/signup", page: () => SignUp(), binding: SignupDependency()),
        GetPage(name: "/forget_password", page: () => ResetPasswordPage(), binding: ResetPasswordBinding()),
        GetPage(name: "/bottom_nav_bar", page: () => BottomNavBar(), binding: BottomNavBarBinding()),
        GetPage(name: "/createCoffeeUi", page: () => CreateCoffeeUi(), binding: CreateCoffeeAdminUIBinding()),
        GetPage(name: "/check_out_page", page: () => CheckOutPage(), binding: CheckOutPageBinding()),
        GetPage(name: "/change_address_user", page: () => ChangeAddressUser()),
        GetPage(name: "/view_order_details", page: () => ViewOrderDetailsScreen(),binding: ViewOrderDetailsBinding()),

        // Individual screens (can be accessed directly if needed)
        GetPage(name: "/home_direct", page: () => MyHomePage(), binding: MyHomePageBinding()),
        GetPage(name: "/cart_direct", page: () => CartScreen(), binding: CartBinding()),
        GetPage(name: "/favorites_direct", page: () => FavoritesScreen()),
        GetPage(name: "/notifications_direct", page: () => NotificationsScreen()),
      ],
    );
  }
}
