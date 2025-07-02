import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_story_demo/screens/story_view_screen.dart';

import '../models/profile_model.dart';
import '../models/story_model.dart';
import '../models/users_story_bundle_model.dart';
import '../services/story_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Profile> profiles = [];
  List<UserStoryBundle> allUserStories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  void fetchProfiles() async {
    List<UserStoryBundle> fetchedUserStories =
        await StoryService().fetchUserStories();

    setState(() {
      allUserStories = fetchedUserStories;
      profiles = fetchedUserStories.map((bundle) => bundle.profile).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),
              child: Text(
                "Instagram",
                style: TextStyle(
                  fontSize: 49,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Scriptorial',
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: width,
              height: 125,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      itemCount: profiles.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        var name = profile.userName;
                        if (index == 0) {
                          name = "Your Story";
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          StoryViewScreen(
                                        allUserStories: allUserStories,
                                        initialUserIndex: index,
                                      ),
                                      transitionDuration:
                                          Duration(milliseconds: 800),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(-1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;

                                        final tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        final offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple,
                                        Colors.red,
                                        Colors.orange
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(3),
                                  child: CircleAvatar(
                                    radius: 37,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage:
                                          AssetImage(profile.profileImageUrl),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              height: 1,
              color: Colors.grey[200],
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_outlined,
                        size: 60, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'Your feed content would appear here',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
