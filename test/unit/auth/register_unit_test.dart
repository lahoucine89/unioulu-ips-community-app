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

  group('RegisterEvent', () {
    test('emit AuthError when register fails', () async {
      // Arrange - Setup the exception that will be thrown
      final exception = Exception('Registration failed');
      when(mockRegister.execute('email', 'password', 'name'))
          .thenThrow(exception);

      // Act
      authBloc.add(RegisterEvent(
        email: 'email',
        password: 'password',
        name: 'name',
      ));

      // Assert - The actual error message will include "Exception: "
      await expectLater(
        authBloc.stream,
        emitsInOrder([
          AuthLoading(),
          AuthError(message: exception.toString()),
        ]),
      );

      // Verify the register was called
      verify(mockRegister.execute('email', 'password', 'name')).called(1);
    });

    test('emits AuthRegistered when register succeeds', () async {
      when(mockRegister.execute('email', 'password', 'name'))
          .thenAnswer((_) async => User(
                id: 'user123',
                email: 'email',
                name: 'name',
                labels: ['user'],
              ));

      authBloc.add(RegisterEvent(
        email: 'email',
        password: 'password',
        name: 'name',
      ));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          AuthLoading(),
          AuthRegistered(),
        ]),
      );

      verify(mockRegister.execute('email', 'password', 'name')).called(1);
      verifyNever(mockLogin.execute(any, any));
    });
  });
}
