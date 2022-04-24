//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'dart:async';


class phone_number_screen extends StatefulWidget {
  const phone_number_screen({Key? key}) : super(key: key);

  @override
  State<phone_number_screen> createState() => _phone_number_screenState();
}

class _phone_number_screenState extends State<phone_number_screen> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDRecieved ="";
  bool otpcodevisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("phone auth"),
      ),
      body: Container(
      margin: const  EdgeInsets.all(10),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                    labelText: "Phone"
    ),

    ),
          const SizedBox(height: 10,),

          
          Visibility(
            visible: otpcodevisible,
            child: TextField(
                      controller: otpController,
                      decoration: const InputDecoration(
                      labelText: "Code"
    ),
          keyboardType: TextInputType.phone,
    ),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: (){
            if(otpcodevisible){
              verifyCode();
            }
            else {
              verifyNumber();
            }
          }, child:Text(otpcodevisible ? "Login":"Verify"))
        ],
      )
      )
    );
  }
  void verifyNumber(){
    auth.verifyPhoneNumber(phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential).then((value) {
        print("You are logged in successfully");
      });
        },
        verificationFailed: (FirebaseAuthException exception){
      print(exception.message);
        },
        codeSent: (String verificationId, int? resendToken){
          verificationIDRecieved=verificationId;
          otpcodevisible= true;
          setState(() {

          });
        },
        codeAutoRetrievalTimeout: (String verificationID){

        });

  }

  void verifyCode() async{
       PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationIDRecieved, smsCode: otpController.text);
          await auth.signInWithCredential(credential).then((value){
         print("You are logged in succefully");

    });

    }
    }

