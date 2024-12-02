class Car {
  String id;
  String name;
  String fuelType;
  String licensePlate;
  String insurance;
  String insuranceContact;
  String odometerStatus;
  String responsiblePerson;
  String description;
  int icon;

  Car({
    this.id = '',
    this.name = '',
    this.fuelType = '',
    this.licensePlate = '',
    this.insurance = '',
    this.insuranceContact = '',
    this.odometerStatus = '',
    this.responsiblePerson = '',
    this.description = '',
    this.icon = 0,
  });

  factory Car.fromMap(String id, Map<String, dynamic> data) {
    return Car(
      id: id,
      name: data['name'] ?? '',
      fuelType: data['fuel_type'] ?? '',
      licensePlate: data['licence_plate'] ?? '',
      insurance: data['insurance'] ?? '',
      insuranceContact: data['insurance_contact'] ?? '',
      odometerStatus: data['odometer_status'] ?? '',
      responsiblePerson: data['responsible_person'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fuel_type': fuelType,
      'licence_plate': licensePlate,
      'insurance': insurance,
      'insurance_contact': insuranceContact,
      'odometer_status': odometerStatus,
      'responsible_person': responsiblePerson,
      'description': description,
      'icon': icon,
    };
  }
}
