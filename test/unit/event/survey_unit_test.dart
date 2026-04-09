import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/features/surveys/data/survey.dart';
import 'package:community/features/surveys/data/survey_question.dart';
import 'package:community/features/surveys/presentation/bloc/survey_bloc.dart';
import 'package:community/features/surveys/presentation/bloc/survey_event.dart';
import 'package:community/features/surveys/presentation/bloc/survey_state.dart';
import 'package:community/features/surveys/service/survey_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'survey_unit_test.mocks.dart';

@GenerateMocks([SurveyService, AuthRepositoryImpl])
void main() {
  late MockAuthRepositoryImpl mockAuthRepository;
  late MockSurveyService mockSurveyService;
  late SurveyBloc surveyBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryImpl();
    mockSurveyService = MockSurveyService();
    surveyBloc = SurveyBloc(
      service: mockSurveyService,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    surveyBloc.close();
  });

  final eventId = 'event123';
  Survey survey = Survey(
    id: "surveyId",
    eventId: eventId,
    title: 'Sample Survey',
    description: 'This is a sample survey',
    questions: [],
  );

  test(
      'when LoadSurvey, emits SurveyLoading, SurveyLoaded when fetch event succeeds',
      () async {
    // Arrange

    when(mockAuthRepository.getCurrentUserId())
        .thenAnswer((_) async => 'userId');

    when(mockSurveyService.getSurveyForEvent(eventId))
        .thenAnswer((_) async => survey);

    // Act
    surveyBloc.add(LoadSurvey(eventId: eventId));

    // Assert
    expectLater(
      surveyBloc.stream,
      emitsInOrder([
        SurveyLoading(),
        isA<SurveyLoaded>(),
      ]),
    );
  });

  test('when LoadSurvey, emits SurveyLoading, SurveyError when fetch fails.',
      () async {
    // Arrange
    final eventId = 'event123';
    when(mockSurveyService.getSurveyForEvent(eventId))
        .thenThrow(Exception('Failed to load survey'));

    // Act
    surveyBloc.add(LoadSurvey(eventId: eventId));

    // Assert
    expectLater(
      surveyBloc.stream,
      emitsInOrder([
        SurveyLoading(),
        isA<SurveyError>(),
      ]),
    );
  });

  test('when AnswerQuestion, emits SurveyLoaded with updated answers',
      () async {
    // Arrange
    final questionId = 'question123';
    final answer = 'Sample Answer';
    final initialState = SurveyLoaded(
      survey: Survey(
          id: 'surveyId',
          eventId: 'eventId',
          title: '',
          description: '',
          questions: []),
      answers: {},
    );
    surveyBloc.emit(initialState);

    // Act
    surveyBloc.add(AnswerQuestion(questionId: questionId, answer: answer));

    // Assert
    expectLater(
      surveyBloc.stream,
      emitsInOrder([
        isA<SurveyLoaded>()
            .having((state) => state.answers[questionId], 'answers', answer),
      ]),
    );
  });

  test(
      'when SubmitSurvey, emits SurveySubmitting, SurveySubmitted when submission succeeds',
      () async {
    final surveyId = 'surveyId';
    final eventId = 'eventId';
    final userId = 'userId';
    final surveyWithQuestion = Survey(
      id: surveyId,
      eventId: eventId,
      title: 'Sample Survey',
      description: 'This is a sample survey',
      questions: [
        SurveyQuestion(
          id: 'question1',
          questionText: 'Q1',
          questionType: QuestionType.text,
        ),
      ],
    );

    when(mockAuthRepository.getCurrentUserId()).thenAnswer((_) async => userId);
    when(mockSurveyService.getSurveyForEvent(eventId))
        .thenAnswer((_) async => surveyWithQuestion);
    when(mockSurveyService.submitSurveyResponse(any))
        .thenAnswer((_) async => {});

    surveyBloc.add(LoadSurvey(eventId: eventId));
    await expectLater(
      surveyBloc.stream,
      emitsInOrder([
        SurveyLoading(),
        isA<SurveyLoaded>(),
      ]),
    );

    surveyBloc.add(
        AnswerQuestion(questionId: 'question1', answer: 'Answer 1'));
    await expectLater(
      surveyBloc.stream,
      emitsInOrder([
        isA<SurveyLoaded>(),
      ]),
    );

    surveyBloc.add(SubmitSurvey(surveyId: surveyId, eventId: eventId));
    await expectLater(
      surveyBloc.stream,
      emitsInOrder([
        SurveySubmitting(),
        isA<SurveySubmitted>(),
      ]),
    );
  });
}
