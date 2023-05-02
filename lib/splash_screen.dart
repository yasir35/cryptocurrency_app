import 'package:cryptocurrency_app/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/2.gif'),
            Column(
              children: const [
                Text(
                  'CryptoHub',
                  style: TextStyle(
                      fontFamily: 'Sigmar-Regular',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Text(
                  'Unlock the potential of digital assets\n with our trusted crypto app.',
                  style: TextStyle(
                      fontFamily: 'SchylerBrunoAceSC-Regular',
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.14),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffFBC700),
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.013),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Get Started',
                          style: TextStyle(
                              fontFamily: 'SchylerBrunoAceSC-Regular',
                              fontSize: 20),
                        ),
                        RotationTransition(
                            turns: AlwaysStoppedAnimation(310 / 360),
                            child: Icon(Icons.arrow_forward_rounded))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
