import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/transactions_list.dart';
import 'package:my_money/components/ui/nav_main.dart';
import 'package:my_money/components/summary_cards_list.dart';
import 'package:my_money/features/transactions/transactions_controller.dart';
import 'package:my_money/features/user/user_controller.dart';
import 'package:my_money/features/user/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController _userController = UserController();
  final TransactionsController _transactionsController =
      TransactionsController();

  String _imageUrl = '';
  String _nomeUsuario = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarHomePageDados();
  }

  Future<void> _carregarHomePageDados() async {
    setState(() => _isLoading = true);

    try {
      // fazendo as chamadas em paralelo
      final results = await Future.wait([
        _userController.obterDadosMinPerfil(),
        _transactionsController.obterMetricasGlobais(),
        _transactionsController.obterTransacoes(),
      ]);

      // extrair o resultado da primeira chamada
      final UserModelMin userModelMin = results[0] as UserModelMin;
      if (mounted) {
        setState(() {
          _nomeUsuario = userModelMin.name;
          _imageUrl = userModelMin.imageUrl;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados da HomePage: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _salvarNovaTransacao(
    String title,
    double amount,
    int categoryId,
    String type,
  ) async {
    try {
      await _transactionsController.criarTransacao(
        title: title,
        amount: amount,
        categoryId: categoryId,
        type: type,
      );
      await _carregarHomePageDados(); // Recarrega os dados da HomePage após criar a transação
    } catch (e) {
      print('Erro ao salvar nova transação: $e');
      throw Exception('Falha ao salvar transação. Tente novamente mais tarde.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: CoresGlobal().primaryColor,
          backgroundColor: CoresGlobal().backgroundColor,
          onRefresh: _carregarHomePageDados,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      NavBarMain(
                        imageUrl: _imageUrl,
                        nomeUsuario: _nomeUsuario,
                        onNovaTransacaoSalva: _salvarNovaTransacao,
                      ),

                      SummaryCardsList(
                        metricsData: _transactionsController.metricas.value,
                        isLoading: _transactionsController.isLoading.value,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          bottom: 24.0,
                        ),
                        child: Column(
                          children: [
                            TransactionsHeader(
                              itemCount: _transactionsController
                                  .transacoes
                                  .value
                                  .length,
                            ),
                            const SizedBox(height: 16),
                            const SearchField(),
                            const SizedBox(height: 24),

                            TransactionsList(
                              transactions:
                                  _transactionsController.transacoes.value,
                              isLoading:
                                  _transactionsController.isLoading.value,
                            ),
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
