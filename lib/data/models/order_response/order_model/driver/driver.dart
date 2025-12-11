import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  Driver({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.profilePicture,
    this.rating,
    this.direction,
    this.currentLocation,
    this.totalTrip,
  });

  Driver.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profilePicture = json['profile_picture'];
    rating = json['rating'];
    direction = json['direction'];
    final loc = json['current_location'] is String ? jsonDecode(json['current_location']) : json['current_location'];
    if (loc != null) {
      currentLocation = LatLng(
        (loc['lat'] as num).toDouble(),
        (loc['lng'] as num).toDouble(),
      );
    }
    totalTrip = json['total_trip'];
  }

  num? id;
  String? name;
  String? email;
  String? mobile;
  String? profilePicture;
  num? rating;
  num? direction;
  LatLng? currentLocation;
  num? totalTrip;
  Driver copyWith({  num? id,
    String? name,
    String? email,
    String? mobile,
    String? profilePicture,
    num? rating,
    num? direction,
    LatLng? currentLocation,
    num? totalTrip

  }) => Driver(  id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profilePicture: profilePicture ?? this.profilePicture,
      rating: rating ?? this.rating,
      direction: direction ?? this.direction,
      currentLocation: currentLocation ?? this.currentLocation,
      totalTrip: totalTrip
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['mobile'] = mobile;
    map['profile_picture'] = profilePicture;
    map['rating'] = rating;
    map['direction'] = direction;
    if (currentLocation != null) {
      map['current_location'] = {
        'lat': currentLocation!.latitude,
        'lng': currentLocation!.longitude,
      };
    }
    map['total_trip'] = totalTrip;
    return map;
  }

}


