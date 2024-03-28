import 'dart:convert';

import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';

class LoanUpdateRequest {
  final int? id;

  final LoanStatus? status;

  LoanUpdateRequest({
    this.id,
    this.status,
  });

  dynamic toJson() {
    return jsonEncode(<String, dynamic>{
      "Id": id,
      "Status": status?.value,
    });
  }
}
