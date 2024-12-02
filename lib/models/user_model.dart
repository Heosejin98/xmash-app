class UserModel {
  final String userId;
  final String userName;
  final String profileUrl;
  
  UserModel({
    required this.userId,
    required this.userName,
    required this.profileUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      profileUrl: json['profileUrl'] as String,
    );
  }
} 