import 'package:insta_story_demo/models/profile_model.dart';
import 'package:insta_story_demo/models/story_model.dart';

class UserStoryBundle {
  final Profile profile;
  final Story story;

  UserStoryBundle({
    required this.profile,
    required this.story,
  });
}
