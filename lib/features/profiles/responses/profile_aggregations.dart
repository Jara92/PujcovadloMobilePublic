class ProfileAggregations {
  int countOfPublicItems;

  int countOfBorrowedItems;

  int countOfLentItems;

  double? averageRating;

  int totalReviews;

  ProfileAggregations({
    required this.countOfPublicItems,
    required this.countOfBorrowedItems,
    required this.countOfLentItems,
    this.averageRating,
    required this.totalReviews,
  });

  factory ProfileAggregations.fromJson(Map<String, dynamic> json) {
    return ProfileAggregations(
      countOfPublicItems: json['CountOfPublicItems'].toInt(),
      countOfBorrowedItems: json['CountOfBorrowedItems'].toInt(),
      countOfLentItems: json['CountOfLentItems'].toInt(),
      averageRating: json['AverageRating']?.toDouble(),
      totalReviews: json['TotalReviews'].toInt(),
    );
  }
}
