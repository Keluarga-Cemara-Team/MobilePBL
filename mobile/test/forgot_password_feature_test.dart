import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/app/router/app_router.dart';
import 'package:mobile/app/router/route_paths.dart';
import 'package:mobile/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:mobile/features/auth/di/auth_providers.dart';
import 'package:mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mobile/features/auth/presentation/widgets/otp_box_input.dart';
import 'package:mobile/shared/widgets/app_button.dart';

void main() {
  testWidgets('Forgot password OTP full flow works end-to-end', (tester) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
    );
    addTearDown(container.dispose);

    container.read(appRouterProvider).go(RoutePaths.forgotPassword);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AntiBurnoutApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
    expect(find.text('Lupa Kata Sandi?'), findsOneWidget);

    // Step 1: Submit Email
    final sendOtpButton = find.widgetWithText(AppButton, 'Kirim Kode OTP');
    expect(sendOtpButton, findsOneWidget);

    // Empty email test
    await tester.tap(sendOtpButton);
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi.'), findsOneWidget);

    // Enter valid email
    final emailField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'Email',
    );
    await tester.enterText(emailField, 'dummy@example.com');
    await tester.tap(sendOtpButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Step 2: Verify OTP
    expect(find.text('Verifikasi OTP'), findsOneWidget);
    expect(
      find.textContaining('Kode OTP 6 digit telah dikirim ke email'),
      findsOneWidget,
    );

    expect(find.byType(OtpBoxInput), findsOneWidget);
    final otpField = find.descendant(
      of: find.byType(OtpBoxInput),
      matching: find.byType(TextField),
    );
    expect(otpField, findsOneWidget);

    final verifyOtpButton = find.widgetWithText(AppButton, 'Verifikasi Kode');
    await tester.enterText(otpField, '123456');
    await tester.tap(verifyOtpButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Step 3: Set New Password
    expect(find.text('Kata Sandi Baru'), findsNWidgets(2)); // Title & TextField hintText
    final newPassField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'Kata Sandi Baru',
    );
    final confirmPassField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'Konfirmasi Kata Sandi Baru',
    );
    expect(newPassField, findsOneWidget);
    expect(confirmPassField, findsOneWidget);

    await tester.enterText(newPassField, 'newpass123');
    await tester.enterText(confirmPassField, 'newpass123');

    final saveButton = find.widgetWithText(AppButton, 'Simpan Kata Sandi');
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Step 4: Success confirmation
    expect(find.text('Sandi Berhasil Diubah!'), findsOneWidget);

    final loginButton = find.widgetWithText(AppButton, 'Masuk Sekarang');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    final router = container.read(appRouterProvider);
    expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
  });
}
