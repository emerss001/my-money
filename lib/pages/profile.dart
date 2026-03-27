import 'package:flutter/material.dart';
import 'package:my_money/components/ui/logout_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Inicializando os controladores com dados fictícios para visualização
  final TextEditingController _nameController = TextEditingController(
    text: 'Emerson Neves Santos',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'emersonn@exemplo.com.br',
  );
  final TextEditingController _dateController = TextEditingController(
    text: '25/03/2026',
  );

  // Cores do padrão do app
  final Color primaryColor = const Color(0xFF00875F);
  final Color dangerColor = const Color(
    0xFFF75A68,
  ); // Vermelho usado nas "saídas"
  final Color labelColor = Colors.white54;
  final Color iconColor = Colors.white54;
  final Color borderColor = Colors.white12;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Reaproveitando o estilo de campo de texto que criamos antes
  Widget _buildTextField({
    required String label,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(
            color: readOnly
                ? Colors.white54
                : Colors.white, // Deixa o texto mais opaco se não for editável
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, color: iconColor, size: 22),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: readOnly ? Colors.transparent : borderColor,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: readOnly ? Colors.transparent : primaryColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
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
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ==========================================
              // SEÇÃO DO AVATAR
              // ==========================================
              Center(
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
                      child: const Center(
                        child: CircleAvatar(
                          radius:
                              58, // Aumentei o raio para preencher o Container
                          backgroundImage: NetworkImage(
                            'https://github.com/emerss001.png',
                          ), // Avatar de exemplo usando o seu Github
                          backgroundColor: Color(0xFF323238),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // Ação para abrir galeria/câmera
                          print("Trocar foto clicado");
                        },
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
              ),

              const SizedBox(height: 48),

              // ==========================================
              // CAMPOS DE INFORMAÇÃO
              // ==========================================
              _buildTextField(
                label: 'NOME',
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),

              _buildTextField(
                label: 'EMAIL',
                prefixIcon: Icons.mail_outline,
                controller: _emailController,
              ),

              _buildTextField(
                label: 'DATA DE CADASTRO',
                prefixIcon: Icons.calendar_today_outlined,
                controller: _dateController,
                readOnly: true, // Data de cadastro geralmente não é editável
              ),

              const SizedBox(height: 32),

              // ==========================================
              // BOTÕES DE AÇÃO (SAIR E EXCLUIR)
              // ==========================================

              // Botão Sair da Conta
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
