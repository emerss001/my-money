import 'package:flutter/material.dart';

class AvatarProfile extends StatelessWidget {
  final String avatarUrl;
  final VoidCallback onCameraTap;

  const AvatarProfile({
    super.key,
    required this.avatarUrl,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00875F);

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF202024),
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 58,
                backgroundColor: const Color(0xFF323238),
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 58, color: Colors.white54)
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onCameraTap,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF121214), width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
