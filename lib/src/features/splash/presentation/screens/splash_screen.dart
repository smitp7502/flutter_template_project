import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = SplashController();

  @override
  void initState() {
    super.initState();

    _controller.navigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: SplashLogo()));
  }
}
