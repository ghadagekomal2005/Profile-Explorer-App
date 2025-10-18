import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Add dependency
import 'package:profile_explorer/Data/Model/user_model.dart';
import 'package:profile_explorer/Presentation/ViewModel/user_notifier.dart';



class ProfileDetailScreen extends ConsumerWidget {
  final UserModel user;

  const ProfileDetailScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final currentUserState = ref.watch(userListProvider).value?.firstWhere((u) => u.id == user.id);
    final isFavorite = currentUserState?.isFavorite ?? user.isFavorite;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Stack(
              children: [
                
                Hero(
                  tag: 'profileImage${user.id}',
                  child: CachedNetworkImage(
                    imageUrl: user.imageUrl,
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                
               
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.65),
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${user.firstName}, ${user.age}",
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  user.city,
                                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            
                            
                            GestureDetector(
                              onTap: () {
                               
                                ref.read(userListProvider.notifier).toggleFavorite(user.id);
                              },
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: 40,
                                color: isFavorite ? Colors.redAccent : Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        
                       
                        
                       
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

