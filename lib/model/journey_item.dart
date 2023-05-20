class JourneyItem {
  final String category;
  final String name;

  JourneyItem(this.category, this.name);

  factory JourneyItem.fromJson(Map<String, dynamic> json) {
    return JourneyItem(
      json["category"],
      json["name"],
    );
  }

  Map toJson() => {
        "category": category,
        "name": name,
      };
}
