import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/features/community/data/models/comment_model.dart';
import 'package:community/features/community/data/models/post_model.dart';
import 'package:community/features/community/service/community_service.dart';
import 'package:equatable/equatable.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityService _communityService;
  final AuthRepositoryImpl _authRepository;

  CommunityBloc({
    required CommunityService communityService,
    required AuthRepositoryImpl authRepository,
  })  : _communityService = communityService,
        _authRepository = authRepository,
        super(CommunityInitial()) {
    on<FetchCommunityPosts>(_onFetchCommunityPosts);
    on<TogglePostLike>(_onTogglePostLike);
    on<ToggleCommentLike>(_onToggleCommentLike);
    on<LoadSinglePost>(_onLoadSinglePost);
    on<AddComment>(_onAddComment);
    on<LoadComments>(_onLoadComments);
    on<VoteOnPoll>(_onVoteOnPoll);
  }

  Future<void> _onVoteOnPoll(
      VoteOnPoll event, Emitter<CommunityState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      final post = currentState.post;

      try {
        emit(CommentsLoading(post: post));

        await _communityService.voteOnPoll(event.postId, event.optionIndex);

        final updatedPollOptions =
            post.pollOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;

          if (index == event.optionIndex) {
            return option.copyWith(votes: option.votes + 1);
          }
          return option;
        }).toList();

        final updatedPost = post.copyWith(
          pollOptions: updatedPollOptions,
        );

        emit(PostLoaded(
          post: updatedPost,
          comments: currentState.comments,
        ));
      } catch (e) {
        emit(
            CommunityError(message: 'Failed to vote on poll: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadSinglePost(
      LoadSinglePost event, Emitter<CommunityState> emit) async {
    emit(CommentsLoading(post: event.post));

    try {
      final comments = await _communityService.getPostComments(event.post.id);

      String userId = 'anonymous';
      try {
        userId = await _authRepository.getCurrentUserId();
      } catch (e) {
        developer.log('Failed to get current user ID: $e');
      }

      final userLikedCommentIds =
          await _communityService.getUserLikedCommentIds(userId);
      final commentLikecounts = await _communityService
          .getCommentLikeCounts(comments.map((c) => c.id).toList());

      for (int i = 0; i < comments.length; i++) {
        if (userLikedCommentIds.contains(comments[i].id)) {
          comments[i] = comments[i].copyWith(isLiked: true);
        }

        if (commentLikecounts.containsKey(comments[i].id)) {
          comments[i] = comments[i].copyWith(
            likeCount: commentLikecounts[comments[i].id] ?? 0,
          );
        }
      }

      emit(PostLoaded(
        post: event.post,
        comments: comments,
      ));
    } catch (e) {
      emit(CommunityError(message: 'Failed to load comments: ${e.toString()}'));
    }
  }

  Future<void> _onAddComment(
      AddComment event, Emitter<CommunityState> emit) async {
    developer.log(
        '_onAddComment event received: postId=${event.postId}, text=${event.commentText}');
    developer.log('Current state: ${state.runtimeType}');

    if (state is PostLoaded || state is CommentsLoading) {
      final post = state is PostLoaded
          ? (state as PostLoaded).post
          : (state as CommentsLoading).post;

      final currentComments = state is PostLoaded
          ? (state as PostLoaded).comments
          : <CommentModel>[];

      try {
        developer.log('Attempting to add comment...');

        final username = await _authRepository.getCurrentUserName();
        developer.log('Got username: $username');

        final comment = await _communityService.addComment(
            post.id, event.commentText, username);

        developer.log('Comment created successfully: ${comment.id}');

        final updatedComments = List<CommentModel>.from(currentComments)
          ..add(comment);

        emit(CommentAdded(
          post: post,
          comments: updatedComments,
          message: 'Comment added successfully',
        ));

        developer.log('CommentAdded state emitted');

        final refreshedComments =
            await _communityService.getPostComments(event.postId);

        developer
            .log('Comments refreshed: ${refreshedComments.length} comments');

        emit(PostLoaded(
          post: post,
          comments: refreshedComments,
        ));
      } catch (e, st) {
        developer.log('Error adding comment: $e', error: e, stackTrace: st);
        emit(CommunityError(message: 'Failed to add comment: ${e.toString()}'));

        final post = state is PostLoaded
            ? (state as PostLoaded).post
            : (state as CommentsLoading).post;
        final currentComments = state is PostLoaded
            ? (state as PostLoaded).comments
            : <CommentModel>[];

        emit(PostLoaded(
          post: post,
          comments: currentComments,
        ));
      }
    } else {
      developer.log(
          'ERROR: Cannot add comment - current state is ${state.runtimeType}. Need to load the post first.');
      emit(CommunityError(
          message: 'Please load the post first before adding comments'));
    }
  }

  Future<void> _onLoadComments(
      LoadComments event, Emitter<CommunityState> emit) async {
    if (state is PostLoaded || state is CommentsLoading) {
      final post = state is PostLoaded
          ? (state as PostLoaded).post
          : (state as CommentsLoading).post;

      try {
        emit(CommentsLoading(post: post));

        final comments = await _communityService.getPostComments(event.postId);

        String userId = 'anonymous';
        try {
          userId = await _authRepository.getCurrentUserId();
        } catch (e) {
          developer.log('Failed to get current user ID: $e');
        }

        final userLikedCommentIds =
            await _communityService.getUserLikedCommentIds(userId);
        final commentLikecounts = await _communityService
            .getCommentLikeCounts(comments.map((c) => c.id).toList());

        for (int i = 0; i < comments.length; i++) {
          if (userLikedCommentIds.contains(comments[i].id)) {
            comments[i] = comments[i].copyWith(isLiked: true);
          }

          if (commentLikecounts.containsKey(comments[i].id)) {
            comments[i] = comments[i].copyWith(
              likeCount: commentLikecounts[comments[i].id] ?? 0,
            );
          }
        }

        emit(PostLoaded(
          post: post,
          comments: comments,
        ));
      } catch (e) {
        emit(CommunityError(
            message: 'Failed to load comments: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFetchCommunityPosts(
      FetchCommunityPosts event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());

    try {
      final posts = await _communityService.getPosts(
        limit: event.limit,
        sortByLatest: event.sortByLatest,
      );

      String userId = 'anonymous';
      try {
        userId = await _authRepository.getCurrentUserId();
      } catch (e) {
        developer.log('Failed to get current user ID: $e');
      }

      Set<String> likedPostIds = {};
      if (userId != 'anonymous') {
        final likedPosts = await _communityService.getUserLikedPosts(userId);
        likedPostIds = likedPosts.map((post) => post.id).toSet();

        for (int i = 0; i < posts.length; i++) {
          if (likedPostIds.contains(posts[i].id)) {
            posts[i] = posts[i].copyWith(isLiked: true);
          }
        }
      }

      emit(CommunityLoaded(
        posts: posts,
        likedPosts: likedPostIds,
      ));
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  Future<void> _onToggleCommentLike(
      ToggleCommentLike event, Emitter<CommunityState> emit) async {
    if (state is! PostLoaded) {
      emit(CommunityError(message: 'Comments not loaded'));
      return;
    }

    try {
      final userId = await _authRepository.getCurrentUserId();
      if (userId == 'anonymous') {
        emit(CommunityError(message: 'Please log in to like comments'));
        return;
      }

      final currentState = state as PostLoaded;
      final post = currentState.post;
      final comments = currentState.comments;
      final commentIndex = comments.indexWhere((c) => c.id == event.commentId);

      if (commentIndex == -1) {
        emit(CommunityError(message: 'Comment not found'));
        emit(currentState);
        return;
      }

      final comment = comments[commentIndex];
      final isLiked = comment.isLiked;
      final updatedComments = List<CommentModel>.from(comments);
      updatedComments[commentIndex] = comment.copyWith(
        isLiked: !isLiked,
        likeCount: comment.likeCount + (isLiked ? -1 : 1),
      );

      if (isLiked) {
        await _communityService.unlikeComment(userId, event.commentId);
      } else {
        await _communityService.likeComment(userId, event.commentId);
      }

      emit(PostLoaded(
        post: post,
        comments: updatedComments,
      ));
    } catch (e) {
      emit(CommunityError(
          message: 'Failed to toggle comment like: ${e.toString()}'));
    }
  }

  Future<void> _onTogglePostLike(
      TogglePostLike event, Emitter<CommunityState> emit) async {
    try {
      final userId = await _authRepository.getCurrentUserId();

      if (userId == 'anonymous') {
        emit(CommunityError(message: 'Please log in to like posts'));
        return;
      }

      if (state is CommunityLoaded) {
        final currentState = state as CommunityLoaded;
        final posts = currentState.posts;
        final likedPosts = currentState.likedPosts;

        final postIndex = posts.indexWhere((p) => p.id == event.postId);
        if (postIndex == -1) {
          emit(CommunityError(message: 'Post not found'));
          return;
        }

        final post = posts[postIndex];
        final isLiked = post.isLiked;

        final updatedPosts = List<PostModel>.from(posts);
        updatedPosts[postIndex] = post.copyWith(
          isLiked: !isLiked,
          likeCount: post.likeCount + (isLiked ? -1 : 1),
        );

        final updatedLikedPosts = Set<String>.from(likedPosts);
        if (isLiked) {
          updatedLikedPosts.remove(event.postId);
        } else {
          updatedLikedPosts.add(event.postId);
        }

        emit(CommunityLoaded(
          posts: updatedPosts,
          likedPosts: updatedLikedPosts,
        ));

        if (isLiked) {
          await _communityService.unlikePost(userId, event.postId);
        } else {
          await _communityService.likePost(userId, event.postId);
        }
      } else if (state is PostLoaded) {
        final currentState = state as PostLoaded;
        final post = currentState.post;
        final comments = currentState.comments;

        final isLiked = post.isLiked;

        final updatedPost = post.copyWith(
          isLiked: !isLiked,
          likeCount: post.likeCount + (isLiked ? -1 : 1),
        );

        emit(PostLoaded(
          post: updatedPost,
          comments: comments,
        ));

        try {
          if (isLiked) {
            await _communityService.unlikePost(userId, event.postId);
          } else {
            await _communityService.likePost(userId, event.postId);
          }
          developer.log('Post like toggled successfully');
        } catch (e) {
          developer.log('Error toggling post like: $e');
          emit(PostLoaded(
            post: post,
            comments: comments,
          ));
          emit(CommunityError(
              message: 'Failed to update like: ${e.toString()}'));
        }
      } else {
        emit(CommunityError(message: 'Post view not loaded'));
      }
    } catch (e) {
      emit(CommunityError(
          message: 'Failed to toggle post like: ${e.toString()}'));
    }
  }
}
