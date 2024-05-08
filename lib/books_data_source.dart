import 'baseNetwork.dart';

class BookDataSource {
  static BookDataSource instance = BookDataSource();
  Future<Map<String, dynamic>> loadBooks() {
    return BaseNetwork.get("new");
  }
}

class BookSearch{
  static BookSearch instance = BookSearch();
  Future<Map<String, dynamic>> searchBooks(String search) {
    return BaseNetwork.get("/search/${search}");
  }
}