

class Spot {
  final String name;
  final String location;
  final String imagePath;
  final int participants;

  Spot({
    required this.name,
    required this.location,
    required this.imagePath,
    required this.participants,
  });
}

class Concept {
  final String title;
  final String iconPath;
  final List<Spot> hotSpots;
  final List<Spot> recommendedTours;
  Concept({
    required this.title,
    required this.iconPath,
    required this.hotSpots,
    required this.recommendedTours,
  });
}