import 'package:cobata/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about.dart';
import '../services/providers/search.dart';
import 'profil_page.dart';
import '../models/BooksModel.dart';
import '../models/books_data_source.dart';
import 'package:cobata/screens/book_detail.dart';

class homePage extends StatefulWidget {
  final String username;
  final SharedPreferences logindata;

  const homePage({Key? key, required this.username, required this.logindata})
      : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage>
    with SingleTickerProviderStateMixin {
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
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationIcon,
        ),
      ),
    );
  }

  void animate() {
    if (!isOpened)
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

    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Bookstore"),
        centerTitle: true,
      ),
      body: _buildNewBooks(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
                0.0, _translateButton.value * 4.0, 0.0),
            child: _buttonSearch(context, "${widget.username}"),
          ),
          Transform(
            transform: Matrix4.translationValues(
                0.0, _translateButton.value * 3.0, 0.0),
            child: _buttonHome(),
          ),
          Transform(
            transform: Matrix4.translationValues(
                0.0, _translateButton.value * 2.0, 0.0),
            child:
                _buttonAbout(context, "${widget.username}", widget.logindata),
          ),
          Transform(
            transform:
                Matrix4.translationValues(0.0, _translateButton.value, 0.0),
            child:
                _buttonProfil(context, "${widget.username}", widget.logindata),
          ),
          buttonClose()
        ],
      ),
    ));
  }

  Widget _buildNewBooks() {
    return Container(
      child: FutureBuilder(
        future: BookDataSource.instance.loadBooks(),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            BooksModel booksModel = BooksModel.fromJson(snapshot.data);
            return _buildSuccessSection(booksModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(BooksModel data) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 5,
        mainAxisExtent: 350,
      ),
      itemCount: data.books?.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemBooks(
            "${data.books?[index].pic}",
            "${data.books?[index].title}",
            "${data.books?[index].price}",
            "${data.books?[index].link}",
            "${data.books?[index].isbn13}",
            "${widget.username}",
            widget.logindata,
            data,
            index);
      },
    );
  }

  Widget _buildItemBooks(
    String pic,
    String title,
    String price,
    String link,
    String isbn13,
    String username,
    SharedPreferences logindata,
    BooksModel data,
    int index,
  ) {
    late bool isFavorite = false;
    return InkWell(
      onTap: () {
        print("ISBN13: $isbn13");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return bookDetailPage(
                username: username,
                logindata: logindata,
                data: data,
                index: index,
                isbn13: isbn13,
              );
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                child: Image.network(pic, fit: BoxFit.cover),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    price,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _launchURL(link);
                  },
                  child: Text("Buy"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[50],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSearch(BuildContext context, String username) {
    return Container(
      child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Search();
            }));
          },
          child: Icon(
            Icons.search,
          )),
    );
  }

  Widget _buttonHome() {
    return Container(
      child: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {},
          child: Icon(
            Icons.my_library_books_outlined,
            color: Colors.green,
          )),
    );
  }

  Widget _buttonAbout(
      BuildContext context, String username, SharedPreferences logindata) {
    return Container(
      child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return aboutPage(
                username: username,
                logindata: logindata,
              );
            }));
          },
          child: Icon(
            Icons.store_mall_directory,
          )),
    );
  }

  Widget _buttonProfil(
      BuildContext context, String username, SharedPreferences logindata) {
    return Container(
      child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return ProfilPage(username: username, logindata: logindata);
            }));
          },
          child: Icon(
            Icons.person,
          )),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
