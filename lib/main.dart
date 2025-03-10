import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:parkingapp/view/home_view.dart';
import 'package:parkingapp/view_model/bt_printers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(BTPrintersController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking Manager',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Colors.grey[200]!,
        lightSource: LightSource.topLeft,
        depth: 8,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Colors.grey[850]!,
        lightSource: LightSource.topLeft,
        depth: 4,
      ),
      home: const HomeWrapper(), // Ensure NeumorphicTheme is applied
    );
  }
}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Colors.grey[200]!,
        lightSource: LightSource.topLeft,
        depth: 8,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Colors.grey[850]!,
        lightSource: LightSource.topLeft,
        depth: 4,
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Orbitron',
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black, // Sets the cursor color to black
            selectionColor: Colors.grey, // Optional: Selected text background color
            selectionHandleColor: Colors.black, // Optional: Handle color
          ),
        ),
        home: HomeView(),
      ),
    );
  }
}
