import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:food_user_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:food_user_app/features/auth/domain/usecases/send_phone_otp_usecase.dart';
import 'package:food_user_app/features/auth/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:food_user_app/features/auth/domain/usecases/complete_registration_usecase.dart';
import 'package:food_user_app/features/auth/data/datasources/social_auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.logoutUseCase,
    required this.sendPhoneOtpUseCase,
    required this.verifyPhoneOtpUseCase,
    required this.completeRegistrationUseCase,
    required this.authRepository,
  }) : super(const AuthStateInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PhoneOtpRequested>(_onPhoneOtpRequested);
    on<PhoneOtpVerifySubmitted>(_onPhoneOtpVerifySubmitted);
    on<CompleteRegistrationSubmitted>(_onCompleteRegistrationSubmitted);
    on<SocialLoginRequested>(_onSocialLoginRequested);
  }

  final LogoutUseCase logoutUseCase;
  final SendPhoneOtpUseCase sendPhoneOtpUseCase;
  final VerifyPhoneOtpUseCase verifyPhoneOtpUseCase;
  final CompleteRegistrationUseCase completeRegistrationUseCase;
  final AuthRepository authRepository;

  String? _registrationToken;

  // ── Auth Check ─────────────────────────────────────────────────────────────

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final loggedIn = await authRepository.isLoggedIn;
    if (isClosed || emit.isDone) return;
    if (!loggedIn) {
      emit(const Unauthenticated());
      return;
    }
    final cachedUser = await authRepository.getCachedUser();
    if (isClosed || emit.isDone) return;
    cachedUser.fold((_) => emit(const Unauthenticated()), (user) {
      if (user == null) {
        emit(const Unauthenticated());
      } else {
        emit(Authenticated(user));
      }
    });
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _registrationToken = null;
    emit(const LogoutInProgress());
    await logoutUseCase(const NoParams());
    if (isClosed || emit.isDone) return;
    emit(const Unauthenticated());
  }

  // ── Social Login ───────────────────────────────────────────────────────────

  Future<void> _onSocialLoginRequested(
    SocialLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const SocialLoginInProgress());

    try {
      SocialAuthResult? result;
      if (event.provider == 'google') {
        result = await SocialAuthService.signInWithGoogle();
      } else if (event.provider == 'apple') {
        result = await SocialAuthService.signInWithApple();
      } else if (event.provider == 'facebook') {
        result = await SocialAuthService.signInWithFacebook();
      }

      if (isClosed || emit.isDone) return;

      if (result == null) {
        emit(const SocialLoginFailure('Social login was canceled or failed.'));
        return;
      }

      final response = await authRepository.loginWithFirebase(
        idToken: result.idToken,
      );
      if (isClosed || emit.isDone) return;
      response.fold((failure) => emit(SocialLoginFailure(failure.message)), (
        authFlow,
      ) {
        if (authFlow.registrationToken != null &&
            authFlow.registrationToken!.isNotEmpty) {
          _registrationToken = authFlow.registrationToken;
        }
        if (authFlow.isAuthenticated && authFlow.user != null) {
          _registrationToken = null;
          emit(Authenticated(authFlow.user!));
        } else if (authFlow.needsPhoneVerification) {
          // Social login required phone verification
          emit(
            PhoneOtpVerificationRequired(
              phone:
                  '', // Can't know phone yet unless it was returned, but usually they enter it
              registrationToken:
                  authFlow.registrationToken ?? _registrationToken ?? '',
            ),
          );
        } else {
          // complete_profile
          emit(
            PhoneOtpCompleteProfile(
              registrationToken:
                  authFlow.registrationToken ?? _registrationToken ?? '',
              requiredFields: authFlow.requiredFields ?? [],
            ),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      if (isClosed || emit.isDone) return;
      if (e.code == 'account-exists-with-different-credential') {
        final email = e.email;
        if (email != null) {
          try {
            // ignore: deprecated_member_use
            final methods = await FirebaseAuth.instance
                .fetchSignInMethodsForEmail(email);
            final providerList = methods.isNotEmpty
                ? methods.join(', ')
                : 'another method';
            emit(
              SocialLoginFailure(
                'An account already exists with the same email ($email) but signed in using $providerList. Please sign in using your original method.',
              ),
            );
          } catch (_) {
            emit(
              SocialLoginFailure(
                'An account already exists with the same email ($email). Please sign in using your original method.',
              ),
            );
          }
        } else {
          emit(
            const SocialLoginFailure(
              'An account already exists with different credentials. Please sign in using your original method.',
            ),
          );
        }
      } else {
        emit(SocialLoginFailure(e.message ?? e.toString()));
      }
    } catch (e) {
      if (isClosed || emit.isDone) return;
      emit(SocialLoginFailure(e.toString()));
    }
  }

  // ── Phone OTP Flow (New Plezmo API) ───────────────────────────────────────

  Future<void> _onPhoneOtpRequested(
    PhoneOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const PhoneOtpSendInProgress());
    final phone = event.phone.trim();
    final result = await sendPhoneOtpUseCase(SendPhoneOtpParams(phone: phone));
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) => emit(PhoneOtpSendFailure(failure.message)),
      (_) => emit(PhoneOtpSent(phone: phone)),
    );
  }

  Future<void> _onPhoneOtpVerifySubmitted(
    PhoneOtpVerifySubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const PhoneOtpVerifyInProgress());
    final regToken =
        (event.registrationToken != null &&
            event.registrationToken!.trim().isNotEmpty)
        ? event.registrationToken!.trim()
        : _registrationToken;
    final result = await verifyPhoneOtpUseCase(
      VerifyPhoneOtpParams(
        phone: event.phone.trim(),
        otp: event.otp.trim(),
        registrationToken: regToken,
      ),
    );
    if (isClosed || emit.isDone) return;
    result.fold((failure) => emit(PhoneOtpVerifyFailure(failure.message)), (
      verify,
    ) {
      if (verify.isAuthenticated && verify.user != null) {
        _registrationToken = null;
        emit(PhoneOtpLoginSuccess(verify.user!));
      } else {
        if (verify.registrationToken != null &&
            verify.registrationToken!.isNotEmpty) {
          _registrationToken = verify.registrationToken;
        }
        emit(
          PhoneOtpCompleteProfile(
            registrationToken:
                verify.registrationToken ?? _registrationToken ?? '',
            requiredFields: verify.requiredFields ?? [],
          ),
        );
      }
    });
  }

  Future<void> _onCompleteRegistrationSubmitted(
    CompleteRegistrationSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const CompleteRegistrationInProgress());
    _registrationToken = event.registrationToken;
    final result = await completeRegistrationUseCase(
      CompleteRegistrationParams(
        registrationToken: event.registrationToken,
        firstName: event.firstName?.trim(),
        lastName: event.lastName?.trim(),
        email: event.email?.trim(),
        phone: event.phone?.trim(),
      ),
    );
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) => emit(CompleteRegistrationFailure(failure.message)),
      (authFlow) {
        if (authFlow.registrationToken != null &&
            authFlow.registrationToken!.isNotEmpty) {
          _registrationToken = authFlow.registrationToken;
        }
        if (authFlow.needsPhoneVerification) {
          emit(
            PhoneOtpVerificationRequired(
              phone: event.phone ?? '', // pass the phone they just entered
              registrationToken:
                  authFlow.registrationToken ?? event.registrationToken,
            ),
          );
        } else if (authFlow.isAuthenticated && authFlow.user != null) {
          _registrationToken = null;
          emit(CompleteRegistrationSuccess(authFlow.user!));
        } else {
          // fallback / unexpected
          emit(
            const CompleteRegistrationFailure(
              'Unexpected response after completing profile',
            ),
          );
        }
      },
    );
  }
}
