class Profile {
  final String profileImageUrl;
  final String userName;

  Profile({
    required this.userName,
    required this.profileImageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileImageUrl: json['profileImageUrl'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileImageUrl': profileImageUrl,
      'userName': userName,
    };
  }
}
