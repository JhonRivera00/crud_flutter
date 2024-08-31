import 'package:flutter/material.dart';

//Importaciones Fairbase
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/pages/add_name.page.dart';
import 'package:flutter_application_1/pages/edit_name_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'firebase_options.dart';

//Pages
// import 'package:flutter_application_1/pages/edit_name_page.dart';
// import 'package:flutter_application_1/pages/add_name.page.dart';
// import 'package:flutter_application_1/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => const Home(),
        '/add': (context) => const AddNamePage(),
        '/edit': (context) => const EditNamePage()
      },
    );
  }
}
