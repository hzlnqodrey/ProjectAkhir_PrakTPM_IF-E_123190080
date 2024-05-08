import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cobata/models/boxes.dart';
import 'package:cobata/models/pengguna.dart';
import 'package:cobata/regist_page.dart';

class tampilkanpengguna extends StatefulWidget {
  final String title;

  const tampilkanpengguna({Key? key, required this.title}) : super(key: key);

  @override
  _tampilkanpenggunaState createState() => _tampilkanpenggunaState();
}

class _tampilkanpenggunaState extends State<tampilkanpengguna> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Pengguna>(HiveBoxex.pengguna).listenable(),
        builder: (context, Box<Pengguna> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('Todo listing is Empty'),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Pengguna? res = box.getAt(index);
              return Dismissible(
                background: Container(
                  color: Colors.red,
                ),
                key: UniqueKey(),
                onDismissed: (direction) {},
                child: Row(
                  children: [
                    Text(res!.username),
                    Text(res.password),
                    Text(res.nomorHandphone),
                  ],
                )
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPage(),
              ))
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
