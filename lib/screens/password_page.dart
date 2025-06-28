import 'package:flutter/material.dart';
import 'package:smart_home/screens/smart_home_page.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  PasswordPageState createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _correctName = "Oleh"; // Правильное имя
  final String _correctPassword = "2104\$#@";

  bool _obscureText = true;
  bool _isPasswordIncorrect = false;
  bool _isNameIncorrect = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _checkCredentials() {
    setState(() {
      _isNameIncorrect = _nameController.text != _correctName;
      _isPasswordIncorrect = _passwordController.text != _correctPassword;
    });

    if (!_isNameIncorrect && !_isPasswordIncorrect) {
      _nameController.clear();
      _passwordController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SmartHomePage(passwordCorrect: 1),
        ),
      );
    } else {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isNameIncorrect = false;
          _isPasswordIncorrect = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Введите имя и пароль')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 6, 175, 0),
              Color.fromARGB(255, 118, 255, 114),
            ],
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: [
                  TextField(
                    controller: _nameController,
                    autofillHints: [AutofillHints.username],
                    decoration: InputDecoration(
                      hintText: 'Имя',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  if (_isNameIncorrect)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.red.withAlpha((0.80 * 255).toInt()),
                          alignment: Alignment.center,
                          child: Text(
                            'Неправильное имя!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Stack(
                children: [
                  TextField(
                    controller: _passwordController,
                    autofillHints: [AutofillHints.password],
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    obscureText: _obscureText,
                    cursorColor: Colors.black,
                  ),
                  if (_isPasswordIncorrect)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.red.withAlpha((0.80 * 255).toInt()),
                          alignment: Alignment.center,
                          child: Text(
                            'Неправильный пароль!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkCredentials,
                child: Text('Войти', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
