import 'package:flutter/foundation.dart';

@immutable
class Pharmacie {
  const Pharmacie({
    required this.id,
    required this.nom,
    required this.quartier,
    required this.telephone,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.isPartner,
    this.whatsapp,
    this.distance,
  });

  final int id;
  final String nom;
  final String quartier;
  final String telephone;
  final String? whatsapp;
  final double latitude;
  final double longitude;
  final bool isActive;
  final bool isPartner;
  final double? distance;

  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      id: json['id'] as int,
      nom: json['nom'] as String,
      quartier: json['quartier'] as String,
      telephone: json['telephone'] as String,
      whatsapp: json['whatsapp'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      isPartner: json['isPartner'] as bool,
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'quartier': quartier,
        'telephone': telephone,
        'whatsapp': whatsapp,
        'latitude': latitude,
        'longitude': longitude,
        'isActive': isActive,
        'isPartner': isPartner,
        'distance': distance,
      };

  Pharmacie copyWith({
    int? id,
    String? nom,
    String? quartier,
    String? telephone,
    String? whatsapp,
    double? latitude,
    double? longitude,
    bool? isActive,
    bool? isPartner,
    double? distance,
  }) {
    return Pharmacie(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      quartier: quartier ?? this.quartier,
      telephone: telephone ?? this.telephone,
      whatsapp: whatsapp ?? this.whatsapp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      isPartner: isPartner ?? this.isPartner,
      distance: distance ?? this.distance,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pharmacie &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Pharmacie(id: $id, nom: $nom, quartier: $quartier)';

  String get whatsappNumber => whatsapp ?? telephone;

  String? get distanceFormatted {
    if (distance == null) return null;
    if (distance! < 1) {
      return '${(distance! * 1000).toStringAsFixed(0)} m';
    }
    return '${distance!.toStringAsFixed(1)} km';
  }

  String get whatsappMessage =>
      'Pharmacie de garde : $nom\n'
      'Quartier : $quartier\n'
      'Tél : $telephone\n'
      'Trouvé via PharmaGo 🏥';
}