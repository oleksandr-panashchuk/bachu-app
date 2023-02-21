import 'package:country_phone_code_picker/core/country_phone_code_picker_widget.dart';
import 'package:country_phone_code_picker/country_phone_code_picker.dart';
import 'package:country_phone_code_picker/models/country.dart';
import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  CountryController phone = CountryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 3, 3, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 65,
          ),
          Padding(
            padding: EdgeInsets.all(25),
            child: Text('Введи свій номер',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(17)),
            child: Row(
              children: [
                SizedBox(
                  width: 112,
                  child: CountryPhoneCodePicker.withDefaultSelectedCountry(
                      searchBarLeadingIcon:
                          Icon(Icons.arrow_back_ios, color: Colors.white),
                      searchSheetBackground: Colors.black,
                      searchBarCursorColor: Colors.blue,
                      countryNameTextStyle: TextStyle(color: Colors.white),
                      searchBarPrefixStyle: TextStyle(color: Colors.white),
                      searchBarHintStyle: TextStyle(color: Colors.white),
                      searchBarHelperStyle: TextStyle(color: Colors.white),
                      searchBarPrefixIcon:
                          Icon(Icons.search, color: Colors.white),
                      searchBarLabelStyle: TextStyle(color: Colors.white),
                      actionIcon: Icon(Icons.arrow_drop_down,
                          color: Colors.white.withOpacity(0.17)),
                      countryPhoneCodeTextStyle:
                          TextStyle(color: Colors.white, fontSize: 17),
                      showPhoneCode: true,
                      defaultCountryCode: Country(
                          name: 'Ukraine',
                          countryCode: 'UA',
                          phoneCode: '+380'),
                      borderRadius: 30,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      searchBarHintText: 'Пошук країни'),
                ),
                Expanded(
                    child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(9)],
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ))
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(21),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(17)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sms, color: Colors.black),
                    SizedBox(
                      width: 7,
                    ),
                    Text('Отримати код',
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
          )
        ],
      ),
    );
  }
}
