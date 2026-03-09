import 'dart:developer' as developer;

import 'package:appwrite/appwrite.dart';
import 'package:community/core/services/http_appwrite_service.dart';
import 'package:community/features/surveys/data/survey_question.dart';
import 'package:community/features/surveys/data/survey.dart';
import 'package:community/features/surveys/data/survey_submission.dart';

class SurveyService {
  final AppwriteService _appwriteService;

  SurveyService({required AppwriteService appwriteService})
      : _appwriteService = appwriteService;

  Future<List<SurveyQuestion>> getQuestionsForSurvey(String surveyId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: "survey_questions",
        queries: [
          Query.equal('surveyId', surveyId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final questionsData = response['documents'] as List;

        return questionsData.map<SurveyQuestion>((question) {
          try {
            return SurveyQuestion.fromMap(question);
          } catch (e) {
            developer.log('Failed to parse survey question: $e');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('Failed to fetch survey questions');
      }
    } catch (e) {
      developer.log(
        'Error fetching questions for survey $surveyId: $e',
        error: e,
        stackTrace: StackTrace.current,
      );
      throw Exception('Failed to fetch questions for survey $surveyId');
    }
  }

  Future<Survey> getSurveyForEvent(String eventId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: "surveys",
        queries: [
          Query.equal('eventId', eventId),
        ],
      );

      if (response.containsKey('documents') &&
          response['documents'] is List &&
          (response['documents'] as List).isNotEmpty) {
        final surveyData = response['documents'][0];
        Survey survey = Survey.fromMap(surveyData);

        final questions = await getQuestionsForSurvey(survey.id);
        survey.questions = questions;

        return survey;
      } else {
        throw Exception('No survey found for event $eventId');
      }
    } catch (e) {
      developer.log(
        'Error fetching survey for event $eventId: $e',
        error: e,
        stackTrace: StackTrace.current,
      );
      throw Exception('Failed to fetch survey for event $eventId');
    }
  }

  Future<void> submitSurveyResponse(SurveySubmission responseModel) async {
    try {
      final response = await _appwriteService.createDocument(
        collectionId: "survey_responses",
        documentId: 'unique()',
        data: {
          'eventId': responseModel.eventId,
          'surveyId': responseModel.surveyId,
          'userId': responseModel.userId,
        },
      );

      final surveyResponse = SurveySubmission.fromMap(response);

      final responses = responseModel.responses;
      for (final responseItem in responses) {
        await _appwriteService.createDocument(
          collectionId: "survey_response_answers",
          documentId: 'unique()',
          data: {
            'responseId': surveyResponse.id,
            'questionId': responseItem.questionId,
            'answer': responseItem.answer.toString(),
          },
        );
      }
    } catch (e) {
      developer.log(
        'Error submitting survey response: $e',
        error: e,
        stackTrace: StackTrace.current,
      );
      throw Exception('Failed to submit survey response');
    }
  }
}
