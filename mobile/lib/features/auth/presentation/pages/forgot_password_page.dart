import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/otp_box_input.dart';
import '../widgets/password_text_field.dart';

enum ForgotPasswordStep {
  email,
  otp,
  newPassword,
  success,
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
    this.onRequestOtp,
    this.onVerifyOtp,
    this.onResetPassword,
    this.onSendResetLink,
  });

  final Future<String> Function(String email)? onRequestOtp;
  final Future<bool> Function(String email, String otp)? onVerifyOtp;
  final Future<void> Function(String email, String otp, String newPassword)?
      onResetPassword;
  final Future<void> Function(String email)? onSendResetLink;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _otp = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  ForgotPasswordStep _step = ForgotPasswordStep.email;
  bool _isSubmitting = false;
  bool _isLinkSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _email.dispose();
    _otp.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (_isSubmitting) return;

    final requestOtp = widget.onRequestOtp;
    final sendResetLink = widget.onSendResetLink;

    if (requestOtp == null && sendResetLink == null) return;
    if (!(_emailFormKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    final email = _email.text.trim();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      if (requestOtp != null) {
        await requestOtp(email);
        if (!mounted) return;
        setState(() {
          _step = ForgotPasswordStep.otp;
        });
      } else if (sendResetLink != null) {
        await sendResetLink(email);
        if (!mounted) return;
        setState(() {
          _isLinkSent = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitOtp() async {
    if (_isSubmitting) return;

    final verifyOtp = widget.onVerifyOtp;
    if (verifyOtp == null) return;
    final email = _email.text.trim();
    final otp = _otp.text.trim();

    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Masukkan 6 digit kode OTP secara lengkap.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final valid = await verifyOtp(email, otp);
      if (!mounted) return;
      if (valid) {
        setState(() {
          _step = ForgotPasswordStep.newPassword;
        });
      } else {
        setState(() {
          _errorMessage = 'Kode OTP tidak valid.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitNewPassword() async {
    if (_isSubmitting) return;

    final resetPassword = widget.onResetPassword;
    if (resetPassword == null) return;
    if (!(_passwordFormKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    final otp = _otp.text.trim();
    final password = _newPassword.text.trim();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await resetPassword(email, otp, password);
      if (!mounted) return;
      setState(() {
        _step = ForgotPasswordStep.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _backToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackdrop(showLeaf: true),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = context.ui(AppSpacing.page);
                final verticalPadding = context.ui(32);
                final minimumHeight = math.max(
                  0.0,
                  constraints.maxHeight - verticalPadding * 2,
                );

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minimumHeight),
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildCurrentStep(context),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context) {
    if (_isLinkSent) {
      return _buildLinkSentView(context);
    }

    switch (_step) {
      case ForgotPasswordStep.email:
        return _buildEmailStep(context);
      case ForgotPasswordStep.otp:
        return _buildOtpStep(context);
      case ForgotPasswordStep.newPassword:
        return _buildNewPasswordStep(context);
      case ForgotPasswordStep.success:
        return _buildSuccessStep(context);
    }
  }

  Widget _buildEmailStep(BuildContext context) {
    final canSubmit =
        widget.onRequestOtp != null || widget.onSendResetLink != null;

    return Form(
      key: _emailFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lupa Kata Sandi?',
            style: AppTextStyles.title(context).copyWith(
              fontSize: context.ui(32),
            ),
          ),
          SizedBox(height: context.ui(12)),
          Text(
            widget.onRequestOtp != null
                ? 'Masukkan email yang terdaftar untuk menerima 6 digit kode OTP.'
                : 'Masukkan email yang terdaftar untuk menerima tautan pengaturan ulang kata sandi.',
            style: AppTextStyles.subtitle(context).copyWith(
              fontSize: context.ui(16),
            ),
          ),
          SizedBox(height: context.ui(34)),
          AbsorbPointer(
            absorbing: _isSubmitting,
            child: AppTextField(
              hintText: 'Email',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              enableSuggestions: false,
              prefix: Icon(
                Icons.alternate_email,
                color: AppColors.of(context).hint,
                size: context.ui(24),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Email wajib diisi.';
                }
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                  return 'Masukkan email yang valid.';
                }
                return null;
              },
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: context.ui(12)),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.of(context).error,
                fontSize: context.ui(13),
              ),
            ),
          ],
          SizedBox(height: context.ui(48)),
          AppButton(
            label: widget.onRequestOtp != null
                ? 'Kirim Kode OTP'
                : 'Kirim Tautan Reset',
            isLoading: _isSubmitting,
            onPressed: canSubmit ? _submitEmail : null,
          ),
          SizedBox(height: context.ui(22)),
          Center(
            child: TextButton(
              onPressed: _isSubmitting ? null : _backToLogin,
              child: Text(
                'Kembali ke Masuk',
                style: AppTextStyles.link(context).copyWith(
                  fontSize: context.ui(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Verifikasi OTP',
            style: AppTextStyles.title(context).copyWith(
              fontSize: context.ui(32),
            ),
          ),
          SizedBox(height: context.ui(12)),
          Text(
            'Kode OTP 6 digit telah dikirim ke email ${_email.text.trim()}. Silakan periksa kotak masuk (inbox) atau folder spam email Anda.',
            style: AppTextStyles.subtitle(context).copyWith(
              fontSize: context.ui(15),
            ),
          ),
          SizedBox(height: context.ui(32)),
          AbsorbPointer(
            absorbing: _isSubmitting,
            child: OtpBoxInput(
              length: 6,
              controller: _otp,
              onCompleted: (_) => _submitOtp(),
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: context.ui(12)),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.of(context).error,
                fontSize: context.ui(13),
              ),
            ),
          ],
          SizedBox(height: context.ui(40)),
          AppButton(
            label: 'Verifikasi Kode',
            isLoading: _isSubmitting,
            onPressed: widget.onVerifyOtp == null ? null : _submitOtp,
          ),
          SizedBox(height: context.ui(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        setState(() {
                          _errorMessage = null;
                          _step = ForgotPasswordStep.email;
                        });
                      },
                child: Text(
                  'Ubah Email',
                  style: TextStyle(
                    color: AppColors.of(context).hint,
                    fontSize: context.ui(14),
                  ),
                ),
              ),
              TextButton(
                onPressed: _isSubmitting ? null : _submitEmail,
                child: Text(
                  'Kirim Ulang OTP',
                  style: AppTextStyles.link(context).copyWith(
                    fontSize: context.ui(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep(BuildContext context) {
    return Form(
      key: _passwordFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kata Sandi Baru',
            style: AppTextStyles.title(context).copyWith(
              fontSize: context.ui(32),
            ),
          ),
          SizedBox(height: context.ui(12)),
          Text(
            'Buat kata sandi baru untuk akun ${_email.text.trim()}. Minimal 6 karakter.',
            style: AppTextStyles.subtitle(context).copyWith(
              fontSize: context.ui(16),
            ),
          ),
          SizedBox(height: context.ui(30)),
          AbsorbPointer(
            absorbing: _isSubmitting,
            child: PasswordTextField(
              hintText: 'Kata Sandi Baru',
              controller: _newPassword,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final password = value?.trim() ?? '';
                if (password.isEmpty) {
                  return 'Kata sandi baru wajib diisi.';
                }
                if (password.length < 6) {
                  return 'Kata sandi minimal 6 karakter.';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: context.ui(16)),
          AbsorbPointer(
            absorbing: _isSubmitting,
            child: PasswordTextField(
              hintText: 'Konfirmasi Kata Sandi Baru',
              controller: _confirmPassword,
              textInputAction: TextInputAction.done,
              validator: (value) {
                final confirm = value?.trim() ?? '';
                if (confirm.isEmpty) {
                  return 'Konfirmasi kata sandi wajib diisi.';
                }
                if (confirm != _newPassword.text.trim()) {
                  return 'Konfirmasi kata sandi tidak cocok.';
                }
                return null;
              },
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: context.ui(12)),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.of(context).error,
                fontSize: context.ui(13),
              ),
            ),
          ],
          SizedBox(height: context.ui(40)),
          AppButton(
            label: 'Simpan Kata Sandi',
            isLoading: _isSubmitting,
            onPressed: widget.onResetPassword == null
                ? null
                : _submitNewPassword,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: context.ui(72),
            height: context.ui(72),
            decoration: BoxDecoration(
              color: AppColors.of(context).primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.of(context).primary,
              size: context.ui(44),
            ),
          ),
        ),
        SizedBox(height: context.ui(24)),
        Text(
          'Sandi Berhasil Diubah!',
          textAlign: TextAlign.center,
          style: AppTextStyles.title(context).copyWith(
            fontSize: context.ui(28),
          ),
        ),
        SizedBox(height: context.ui(12)),
        Text(
          'Kata sandi akun Anda telah berhasil diperbarui. Silakan masuk kembali menggunakan kata sandi baru Anda.',
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle(context).copyWith(
            fontSize: context.ui(15),
          ),
        ),
        SizedBox(height: context.ui(40)),
        AppButton(
          label: 'Masuk Sekarang',
          onPressed: _backToLogin,
        ),
      ],
    );
  }

  Widget _buildLinkSentView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Periksa Emailmu',
          style: AppTextStyles.title(context).copyWith(
            fontSize: context.ui(32),
          ),
        ),
        SizedBox(height: context.ui(12)),
        Text(
          'Jika email tersebut terdaftar, kamu akan menerima tautan untuk mengatur ulang kata sandi. Periksa juga folder spam.',
          style: AppTextStyles.subtitle(context).copyWith(
            fontSize: context.ui(16),
          ),
        ),
        SizedBox(height: context.ui(34)),
        AppButton(
          label: 'Kembali ke Masuk',
          onPressed: _backToLogin,
        ),
      ],
    );
  }
}
