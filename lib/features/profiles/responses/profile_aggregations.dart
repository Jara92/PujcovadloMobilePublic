class ProfileAggregations {
  int countIfPublicItems;

  double? averageRating;

  int totalReviews;

  ProfileAggregations({
    required this.countIfPublicItems,
    this.averageRating,
    required this.totalReviews,
  });

  factory ProfileAggregations.fromJson(Map<String, dynamic> json) {
    return ProfileAggregations(
      countIfPublicItems: json['CountOfPublicItems'].toInt(),
      averageRating: json['AverageRating']?.toDouble(),
      totalReviews: json['TotalReviews'].toInt(),
    );
  }
}
