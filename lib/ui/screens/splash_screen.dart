import 'package:flutter/material.dart';
import 'package:pokemon_app/helpers/files_exports.dart';
import 'package:pokemon_app/helpers/packages_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width,
                height: height / 2,
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Text(
                        'POKO GO',
                        style: TextStyle(
                          fontSize: 80,
                          letterSpacing: 2,
                          fontFamily: 'Pokemon',
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.blue.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'POKO GO',
                        style: TextStyle(
                          fontSize: 80,
                          letterSpacing: 2,
                          fontFamily: 'Pokemon',
                          color: Colors.yellow.shade300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const Gutter(),
              const SlideActionBtn()
            ],
          )),
    );
  }
}
