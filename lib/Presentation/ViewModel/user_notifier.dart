import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:profile_explorer/Data/Model/user_model.dart';
import 'package:profile_explorer/Data/Services/api_services.dart';



class UserNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
 
  UserNotifier(this._userService) : super(const AsyncValue.loading()) {
    fetchUsers(); 
  }

  final UserService _userService;


  Future<void> fetchUsers() async {
    try {
     
      state = const AsyncValue.loading();
      
      final users = await _userService.fetchUsers();
      
     
      state = AsyncValue.data(users);
    } catch (e, stack) {
    
      state = AsyncValue.error(e, stack);
    }
  }


  void toggleFavorite(String userId) {
    if (state.value == null) return;

    
    final updatedList = state.value!.map((user) {
      if (user.id == userId) {
        
        return user.copyWith(isFavorite: !user.isFavorite);
      }
      return user;
    }).toList();

   
    state = AsyncValue.data(updatedList);
  }
}


final userServiceProvider = Provider((ref) => UserService());

final userListProvider = StateNotifierProvider<UserNotifier, AsyncValue<List<UserModel>>>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserNotifier(userService);
  
});

