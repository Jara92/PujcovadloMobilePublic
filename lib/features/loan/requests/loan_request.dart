import 'dart:convert';

import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';

class LoanRequest {
  int? id;

  LoanStatus? status;

  DateTime? from;

  DateTime? to;

  String? tenantNote;

  int? itemId;

  LoanRequest({
    this.id,
    this.status,
    this.from,
    this.to,
    this.tenantNote,
    this.itemId,
  });

  dynamic toJson() {
    return jsonEncode(<String, dynamic>{
      "Id": id,
      "Status": status?.value,
      "From": from?.toIso8601String(),
      "To": to?.toIso8601String(),
      "TenantNote": tenantNote,
      "ItemId": itemId,
    });
  }
}
