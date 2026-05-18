import 'package:flutter/material.dart';

class Destination {
  final String title;
  final String location;
  final String imagePath;

  Destination(this.title, this.location, this.imagePath);
}

class PopularViewModel extends ChangeNotifier {
  final List<Destination> _allDestinations = [
    Destination("기아 타이거즈 투어", "광주광역시", "assets/Dummy/dum2.png"),
    Destination("ACC 투어", "광주광역시", "assets/Dummy/dum1.png"),
  ];

  String _searchQuery = '';

  List<Destination> get filteredDestinations {
    if (_searchQuery.isEmpty) return _allDestinations;
    final lowerQuery = _searchQuery.toLowerCase();
    return _allDestinations
        .where((d) =>
            d.location.toLowerCase().contains(lowerQuery) ||
            d.title.toLowerCase().contains(lowerQuery))
        .toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}