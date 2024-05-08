import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'search_page.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  late String searchBooks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: Column(
            children: [
              SafeArea(
                child: Form(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(labelText: 'Search'),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Required";
                            }
                            return null;
                          },
                          onChanged: (value){searchBooks = value;},
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return searchPage(search: searchBooks, username: '',);
                              }));
                            },
                            child: Text('Search')),
                        SizedBox(height: 24), // _buildButtonSubmit(),
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
