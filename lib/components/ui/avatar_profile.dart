import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_money/repository/user_repository.dart';
import 'dart:io';

class AvatarProfile extends StatefulWidget {
  final String avatarUrl;
  final VoidCallback? onImageUpdated;

  const AvatarProfile({
    super.key,
    required this.avatarUrl,
    this.onImageUpdated,
  });

  @override
  State<AvatarProfile> createState() => _AvatarProfileState();
}

class _AvatarProfileState extends State<AvatarProfile> {
  bool _isLoading = false;

  Future<void> onCameraTap() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final UserRepository userRepository = UserRepository();
        await userRepository.atualizarImagemPerfil(File(image.path));

        if (widget.onImageUpdated != null) {
          widget.onImageUpdated!();
        }
        print("Imagem atualizada com sucesso");
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
              border: Border.all(
                color: primaryColor,
                width: _isLoading ? 0 : 2,
              ),
            ),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: primaryColor)
                  : CircleAvatar(
                      radius: 58,
                      backgroundColor: const Color(0xFF323238),
                      backgroundImage: widget.avatarUrl.isNotEmpty
                          ? NetworkImage(widget.avatarUrl)
                          : null,
                      child: widget.avatarUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 58,
                              color: Colors.white54,
                            )
                          : null,
                    ),
            ),
          ),
          if (!_isLoading)
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
                    border: Border.all(
                      color: const Color(0xFF121214),
                      width: 3,
                    ),
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
