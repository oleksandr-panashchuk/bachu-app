import 'dart:io';

import 'package:flutter/material.dart';

class Ban extends StatefulWidget {
  const Ban({super.key});

  @override
  State<Ban> createState() => _BanState();
}

class _BanState extends State<Ban> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 3, 3, 1),
      body: Column(
        children: [
          SizedBox(height: 77),
          Text('Тебе було заблоковано!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500)),
          SizedBox(
            height: 12,
          ),
          Text('Якщо це сталося помилково звернися\nдо тех. підтримки',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 15)),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () async {
                exit(0);
              },
              child: Container(
                padding: EdgeInsets.all(21),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(17)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel, color: Colors.black, size: 30),
                    SizedBox(
                      width: 7,
                    ),
                    Text('Закрити додаток',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
