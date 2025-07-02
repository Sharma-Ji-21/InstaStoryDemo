class Story {
  final String userName;
  final List<String> stories;

  Story({
    required this.userName,
    required this.stories,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      userName: json['userName'],
      stories: List<String>.from(json['stories']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'stories': stories,
    };
  }
}
