import '../../domain/entities/psychologist.dart';

class PsychologistState {
  const PsychologistState({
    this.isLoading = false,
    this.isLocating = false,
    this.userLatitude,
    this.userLongitude,
    this.locationLabel = 'Memuat lokasi...',
    this.hasGpsLocation = false,
    this.selectedCity = 'Semua',
    this.searchQuery = '',
    this.psychologists = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final bool isLocating;
  final double? userLatitude;
  final double? userLongitude;
  final String locationLabel;
  final bool hasGpsLocation;
  final String selectedCity;
  final String searchQuery;
  final List<Psychologist> psychologists;
  final String? errorMessage;

  PsychologistState copyWith({
    bool? isLoading,
    bool? isLocating,
    double? userLatitude,
    double? userLongitude,
    String? locationLabel,
    bool? hasGpsLocation,
    String? selectedCity,
    String? searchQuery,
    List<Psychologist>? psychologists,
    String? errorMessage,
  }) {
    return PsychologistState(
      isLoading: isLoading ?? this.isLoading,
      isLocating: isLocating ?? this.isLocating,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      locationLabel: locationLabel ?? this.locationLabel,
      hasGpsLocation: hasGpsLocation ?? this.hasGpsLocation,
      selectedCity: selectedCity ?? this.selectedCity,
      searchQuery: searchQuery ?? this.searchQuery,
      psychologists: psychologists ?? this.psychologists,
      errorMessage: errorMessage,
    );
  }
}
