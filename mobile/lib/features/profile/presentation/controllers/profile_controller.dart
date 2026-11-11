import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/di/auth_providers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileDetails {
  const ProfileDetails({
    required this.name,
    required this.email,
    this.photoUrl,
    this.photoBytes,
  });

  final String name;
  final String email;
  final String? photoUrl;
  final Uint8List? photoBytes;
}

/// Local presentation state only. It is reset when the signed-in user changes.
class ProfileController extends Notifier<ProfileDetails> {
  @override
  ProfileDetails build() {
    ref.watch(authControllerProvider.select((value) => value.user?.id));
    final user = ref.read(authControllerProvider).user;
    return ProfileDetails(
      name: user?.name.trim().isNotEmpty == true ? user!.name : 'Pengguna',
      email: user?.email ?? '',
      photoUrl: user?.photoUrl,
    );
  }

  Future<bool> updateProfile({
    required String name,
    Uint8List? photoBytes,
    bool removePhoto = false,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return false;

    String? photoUrl = state.photoUrl;
    if (removePhoto) {
      photoUrl = null;
    } else if (photoBytes != null) {
      photoUrl = 'data:image/jpeg;base64,${base64Encode(photoBytes)}';
    }

    final user = ref.read(authControllerProvider).user;
    final userId = user?.id ?? 'guest-user';

    try {
      final updatedUser = await ref.read(authRepositoryProvider).updateProfile(
        userId: userId,
        name: trimmedName,
        photoUrl: photoUrl,
      );
      ref.read(authControllerProvider.notifier).updateCurrentUser(updatedUser);
    } catch (e) {
      debugPrint('ProfileController updateProfile error: $e');
    }

    state = ProfileDetails(
      name: trimmedName,
      email: state.email,
      photoUrl: photoUrl,
      photoBytes: removePhoto ? null : (photoBytes ?? state.photoBytes),
    );
    return true;
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileDetails>(ProfileController.new);

/// Keeping this callback injectable lets the UI be tested without a gallery.
final profileImagePickerProvider = Provider<Future<Uint8List?> Function()>((
  ref,
) {
  return () async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
      requestFullMetadata: false,
    );
    return image?.readAsBytes();
  };
});
