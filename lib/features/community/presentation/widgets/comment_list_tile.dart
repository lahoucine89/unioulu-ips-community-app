import 'package:community/core/utils/format_date.dart';
import 'package:community/features/community/data/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentListTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onLikePressed;
  final VoidCallback? onReplyPressed;
  final double leftPadding;
  final bool showReplyButton;

  const CommentListTile({
    super.key,
    required this.comment,
    this.onLikePressed,
    this.onReplyPressed,
    this.leftPadding = 0,
    this.showReplyButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isReply = comment.isReply;

    return Padding(
      padding: EdgeInsets.only(
        left: 16 + leftPadding,
        right: 16,
        top: 6,
        bottom: 6,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isReply ? Colors.grey.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isReply ? 16 : 18,
              child: const Icon(Icons.person, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        formatDateTime(comment.dateTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(comment.text),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: onLikePressed,
                        child: Row(
                          children: [
                            Icon(
                              comment.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: comment.isLiked ? Colors.red : null,
                            ),
                            const SizedBox(width: 4),
                            Text('${comment.likeCount}'),
                          ],
                        ),
                      ),
                      if (showReplyButton) ...[
                        const SizedBox(width: 18),
                        InkWell(
                          onTap: onReplyPressed,
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
