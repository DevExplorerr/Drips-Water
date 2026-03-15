import 'package:drips_water/data/models/card_model.dart';
import 'package:drips_water/data/repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

  Future<Map<String, dynamic>?> getUserData(String uid) {
    return _userRepository.fetchUserData(uid);
  }

  Future<void> saveUserCard(String uid, CardModel card) async {
    try {
      await _userRepository.setUserCard(uid, card);
    } catch (e) {
      throw Exception('Failed to save card: $e');
    }
  }
}
