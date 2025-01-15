enum RideType {
  Business,
  Personal,
  Commute,
  Delivery,
  Leisure,
  Other,
}

RideType stringToRideType(String rideTypeString) {
  switch (rideTypeString.toLowerCase()) {
    case 'business':
      return RideType.Business;
    case 'personal':
      return RideType.Personal;
    case 'commute':
      return RideType.Commute;
    case 'delivery':
      return RideType.Delivery;
    case 'leisure':
      return RideType.Leisure;
    case 'other':
      return RideType.Other;
    default:
      return RideType.Other;
  }
}
