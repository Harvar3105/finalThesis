import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'loading.g.dart';

// TODO(all): Will add more providers here later
@riverpod
bool isLoading(Ref ref) {
  final authProvider = ref.watch(authenticationProvider);
  // final isImageUploading = ref.watch(imageUploadProvider);
  // final isSendingComment = ref.watch(sendCommentProvider);
  // final isDeletingComment = ref.watch(deleteCommentProvider);
  // final isDeletingPost = ref.watch(deletePostProvider);

  // return authProvider.isLoading ||
  //     isImageUploading ||
  //     isSendingComment ||
  //     isDeletingComment ||
  //     isDeletingPost;

  return authProvider.isLoading;
}
