import 'package:community/features/auth/domain/entities/user.dart';
import 'package:community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:community/features/auth/presentation/bloc/auth_state.dart';
import 'package:community/features/more/presentation/bloc/more_bloc.dart';
import 'package:community/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.mocks.dart';

void main() {
  late MockMoreBloc mockMoreBloc;
  late MockAuthBloc mockAuthBloc;

  late AuthAuthenticated authenticatedState;

  setUp(() {
    mockMoreBloc = MockMoreBloc();
    mockAuthBloc = MockAuthBloc();

    when(mockMoreBloc.stream)
        .thenAnswer((_) => Stream<MoreState>.value(MoreInitial()));
    when(mockMoreBloc.state).thenReturn(MoreInitial());

    final user = User(
      id: 'u1',
      email: 'user@test.com',
      name: 'Test User',
      labels: const ['user'],
    );
    authenticatedState = AuthAuthenticated(user: user, labels: user.labels);

    when(mockAuthBloc.state).thenReturn(authenticatedState);
    when(mockAuthBloc.stream).thenAnswer(
      (_) => Stream<AuthState>.value(authenticatedState),
    );
  });

  Widget profileApp() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MoreBloc>.value(value: mockMoreBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
        child: const ProfilePage(),
      ),
    );
  }

  testWidgets('Profile page shows title and main sections when logged in',
      (WidgetTester tester) async {
    await tester.pumpWidget(profileApp());
    await tester.pumpAndSettle();

    expect(find.text('Profile Management'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('Profile page shows Change Password action when logged in',
      (WidgetTester tester) async {
    await tester.pumpWidget(profileApp());
    await tester.pumpAndSettle();

    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Update your current password'), findsOneWidget);
  });

}
