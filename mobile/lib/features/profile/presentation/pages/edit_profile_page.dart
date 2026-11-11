import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_subpage_scaffold.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final String _email;
  String? _photoUrl;
  Uint8List? _photoBytes;
  bool _removePhoto = false;
  bool _isPickingPhoto = false;
  bool _isSaving = false;
  bool _isDefaultName = false;
  String? _photoError;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider);
    _isDefaultName = profile.name == 'Pengguna';
    _nameController = TextEditingController(text: profile.name);
    _email = profile.email;
    _photoUrl = profile.photoUrl;
    _photoBytes = profile.photoBytes;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isDefaultName) {
      _nameController.text = AppLocalizations.of(context)!.profileDefaultUser;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_isPickingPhoto) return;
    setState(() {
      _isPickingPhoto = true;
      _photoError = null;
    });
    try {
      final bytes = await ref.read(profileImagePickerProvider)();
      if (!mounted || bytes == null) return;
      if (bytes.isEmpty) throw const FormatException('Empty image');
      final codec = await ui.instantiateImageCodec(bytes);
      try {
        final frame = await codec.getNextFrame();
        frame.image.dispose();
      } finally {
        codec.dispose();
      }
      if (!mounted) return;
      setState(() {
        _photoBytes = bytes;
        _removePhoto = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _photoError = AppLocalizations.of(context)!.profilePhotoError;
      });
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  Future<void> _save() async {
    if (_isPickingPhoto || _isSaving || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    final saved = await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          name: _isDefaultName ? 'Pengguna' : _nameController.text,
          photoBytes: _photoBytes,
          removePhoto: _removePhoto,
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (!saved) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileSaved)),
      );
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fieldStyle = AppTextStyles.subtitle(context)
        .copyWith(color: AppColors.of(context).navy, fontSize: context.ui(16));
    final actionStyle = TextButton.styleFrom(
      textStyle: TextStyle(fontSize: context.ui(14)),
      iconSize: context.ui(24),
      padding: EdgeInsets.symmetric(
        horizontal: context.ui(16),
        vertical: context.ui(10),
      ),
    );

    InputDecoration decoration({
      required String label,
      required IconData icon,
      String? hint,
      String? helper,
      bool disabled = false,
    }) {
      final colors = AppColors.of(context);
      OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.ui(14)),
        borderSide: BorderSide(color: color),
      );
      return InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        labelStyle: TextStyle(
          color: disabled ? colors.hint : colors.body,
          fontSize: context.ui(16),
        ),
        hintStyle: TextStyle(color: colors.hint, fontSize: context.ui(14)),
        helperStyle: TextStyle(color: colors.body, fontSize: context.ui(12)),
        errorStyle: TextStyle(color: colors.error, fontSize: context.ui(12)),
        counterStyle: TextStyle(color: colors.hint, fontSize: context.ui(12)),
        errorMaxLines: 3,
        helperMaxLines: 3,
        filled: true,
        fillColor: disabled ? colors.disabledSurface : colors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.ui(16),
          vertical: context.ui(16),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: context.ui(48).clamp(48.0, double.infinity).toDouble(),
          minHeight: context.ui(48).clamp(48.0, double.infinity).toDouble(),
        ),
        prefixIcon: Icon(icon, color: colors.hint, size: context.ui(24)),
        border: border(colors.border),
        enabledBorder: border(colors.border),
        disabledBorder: border(colors.border),
        focusedBorder: border(colors.primary),
        errorBorder: border(colors.error),
        focusedErrorBorder: border(colors.error),
      );
    }

    return ProfileSubpageScaffold(
      title: l10n.profileEditTitle,
      onBack: widget.onBack,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: UserAvatar(
                  size: 108,
                  photoUrl: _photoUrl,
                  photoBytes: _photoBytes,
                ),
              ),
              SizedBox(height: context.ui(12)),
              Center(
                child: TextButton.icon(
                  onPressed: _isPickingPhoto ? null : _pickPhoto,
                  style: actionStyle,
                  icon: _isPickingPhoto
                      ? SizedBox(
                          width: context.ui(18),
                          height: context.ui(18),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.photo_library_outlined),
                  label: Text(
                    _isPickingPhoto
                        ? l10n.profileOpeningGallery
                        : l10n.profileChangePhoto,
                  ),
                ),
              ),
              if (_photoBytes != null || _photoUrl?.isNotEmpty == true)
                Center(
                  child: TextButton(
                    style: actionStyle,
                    onPressed: _isPickingPhoto
                        ? null
                        : () => setState(() {
                            _photoBytes = null;
                            _photoUrl = null;
                            _removePhoto = true;
                            _photoError = null;
                          }),
                    child: Text(l10n.profileUseDefaultAvatar),
                  ),
                ),
              if (_photoError != null)
                Padding(
                  padding: EdgeInsets.only(top: context.ui(8)),
                  child: Text(
                    _photoError!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle(context)
                        .copyWith(color: AppColors.of(context).error),
                  ),
                ),
              SizedBox(height: context.ui(28)),
              TextFormField(
                key: const Key('edit-profile-name'),
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                maxLength: 60,
                style: fieldStyle,
                decoration: decoration(
                  label: l10n.profileName,
                  hint: l10n.profileNameHint,
                  icon: Icons.person_outline_rounded,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.profileNameRequired
                    : null,
                onChanged: (_) => _isDefaultName = false,
                onFieldSubmitted: (_) => _save(),
              ),
              SizedBox(height: context.ui(18)),
              TextFormField(
                initialValue: _email,
                enabled: false,
                readOnly: true,
                style: fieldStyle.copyWith(color: AppColors.of(context).hint),
                decoration: decoration(
                  label: l10n.profileEmail,
                  helper: l10n.profileEmailCannotChange,
                  icon: Icons.mail_outline_rounded,
                  disabled: true,
                ),
              ),
              SizedBox(height: context.ui(26)),
              ProfileInfoCard(
                text: l10n.profileNamePhotoSync,
              ),
              SizedBox(height: context.ui(28)),
              AppButton(
                label: l10n.profileSaveChanges,
                isLoading: _isSaving,
                onPressed: _isPickingPhoto || _isSaving ? null : _save,
              ),
              SizedBox(height: context.ui(8)),
              TextButton(
                onPressed: widget.onBack,
                style: actionStyle,
                child: Text(l10n.profileCancel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
