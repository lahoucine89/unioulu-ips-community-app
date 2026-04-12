// survey_intro_page.dart
import 'package:community/core/services/dependency_injection.dart';
import 'package:community/core/widgets/custom_button.dart';
import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/features/surveys/presentation/bloc/survey_bloc.dart';
import 'package:community/features/surveys/presentation/bloc/survey_event.dart';
import 'package:community/features/surveys/presentation/bloc/survey_state.dart';
import 'package:community/features/surveys/presentation/pages/survey_question_page.dart';
import 'package:community/features/surveys/service/survey_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurveyIntroPage extends StatelessWidget {
  final String eventId;
  
  const SurveyIntroPage({super.key, required this.eventId});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyBloc(
        service: locator<SurveyService>(),
        authRepository: locator<AuthRepositoryImpl>(),
      )..add(LoadSurvey(eventId: eventId)),
      child: BlocConsumer<SurveyBloc, SurveyState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SurveyLoading || state is SurveyInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Event Survey'),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is SurveyError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Event Survey')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 64, color: Theme.of(context).primaryColor),
                      const SizedBox(height: 16),
                      Text(
                        'No Survey Available',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'There is no survey available for this event yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Go Back',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is SurveyLoaded) {
            final survey = state.survey;
            
            return Scaffold(
              appBar: AppBar(
                title: const Text('Event Survey'),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      survey.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      survey.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${survey.questions.length} questions in total',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Start Survey',
                        onPressed: () {
                          final surveyBloc = context.read<SurveyBloc>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(value: surveyBloc),
                                ],
                                child: SurveyQuestionPage(
                                  eventId: eventId,
                                  survey: survey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return Scaffold(
            appBar: AppBar(title: const Text('Event Survey')),
            body: const Center(child: Text('No survey available')),
          );
        },
      ),
    );
  }
}