import 'package:flutter/material.dart';

class BookmarkViewModel extends ChangeNotifier{
    List<String> bookmarks = [];

    void addBookmark(String place){
        bookmarks.add(place);
        notifyListeners();
    }
    void removeBookmark(String place){
        bookmarks.remove(place);
        notifyListeners();
    }
    bool isBookmark(String place){
        return bookmarks.contains(place);
    }
}