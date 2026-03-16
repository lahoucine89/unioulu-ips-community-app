import 'package:community/core/widgets/custom_button.dart';
import 'package:community/features/community/data/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentInputField extends StatefulWidget {
  final String postId;
  final Function(String postId, String commentText) onCommentSubmit;
  final CommentModel? replyToComment;
  final VoidCallback? onCancelReply;

  const CommentInputField({
    super.key,
    required this.postId,
    required this.onCommentSubmit,
    this.replyToComment,
    this.onCancelReply,
  });

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void didUpdateWidget(covariant CommentInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.replyToComment?.id != widget.replyToComment?.id) {
      if (widget.replyToComment != null &&
          _commentController.text.trim().isEmpty) {
        _commentController.text = '@${widget.replyToComment!.username} ';
        _commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    widget.onCommentSubmit(widget.postId, comment);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isReplyMode = widget.replyToComment != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isReplyMode)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to ${widget.replyToComment!.username}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onCancelReply,
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText:
                        isReplyMode ? 'Write a reply...' : 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomButton(
                onPressed: _submit,
                text: isReplyMode ? 'Reply' : 'Post',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
