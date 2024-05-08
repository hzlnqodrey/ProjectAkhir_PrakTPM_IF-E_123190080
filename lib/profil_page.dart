import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about.dart';
import 'home.dart';
import 'login_page.dart';
import 'models/boxes.dart';
import 'models/pengguna.dart';

class ProfilPage extends StatefulWidget {
  final String username;
  final SharedPreferences logindata;

  const ProfilPage({Key? key,
    required this.username, required this.logindata,
  }) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with SingleTickerProviderStateMixin{
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Pengguna>(HiveBoxex.pengguna);
    String boxusername;
    String namaLengkap = "";
    String alamat = "";
    String nomorHandphone = "";
    String email = "";
    String usernames = "";
    int indexs = 0;
    boxusername ="";

    for (indexs; indexs<box.values.length; indexs++){
      Pengguna? res = box.getAt(indexs);
      boxusername = res!.username;
      if(widget.username == boxusername){
        namaLengkap = res.namaLengkap;
        alamat = res.alamatRumah;
        nomorHandphone = res.nomorHandphone;
        email = res.email;
        usernames = res.username;
      }
    }
    return SafeArea(child:
    Scaffold(
        appBar: AppBar(
          title: Text("Profil"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: AssetImage('assets/images/profil.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Nama Lengkap", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text(namaLengkap, style: TextStyle(fontSize: 16),),
              SizedBox(height: 20),
              Text("Nomor Handphone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text(nomorHandphone, style: TextStyle(fontSize: 16),),
              SizedBox(height: 20),
              Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text(email, style: TextStyle(fontSize: 16),),
              SizedBox(height: 20),
              Text("Alamat",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text(alamat, style: TextStyle(fontSize: 16),),
              SizedBox(height: 20),
              Text("Username", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text(usernames, style: TextStyle(fontSize: 16),),
              SizedBox(height: 20),
              _logout(context, widget.logindata),
            ],
          ),
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
          child: _buttonAbout(context,"${widget.username}",widget.logindata),
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

Widget _buttonAbout(BuildContext context, String username, SharedPreferences logindata){
  return Container(
    child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return aboutPage(username: username, logindata: logindata);
          }));
        },
        child: Icon(
          Icons.store_mall_directory,
        )),
  );
}

Widget _buttonProfil(BuildContext context, String username, SharedPreferences logindata){
  return Container(
    child: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {},
        child: Icon(
          Icons.person,
          color: Colors.green,
        )),
  );
}

Widget _logout(BuildContext context, SharedPreferences logindata){
  return ElevatedButton(
    onPressed: () {
      logindata.setBool('login', true);
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => LoginPage()));
    },
    child: Text('LogOut'),
  );
}