import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/new_transaction_form.dart';
import 'package:my_money/components/transactions_list.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';
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

  Future<void> _handleDeleteTransaction(int transactionId) async {
    await _transactionsController.excluirTransacao(transactionId);

    if (!context.mounted) return;

    if (mounted) {
      CustomSnackBar.show(
        context: context,
        message: "Transação excluída com sucesso!",
      );

      await _carregarHomePageDados(); // Recarrega os dados da Home
    } else {
      CustomSnackBar.show(
        context: context,
        message:
            _transactionsController.errorMessage.value ??
            "Erro ao excluir transação.",
        isError: true,
      );
    }
  }

  Future<void> _handleEditTransaction({
    required int idTransacao,
    required String tittleInicial,
    required double precoInicial,
    required int categoriaIdInicial,
    required String tipoInicial,
  }) async {
    // Lógica para editar a transação
    await _transactionsController.editarTransacao(
      id: idTransacao,
      title: tittleInicial,
      amount: precoInicial,
      type: tipoInicial,
      categoryId: categoriaIdInicial,
    );

    if (!context.mounted) return;
    if (mounted) {
      CustomSnackBar.show(
        context: context,
        message: "Transação editada com sucesso!",
      );

      await _carregarHomePageDados(); // Recarrega os dados da Home
    } else {
      CustomSnackBar.show(
        context: context,
        message:
            _transactionsController.errorMessage.value ??
            "Erro ao editar transação.",
        isError: true,
      );
    } // Recarrega os dados da HomePage após editar a transação
  }

  void _abrirModalTransacao({
    int? idTransacao,
    String? tittleInicial,
    double? precoInicial,
    int? categoriaIdInicial,
    String? tipoInicial,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NewTransactionForm(
            transactionId: idTransacao,
            initialTitle: tittleInicial,
            initialPrice: precoInicial,
            initialCategoryId: categoriaIdInicial,
            initialType: tipoInicial,
            isEditMode: idTransacao != null,
            onClosePressed: () => Navigator.of(context).pop(),
            onRegisterPressed: (descricao, preco, categoria, tipo) async {
              if (idTransacao != null) {
                // Lógica para editar a transação
                await _handleEditTransaction(
                  idTransacao: idTransacao,
                  tittleInicial: descricao,
                  precoInicial: preco,
                  categoriaIdInicial: categoria,
                  tipoInicial: tipo,
                );
              } else {
                // Lógica para criar uma nova transação
                await _salvarNovaTransacao(descricao, preco, categoria, tipo);
              }

              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
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
                        onNovaTransacaoPressed: () => _abrirModalTransacao(),
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
                              onEdit:
                                  ({
                                    int? idTransacao,
                                    String? tittleInicial,
                                    double? precoInicial,
                                    int? categoriaIdInicial,
                                    String? tipoInicial,
                                  }) {
                                    _abrirModalTransacao(
                                      idTransacao: idTransacao,
                                      tittleInicial: tittleInicial,
                                      precoInicial: precoInicial,
                                      categoriaIdInicial: categoriaIdInicial,
                                      tipoInicial: tipoInicial,
                                    );
                                  },
                              onDelete: _handleDeleteTransaction,
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
