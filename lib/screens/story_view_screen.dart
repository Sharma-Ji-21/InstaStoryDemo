import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/users_story_bundle_model.dart';
import 'home_screen.dart';

class StoryViewScreen extends StatefulWidget {
  final List<UserStoryBundle> allUserStories;
  final int initialUserIndex;

  const StoryViewScreen({
    super.key,
    required this.allUserStories,
    required this.initialUserIndex,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with TickerProviderStateMixin {
  late PageController userPageController;
  late PageController storyPageController;
  late AnimationController progressController;

  int currentUserIndex = 0;
  int currentStoryIndex = 0;
  bool isProgressing = true;
  List<bool> storyLoadingStatus = [];

  @override
  void initState() {
    super.initState();
    currentUserIndex = widget.initialUserIndex;
    userPageController = PageController(initialPage: currentUserIndex);
    storyPageController = PageController();
    progressController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);

    final currentUser = widget.allUserStories[currentUserIndex];
    storyLoadingStatus =
        List.generate(currentUser.story.stories.length, (_) => true);

    startStoryProgress();
  }

  void startStoryProgress() {
    if (!isProgressing) return;

    progressController.reset();
    progressController.forward().then((_) {
      if (mounted && isProgressing) {
        nextStory();
      }
    });
  }

  void nextStory() {
    final currentUser = widget.allUserStories[currentUserIndex];

    if (currentStoryIndex < currentUser.story.stories.length - 1) {
      setState(() {
        currentStoryIndex++;
        // Ensure storyLoadingStatus has an entry for the new index
        if (storyLoadingStatus.length <= currentStoryIndex) {
          storyLoadingStatus.add(true);
        }
      });
      storyPageController.jumpToPage(currentStoryIndex);
      startStoryProgress();
    } else {
      nextUser();
    }
  }

  void previousStory() {
    if (currentStoryIndex > 0) {
      setState(() {
        currentStoryIndex--;
        // Just in case (though likely already exists)
        if (storyLoadingStatus.length <= currentStoryIndex) {
          storyLoadingStatus.add(true);
        }
      });
      storyPageController.jumpToPage(currentStoryIndex);
      startStoryProgress();
    } else {
      previousUser();
    }
  }

  void nextUser() {
    if (currentUserIndex < widget.allUserStories.length - 1) {
      setState(() {
        currentUserIndex++;
        currentStoryIndex = 0;
        final user = widget.allUserStories[currentUserIndex];
        storyLoadingStatus =
            List.generate(user.story.stories.length, (_) => true);
      });
      userPageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      storyPageController = PageController();
      startStoryProgress();
    } else {
      goToHome();
    }
  }

  void previousUser() {
    if (currentUserIndex > 0) {
      setState(() {
        currentUserIndex--;
        currentStoryIndex = 0;
        final user = widget.allUserStories[currentUserIndex];
        storyLoadingStatus =
            List.generate(user.story.stories.length, (_) => true);
      });
      userPageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      storyPageController = PageController(initialPage: currentStoryIndex);
      startStoryProgress();
    } else {
      goToHome();
    }
  }

  void goToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void pauseStory() {
    setState(() {
      isProgressing = false;
    });
    progressController.stop();
  }

  void resumeStory() {
    setState(() {
      isProgressing = true;
    });
    progressController.forward();
  }

  @override
  void dispose() {
    userPageController.dispose();
    storyPageController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => pauseStory(),
        onTapUp: (details) {
          resumeStory();

          final screenWidth = MediaQuery.of(context).size.width;
          final tapPosition = details.globalPosition.dx;

          if (tapPosition < screenWidth * 0.3) {
            previousStory();
          } else if (tapPosition > screenWidth * 0.7) {
            nextStory();
          }
        },
        onTapCancel: () => resumeStory(),
        child: PageView.builder(
          controller: userPageController,
          onPageChanged: (userIndex) {
            setState(() {
              currentUserIndex = userIndex;
              currentStoryIndex = 0;
              final user = widget.allUserStories[userIndex];
              storyLoadingStatus =
                  List.generate(user.story.stories.length, (_) => true);
            });
            storyPageController = PageController();
            startStoryProgress();
          },
          itemCount: widget.allUserStories.length,
          itemBuilder: (context, userIndex) {
            final user = widget.allUserStories[userIndex];
            var name = user.profile.userName;
            if (name == "User_0") {
              name = "Your Story";
            }

            return Stack(
              children: [
                // Story Images
                PageView.builder(
                  controller: userIndex == currentUserIndex
                      ? storyPageController
                      : PageController(),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: user.story.stories.length,
                  itemBuilder: (context, storyIndex) {
                    final imageUrl = user.story.stories[storyIndex];
                    final isLoading = (storyLoadingStatus.length > storyIndex &&
                        storyLoadingStatus[storyIndex] != false);
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              if (frame == null) {
                                return const SizedBox();
                              } else {
                                if (isLoading) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {
                                        storyLoadingStatus[storyIndex] = false;
                                      });
                                    }
                                  });
                                }
                                return child;
                              }
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(Icons.error, color: Colors.white),
                            ),
                          ),
                        ),
                        if (isLoading)
                          const Positioned.fill(
                            child: ColoredBox(
                              color: Colors.black,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Progress Indicators
                Positioned(
                  top: 50,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: List.generate(
                      user.story.stories.length,
                      (index) => Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: userIndex == currentUserIndex
                              ? AnimatedBuilder(
                                  animation: progressController,
                                  builder: (context, child) {
                                    double progress = 0.0;
                                    if (index < currentStoryIndex) {
                                      progress = 1.0;
                                    } else if (index == currentStoryIndex) {
                                      progress = progressController.value;
                                    }

                                    return LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.transparent,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    );
                                  },
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),

                // User Info
                Positioned(
                  top: 70,
                  left: 12,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage(user.profile.profileImageUrl),
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
                Positioned(
                  top: 60,
                  right: 12,
                  child: IconButton(
                    onPressed: goToHome,
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
