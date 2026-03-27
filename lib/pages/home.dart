import 'package:flutter/material.dart';
import 'package:my_money/components/transactions_list.dart';
import 'package:my_money/components/ui/nav_main.dart';
import 'package:my_money/components/summary_cards_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Chave usada para forçar as listas e os componentes e remontarem e recarregarem os dados da API
  Key _refreshKey = UniqueKey();

  Future<void> _handleRefresh() async {
    setState(() {
      _refreshKey = UniqueKey();
    });
    // Dá um tempo de 1 segundo de respiro para a animação do componente e para a API finalizar de buscar (como não temos acesso a todos os estados no pai, usamos esse atraso visual)
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF00875F),
          backgroundColor: const Color(0xFF202024),
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            // physics: AlwaysScrollableScrollPhysics é essencial para o Push To Refresh funcionar
            // mesmo quando os itens da tela não preencherem tudo
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              key: _refreshKey,
              children: [
                const NavBarMain(),
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
                      const TransactionsList(),
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
