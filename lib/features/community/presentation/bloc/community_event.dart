part of 'community_bloc.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object?> get props => [];
}

class LoadSinglePost extends CommunityEvent {
  final PostModel post;

  const LoadSinglePost({required this.post});

  @override
  List<Object> get props => [post];
}

class AddComment extends CommunityEvent {
  final String postId;
  final String commentText;
  final String? parentCommentId;

  const AddComment({
    required this.postId,
    required this.commentText,
    this.parentCommentId,
  });

  @override
  List<Object?> get props => [postId, commentText, parentCommentId];
}

class LoadComments extends CommunityEvent {
  final String postId;

  const LoadComments({required this.postId});

  @override
  List<Object> get props => [postId];
}

class FetchCommunityPosts extends CommunityEvent {
  final int? limit;
  final bool sortByLatest;
  final String? userId;

  const FetchCommunityPosts({
    this.limit = 50,
    this.sortByLatest = true,
    this.userId,
  });

  @override
  List<Object?> get props => [limit, sortByLatest, userId];
}

class TogglePostLike extends CommunityEvent {
  final String postId;

  const TogglePostLike({required this.postId});

  @override
  List<Object> get props => [postId];
}

class ToggleCommentLike extends CommunityEvent {
  final String commentId;

  const ToggleCommentLike({required this.commentId});

  @override
  List<Object> get props => [commentId];
}

class VoteOnPoll extends CommunityEvent {
  final String postId;
  final int optionIndex;

  const VoteOnPoll({required this.postId, required this.optionIndex});

  @override
  List<Object> get props => [postId, optionIndex];
}
