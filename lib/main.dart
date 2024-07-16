// ignore_for_file: non_constant_identifier_names

import 'package:appv2/pages/login.dart';
import 'package:appv2/pages/mecanicDash.dart';
import 'package:appv2/pages/myCars.dart';
import 'package:appv2/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appv2/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const serverIp = 'https://marian-app-api.vercel.app';
const storage = FlutterSecureStorage();

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String value = "none";
  void Logout() {
    ref.read(roleProvider.notifier).update((state) => 5);
    ref.read(indexBottomNavbarProvider.notifier).update((state) => 0);
    storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19376D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(roleProvider.notifier).update((state) => 5);
          ref.read(indexBottomNavbarProvider.notifier).update((state) => 0);
          storage.deleteAll();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreen();
}

class _MainScreen extends ConsumerState<MainScreen> {
  String value = '';

  @override
  Widget build(BuildContext context) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    final role = ref.watch(roleProvider);
    var bodies = [];
    List<BottomNavigationBarItem> navBarItems() {
      if (role == 2) {
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.car_rental), label: 'Cars&Jobs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ];
      } else if (role == 1) {
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.car_rental), label: 'Cars&Jobs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ];
      } else if (role == 0) {
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'My Cars',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ];
      } else {
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
        ];
      }
    }

    if (role == 2) {
      bodies = [
        const MyHomePage(),
        LoginPage(),
        LoginPage(),
      ];
    } else if (role == 1) {
      bodies = [
        const MyHomePage(),
        const Mecanicdash(),
        const Settings(),
      ];
    } else if (role == 0) {
      bodies = [
        const MyHomePage(),
        const Mycars(),
        const Settings(),
      ];
    } else {
      bodies = [
        const MyHomePage(),
        LoginPage(),
      ];
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexBottomNavbar,
        onTap: (value) {
          ref.read(indexBottomNavbarProvider.notifier).update((state) => value);
        },
        backgroundColor: const Color(0xFF0B2447),
        fixedColor: const Color(0xFFA5D7E8),
        unselectedItemColor: const Color(0xFF576CBC),
        unselectedLabelStyle: const TextStyle(color: Color(0xFF576CBC)),
        items: navBarItems(),
      ),
      body: bodies[indexBottomNavbar],
    );
  }
}
