import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';

class TenantLoanStatusWidget extends StatelessWidget {
  final LoanStatus status;

  const TenantLoanStatusWidget({required this.status, super.key});

  String _localizeStatusName(BuildContext context, LoanStatus status) {
    switch (status) {
      case LoanStatus.inquired:
        return context.loc.loan_status_tenant_inquired_title;
      case LoanStatus.accepted:
        return context.loc.loan_status_tenant_accepted_title;
      case LoanStatus.denied:
        return context.loc.loan_status_tenant_denied_title;
      case LoanStatus.cancelled:
        return context.loc.loan_status_tenant_cancelled_title;
      case LoanStatus.preparedForPickup:
        return context.loc.loan_status_tenant_prepared_for_pickup_title;
      case LoanStatus.pickupDenied:
        return context.loc.loan_status_tenant_pickup_denied_title;
      case LoanStatus.active:
        return context.loc.loan_status_tenant_active_title;
      case LoanStatus.preparedForReturn:
        return context.loc.loan_status_tenant_prepared_for_return_title;
      case LoanStatus.returnDenied:
        return context.loc.loan_status_tenant_return_denied_title;
      case LoanStatus.returned:
        return context.loc.loan_status_tenant_returned_title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Text(
        _localizeStatusName(context, status),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 10.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
