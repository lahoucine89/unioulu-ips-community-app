import 'dart:io';

import 'package:community/core/services/http_appwrite_service.dart';
import 'package:community/core/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPreviewData {
  const EventPreviewData({
    required this.title,
    required this.location,
    required this.details,
    required this.dateLabel,
    required this.fromTimeLabel,
    required this.toTimeLabel,
    required this.category,
    required this.ticketLabel,
    required this.surveyEnabled,
    required this.mcqCount,
    required this.qaCount,
    required this.feedbackCount,
    this.image,
  });

  final String title;
  final String location;
  final String details;
  final String dateLabel;
  final String fromTimeLabel;
  final String toTimeLabel;
  final String category;
  final String ticketLabel;
  final bool surveyEnabled;
  final int mcqCount;
  final int qaCount;
  final int feedbackCount;
  final File? image;
}

class EventPreviewPage extends StatefulWidget {
  const EventPreviewPage({
    super.key,
    required this.preview,
  });

  final EventPreviewData preview;

  @override
  State<EventPreviewPage> createState() => _EventPreviewPageState();
}

class _EventPreviewPageState extends State<EventPreviewPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final AppwriteService _appwriteService = AppwriteService();
  int _stars = 4;
  bool _isSaving = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
    required Color primary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _surveyCard({
    required Color primary,
    required String question,
    required List<String> options,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              question,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              children: [
                for (final option in options)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.radio_button_off,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SurveyNavButton(icon: Icons.chevron_left, primary: primary),
                    const SizedBox(width: 16),
                    _SurveyNavButton(icon: Icons.chevron_right, primary: primary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _uploadPosterPhoto(File image) async {
    final response = await _appwriteService.uploadFile(
      bucketId: appwriteBucketId,
      file: image,
      fileId: 'unique()',
    );

    final fileId = response['\$id'];
    return '${_appwriteService.endpoint}/storage/buckets/$appwriteBucketId/files/$fileId/view?project=$appwriteProjectId';
  }

  Future<void> _createEvent() async {
    if (_isSaving) return;

    final preview = widget.preview;
    final title = preview.title.trim().isEmpty ? 'Untitled event' : preview.title.trim();
    final location = preview.location.trim();
    final details = preview.details.trim();

    DateTime? parsedDate;
    try {
      parsedDate = DateFormat('dd-MMMM-yyyy').parseStrict(preview.dateLabel);
    } catch (_) {
      parsedDate = null;
    }

    final normalizedDate = parsedDate == null
        ? DateFormat('yyyy-MM-dd').format(DateTime.now())
        : DateFormat('yyyy-MM-dd').format(parsedDate);

    final ticketLabel = preview.ticketLabel.trim().isEmpty ? 'Free' : preview.ticketLabel.trim();

    setState(() => _isSaving = true);
    try {
      String posterPhotoUrl = '';
      if (preview.image != null) {
        final uploadedUrl = await _uploadPosterPhoto(preview.image!);
        if (uploadedUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload selected image.')),
          );
          return;
        }
        posterPhotoUrl = uploadedUrl;
      }

      final data = {
        'posterPhotoUrl': posterPhotoUrl,
        'topics': preview.category,
        'title_en': title,
        'title_fi': '',
        'title_sv': '',
        'location_en': location,
        'location_fi': '',
        'location_sv': '',
        'date': normalizedDate,
        'time': '${preview.fromTimeLabel} - ${preview.toTimeLabel}',
        'organizerName': 'UniOulu Community',
        'details_en': details,
        'details_fi': '',
        'details_sv': '',
        'ticketDetails_en': preview.surveyEnabled
            ? 'Survey enabled: MCQ ${preview.mcqCount}, Q&A ${preview.qaCount}, Feedback ${preview.feedbackCount}'
            : 'No survey',
        'ticketDetails_fi': '',
        'ticketDetails_sv': '',
        'locationUrl': '',
        'price': ticketLabel,
      };

      await _appwriteService.createDocument(
        collectionId: 'events',
        data: {
          'documentId': 'unique()',
          'data': data,
        },
        documentId: 'unique()',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = widget.preview;
    final primary = Theme.of(context).primaryColor;
    final eventTitle = preview.title.trim().isEmpty ? 'Untitled event' : preview.title;
    final details = preview.details.trim().isEmpty
        ? 'Your event details will appear here.'
        : preview.details;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Event Preview',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 170,
                          child: preview.image == null
                              ? Container(
                                  color: const Color(0xFFE7E7EC),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 64,
                                    color: Colors.grey.shade500,
                                  ),
                                )
                              : Image.file(preview.image!, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.edit_outlined, color: primary, size: 16),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: primary,
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.save_alt, size: 14),
                      label: const Text('SAVE DRAFT'),
                    ),
                  ),
                  Text(
                    eventTitle,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  _infoRow(
                    icon: Icons.calendar_today_outlined,
                    text:
                        '${preview.dateLabel} | ${preview.fromTimeLabel} - ${preview.toTimeLabel}',
                    primary: primary,
                  ),
                  _infoRow(
                    icon: Icons.location_on_outlined,
                    text: preview.location,
                    primary: primary,
                  ),
                  _infoRow(
                    icon: Icons.confirmation_number_outlined,
                    text: preview.ticketLabel,
                    primary: primary,
                  ),
                  if (preview.image != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        preview.image!,
                        height: 70,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Text(
                    'Hosted by',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    preview.category,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Event Description',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.35),
                  ),
                ],
              ),
            ),
            if (preview.surveyEnabled) ...[
              const SizedBox(height: 16),
              Text(
                'Answer The Survey!',
                style: TextStyle(
                  color: primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              if (preview.mcqCount > 0)
                _surveyCard(
                  primary: primary,
                  question: 'How would you rate your overall experience at this event?',
                  options: const ['Excellent', 'Good', 'Average', 'Poor'],
                ),
              if (preview.mcqCount > 1)
                _surveyCard(
                  primary: primary,
                  question: 'What part of the event did you find most engaging?',
                  options: const [
                    'Interactive activities',
                    'Presentations by experts',
                    'Networking opportunities',
                    'Hands-on learning',
                  ],
                ),
              if (preview.qaCount > 0)
                _surveyCard(
                  primary: primary,
                  question: 'Would you be interested in attending similar events?',
                  options: const [
                    'Definitely',
                    'Maybe, if the topic interests me',
                    'Only if it is in person',
                    'Not really',
                  ],
                ),
              if (preview.feedbackCount > 0)
                _surveyCard(
                  primary: primary,
                  question: 'What was your favorite part of this event and why?',
                  options: const ['Write your answer here...'],
                ),
            ],
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Event Feedback',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Please rate your experience below',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () => setState(() => _stars = i),
                          child: Icon(
                            i <= _stars ? Icons.star : Icons.star_border,
                            color: const Color(0xFFFFC107),
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Additional feedback',
                    style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _feedbackController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'My feedback',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback submitted')),
                  );
                },
                child: const Text('Submit feedback'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isSaving ? null : _createEvent,
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurveyNavButton extends StatelessWidget {
  const _SurveyNavButton({
    required this.icon,
    required this.primary,
  });

  final IconData icon;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 16),
        constraints: const BoxConstraints(minHeight: 28, minWidth: 28),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
