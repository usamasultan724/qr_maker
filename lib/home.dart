import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_maker/qr_generator.dart';
import 'package:qr_maker/qr_scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
//

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color =  isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Center(
            child: FadeInDown(
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(CupertinoIcons.qrcode_viewfinder,
                  color: color
                  ,size: 200,),
              ),
            ),
          ),
          FadeInUp(
              duration: const Duration(milliseconds: 1600),
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const QrScanner(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(
                                  1.0, 0.0); // Start from the right side
                              const end =
                                  Offset.zero; // Ends at normal position
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        ),
                        child: const Text('Scan QR'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const QRGenerator(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(
                                  1.0, 0.0); // Start from the right side
                              const end =
                                  Offset.zero; // Ends at normal position
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        ),
                        child: const Text('Generate QR'),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
