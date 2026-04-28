import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Event creation 
class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _eventNameController = TextEditingController(text: 'Board game night');
  final _locationController = TextEditingController(
    text: "Blanket's guild room, University of Oulu",
  );
  final _detailsController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _feedbackController = TextEditingController(text: 'My feedback!!');

  DateTime? _eventDate = DateTime(2023, 11, 2);
  TimeOfDay _timeFrom = const TimeOfDay(hour: 20, minute: 0);
  TimeOfDay _timeTo = const TimeOfDay(hour: 23, minute: 0);

  String _category = 'Games & Hobbies';
  bool _ticketFree = true;
  bool _surveyEnabled = true;
  String _questionType = 'Mixed';
  int _mcqCount = 3;
  int _qaCount = 2;
  int _feedbackQuestionCount = 1;
  int _feedbackStars = 4;
  File? _pickedImage;

  static const _categories = [
    'Games & Hobbies',
    'Sports',
    'Academy',
    'Group Work',
    'Other',
  ];

  static const _questionTypes = [
    'Mixed',
    'Multiple choice',
    'Short answer',
    'Feedback',
  ];

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    _paidAmountController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return DateFormat('dd-MMMM-yyyy').format(d);
  }

  String _formatTime(TimeOfDay t) {
    final dt = DateTime(0, 1, 1, t.hour, t.minute);
    return DateFormat.jm().format(dt);
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    String? hint,
    Widget? suffix,
  }) {
    final primary = Theme.of(context).primaryColor;
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  InputDecoration _paidFieldDecoration(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final tint = primary.withValues(alpha: 0.08);
    return InputDecoration(
      hintText: 'Enter the amount',
      filled: true,
      fillColor: tint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  Future<void> _pickTime(bool isFrom) async {
    final initial = isFrom ? _timeFrom : _timeTo;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _timeFrom = picked;
        } else {
          _timeTo = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() => _pickedImage = File(result.files.single.path!));
    }
  }

  Widget _counterTile({
    required IconData icon,
    required String title,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    required Color primary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onMinus,
            icon: Icon(Icons.remove_circle_outline, color: primary),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPlus,
            icon: Icon(Icons.add_circle_outline, color: primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Event Preview',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MainDetailsCard(
              primary: primary,
              eventNameController: _eventNameController,
              locationController: _locationController,
              detailsController: _detailsController,
              paidAmountController: _paidAmountController,
              dateText: _formatDate(_eventDate),
              timeFromText: _formatTime(_timeFrom),
              timeToText: _formatTime(_timeTo),
              category: _category,
              categories: _categories,
              ticketFree: _ticketFree,
              pickedImage: _pickedImage,
              fieldDecoration: _fieldDecoration,
              paidFieldDecoration: _paidFieldDecoration,
              label: _label,
              onPickDate: _pickDate,
              onPickFromTime: () => _pickTime(true),
              onPickToTime: () => _pickTime(false),
              onCategoryChanged: (v) => setState(() => _category = v!),
              onTicketFreeChanged: (v) => setState(() => _ticketFree = v),
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Do You want a survey?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                  Switch(
                    value: _surveyEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: primary,
                    inactiveTrackColor: Colors.grey.shade300,
                    onChanged: (v) => setState(() => _surveyEnabled = v),
                  ),
                ],
              ),
            ),
            if (_surveyEnabled) ...[
              const SizedBox(height: 16),
              Text(
                'What type of questions would you like to create for users?',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _questionType,
                    icon: Icon(Icons.list_alt, color: primary),
                    items: _questionTypes
                        .map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _questionType = v!),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _counterTile(
                icon: Icons.quiz_outlined,
                title: 'MCQs',
                value: _mcqCount,
                primary: primary,
                onMinus: () => setState(() => _mcqCount = math.max(0, _mcqCount - 1)),
                onPlus: () => setState(() => _mcqCount = math.min(10, _mcqCount + 1)),
              ),
              _counterTile(
                icon: Icons.question_answer_outlined,
                title: 'Q&A',
                value: _qaCount,
                primary: primary,
                onMinus: () => setState(() => _qaCount = math.max(0, _qaCount - 1)),
                onPlus: () => setState(() => _qaCount = math.min(10, _qaCount + 1)),
              ),
              _counterTile(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                value: _feedbackQuestionCount,
                primary: primary,
                onMinus: () => setState(
                  () => _feedbackQuestionCount =
                      math.max(0, _feedbackQuestionCount - 1),
                ),
                onPlus: () => setState(
                  () => _feedbackQuestionCount =
                      math.min(10, _feedbackQuestionCount + 1),
                ),
              ),
              const SizedBox(height: 20),
              if (_mcqCount > 0) ...[
                _SurveyMcqCard(
                  primary: primary,
                  title:
                      'How would you rate your overall experience at the UniOulu XR Event?',
                  options: const ['Excellent', 'Good', 'Average', 'Poor'],
                ),
                const SizedBox(height: 14),
              ],
              if (_mcqCount > 1) ...[
                _SurveyMcqIconsCard(
                  primary: primary,
                  title: 'Which part of the event did you find most engaging?',
                  options: const [
                    'Interactive VR demo',
                    'Presentation by XR experts',
                    'Networking opportunities',
                    'Exploring new XR tech in general',
                  ],
                ),
                const SizedBox(height: 14),
              ],
              if (_mcqCount > 2) ...[
                _SurveyMcqStatusCard(
                  primary: primary,
                  title:
                      'Would you be interested in attending more tech-focused events like this in the future?',
                  options: const [
                    'Definitely!',
                    'Maybe, if the topic interests me',
                    'Only if it is in person',
                    'Not really',
                  ],
                ),
                const SizedBox(height: 14),
              ],
              for (var i = 0; i < _qaCount && i < 2; i++) ...[
                _SurveyShortAnswerCard(
                  primary: primary,
                  title: i == 0
                      ? 'What did you enjoy most about this event?'
                      : 'How could we improve future events?',
                ),
                const SizedBox(height: 14),
              ],
            ],
            const SizedBox(height: 8),
            _EventFeedbackCard(
              primary: primary,
              stars: _feedbackStars,
              controller: _feedbackController,
              onStarsChanged: (s) => setState(() => _feedbackStars = s),
              onSend: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback sent')),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create event — API wiring TBD')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create event',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketRadio extends StatelessWidget {
  const _TicketRadio({
    required this.label,
    required this.selected,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primary, width: 2),
                color: selected ? primary : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _MainDetailsCard extends StatelessWidget {
  const _MainDetailsCard({
    required this.primary,
    required this.eventNameController,
    required this.locationController,
    required this.detailsController,
    required this.paidAmountController,
    required this.dateText,
    required this.timeFromText,
    required this.timeToText,
    required this.category,
    required this.categories,
    required this.ticketFree,
    required this.pickedImage,
    required this.fieldDecoration,
    required this.paidFieldDecoration,
    required this.label,
    required this.onPickDate,
    required this.onPickFromTime,
    required this.onPickToTime,
    required this.onCategoryChanged,
    required this.onTicketFreeChanged,
    required this.onPickImage,
  });

  final Color primary;
  final TextEditingController eventNameController;
  final TextEditingController locationController;
  final TextEditingController detailsController;
  final TextEditingController paidAmountController;
  final String dateText;
  final String timeFromText;
  final String timeToText;
  final String category;
  final List<String> categories;
  final bool ticketFree;
  final File? pickedImage;
  final InputDecoration Function(BuildContext context, {String? hint, Widget? suffix})
      fieldDecoration;
  final InputDecoration Function(BuildContext context) paidFieldDecoration;
  final Widget Function(String text) label;
  final VoidCallback onPickDate;
  final VoidCallback onPickFromTime;
  final VoidCallback onPickToTime;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<bool> onTicketFreeChanged;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          label('Event Name'),
          TextField(
            controller: eventNameController,
            decoration: fieldDecoration(context),
          ),
          const SizedBox(height: 18),
          label('Event Date'),
          InkWell(
            onTap: onPickDate,
            borderRadius: BorderRadius.circular(10),
            child: InputDecorator(
              decoration: fieldDecoration(context).copyWith(
                suffixIcon: Icon(Icons.calendar_today_outlined, color: primary, size: 20),
              ),
              child: Text(dateText, style: const TextStyle(fontSize: 16, height: 1.35)),
            ),
          ),
          const SizedBox(height: 18),
          label('Event Time'),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: onPickFromTime,
                      borderRadius: BorderRadius.circular(10),
                      child: InputDecorator(
                        decoration: fieldDecoration(context),
                        child: Text(
                          timeFromText,
                          style: const TextStyle(fontSize: 16, height: 1.35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: onPickToTime,
                      borderRadius: BorderRadius.circular(10),
                      child: InputDecorator(
                        decoration: fieldDecoration(context),
                        child: Text(
                          timeToText,
                          style: const TextStyle(fontSize: 16, height: 1.35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          label('Category'),
          InputDecorator(
            decoration: fieldDecoration(context),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: category,
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onCategoryChanged,
              ),
            ),
          ),
          const SizedBox(height: 18),
          label('Location'),
          TextField(
            controller: locationController,
            decoration: fieldDecoration(
              context,
              suffix: Icon(Icons.location_on_outlined, color: primary, size: 22),
            ),
          ),
          const SizedBox(height: 18),
          label('Event Details'),
          TextField(
            controller: detailsController,
            minLines: 4,
            maxLines: 8,
            decoration: fieldDecoration(
              context,
              hint: 'Enter the event details...',
            ),
          ),
          const SizedBox(height: 18),
          label('Ticket Price'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _TicketRadio(
                label: 'Free',
                selected: ticketFree,
                primary: primary,
                onTap: () => onTicketFreeChanged(true),
              ),
              _TicketRadio(
                label: 'Paid',
                selected: !ticketFree,
                primary: primary,
                onTap: () => onTicketFreeChanged(false),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: paidAmountController,
                  enabled: !ticketFree,
                  keyboardType: TextInputType.number,
                  decoration: paidFieldDecoration(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          label('Upload Media'),
          Center(
            child: _PhotoUploadBox(
              primary: primary,
              file: pickedImage,
              onTap: onPickImage,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoUploadBox extends StatelessWidget {
  const _PhotoUploadBox({
    required this.primary,
    required this.file,
    required this.onTap,
  });

  final Color primary;
  final File? file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: _DashedRoundedRectPainter(color: Colors.grey.shade400),
          child: SizedBox(
            width: 120,
            height: 120,
            child: file != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(file!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera_outlined, color: Colors.grey.shade600, size: 32),
                      const SizedBox(height: 6),
                      Text(
                        'Photo',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  _DashedRoundedRectPainter({required this.color});

  final Color color;
  static const double _radius = 12;
  static const double _dashLength = 5;
  static const double _gapLength = 4;
  static const double _strokeWidth = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        _strokeWidth / 2,
        _strokeWidth / 2,
        size.width - _strokeWidth,
        size.height - _strokeWidth,
      ),
      const Radius.circular(_radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + _dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SurveyNavRow extends StatelessWidget {
  const _SurveyNavRow({required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundNavButton(primary: primary, icon: Icons.chevron_left),
        const SizedBox(width: 16),
        _RoundNavButton(primary: primary, icon: Icons.chevron_right),
      ],
    );
  }
}

class _RoundNavButton extends StatelessWidget {
  const _RoundNavButton({required this.primary, required this.icon});

  final Color primary;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _SurveyMcqCard extends StatelessWidget {
  const _SurveyMcqCard({
    required this.primary,
    required this.title,
    required this.options,
  });

  final Color primary;
  final String title;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return _SurveyCardShell(
      primary: primary,
      title: title,
      child: Column(
        children: [
          for (final o in options) ...[
            Row(
              children: [
                Icon(Icons.radio_button_off, size: 22, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(child: Text(o, style: const TextStyle(fontSize: 14))),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _SurveyNavRow(primary: primary),
        ],
      ),
    );
  }
}

class _SurveyMcqIconsCard extends StatelessWidget {
  const _SurveyMcqIconsCard({
    required this.primary,
    required this.title,
    required this.options,
  });

  final Color primary;
  final String title;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.videogame_asset_outlined,
      Icons.school_outlined,
      Icons.people_outline,
      Icons.explore_outlined,
    ];
    return _SurveyCardShell(
      primary: primary,
      title: title,
      child: Column(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            Row(
              children: [
                Icon(Icons.radio_button_off, size: 22, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Icon(icons[i % icons.length], size: 20, color: primary),
                const SizedBox(width: 8),
                Expanded(child: Text(options[i], style: const TextStyle(fontSize: 14))),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _SurveyNavRow(primary: primary),
        ],
      ),
    );
  }
}

class _SurveyMcqStatusCard extends StatelessWidget {
  const _SurveyMcqStatusCard({
    required this.primary,
    required this.title,
    required this.options,
  });

  final Color primary;
  final String title;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.green,
      Colors.orange,
      Colors.blue,
      Colors.red,
    ];
    return _SurveyCardShell(
      primary: primary,
      title: title,
      child: Column(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            Row(
              children: [
                Icon(Icons.radio_button_off, size: 22, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Icon(
                  i == 0 ? Icons.check_circle : Icons.cancel_outlined,
                  size: 20,
                  color: colors[i % colors.length],
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(options[i], style: const TextStyle(fontSize: 14))),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _SurveyNavRow(primary: primary),
        ],
      ),
    );
  }
}

class _SurveyShortAnswerCard extends StatelessWidget {
  const _SurveyShortAnswerCard({
    required this.primary,
    required this.title,
  });

  final Color primary;
  final String title;

  @override
  Widget build(BuildContext context) {
    return _SurveyCardShell(
      primary: primary,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write your answer here...',
              filled: true,
              fillColor: Colors.grey.shade50,
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
          const SizedBox(height: 12),
          _SurveyNavRow(primary: primary),
        ],
      ),
    );
  }
}

class _SurveyCardShell extends StatelessWidget {
  const _SurveyCardShell({
    required this.primary,
    required this.title,
    required this.child,
  });

  final Color primary;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            color: primary,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _EventFeedbackCard extends StatelessWidget {
  const _EventFeedbackCard({
    required this.primary,
    required this.stars,
    required this.controller,
    required this.onStarsChanged,
    required this.onSend,
  });

  final Color primary;
  final int stars;
  final TextEditingController controller;
  final ValueChanged<int> onStarsChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Feedback',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please rate your experience below',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                GestureDetector(
                  onTap: () => onStarsChanged(i),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      i <= stars ? Icons.star : Icons.star_border,
                      color: i <= stars ? const Color(0xFFFFC107) : Colors.grey.shade400,
                      size: 32,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '$stars.0 stars',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Additional feedback',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSend,
              style: TextButton.styleFrom(
                foregroundColor: primary,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Send'),
            ),
          ),
        ],
      ),
    );
  }
}
