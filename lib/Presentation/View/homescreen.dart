import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:profile_explorer/Data/Model/user_model.dart';
import 'package:profile_explorer/Presentation/View/profilescreen.dart';
import 'package:profile_explorer/Presentation/ViewModel/user_notifier.dart';



class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    final userListAsyncValue = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Explorer"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: userListAsyncValue.when(
       
        loading: () => const Center(child: CircularProgressIndicator()),

       
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),

       
        data: (users) {
        
          return RefreshIndicator(
            onRefresh: () => ref.read(userListProvider.notifier).fetchUsers(),
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: 0.75, 
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _ProfileGridItem(user: user);
              },
            ),
          );
        },
      ),
    );
  }
}


class _ProfileGridItem extends ConsumerWidget {
  final UserModel user;
  const _ProfileGridItem({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileDetailScreen(user: user),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
             
              Hero(
                tag: 'profileImage${user.id}',
                child: CachedNetworkImage(
                  imageUrl: user.imageUrl,
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  fit: BoxFit.cover,
                 
                  placeholder: (context, url) => Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()), 
                  ),
                  
                  errorWidget: (context, url, error) => Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    color: Colors.red[100],
                    child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.red)), 
                  ),
              ),
              ),
 
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),

             
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.firstName}, ${user.age}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.city,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    GestureDetector(
                      onTap: () {
                       
                        ref
                            .read(userListProvider.notifier)
                            .toggleFavorite(user.id);
                      },
                      child: Icon(
                        user.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 30,
                        color: user.isFavorite
                            ? Colors.redAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
