import 'package:flutter/material.dart';
import 'package:my_money/components/ui/logout_button.dart';
import 'package:my_money/components/ui/custom_text_field.dart';
import 'package:my_money/components/ui/avatar_profile.dart';
import 'package:my_money/repository/user_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _userRepository = UserRepository();
  bool _isLoading = true;
  String? _errorMessage;
  bool _imageUpdated = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: '-',
  );

  String _avatarUrl = '';

  // Cores do padrão do app
  final Color primaryColor = const Color(0xFF00875F);
  final Color dangerColor = const Color(
    0xFFF75A68,
  ); // Vermelho usado nas "saídas"
  final Color labelColor = Colors.white54;
  final Color iconColor = Colors.white54;
  final Color borderColor = Colors.white12;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _userRepository.obterPerfilUsuario();
      if (mounted) {
        setState(() {
          _nameController.text = data["nome"] ?? "";
          _emailController.text = data["email"] ?? "";
          _dateController.text = data["criadoEm"] != null
              ? DateTime.parse(
                  data["criadoEm"],
                ).toLocal().toString().split(' ')[0]
              : "-";
          _avatarUrl = data["imagemUrl"] ?? "";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Minha Conta',
          style: TextStyle(
            color: Color(0xFFE1E1E6),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE1E1E6)),
          onPressed: () {
            Navigator.pop(context, _imageUpdated);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: dangerColor, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child: const Text(
                        'Tentar novamente',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // foto do avatar de perfil
                    AvatarProfile(
                      avatarUrl: _avatarUrl,
                      onImageUpdated: () {
                        _imageUpdated = true;
                        _loadUserData();
                      },
                    ),

                    const SizedBox(height: 48),

                    // campos com as informções do usuário
                    CustomTextField(
                      label: 'NOME',
                      prefixIcon: Icons.person_outline,
                      controller: _nameController,
                    ),

                    CustomTextField(
                      label: 'EMAIL',
                      prefixIcon: Icons.mail_outline,
                      controller: _emailController,
                    ),

                    CustomTextField(
                      label: 'DATA DE CADASTRO',
                      prefixIcon: Icons.calendar_today_outlined,
                      controller: _dateController,
                      readOnly: true,
                    ),

                    const SizedBox(height: 32),

                    // botões de ação
                    LogoutButton(borderColor: borderColor),

                    const SizedBox(height: 16),

                    // Botão Excluir Conta
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton.icon(
                        onPressed: () {
                          print("Excluir conta");
                        },
                        icon: Icon(Icons.delete_outline, color: dangerColor),
                        label: Text(
                          'Excluir conta',
                          style: TextStyle(
                            color: dangerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
