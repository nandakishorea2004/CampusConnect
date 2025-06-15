import 'package:campus/shared/widget/common_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RegisterPage> {
  TextEditingController nameTxt=TextEditingController();
  TextEditingController dept=TextEditingController();
  TextEditingController id=TextEditingController();
  TextEditingController mobilenumber=TextEditingController();
  TextEditingController emailId=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController cnfpassword=TextEditingController();

  
   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

 insertNewUser()async{

     final newPersonRef = _dbRef.child('User').push();
      var token = await FirebaseMessaging.instance.getToken();
     
      await newPersonRef.set({
        'name': nameTxt.text,
        'Dept': dept.text,
        'id': id.text,
        'mobileNumber': mobilenumber.text,
        'emailId':emailId.text,
        'password':password.text,
        'role':'user',
        'status':'active',
        'created_at': DateTime.now().toString(),
        'token':token
      });
      
                  print( newPersonRef.key!);

     ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account created successfully'),
                  ),
                );
                Navigator.pop(context);

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Fill in your details to create a new account',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameTxt,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 10),
            TextFormField(
              controller: dept,
              decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.home),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: id,
              decoration: const InputDecoration(
                labelText: 'ID Number',
                prefixIcon: Icon(Icons.person_2_rounded),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: mobilenumber,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone),
              ),
               keyboardType: TextInputType.number
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailId,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cnfpassword,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CommonButton(
                width: MediaQuery.of(context).size.width,
                height: 45,onPressed:(){
              if(nameTxt.text.isEmpty||dept.text.isEmpty||id.text.isEmpty||mobilenumber.text.isEmpty||emailId.text.isEmpty||password.text.isEmpty||cnfpassword.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All fields are required'),
                  ),
                );
              }else if(password.text!=cnfpassword.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password does not match'),
                  ),
                );
              }else {
                insertNewUser(
                  );
                  
              }
            } , text: "REGISTER")
          ],
        ),
      ),
    );
  }
}