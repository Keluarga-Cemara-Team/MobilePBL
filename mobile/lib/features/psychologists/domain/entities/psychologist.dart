class Psychologist {
  const Psychologist({
    required this.id,
    required this.name,
    required this.title,
    required this.clinicOrHospital,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.whatsapp,
    required this.rating,
    required this.reviewCount,
    required this.openHours,
    required this.specialties,
    this.distanceKm,
  });

  final String id;
  final String name;
  final String title;
  final String clinicOrHospital;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String phone;
  final String whatsapp;
  final double rating;
  final int reviewCount;
  final String openHours;
  final List<String> specialties;
  final double? distanceKm;

  Psychologist copyWith({
    String? id,
    String? name,
    String? title,
    String? clinicOrHospital,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    String? phone,
    String? whatsapp,
    double? rating,
    int? reviewCount,
    String? openHours,
    List<String>? specialties,
    double? distanceKm,
  }) {
    return Psychologist(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      clinicOrHospital: clinicOrHospital ?? this.clinicOrHospital,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      openHours: openHours ?? this.openHours,
      specialties: specialties ?? this.specialties,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  factory Psychologist.fromJson(Map<String, dynamic> json, {String? id}) {
    return Psychologist(
      id: id ?? (json['id'] as String? ?? ''),
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? 'Psikolog Klinis',
      clinicOrHospital: json['clinic_or_hospital'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? 'Batam',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      phone: json['phone'] as String? ?? '',
      whatsapp: json['whatsapp'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 24,
      openHours: json['open_hours'] as String? ?? 'Senin - Sabtu: 09:00 - 17:00',
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Burnout & Stres Kerja', 'Konseling Karir'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'clinic_or_hospital': clinicOrHospital,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'whatsapp': whatsapp,
      'rating': rating,
      'review_count': reviewCount,
      'open_hours': openHours,
      'specialties': specialties,
    };
  }
}

