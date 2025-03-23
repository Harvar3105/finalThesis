import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/domain/user.dart';
import '../../../../app/services/providers.dart';


part 'custom_app_bar_view_model.g.dart';

@riverpod
class CustomAppBarViewModel extends _$CustomAppBarViewModel {
  @override
  Future<User?> build() async {
    final userService = ref.watch(userServiceProvider);
    return await userService.getCurrentUser();
  }
}