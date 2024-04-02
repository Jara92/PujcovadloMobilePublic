import 'dart:convert';

class ReviewRequest {
  final int? loanId;
  final String? comment;
  final double? rating;

  ReviewRequest({
    this.loanId,
    this.comment,
    this.rating,
  });

  String toJson() {
    return jsonEncode({
      'LoanId': loanId,
      'Comment': comment,
      'Rating': rating,
    });
  }
}
