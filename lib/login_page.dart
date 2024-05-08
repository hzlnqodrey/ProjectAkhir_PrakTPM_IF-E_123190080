import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/pengguna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'models/boxes.dart';
import 'regist_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
  bool isLoginSuccess = true;
  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }
  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) {
            return homePage(username: username_controller.text, logindata: logindata,);
      }));
    }
  }
  @override
  void dispose() {
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
//          leading: Image.asset(name),
          title: Text("Login to Bookstore"),
        ),
        body: Container(
          child: Column(
            children: [
              _logo(),
              _username(),
              _password(),
              _loginbutton(context),
              _register(context),
            ],
          ),
        ),

      ),
    );
  }

  Widget _logo() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 200, 16, 100),
        child: Image.asset(
          "assets/images/logo.png",
          width: 100,
        ),
      ),
    );
  }

  Widget _username() {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: username_controller,
        enabled: true,
        // onChanged: (value) {
        //   username = value;
        // },
        decoration: InputDecoration(
            icon: Icon(Icons.person),
            hintText: "username",
            labelText: "username",
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: (isLoginSuccess) ? Colors.lightGreen : Colors.red),
            )
        ),
      ),
    );
  }

  Widget _password() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: password_controller,
        enabled: true,
        obscureText: true,
        // onChanged: (value) {
        //   password = value;
        // },
        decoration: InputDecoration(
            icon: Icon(Icons.lock_rounded),
            hintText: "password",
            labelText: "password",
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: (isLoginSuccess) ? Colors.lightGreen: Colors.red),
            )
        ),
      ),
    );
  }

  Widget _loginbutton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: (isLoginSuccess) ? Colors.lightGreen : Colors.red,
          onPrimary: Colors.white,
        ),
          child: const Text('Login'),
        onPressed: () {
          String username = username_controller.text;
          String password = password_controller.text;
          String text = "";

          if (username != '' && password != '') {
            var box = Hive.box<Pengguna>(HiveBoxex.pengguna);
            var boxusername;
            var boxpassword;
            int index = 0;
            for (index; index<box.values.length;index++){
              Pengguna? res = box.getAt(index);
              boxusername = res!.username;
              boxpassword = res.password;

              if(username == boxusername && password == boxpassword){
                logindata.setBool('login', false);
                logindata.setString('username', username);
                setState(() {
                  text = "Login Berhasil";
                  isLoginSuccess = true;
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return homePage(username: username, logindata: logindata);
                }));
              }
              else{
                setState(() {
                  text = "Login Gagal";
                  isLoginSuccess = false;
                });
              }
            }
          }
          else {
            setState(() {
              text = "Isi username dan password";
              isLoginSuccess = false;
            });
          }
          SnackBar snackBar = SnackBar(
            content: Text(text),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }

  Widget _register(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return RegisterPage();
          }));
        },
        child: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
