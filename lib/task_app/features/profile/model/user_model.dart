//Abstract class. Closed to modification.
abstract class UserProfileModel {
  final String userId;
  final String displayName;
  final String email;
  final String joined;

  UserProfileModel(
      {required this.userId,
      required this.displayName,
      required this.email,
      required this.joined});
}

//App User. This can be modified in future in case of new user features.
class UserProfile extends UserProfileModel {
  final bool isEmailVerified;
  UserProfile({
    required this.isEmailVerified,
    required super.userId,
    required super.displayName,
    required super.email,
    required super.joined,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'createdAt': joined,
      'emailVerified': isEmailVerified
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      displayName: json['displayName'] ?? '',
      joined: json['createdAt'] ?? '',
      email: json['email'] ?? '', 
      isEmailVerified:json['emailVerified']  ?? false,
    );
  }
}
