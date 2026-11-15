class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.isNewUser = false,
  });

  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final bool isNewUser;
}
