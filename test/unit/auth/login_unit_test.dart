import 'package:appwrite/appwrite.dart';
import 'package:community/features/auth/domain/entities/user.dart';
import 'package:community/features/auth/domain/repositories/auth_repository.dart';
import 'package:community/features/auth/domain/usecases/authenticate_anonymous.dart';
import 'package:community/features/auth/domain/usecases/login.dart';
import 'package:community/features/auth/domain/usecases/logout.dart';
import 'package:community/features/auth/domain/usecases/register.dart';
import 'package:community/features/auth/domain/usecases/update_profile.dart';
import 'package:community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:community/features/auth/presentation/bloc/auth_event.dart';
import 'package:community/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/models.dart' as appwrite;

import 'register_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Register>(),
  MockSpec<Login>(),
  MockSpec<Logout>(),
  MockSpec<UpdateProfile>(),
  MockSpec<AuthenticateAnonymous>(),
  MockSpec<Account>(),
  MockSpec<Client>(),
])
@GenerateMocks([
  AuthRepository,
])
void main() {
  late MockRegister mockRegister;
  late MockLogin mockLogin;
  late MockLogout mockLogout;
  late MockUpdateProfile mockUpdateProfile;
  late MockAuthenticateAnonymous mockAuthenticateAnonymous;
  late MockAccount mockAccount;
  late AuthBloc authBloc;

  setUp(() {

    // Initialize all mock use cases with the mock repository
    mockRegister = MockRegister();
    mockLogin = MockLogin();
    mockLogout = MockLogout();
    mockUpdateProfile = MockUpdateProfile();
    mockAuthenticateAnonymous = MockAuthenticateAnonymous();
    mockAccount = MockAccount();

    // Create the auth bloc with mock dependencies
    authBloc = AuthBloc(
      login: mockLogin,
      logout: mockLogout,
      register: mockRegister,
      updateProfile: mockUpdateProfile,
      authenticateAnonymous: mockAuthenticateAnonymous,
      account: mockAccount,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('LoginEvent', () {
    test('emits AuthLoading, AuthError when login fails', () async {
      // Arrange
      final exception =
          Exception('Invalid email or password. Please try again.');
      when(mockLogin.execute('email', 'password')).thenThrow(exception);

      // Act
      authBloc.add(LoginEvent(email: 'email', password: 'password'));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          AuthLoading(),
          AuthError(message: exception.toString()),
        ]),
      );
    });

    test('emits AuthLoading, AuthAuthenticated when login succeeds ', () async {
      // Arrange
      when(mockLogin.execute('email', 'password')).thenAnswer((_) async {
        return User(
          id: 'userId',
          name: 'User Name',
          email: 'email',
          labels: [],
        );
      });

      final appwriteUser = appwrite.User(
          $id: 'userId',
          name: 'User Name',
          email: 'email',
          labels: [],
          $createdAt: "2025-10-01T00:00:00Z",
          $updatedAt: "2025-10-01T00:00:00Z",
          registration: "email",
          status: true,
          passwordUpdate: "2025-10-01T00:00:00Z",
          phone: "1234567890",
          emailVerification: false,
          phoneVerification: false,
          mfa: false,
          prefs: appwrite.Preferences(data: {}),
          targets: [],
          accessedAt: "2025-10-01T00:00:00Z",
        );

      when(mockAccount.get()).thenAnswer((_) async {
        return appwriteUser;
      });

      // Act
      authBloc.add(LoginEvent(email: 'email', password: 'password'));

      // Assert
      await expectLater(
        authBloc.stream,
        emitsInOrder([
          AuthLoading(),
          AuthAuthenticated(
            user: User(
              id: 'userId',
              name: 'User Name',
              email: 'email',
              labels: [],
            ),
            labels: [],
          ),
        ]),
      );
    });
  });
}
