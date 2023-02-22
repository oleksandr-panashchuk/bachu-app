import 'package:bachu/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Congrats extends StatefulWidget {
  const Congrats({super.key});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 71,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Text('Вітаємо з реєстрацією!',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text('Ти успішно зареєструвався\nв Bachu.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.52), fontSize: 18)),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21),
            child: SlideAction(
              borderRadius: 17,
              sliderButtonIconPadding: 17,
              height: 77,
              onSubmit: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              },
              elevation: 0,
              sliderButtonIcon:
                  Icon(Icons.keyboard_arrow_right_sharp, size: 30),
              innerColor: Colors.yellow,
              outerColor: Colors.black,
              text: 'На головний екран',
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
