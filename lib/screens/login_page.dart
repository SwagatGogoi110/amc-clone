import 'package:amcdemo/screens/details_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: const DecorationImage(
          image: AssetImage("assets/bgYellow.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          //Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        color: const Color(0xFF243C63),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          child: Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.white, width: 5),
              ),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildGreyText("Username"),
        const SizedBox(height: 2),
        _buildInputField(usernameController),
        const SizedBox(height: 40),
        _buildGreyText("Password"),
        const SizedBox(height: 2),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 80),
        _buildLoginButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white), // Set text color to white
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? const Icon(Icons.remove_red_eye,
                color: Colors.white) // Set icon color to white
            : const Icon(Icons.done,
                color: Colors.white), // Set icon color to white
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // Set border color to white
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // Set border color to white
        ),
        border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // Set border color to white
        ),
        hintText: 'Enter text', // Set the placeholder text color to white
        hintStyle: const TextStyle(
            color: Colors.white), // Set the placeholder text color to white
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Username: ${usernameController.text}");
        debugPrint("Password: ${passwordController.text}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailsScreen()));
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: const Color(0xFFEFC50F),
      ),
      child: const Text(
        "LOGIN",
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}
