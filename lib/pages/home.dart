import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/transactions_list.dart';
import 'package:my_money/components/ui/nav_main.dart';
import 'package:my_money/components/summary_cards_list.dart';
import 'package:my_money/features/user/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Key _refreshKey = UniqueKey();
  final UserController _userController = UserController();

  String _imageUrl = '';
  String _nomeUsuario = '';

  Future<void> _loadUserData() async {
    try {
      final userModelMin = await _userController.obterDadosMinPerfil();
      if (mounted) {
        setState(() {
          _nomeUsuario = userModelMin.name;
          _imageUrl = userModelMin.imageUrl;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados mínimos do perfil: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _refreshKey = UniqueKey();
    });
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: CoresGlobal().primaryColor,
          backgroundColor: CoresGlobal().backgroundColor,
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              key: _refreshKey,
              children: [
                NavBarMain(
                  imageUrl: _imageUrl,
                  nomeUsuario: _nomeUsuario,
                  onProfileUpdated: _loadUserData,
                ),
                const SummaryCardsList(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 24.0,
                  ),
                  child: Column(
                    children: [
                      // TODO: Ajustar o itemCount dinamicamente caso seja necessário futuramente
                      const TransactionsHeader(itemCount: 4),
                      const SizedBox(height: 16),
                      const SearchField(),
                      const SizedBox(height: 24),
                      TransactionsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
