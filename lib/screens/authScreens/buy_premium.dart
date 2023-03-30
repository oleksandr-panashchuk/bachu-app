import 'package:flutter/material.dart';

class BuyPremium extends StatefulWidget {
  const BuyPremium({super.key});

  @override
  State<BuyPremium> createState() => _BuyPremiumState();
}

class _BuyPremiumState extends State<BuyPremium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 201, 136, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 62,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(17)),
                    child: Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 17),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 21,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21),
            child: Text('Навіщо мені преміум?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
            child: Text('- немає реклами.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
            child: Text('- рамка для аватарки.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
            child: Text('- якась плюшка 3.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
            child: Text('- якась плюшка 4.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
            child: Text('- якась плюшка 5.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
            child: Text('- якась плюшка 6.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
            child: Text('- якась плюшка 7.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
