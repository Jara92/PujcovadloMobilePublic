import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

class ItemLocalizationHelper {
  static String? itemDistance(AppLocalizations loc, double? distance) {
    if (distance == null) {
      return null;
    }

    if (distance < 1000) {
      int roundedDistance = _roundToNearest50(distance);
      return loc.item_distance_meters(roundedDistance);
    }

    double distanceInKm = distance / 1000;
    return loc.item_distance_kilometers(distanceInKm);
  }

  static int _roundToNearest50(double number) {
    // Divide the number by 50 and round to nearest integer
    int rounded = (number / 50).ceil();

    // Multiply the rounded result by 50
    int result = rounded * 50;

    return result;
  }
}
