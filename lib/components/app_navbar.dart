import 'package:flutter/material.dart';
import 'package:taralibrary/utils/colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String greetingMessage;
  final String libraryName;
  final String avatarImagePath;

  const CustomAppBar({
    super.key,
    this.greetingMessage = 'Good Morning, Kian!',
    this.libraryName = 'KEPLRC Library',
    this.avatarImagePath = 'assets/images/avatar.jpg',
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      elevation: 4,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.greetingMessage,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          widget.libraryName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement profile tap functionality
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 5.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 22.0,
                        backgroundImage: AssetImage(widget.avatarImagePath),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
