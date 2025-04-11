import 'package:flutter/material.dart';
import 'package:task_app/auth/signup.dart';
import 'package:task_app/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5F33E1),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFD9D9D9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFD9D9D9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color(0xFF5F33E1)),
                      ),
                    ),
                    SizedBox(height: 10),


                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5F33E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },

                      child:
                          Text('Log in', style: TextStyle(color: Colors.white)),
                    ),



                    SizedBox(height: 20),
                    Text(
                      'or connect using',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/linkedin.png',
                                width: 24, height: 24),
                            label: Text('LinkedIn',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0077B5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/google.png',
                                width: 24, height: 24),
                            label: Text('Google',
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style: TextStyle(color: Colors.black)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()),
                            );
                          },
                          child: Text('Sign up',
                              style: TextStyle(color: Color(0xFF5F33E1))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
