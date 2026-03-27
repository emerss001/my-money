import 'package:flutter/material.dart';
import 'package:my_money/components/ui/transaction_card.dart';
import 'package:my_money/repository/transactions_repository.dart';

class TransactionsList extends StatelessWidget {
  final TransactionsRepository _transactionsRepository =
      TransactionsRepository();

  TransactionsList({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    // Simulação de uma chamada de API para obter as transações
    final data = await _transactionsRepository.obterTransacoes();
    return {"transactions": data};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF00B37E)),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Erro ao carregar transações',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final transactions =
            snapshot.data?['transactions'] as List<dynamic>? ?? [];

        if (transactions.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 64.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 48,
                    color: Color(0xFF7C7C8A),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma transação cadastrada.',
                    style: TextStyle(color: Color(0xFF7C7C8A), fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: transactions.map((transaction) {
            final double amount =
                (transaction['amount'] as num?)?.toDouble() ?? 0.0;

            return TransactionCard(
              title: transaction['title'],
              amount: amount,
              category: transaction['category'],
              date: transaction['createdAt'],
              isExpense: transaction['type'] == "saida",
            );
          }).toList(),
        );
      },
    );
  }
}

// Cabeçalho da lista de transações
class TransactionsHeader extends StatelessWidget {
  final int itemCount;

  const TransactionsHeader({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Transações',
            style: TextStyle(
              color: Color(0xFFE1E1E6),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '$itemCount itens',
            style: const TextStyle(color: Color(0xFF7C7C8A), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Campo de busca para filtrar transações
class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Busque uma transação',
        hintStyle: const TextStyle(color: Color(0xFF7C7C8A)),
        filled: true,
        fillColor: const Color(0xFF121214), // Fundo interno mais escuro
        suffixIcon: const Icon(Icons.sort, color: Color(0xFF00B37E)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF323238)), // Borda sutil
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color(0xFF00875F),
          ), // Borda verde ao focar
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
