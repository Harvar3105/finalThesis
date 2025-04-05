
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/typedefs/e_role.dart';
import '../../../../app/typedefs/e_sorting_order.dart';
import '../../../../app/typedefs/entity.dart';
import '../../../../data/domain/user.dart';
import '../../../../app/services/providers.dart';

part 'user_search_view_model.g.dart';

@riverpod
class UserSearchViewModel extends _$UserSearchViewModel {
  @override
  FutureOr<List<User>?> build() async => [];

  Future<void> searchUsers({
    required String query,
    required int selectedIndex,
    required Id userId,
    required ERole role,
    required ESortingOrder sortingOrder,
  }) async {
    state = const AsyncValue.loading();

    try {
      final userService = ref.watch(userServiceProvider);
      final users = await userService.searchUsersByName(
        query, selectedIndex, userId, role, sortingOrder,
      );
      state = AsyncValue.data(users);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearSearch() {
    state = const AsyncValue.data(null);
  }
}