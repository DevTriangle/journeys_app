class JourneyItem {
  final String category;
  final String name;
  final int count;

  JourneyItem(this.category, this.name, this.count);

  factory JourneyItem.fromJson(Map<String, dynamic> json) {
    return JourneyItem(
      json["category"],
      json["name"],
      json["count"],
    );
  }

  Map toJson() => {
        "category": category,
        "name": name,
        "count": count,
      };
}
