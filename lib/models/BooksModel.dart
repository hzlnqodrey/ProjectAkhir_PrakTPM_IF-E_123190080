class BooksModel {
  List<Books>? books;
  BooksModel({this.books});
  BooksModel.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// Get item by [isbn13].
  Books? getById(String isbn13) {
    if (books == null) return null;
    return books!
        .firstWhere((book) => book.isbn13 == isbn13, orElse: () => Books());
  }

  /// Get item by its position in the List.
  Books? getByPosition(int position) {
    if (books == null || position < 0 || position >= books!.length) return null;
    return books![position];
  }
}

class Books {
  String? title;
  String? price;
  String? pic;
  String? link;
  String? isbn13;
  String? desc;
  String? authors;
  int? pages;
  int? year;
  int? rating;
  String? subtitle;
  String? publisher;


  Books({this.title, this.price});
  Books.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    pic = json['image'];
    link = json['url'];
    isbn13 = json['isbn13'];
    desc = json['desc'];
    authors = json['authors'];
    pages = json['pages'];
    year = json['year'];
    rating = json['rating'];
    subtitle = json['subtitle'];
    publisher = json['publisher'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.title;
    data['price'] = this.price;
    data['pic'] = this.pic;
    data['link'] = this.link;
    data['isbn13'] = this.isbn13;
    data['desc'] = this.desc;
    data['authors'] = this.authors;
    data['pages'] = this.pages;
    data['year'] = this.year;
    data['rating'] = this.rating;
    data['subtitle'] = this.subtitle;
    data['publisher'] = this.publisher;

    return data;
  }

  // Get item by [isbn13]
  @override
  int get hashCode => isbn13.hashCode;

  @override
  bool operator ==(Object other) => other is Books && other.isbn13 == isbn13;
}
