import '../../../data/domain/user.dart';
import '../../../data/repositories/user/user_storage.dart';
import '../../typedefs/e_role.dart';
import '../../typedefs/e_sorting_order.dart';
import '../../typedefs/entity.dart';

class UserService {
  final UserStorage _userStorage;

  UserService(this._userStorage);

  Future<User?> getCurrentUser() async {
    return (await _userStorage.getCurrentUser())?.userFromPayload();
  }

  Future<User?> getUserById(String id) async {
    return (await _userStorage.gerUserById(id))?.userFromPayload();
  }

  Future<List<User>?> getAllUsers() async {
    return (await _userStorage.getAllUsers())
        ?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }

  Future<List<User>?> getUsersByIds(Set<String> ids) async {
    return (await _userStorage.getUsersByIds(ids))
        ?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }

  Future<List<User>?> getUsersFriends(User user) async {
    return (await _userStorage.getUsersFriends(UserPayload().userToPayload(user)))
        ?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }

  Future<bool> saveOrUpdateUser(User user) async {
    return await _userStorage.saveOrUpdateUserInfo(UserPayload().userToPayload(user));
  }

  Future<bool> deleteUserPicture(User user) async {
    return await _userStorage.deleteUserPicture(UserPayload().userToPayload(user));
  }

  Future<List<User>?> searchUsersByName(
      String searchingSubstring,
      int type,
      Id currentUserId,
      ERole role,
      ESortingOrder sortingOrder,
      ) async {
    return (await _userStorage.searchUsersByName(
      searchingSubstring,
      type,
      currentUserId,
      role,
      sortingOrder,
      ))?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }
}