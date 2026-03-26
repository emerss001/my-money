import 'package:flutter/material.dart';
import 'package:my_money/components/ui/transaction_card.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TransactionCard(
          title: 'Hamburguer',
          amount: '- R\$ 59,00',
          category: 'Alimentação',
          date: '10/04/2022',
          isExpense: true,
        ),
        TransactionCard(
          title: 'Aluguel do apartamento',
          amount: '- R\$ 1.200,00',
          category: 'Casa',
          date: '27/03/2022',
          isExpense: true,
        ),
        TransactionCard(
          title: 'Computador',
          amount: 'R\$ 5.400,00',
          category: 'Venda',
          date: '15/03/2022',
          isExpense: false,
        ),
        TransactionCard(
          title: 'Desenvolvimento de site',
          amount: 'R\$ 8.000,00',
          category: 'Venda',
          date: '13/03/2022',
          isExpense: false,
        ),
        TransactionCard(
          title: 'Janta',
          amount: '- R\$ 39,00',
          category: 'Alimentação',
          date: '10/03/2022',
          isExpense: true,
        ),
      ],
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
