import 'package:community/core/services/dependency_injection.dart';
import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/features/community/data/models/comment_model.dart';
import 'package:community/features/community/data/models/post_model.dart';
import 'package:community/features/community/presentation/bloc/community_bloc.dart';
import 'package:community/features/community/presentation/widgets/comment_input_field.dart';
import 'package:community/features/community/presentation/widgets/comment_section.dart';
import 'package:community/features/community/service/community_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleCommunityPostPage extends StatefulWidget {
  const SingleCommunityPostPage({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  State<SingleCommunityPostPage> createState() =>
      _SingleCommunityPostPageState();
}

class _SingleCommunityPostPageState extends State<SingleCommunityPostPage> {
  int? _selectedPollOption;
  CommentModel? _replyToComment;

  Future<void> _voteOnPoll(BuildContext context, int index) async {
    if (_selectedPollOption != null) return;

    setState(() {
      _selectedPollOption = index;
    });

    context.read<CommunityBloc>().add(
          VoteOnPoll(postId: widget.post.id, optionIndex: index),
        );
  }

  double _pollPercentage(PostModel post, int index) {
    final opts = post.pollOptions;
    final total = opts.fold<int>(0, (sum, o) => sum + o.votes);
    return total > 0 ? opts[index].votes / total : 0;
  }

  void _setReplyTarget(CommentModel comment) {
    setState(() {
      _replyToComment = comment;
    });
  }

  void _clearReplyTarget() {
    setState(() {
      _replyToComment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommunityBloc(
        communityService: locator<CommunityService>(),
        authRepository: locator<AuthRepositoryImpl>(),
      )..add(LoadSinglePost(post: widget.post)),
      child: Builder(
        builder: (innerContext) {
          return BlocListener<CommunityBloc, CommunityState>(
            listener: (context, state) {
              if (state is CommunityError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is CommentAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );

                if (mounted) {
                  _clearReplyTarget();
                }
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Community Post'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPostCard(innerContext),
                    BlocBuilder<CommunityBloc, CommunityState>(
                      buildWhen: (prev, curr) =>
                          curr is PostLoaded || curr is CommentsLoading,
                      builder: (context, state) {
                        if (state is PostLoaded) {
                          return CommentInputField(
                            postId: state.post.id,
                            replyToComment: _replyToComment,
                            onCancelReply: _clearReplyTarget,
                            onCommentSubmit: (_, commentText) {
                              context.read<CommunityBloc>().add(
                                    AddComment(
                                      postId: state.post.id,
                                      commentText: commentText,
                                      parentCommentId: _replyToComment?.id,
                                    ),
                                  );
                            },
                          );
                        }

                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    CommentsSection(
                      postId: widget.post.id,
                      onReplyTap: _setReplyTarget,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      buildWhen: (prev, curr) =>
          curr is PostLoaded ||
          curr is CommunityActionSuccess ||
          curr is CommunityLoading ||
          curr is CommentsLoading,
      builder: (context, state) {
        final post = state is PostLoaded
            ? state.post
            : state is CommentsLoading
                ? state.post
                : widget.post;

        return Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _authorRow(post),
                const SizedBox(height: 16),
                _postImage(post),
                const SizedBox(height: 16),
                Text(
                  post.postTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.content,
                  style: const TextStyle(fontSize: 14),
                ),
                if (post.pollOptions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _pollSection(context, post),
                ],
                const SizedBox(height: 16),
                _likeRow(context, post),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _authorRow(PostModel post) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          child: Icon(Icons.person),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                post.authorTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _postImage(PostModel post) {
    return post.imageUrl.isNotEmpty
        ? Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const Icon(
                Icons.broken_image,
                size: 100,
                color: Colors.grey,
              );
            },
          )
        : Image.asset(
            'assets/default_avatar.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          );
  }

  Widget _pollSection(BuildContext context, PostModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.pollQuestion,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(post.pollOptions.length, (i) {
          final opt = post.pollOptions[i];
          final isSelected = _selectedPollOption == i;
          final percentage = _pollPercentage(post, i);

          return GestureDetector(
            onTap: () => _voteOnPoll(context, i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt.option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(percentage * 100).toStringAsFixed(1)}% (${opt.votes} votes)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (_selectedPollOption != null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Thanks for voting!',
              style: TextStyle(color: Colors.green),
            ),
          ),
      ],
    );
  }

  Widget _likeRow(BuildContext context, PostModel post) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: post.isLiked ? Colors.red : null,
          ),
          onPressed: () {
            context.read<CommunityBloc>().add(
                  TogglePostLike(postId: post.id),
                );
          },
        ),
        Text('${post.likeCount}'),
      ],
    );
  }
}
