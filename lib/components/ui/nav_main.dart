import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_money/repository/user_repository.dart';

class NavBarMain extends StatefulWidget {
  const NavBarMain({super.key});

  @override
  State<NavBarMain> createState() => _NavBarMainState();
}

class _NavBarMainState extends State<NavBarMain> {
  final UserRepository _userRepository = UserRepository();
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final url = await _userRepository.obterImagemPerfil();
      if (mounted) {
        setState(() {
          _imageUrl = url;
        });
      }
    } catch (e) {
      print('Erro ao carregar imagem: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo e Perfil
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'lib/assets/images/logo.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'DT Money',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE1E1E6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/profile');
                  if (result == true) {
                    _loadProfileImage();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFF323238),
                        backgroundImage: _imageUrl.isNotEmpty
                            ? NetworkImage(_imageUrl)
                            : null,
                        child: _imageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.white54,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      // TODO: Substituir por nome do usuário real
                      const Text(
                        'Olá, Emerson',
                        style: TextStyle(
                          color: Color(0xFFC4C4CC),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Botão Nova Transação
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00875F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Nova transação',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
