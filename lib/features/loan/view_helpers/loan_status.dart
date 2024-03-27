import 'package:flutter/cupertino.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';

class LoanStatusLocalizationHelper {
  static String locForOwner(BuildContext context, LoanStatus status) {
    switch (status) {
      case LoanStatus.inquired:
        return context.loc.loan_status_owner_inquired_title;
      case LoanStatus.accepted:
        return context.loc.loan_status_owner_accepted_title;
      case LoanStatus.denied:
        return context.loc.loan_status_owner_denied_title;
      case LoanStatus.cancelled:
        return context.loc.loan_status_owner_cancelled_title;
      case LoanStatus.preparedForPickup:
        return context.loc.loan_status_owner_prepared_for_pickup_title;
      case LoanStatus.pickupDenied:
        return context.loc.loan_status_owner_pickup_denied_title;
      case LoanStatus.active:
        return context.loc.loan_status_owner_active_title;
      case LoanStatus.preparedForReturn:
        return context.loc.loan_status_owner_prepared_for_return_title;
      case LoanStatus.returnDenied:
        return context.loc.loan_status_owner_return_denied_title;
      case LoanStatus.returned:
        return context.loc.loan_status_owner_returned_title;
    }
  }

  static String locForTenant(BuildContext context, LoanStatus status) {
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

  static String locDescriptionForOwner(
      BuildContext context, LoanStatus status) {
    switch (status) {
      case LoanStatus.inquired:
        return context.loc.loan_status_owner_inquired_description;
      case LoanStatus.accepted:
        return context.loc.loan_status_owner_accepted_description;
      case LoanStatus.denied:
        return context.loc.loan_status_owner_denied_description;
      case LoanStatus.cancelled:
        return context.loc.loan_status_owner_cancelled_description;
      case LoanStatus.preparedForPickup:
        return context.loc.loan_status_owner_prepared_for_pickup_description;
      case LoanStatus.pickupDenied:
        return context.loc.loan_status_owner_pickup_denied_description;
      case LoanStatus.active:
        return context.loc.loan_status_owner_active_description;
      case LoanStatus.preparedForReturn:
        return context.loc.loan_status_owner_prepared_for_return_description;
      case LoanStatus.returnDenied:
        return context.loc.loan_status_owner_return_denied_description;
      case LoanStatus.returned:
        return context.loc.loan_status_owner_returned_description;
    }
  }
}
