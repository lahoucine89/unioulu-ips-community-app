enum QuestionType {
  multipleChoice,
  rating,
  text
}

class SurveyQuestion {
  final String id;
  final String questionText;
  final QuestionType questionType;
  final List<String>? options;
  final bool isRequired;
  
  SurveyQuestion({
    required this.id,
    required this.questionText,
    required this.questionType,
    this.options,
    this.isRequired = true,
  });

  factory SurveyQuestion.fromMap(Map<String, dynamic> map) {
    return SurveyQuestion(
      id: map['\$id'] ?? '',
      questionText: map['question'] ?? '',
      questionType: (map['questionType'] as String?)?.toQuestionType() ?? QuestionType.text,
      options: (map['options'] != null && (map['options'] as String).isNotEmpty)
          ? (map['options'] as String).split(',')
          : null,
      isRequired: map['isRequired'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': questionText,
      'questionType': questionType.index,
      'options': options,
      'isRequired': isRequired,
    };
  }

  @override
  String toString() {
    return 'Question{id: $id, question: $questionText, questionType: $questionType, options: $options, isRequired: $isRequired}';
  }
}


extension QuestionTypeExtension on String {
  QuestionType toQuestionType() {
    switch (this) {
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'rating':
        return QuestionType.rating;
      case 'text':
        return QuestionType.text;
      default:
        return QuestionType.text; // Default fallback
    }
  }
}