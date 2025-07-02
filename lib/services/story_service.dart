import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:insta_story_demo/models/story_model.dart';

import '../models/profile_model.dart';
import '../models/users_story_bundle_model.dart';

class StoryService {
  Future<List<Profile>> fetchProfile() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    List<Map<String, dynamic>> mockData = List.generate(
      10,
      (index) => {
        "profileImageUrl": 'assets/profileImageUrl/$index.jpg',
        "userName": "User_${index}",
      },
    );

    return mockData.map((data) => Profile.fromJson(data)).toList();
  }

  Future<List<Story>> fetchStory() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    List<Map<String, dynamic>> mockData = List.generate(
      10,
      (index) => {
        "userName": "User_${index}",
        "stories": List.generate(
          3,
          (i) => 'https://picsum.photos/500/800?random=${index * 3 + i}',
        ),
      },
    );

    return mockData.map((data) => Story.fromJson(data)).toList();
  }

  Future<List<UserStoryBundle>> fetchUserStories() async {
    final profiles = await fetchProfile();
    final stories = await fetchStory();

    return profiles.map((profile) {
      final userStory = stories.firstWhere(
        (story) => story.userName == profile.userName,
        orElse: () => Story(userName: profile.userName, stories: []),
      );
      return UserStoryBundle(profile: profile, story: userStory);
    }).toList();
  }
}
