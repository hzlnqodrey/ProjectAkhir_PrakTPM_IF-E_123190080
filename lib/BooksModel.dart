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
}
class Books {
  String? title;
  String? price;
  String? pic;
  String? link;

  Books({this.title, this.price});
  Books.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    pic = json['image'];
    link = json['url'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.title;
    data['price'] = this.price;
    data['pic'] = this.pic;
    data['link'] = this.link;
    return data;
  }
}