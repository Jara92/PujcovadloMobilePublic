

class ReviewResponse {
  int id;

  String? comment;

  double? rating;

  int loanId;

  String authorId;

  DateTime createdAt;

  ReviewResponse({
    required this.id,
    required this.comment,
    required this.rating,
    required this.loanId,
    required this.authorId,
    required this.createdAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['Id'] as int,
      comment: json['Comment'] as String,
      rating: json['Rating'].toDouble(),
      // todo: should work no
      loanId: json['LoanId'] as int,
      authorId: json['AuthorId'].toString(),
      createdAt: DateTime.parse(json['CreatedAt'].toString()),
    );
  }
}
