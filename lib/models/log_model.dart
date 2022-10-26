import 'dart:convert';

import 'package:flutter/foundation.dart';

class LogModel {
  String userImgUrl;
  DateTime addedAt;
  Map<String, dynamic> geoLocation;
  LogModel({
    required this.userImgUrl,
    required this.addedAt,
    required this.geoLocation,
  });

  LogModel copyWith({
    String? userImgUrl,
    DateTime? addedAt,
    Map<String, dynamic>? geoLocation,
  }) {
    return LogModel(
      userImgUrl: userImgUrl ?? this.userImgUrl,
      addedAt: addedAt ?? this.addedAt,
      geoLocation: geoLocation ?? this.geoLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userImgUrl': userImgUrl,
      'addedAt': addedAt.millisecondsSinceEpoch,
      'geoLocation': geoLocation,
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      userImgUrl: map['userImgUrl'] ?? '',
      addedAt: DateTime.fromMillisecondsSinceEpoch(map['addedAt']),
      geoLocation: Map<String, dynamic>.from(map['geoLocation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LogModel.fromJson(String source) =>
      LogModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LogModel(userImgUrl: $userImgUrl, addedAt: $addedAt, geoLocation: $geoLocation)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LogModel &&
        other.userImgUrl == userImgUrl &&
        other.addedAt == addedAt &&
        mapEquals(other.geoLocation, geoLocation);
  }

  @override
  int get hashCode =>
      userImgUrl.hashCode ^ addedAt.hashCode ^ geoLocation.hashCode;
}
