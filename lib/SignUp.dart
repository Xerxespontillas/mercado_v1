// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mercado_v1/utils.dart';

import 'main.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _selectedRole = TextEditingController();
  String _role = 'Customer';

  @override
  void dispose() {
    _username.dispose();
    _phoneNumber.dispose();
    _address.dispose();
    _company.dispose();
    _password.dispose();
    _selectedRole.dispose();
    super.dispose();
  }

  bool isSignUpSuccessful = false;

  Future<void> _submitForm() async {
    String username = _username.text;
    String password = _password.text;
    String address = _address.text;
    String company = _company.text;
    String role = _selectedRole.text;
    String phoneNumber = _phoneNumber.text;

    var url = Uri.parse('http://192.168.1.5:3000/api/Signup');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'role': role,
          'address': address,
          'company': company,
          'phoneNum': phoneNumber,
        }));
    final responseBody = response.body;
    print(response.statusCode);
    print(responseBody);

    if (response.statusCode == 307) {
      final location = response.headers['location'];
      print('Redirecting to $location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _username,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty && value.length != 11) {
                    return 'Please enter your number';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _address,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _company,
                decoration: InputDecoration(labelText: 'Company'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your company ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _role,
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                  _selectedRole.text = value!;
                },
                items: [
                  DropdownMenuItem(
                    value: 'Customer',
                    child: Text('Customer'),
                  ),
                  DropdownMenuItem(
                    value: 'Farmer',
                    child: Text('Farmer'),
                  ),
                  DropdownMenuItem(
                    value: 'Organization',
                    child: Text('Organization'),
                  ),
                ],
                decoration: InputDecoration(
                  hintText: 'Select an option',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () async {
                  // Call backend to create new user account
                  // Save user info in database
                  // Navigate to home screen or login screen
                  await _submitForm();
                  if (_formKey.currentState!.validate()) {
                    // Call backend to create new user account
                    _formKey.currentState!.save();
                    // Navigate to home screen or login screen
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                          title: 'login',
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
