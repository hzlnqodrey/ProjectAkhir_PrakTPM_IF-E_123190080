import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/pengguna.dart';
import 'models/boxes.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validated() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate()) {
      _onFormSubmit();
      print("Form Validated!");
    } else {
      print("Form not validated!");
      return;
    }
  }

  late String namaLengkap;
  late String email;
  late String nomorHandphone;
  late String alamatRumah;
  late String username;
  late String password;


  void _onFormSubmit() {
    Box<Pengguna> penggunaBox = Hive.box<Pengguna>(HiveBoxex.pengguna);
    penggunaBox.add(Pengguna(namaLengkap: namaLengkap,
        email: email,
        alamatRumah: alamatRumah,
        nomorHandphone: nomorHandphone,
        username: username,
        password: password));
    Navigator.of(context).pop();
    print(penggunaBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: Column(
            children: [
              Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24,
              ),
              Text("Lengkapi Data Anda Untuk Mendaftar!"),
              SizedBox(height: 16),
              SafeArea(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autofocus: false,
                          decoration:
                          InputDecoration(labelText: 'Nama Lengkap'),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Required";
                            }
                            return null;
                          },
                          onChanged: (value){namaLengkap = value;},
                        ),

                        TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Required";
                            }
                            return null;
                          },
                          onChanged: (value){email = value;},
                        ),

                        TextFormField(
                          autofocus: false,
                          decoration:
                          InputDecoration(labelText: 'Alamat Rumah'),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Required";
                            }
                            return null;
                          },
                          onChanged: (value){alamatRumah = value;},
                        ),

                        TextFormField(
                          autofocus: false,
                          decoration:
                          InputDecoration(labelText: 'Nomor Handphone'),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Required";
                            }
                            return null;
                          },
                          onChanged: (value){nomorHandphone = value;},
                        ),

                        TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(labelText: 'username'),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Required";
                            }
                            return null;
                          },
                          onChanged: (value){username = value;},
                        ),

                        TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(labelText: 'password'),
                          obscureText: true,
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Required";
                            }
                            return null;
                          },
                          onChanged: (value){password = value;},
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                            onPressed: () {
                              print(username);
                              var box = Hive.box<Pengguna>(HiveBoxex.pengguna);
                              var boxusername;
                              int index = 0;
                              if(box.values.isEmpty){
                                validated();
                              }
                              else{
                              for (index; index < box.values.length; index++) {
                                Pengguna? res = box.getAt(index);
                                boxusername = res!.username;

                                if (username == boxusername) {
                                  SnackBar snackBar = SnackBar(content: Text("username sudah digunakan"));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                                else{
                                  index = box.values.length;
                                  validated();
                                }
                              }
                            }
                            },
                            child: Text('Buat Akun')),
                        SizedBox(height: 24),
                        // _buildButtonSubmit(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
