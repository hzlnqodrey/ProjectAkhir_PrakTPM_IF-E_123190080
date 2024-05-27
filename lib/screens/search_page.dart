import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/BooksModel.dart';
import '../models/books_data_source.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cobata/screens/book_detail.dart';

class searchPage extends StatefulWidget {
  final String username;
  final String search;
  const searchPage({
    Key? key,
    required this.username,
    required this.search,
  }) : super(key: key);

  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Books You Search"),
        centerTitle: true,
      ),
      body: _buildSearchBooks("${widget.search}"),
    ));
  }

  Widget _buildSearchBooks(String search) {
    return Container(
      child: FutureBuilder(
        future: BookSearch.instance.searchBooks(search),
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
    return ListView.builder(
      itemCount: data.books?.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemBooks(
            "${data.books?[index].pic}",
            "${data.books?[index].title}",
            "${data.books?[index].price}",
            "${data.books?[index].link}",
            "${data.books?[index].isbn13}",
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
    BooksModel data,
    int index,
  ) {
    return InkWell(
        onTap: () {
          print("ISBN13: $isbn13");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return bookDetailPage(
                  data: data,
                  index: index,
                  isbn13: isbn13,
                );
              },
            ),
          );
        },
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Image.network(
                pic,
                fit: BoxFit.cover,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _launchURL(link);
                  },
                  child: Text('Buy')),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
