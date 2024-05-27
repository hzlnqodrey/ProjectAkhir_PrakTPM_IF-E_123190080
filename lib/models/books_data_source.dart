import '../services/api/baseNetwork.dart';

class BookDataSource {
  static BookDataSource instance = BookDataSource();
  Future<Map<String, dynamic>> loadBooks() {
    return BaseNetwork.get("new");
  }
}

class BookDetailSource {
  static BookDetailSource instance = BookDetailSource();
  Future<Map<String, dynamic>> loadBookDetail(String isbn13) {
    return BaseNetwork.get("books/${isbn13}");
  }
}

class BookSearch{
  static BookSearch instance = BookSearch();
  Future<Map<String, dynamic>> searchBooks(String search) {
    return BaseNetwork.get("/search/${search}");
  }
}