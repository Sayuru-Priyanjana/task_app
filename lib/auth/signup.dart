import 'package:flutter/material.dart';
import 'package:task_app/auth/login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5F33E1),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildTextField('Name', _nameController),
                    SizedBox(height: 15),
                    _buildTextField('Email', _emailController),
                    SizedBox(height: 15),
                    _buildTextField('Phone number', _phonenumberController),
                    SizedBox(height: 15),
                    _buildTextField('Password', _passwordController,
                        isPassword: true),
                    SizedBox(height: 15),
                    _buildTextField(
                        'Confirm Password', _confirmpasswordController,
                        isPassword: true),
                    SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5F33E1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        'or connect using',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton('LinkedIn', 'assets/linkedin.png',
                            Color(0xFF0077B5), Colors.white),
                        SizedBox(width: 15),
                        _buildSocialButton('Google', 'assets/google.png',
                            Colors.white, Colors.black),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Color(0xFF5F33E1), fontSize: 16),
                          ),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFD9D9D9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          obscureText: isPassword,
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      String label, String assetPath, Color backgroundColor, Color textColor) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(
        assetPath,
        width: 30,
        height: 30,
      ),
      label: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
