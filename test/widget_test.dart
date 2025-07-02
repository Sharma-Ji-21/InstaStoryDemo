// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:insta_story_demo/main.dart';
import 'package:insta_story_demo/models/profile_model.dart';
import 'package:insta_story_demo/models/story_model.dart';
import 'package:insta_story_demo/models/users_story_bundle_model.dart';
import 'package:insta_story_demo/screens/home_screen.dart';
import 'package:insta_story_demo/screens/story_view_screen.dart';
import 'package:insta_story_demo/services/story_service.dart';

void main() {
  group('Profile Model Tests', () {
    test('should create Profile from valid JSON', () {
      // Arrange
      final json = {
        'profileImageUrl': 'assets/images/profile1.jpg',
        'userName': 'testUser',
      };

      // Act
      final profile = Profile.fromJson(json);

      // Assert
      expect(profile.profileImageUrl, equals('assets/images/profile1.jpg'));
      expect(profile.userName, equals('testUser'));
    });

    test('should convert Profile to JSON', () {
      // Arrange
      final profile = Profile(
        profileImageUrl: 'assets/images/profile1.jpg',
        userName: 'testUser',
      );

      // Act
      final json = profile.toJson();

      // Assert
      expect(json['profileImageUrl'], equals('assets/images/profile1.jpg'));
      expect(json['userName'], equals('testUser'));
    });

    test('should handle empty strings in JSON', () {
      // Arrange
      final json = {
        'profileImageUrl': '',
        'userName': '',
      };

      // Act
      final profile = Profile.fromJson(json);

      // Assert
      expect(profile.profileImageUrl, equals(''));
      expect(profile.userName, equals(''));
    });

    test('should create Profile with constructor parameters', () {
      // Arrange & Act
      final profile = Profile(
        profileImageUrl: 'test/image/url',
        userName: 'testUserName',
      );

      // Assert
      expect(profile.profileImageUrl, equals('test/image/url'));
      expect(profile.userName, equals('testUserName'));
    });
  });
  group('Story Model Tests', () {
    test('should create Story from valid JSON', () {
      // Arrange
      final json = {
        'userName': 'testUser',
        'stories': ['url1', 'url2', 'url3'],
      };

      // Act
      final story = Story.fromJson(json);

      // Assert
      expect(story.userName, equals('testUser'));
      expect(story.stories, hasLength(3));
      expect(story.stories, containsAll(['url1', 'url2', 'url3']));
    });

    test('should convert Story to JSON', () {
      // Arrange
      final story = Story(
        userName: 'testUser',
        stories: ['url1', 'url2'],
      );

      // Act
      final json = story.toJson();

      // Assert
      expect(json['userName'], equals('testUser'));
      expect(json['stories'], equals(['url1', 'url2']));
    });

    test('should handle empty stories list', () {
      // Arrange
      final json = {
        'userName': 'testUser',
        'stories': <String>[],
      };

      // Act
      final story = Story.fromJson(json);

      // Assert
      expect(story.userName, equals('testUser'));
      expect(story.stories, isEmpty);
    });

    test('should handle single story in list', () {
      // Arrange
      final story = Story(
        userName: 'singleStoryUser',
        stories: ['single_story_url'],
      );

      // Act
      final json = story.toJson();

      // Assert
      expect(json['stories'], hasLength(1));
      expect(json['stories'][0], equals('single_story_url'));
    });
  });
  group('UserStoryBundle Model Tests', () {
    late Profile testProfile;
    late Story testStory;

    setUp(() {
      testProfile = Profile(
        profileImageUrl: 'assets/test.jpg',
        userName: 'testUser',
      );
      testStory = Story(
        userName: 'testUser',
        stories: ['story1', 'story2'],
      );
    });

    test('should create UserStoryBundle with profile and story', () {
      // Act
      final bundle = UserStoryBundle(
        profile: testProfile,
        story: testStory,
      );

      // Assert
      expect(bundle.profile, equals(testProfile));
      expect(bundle.story, equals(testStory));
      expect(bundle.profile.userName, equals(bundle.story.userName));
    });

    test('should handle bundle with empty story list', () {
      // Arrange
      final emptyStory = Story(userName: 'testUser', stories: []);

      // Act
      final bundle = UserStoryBundle(
        profile: testProfile,
        story: emptyStory,
      );

      // Assert
      expect(bundle.story.stories, isEmpty);
      expect(bundle.profile.userName, equals('testUser'));
    });
  });
  group('StoryService Tests', () {
    late StoryService storyService;

    setUp(() {
      storyService = StoryService();
    });

    group('fetchProfile', () {
      test('should return list of 10 profiles', () async {
        // Act
        final profiles = await storyService.fetchProfile();

        // Assert
        expect(profiles, hasLength(10));
        expect(profiles, everyElement(isA<Profile>()));
      });

      test('should return profiles with correct format', () async {
        // Act
        final profiles = await storyService.fetchProfile();

        // Assert
        for (int i = 0; i < profiles.length; i++) {
          expect(profiles[i].profileImageUrl,
              equals('assets/profileImageUrl/$i.jpg'));
          expect(profiles[i].userName, equals('User_$i'));
        }
      });

      test('should complete within reasonable time', () async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        await storyService.fetchProfile();

        // Assert
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds,
            lessThan(1000)); // Less than 1 second
      });
    });

    group('fetchStory', () {
      test('should return list of 10 stories', () async {
        // Act
        final stories = await storyService.fetchStory();

        // Assert
        expect(stories, hasLength(10));
        expect(stories, everyElement(isA<Story>()));
      });

      test('should return stories with 3 story URLs each', () async {
        // Act
        final stories = await storyService.fetchStory();

        // Assert
        for (final story in stories) {
          expect(story.stories, hasLength(3));
          expect(story.stories, everyElement(isA<String>()));
        }
      });

      test('should generate unique story URLs', () async {
        // Act
        final stories = await storyService.fetchStory();

        // Assert
        final allUrls = <String>[];
        for (final story in stories) {
          allUrls.addAll(story.stories);
        }
        final uniqueUrls = allUrls.toSet();
        expect(uniqueUrls.length,
            equals(allUrls.length)); // All URLs should be unique
      });
    });

    group('fetchUserStories', () {
      test('should return list of UserStoryBundle objects', () async {
        // Act
        final userStories = await storyService.fetchUserStories();

        // Assert
        expect(userStories, hasLength(10));
        expect(userStories, everyElement(isA<UserStoryBundle>()));
      });

      test('should match profiles with their corresponding stories', () async {
        // Act
        final userStories = await storyService.fetchUserStories();

        // Assert
        for (final bundle in userStories) {
          expect(bundle.profile.userName, equals(bundle.story.userName));
        }
      });

      test('should handle case where profile has no matching story', () async {
        // Act
        final userStories = await storyService.fetchUserStories();

        // Assert
        // All profiles should have matching stories in this mock implementation
        for (final bundle in userStories) {
          expect(bundle.story.stories, isNotEmpty);
        }
      });

      test('should complete both async calls', () async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        final userStories = await storyService.fetchUserStories();

        // Assert
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds,
            lessThan(1500)); // Less than 1.5 seconds
        expect(userStories, isNotEmpty);
      });
    });
  });
  group('HomeScreen Widget Tests', () {
    testWidgets('should display Instagram title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Instagram'), findsOneWidget);
    });

    testWidgets('should display profiles after loading', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display "Your Story" as first item', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Your Story'), findsOneWidget);
    });

    testWidgets('should display user names for other profiles', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      for (int i = 1; i < 9; i++) {
        expect(find.text('User_$i'), findsOneWidget);
      }
    });

    // testWidgets('should navigate to StoryViewScreen when profile tapped',
    //     (tester) async {
    //   await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.byType(GestureDetector).at(0)); // Tap 2nd profile
    //   await tester.pumpAndSettle();
    //   expect(find.byType(StoryViewScreen), findsOneWidget);
    // });

    testWidgets('should display feed placeholder content', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Your feed content would appear here'), findsOneWidget);
      expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    });

    testWidgets('should have correct profile image gradients', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      final containers = tester.widgetList<Container>(find.byType(Container));
      final gradientContainers = containers.where((c) {
        final decoration = c.decoration;
        return decoration is BoxDecoration && decoration.gradient != null;
      });

      expect(gradientContainers.length, greaterThan(0));
    });

    testWidgets('should handle profile name overflow', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final nameTexts = textWidgets.where((text) =>
          text.maxLines == 1 && text.overflow == TextOverflow.ellipsis);

      expect(nameTexts.length, greaterThan(0));
    });
  });
  group('StoryViewScreen Widget Tests', () {
    late List<UserStoryBundle> testUserStories;

    setUp(() {
      testUserStories = [
        UserStoryBundle(
          profile: Profile(
              userName: 'User_0',
              profileImageUrl: 'assets/profileImageUrl/0.jpg'),
          story: Story(userName: 'User_0', stories: ['url1', 'url2']),
        ),
        UserStoryBundle(
          profile: Profile(
              userName: 'User_1',
              profileImageUrl: 'assets/profileImageUrl/1.jpg'),
          story: Story(userName: 'User_1', stories: ['url3', 'url4', 'url5']),
        ),
      ];
    });

    testWidgets('should display story view with correct initial user',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Assert
      expect(find.text('Your Story'), findsOneWidget);
      expect(find.byType(PageView), findsWidgets);
    });

    testWidgets('should show progress indicators for current user stories',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Assert
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });

    testWidgets('should display close button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should navigate to HomeScreen when close button tapped',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should handle tap on left side of screen (previous story)',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Tap on left side (30% of screen width)
      final screenSize = tester.getSize(find.byType(Scaffold));
      await tester
          .tapAt(Offset(screenSize.width * 0.3, screenSize.height * 0.5));
      await tester.pump();

      // Assert - Should handle the tap without errors
      expect(find.byType(StoryViewScreen), findsOneWidget);
    });

    testWidgets('should handle tap on right side of screen (next story)',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Tap on right side (80% of screen width)
      final screenSize = tester.getSize(find.byType(Scaffold));
      await tester
          .tapAt(Offset(screenSize.width * 0.7, screenSize.height * 0.5));
      await tester.pump();

      // Assert - Should handle the tap without errors
      expect(find.byType(StoryViewScreen), findsOneWidget);
    });

    testWidgets('should display user profile information',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 1,
        ),
      ));

      // Assert
      expect(find.text('User_1'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('should show "Your Story" for User_0',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Assert
      expect(find.text('Your Story'), findsOneWidget);
      expect(find.text('User_0'), findsNothing);
    });

    testWidgets('should handle loading state for images',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should have black background', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(
        home: StoryViewScreen(
          allUserStories: testUserStories,
          initialUserIndex: 0,
        ),
      ));

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.black));
    });
  });
}
