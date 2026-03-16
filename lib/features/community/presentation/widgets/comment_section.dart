import 'package:community/features/community/data/models/comment_model.dart';
import 'package:community/features/community/presentation/bloc/community_bloc.dart';
import 'package:community/features/community/presentation/widgets/comment_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsSection extends StatelessWidget {
  final String postId;
  final ValueChanged<CommentModel>? onReplyTap;

  const CommentsSection({
    super.key,
    required this.postId,
    this.onReplyTap,
  });

  List<CommentModel> _topLevelComments(List<CommentModel> comments) {
    return comments
        .where(
          (comment) =>
              comment.parentCommentId == null ||
              comment.parentCommentId!.trim().isEmpty,
        )
        .toList();
  }

  List<CommentModel> _repliesForComment(
    List<CommentModel> comments,
    String parentCommentId,
  ) {
    return comments
        .where((comment) => comment.parentCommentId == parentCommentId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      buildWhen: (previous, current) {
        return current is PostLoaded || current is CommentsLoading;
      },
      builder: (context, state) {
        final comments =
            state is PostLoaded ? state.comments : <CommentModel>[];
        final isLoading = state is CommentsLoading;

        final topLevelComments = _topLevelComments(comments);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (comments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No comments yet. Be the first to comment!'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topLevelComments.length,
                itemBuilder: (context, index) {
                  final comment = topLevelComments[index];
                  final replies = _repliesForComment(comments, comment.id);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentListTile(
                        key: ValueKey(comment.id),
                        comment: comment,
                        onLikePressed: () {
                          context.read<CommunityBloc>().add(
                                ToggleCommentLike(commentId: comment.id),
                              );
                        },
                        onReplyPressed: () {
                          if (onReplyTap != null) {
                            onReplyTap!(comment);
                          }
                        },
                      ),
                      if (replies.isNotEmpty)
                        ...replies.map(
                          (reply) => CommentListTile(
                            key: ValueKey(reply.id),
                            comment: reply,
                            leftPadding: 28,
                            onLikePressed: () {
                              context.read<CommunityBloc>().add(
                                    ToggleCommentLike(commentId: reply.id),
                                  );
                            },
                            onReplyPressed: () {
                              if (onReplyTap != null) {
                                onReplyTap!(comment);
                              }
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
