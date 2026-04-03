import 'package:flutter/material.dart';
import 'dart:async';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/filter_transactions_modal.dart';
import 'package:my_money/components/new_transaction_form.dart';
import 'package:my_money/components/transactions_list.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';
import 'package:my_money/components/ui/nav_main.dart';
import 'package:my_money/components/summary_cards_list.dart';
import 'package:my_money/features/transactions/transactions_controller.dart';
import 'package:my_money/features/transactions/transactions_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionsController _transactionsController =
      TransactionsController();

  TransactionsFilters _filters = TransactionsFilters();

  bool _isLoading = true;
  // Loading específico para a lista de transações
  bool _isLoadingTransactions = false;
  // Loading específico para métricas/resumo
  bool _isLoadingMetrics = false;
  // Debounce para busca
  Timer? _searchDebounce;
  // Controller do campo de busca
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _filters.search ?? '');
    _carregarHomePageDados();
  }

  Future<void> _carregarHomePageDados() async {
    setState(() => _isLoading = true);
    // indicamos que as métricas também estão sendo carregadas
    if (mounted) setState(() => _isLoadingMetrics = true);

    try {
      // fazendo as chamadas em paralelo (perfil agora é buscado pelo NavBarMain)
      await Future.wait([
        _transactionsController.obterMetricasGlobais(),
        _transactionsController.obterTransacoes(filters: _filters),
      ]);
    } catch (e) {
      print('Erro ao carregar dados da HomePage: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
      if (mounted) setState(() => _isLoadingMetrics = false);
    }
  }

  // Carrega apenas a lista de transações (usada para buscas/filtros rápidos)
  Future<void> _carregarTransacoesSomente() async {
    if (mounted) setState(() => _isLoadingTransactions = true);

    try {
      await _transactionsController.obterTransacoes(filters: _filters);
    } catch (e) {
      print('Erro ao carregar transações: $e');
    } finally {
      if (mounted) setState(() => _isLoadingTransactions = false);
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
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

  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF202024), // Cor do fundo do modal
      builder: (context) {
        return FilterTransactionsForm(
          // Mandamos o filtro atual pro modal saber o que já estava marcado
          filtrosAtuais: _filters,

          // O Modal chama essa função quando o usuário clica em "Filtrar"
          onApplyFilters: (novosFiltros) {
            setState(() {
              _filters = novosFiltros; // Atualiza o estado da Home
            });
            // Atualiza também o campo de busca com o valor do filtro
            _searchController.text = novosFiltros.search ?? '';
            // Recarrega apenas a lista de transações (não toda a Home)
            _carregarTransacoesSomente();
          },
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
                        onNovaTransacaoPressed: () => _abrirModalTransacao(),
                      ),

                      SummaryCardsList(
                        metricsData: _transactionsController.metricas.value,
                        isLoading: _isLoadingMetrics,
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
                            SearchField(
                              controller: _searchController,
                              onSearchChanged: (value) {
                                setState(() {
                                  _filters = TransactionsFilters(
                                    dataInicio: _filters.dataInicio,
                                    dataFim: _filters.dataFim,
                                    categoriasId: _filters.categoriasId,
                                    tipos: _filters.tipos,
                                    search: value.isEmpty ? null : value,
                                  );
                                });

                                // Debounce: aguarda 300ms após o último caractere
                                _searchDebounce?.cancel();
                                _searchDebounce = Timer(
                                  const Duration(milliseconds: 400),
                                  () => _carregarTransacoesSomente(),
                                );
                              },
                              onFilterPressed: _abrirFiltros,
                            ),
                            const SizedBox(height: 24),

                            TransactionsList(
                              transactions:
                                  _transactionsController.transacoes.value,
                              isLoading: _isLoadingTransactions,
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
