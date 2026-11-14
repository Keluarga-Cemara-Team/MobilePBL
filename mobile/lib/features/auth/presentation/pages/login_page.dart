import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authControllerProvider).isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    final ok = await ref
        .read(authControllerProvider.notifier)
        .login(email: _email.text.trim(), password: _password.text);

    if (!mounted) return;

    if (ok) {
      context.go(RoutePaths.home);
    }
  }

  Future<void> _loginWithGoogle() async {
    if (ref.read(authControllerProvider).isSubmitting) return;
    FocusScope.of(context).unfocus();

    final ok =
        await ref.read(authControllerProvider.notifier).loginWithGoogle();

    if (!mounted) return;

    if (ok) {
      context.go(RoutePaths.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Selamat Datang!',
                                textAlign: TextAlign.left,
                                style: AppTextStyles.title(context).copyWith(
                                  color: AppColors.of(context).primaryDark,
                                  fontSize: context.ui(32),
                                ),
                              ),
                              SizedBox(height: context.ui(28)),
                              Text(
                                'Masuk untuk melanjutkan perjalanan '
                                'menuju versi terbaik dirimu.',
                                textAlign: TextAlign.left,
                                style: AppTextStyles.subtitle(context)
                                    .copyWith(fontSize: context.ui(16)),
                              ),

                              // Jarak deskripsi ke form mengikuti mockup.
                              SizedBox(height: context.ui(56)),

                              AppTextField(
                                hintText: 'Email',
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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

                                  if (!email.contains('@')) {
                                    return 'Masukkan email yang valid.';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: context.ui(28)),
                              PasswordTextField(
                                hintText: 'Kata Sandi',
                                controller: _password,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Kata sandi wajib diisi.';
                                  }

                                  return null;
                                },
                              ),

                              SizedBox(height: context.ui(20)),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: auth.isSubmitting
                                      ? null
                                      : () {
                                          context.push(
                                            RoutePaths.forgotPassword,
                                          );
                                        },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.ui(4),
                                      vertical: context.ui(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Lupa kata sandi?',
                                    style: AppTextStyles.link(context).copyWith(
                                      fontSize: context.ui(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),

                              if (auth.errorMessage != null) ...[
                                SizedBox(height: context.ui(12)),
                                Text(
                                  auth.errorMessage!,
                                  style: TextStyle(
                                    color: AppColors.of(context).error,
                                    fontSize: context.ui(13),
                                  ),
                                ),
                              ],

                              SizedBox(height: context.ui(32)),

                              AppButton(
                                label: 'Masuk',
                                isLoading: auth.isSubmitting,
                                onPressed: _submit,
                              ),

                              SizedBox(height: context.ui(20)),

                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: AppColors.of(context).border,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.ui(16),
                                    ),
                                    child: Text(
                                      'atau masuk dengan',
                                      style: TextStyle(
                                        color: AppColors.of(context).hint,
                                        fontSize: context.ui(13),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: AppColors.of(context).border,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: context.ui(20)),

                              OutlinedButton(
                                onPressed:
                                    auth.isSubmitting ? null : _loginWithGoogle,
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.ui(14),
                                  ),
                                  side: BorderSide(
                                    color: AppColors.of(context).border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      context.ui(14),
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white10
                                          : Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.string(
                                      '''<svg viewBox="0 0 48 48" width="22" height="22"><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/></svg>''',
                                      width: context.ui(22),
                                      height: context.ui(22),
                                    ),
                                    SizedBox(width: context.ui(12)),
                                    Text(
                                      'Masuk dengan Google',
                                      style: TextStyle(
                                        color:
                                            AppColors.of(context).primaryDark,
                                        fontSize: context.ui(15),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: context.ui(24)),

                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Belum punya akun?',
                                    style: TextStyle(
                                      color: AppColors.of(context).body,
                                      fontSize: context.ui(15),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: auth.isSubmitting
                                        ? null
                                        : () {
                                            context.go(RoutePaths.register);
                                          },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.ui(8),
                                        vertical: context.ui(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Daftar',
                                      style: AppTextStyles.link(context)
                                          .copyWith(fontSize: context.ui(15)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
}
