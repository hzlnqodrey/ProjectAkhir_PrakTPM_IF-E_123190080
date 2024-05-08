import 'package:flutter/material.dart';
import 'package:cobata/profil_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class aboutPage extends StatefulWidget {
  final String username;
  final SharedPreferences logindata;
  const aboutPage({Key? key, required this.username, required this.logindata}) : super(key: key);

  @override
  _aboutPageState createState() => _aboutPageState();
}

class _aboutPageState extends State<aboutPage> with SingleTickerProviderStateMixin{
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<double> _animationIcon;
  late Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;


  Widget buttonClose() {
    return Container(
      child: FloatingActionButton(
        onPressed: animate,
        tooltip: "Toggle",
        child: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _animationIcon,),
      ),
    );
  }

  void animate() {
    if(!isOpened)
      _animationController.forward();
    else
      _animationController.reverse();
    isOpened = !isOpened;
  }

  @override
  void initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });

    _animationIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)
        )
    );
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
//          leading: Image.asset(name),
            title: Text("About"),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                child: Column(children: [
                  _logo(),
                  _nama(),
                  _alamat(),
                  _noHp(),
                  _email(),
                ]),
                height: 5000,
              ),
            ],
          ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value*3.0, 0.0),
              child: _buttonHome(context,"${widget.username}",widget.logindata),
            ),
            Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value*2.0, 0.0),
              child: _buttonAbout(),
            ),
            Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value, 0.0),
              child: _buttonProfil(context,"${widget.username}",widget.logindata),
            ),
            buttonClose()
          ],
        ),
    ),
    );
  }

  Widget _logo() {
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 100, 50, 10),
          child: Image.asset("assets/images/logo.png", width: 150,),
        ),
      ),
    );
  }

  Widget _nama() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: Text(
          "Book Store",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _alamat() {
    return Container(
      child: Padding(
          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: Column(
            children: [
              Text("Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                  "Jembatan Merah Plasa 1 lt.2 C-47, Jembatan Merah Plasa 1 lt.2 C-55, Surabaya, Jawa Timur, Indonesia",
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.center,

              ),
            ],
          )),
    );
  }

  Widget _noHp() {
    return Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: Column(
              children: [
                Text("Phone",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("031-92004154", style: TextStyle(fontSize: 16)),
              ],
            )));
  }

  Widget _email() {
    return Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: Column(
              children: [
                Text("Email",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("BookStore@example.com", style: TextStyle(fontSize: 16)),
              ],
            )));
  }
}
Widget _buttonHome(BuildContext context, String username, SharedPreferences logindata) {
  return Container(
    child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return homePage(username: username, logindata: logindata);
          }));
        },
        child: Icon(
          Icons.my_library_books_outlined,
        )),
  );
}
Widget _buttonAbout(){
  return Container(
    child: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {},
        child: Icon(
          Icons.store_mall_directory,
          color: Colors.green,
        )),
  );
}

Widget _buttonProfil(BuildContext context, String username, SharedPreferences logindata){
  return Container(
    child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return ProfilPage(username: username, logindata: logindata,);
          }));
        },
        child: Icon(
          Icons.person,
        )),
  );
}

