import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/ui/logout_button.dart';
import 'package:my_money/components/ui/custom_text_field.dart';
import 'package:my_money/components/ui/avatar_profile.dart';
import 'package:my_money/features/user/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController _userController = UserController();

  bool _isLoading = true;
  String? _errorMessage;
  bool _imageUpdated = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: '-',
  );

  String _avatarUrl = '';

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
      final user = await _userController.obterPerfilUsuario();

      _nameController.text = user.name;
      _emailController.text = user.email;
      _dateController.text = user.createdAt;
      _avatarUrl = user.imageUrl;
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          ? Center(
              child: CircularProgressIndicator(
                color: CoresGlobal().primaryColor,
              ),
            )
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: CoresGlobal().outcomeColor,
                      size: 48,
                    ),
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
                        backgroundColor: CoresGlobal().primaryColor,
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
                      readOnly: true,
                    ),

                    CustomTextField(
                      label: 'DATA DE CADASTRO',
                      prefixIcon: Icons.calendar_today_outlined,
                      controller: _dateController,
                      readOnly: true,
                    ),

                    const SizedBox(height: 32),

                    // botões de ação
                    LogoutButton(borderColor: CoresGlobal().borderColor),

                    const SizedBox(height: 16),

                    // Botão Excluir Conta
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton.icon(
                        onPressed: () {
                          print("Excluir conta");
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: CoresGlobal().outcomeColor,
                        ),
                        label: Text(
                          'Excluir conta',
                          style: TextStyle(
                            color: CoresGlobal().outcomeColor,
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
