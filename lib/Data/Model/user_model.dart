

class UserModel {
  final String
  id; 
  final String firstName;
  final int age;
  final String city;
  final String imageUrl;
  bool isFavorite;

  UserModel({
    required this.id,
    required this.firstName,
    required this.age,
    required this.city,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    
    
    return UserModel(
     
      id: "${json['name']['first']}-${json['location']['city']}",
      firstName: json['name']['first'] ?? 'N/A',
      age: json['dob']['age'] ?? 0,
      city: json['location']['city'] ?? 'Unknown',
      imageUrl:
          (json['picture']['large'] != null &&
              (json['picture']['large'] as String).isNotEmpty)
          ? json['picture']['large']
          : 'https://via.placeholder.com/300',
          
      

    
      isFavorite: false,
      
    );
   
  } 
  UserModel copyWith({bool? isFavorite}) {
     print("Loading URL: $imageUrl");
    return UserModel(
      id: this.id,
      firstName: this.firstName,
      age: this.age,
      city: this.city,
      imageUrl: this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  
}
