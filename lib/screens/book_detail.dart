import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about.dart';
import '../services/providers/search.dart';
import 'profil_page.dart';
import '../models/BooksModel.dart';
import '../models/books_data_source.dart';
import 'package:cobata/models/BookDetailModel.dart';

class bookDetailPage extends StatefulWidget {
  final String username;
  final SharedPreferences logindata;
  final BooksModel data;
  final int index;
  final String isbn13;

  const bookDetailPage({
    Key? key,
    required this.username,
    required this.logindata,
    required this.data,
    required this.index,
    required this.isbn13,
  }) : super(key: key);

  @override
  _bookDetailPageState createState() => _bookDetailPageState();
}

class _bookDetailPageState extends State<bookDetailPage> {
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        backgroundColor: Color.fromARGB(255, 37, 85, 50),
        appBar: AppBar(
          title: Text(
            'Detail Buku',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Color.fromARGB(255, 37, 85, 50),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: ElevatedButton(
            onPressed: () async {
              final url =
                  widget.data.books?[0].link ?? "https://www.google.com";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                // Handle the error when the URL can't be launched
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $url')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 37, 85, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Info Buku",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
            child: Container(
                child: FutureBuilder(
                    future:
                        BookDetailSource.instance.loadBookDetail(widget.isbn13),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<dynamic> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return _buildErrorSection();
                      }
                      if (snapshot.hasData) {
                        BookDetail data = BookDetail.fromJson(snapshot.data);
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/overlay.png"),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/overlay.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 230,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              (data.image == "")
                                                  ? "https://islandpress.org/files/default_book_cover_2015.jpg"
                                                  : data.image ?? "",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        data.title ?? "",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            fontSize: 23,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "by " +
                                            (data.authors == null
                                                ? "Unknown"
                                                : data.authors ?? ""),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Rating",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                (data.rating == null)
                                                    ? "⭐ " +
                                                        "No rating available"
                                                    : "⭐ " +
                                                        (data.rating
                                                                .toString() ??
                                                            ""),
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Pages",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                (data.pages == null
                                                    ? "Unknown"
                                                    : data.pages.toString() ??
                                                        ""),
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Publisher",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                (data.publisher == null
                                                        ? "Unknown"
                                                        : data.publisher ?? "")
                                                    .toString()
                                                    .toUpperCase(),
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Publish date",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                (data.year == null
                                                        ? "Unknown"
                                                        : data.year ?? "")
                                                    .toString()
                                                    .toUpperCase(),
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () async {
                                      //     await launchUrl(
                                      //         Uri.parse(data.url ?? ""));
                                      //   },
                                      //   style: ElevatedButton.styleFrom(
                                      //     backgroundColor: Colors.white,
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(20),
                                      //     ),
                                      //   ),
                                      //   // splashColor: Colors.grey,
                                      //   // color: Colors.black,
                                      //   child: Text(
                                      //     "INFO BUKU",
                                      //     style: TextStyle(
                                      //       color:
                                      //           Color.fromARGB(255, 37, 85, 50),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28.0, vertical: 25),
                                        child: ListView(
                                          children: [
                                            Text(
                                              "What's it about?",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data.desc ?? "",
                                              style: GoogleFonts.lato(
                                                color: Colors.grey[600],
                                                fontSize: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return _buildLoadingSection();
                    })))));
  }

  Widget _buildErrorSection() {
    return Center(
      child: Text("Error"),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
