import 'dart:convert';

class UserModel {
  final int? id;
  final String email;
  final String username;
  final String password;
  final NameModel name;
  final AddressModel address;
  final String phone;

  const UserModel({
    this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
  });

  /// -------------------- FROM JSON --------------------
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: NameModel.fromJson(json['name'] ?? {}),
      address: AddressModel.fromJson(json['address'] ?? {}),
      phone: json['phone'] ?? '',
    );
  }

  /// -------------------- TO JSON --------------------
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'email': email,
        'username': username,
        'password': password,
        'name': name.toJson(),
        'address': address.toJson(),
        'phone': phone,
      };

  /// -------------------- COPY WITH --------------------
  UserModel copyWith({
    int? id,
    String? email,
    String? username,
    String? password,
    NameModel? name,
    AddressModel? address,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() => jsonEncode(toJson());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          username == other.username &&
          password == other.password &&
          name == other.name &&
          address == other.address &&
          phone == other.phone;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      username.hashCode ^
      password.hashCode ^
      name.hashCode ^
      address.hashCode ^
      phone.hashCode;
}

/// =======================================================

class NameModel {
  final String firstname;
  final String lastname;

  const NameModel({
    required this.firstname,
    required this.lastname,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
      };

  NameModel copyWith({
    String? firstname,
    String? lastname,
  }) {
    return NameModel(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
    );
  }

  @override
  String toString() => '$firstname $lastname';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameModel &&
          firstname == other.firstname &&
          lastname == other.lastname;

  @override
  int get hashCode => firstname.hashCode ^ lastname.hashCode;
}

/// =======================================================

class AddressModel {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeoLocationModel geolocation;

  const AddressModel({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      number: (json['number'] is num)
          ? (json['number'] as num).toInt()
          : 0,
      zipcode: json['zipcode'] ?? '',
      geolocation:
          GeoLocationModel.fromJson(json['geolocation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'street': street,
        'number': number,
        'zipcode': zipcode,
        'geolocation': geolocation.toJson(),
      };

  AddressModel copyWith({
    String? city,
    String? street,
    int? number,
    String? zipcode,
    GeoLocationModel? geolocation,
  }) {
    return AddressModel(
      city: city ?? this.city,
      street: street ?? this.street,
      number: number ?? this.number,
      zipcode: zipcode ?? this.zipcode,
      geolocation: geolocation ?? this.geolocation,
    );
  }

  @override
  String toString() => '$street $number, $city ($zipcode)';

  @override
  int get hashCode =>
      city.hashCode ^
      street.hashCode ^
      number.hashCode ^
      zipcode.hashCode ^
      geolocation.hashCode;
}

/// =======================================================

class GeoLocationModel {
  final String lat;
  final String long;

  const GeoLocationModel({
    required this.lat,
    required this.long,
  });

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationModel(
      lat: (json['lat'] ?? '').toString(),
      long: (json['long'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'long': long,
      };

  @override
  String toString() => '($lat, $long)';

  @override
  int get hashCode => lat.hashCode ^ long.hashCode;
}
