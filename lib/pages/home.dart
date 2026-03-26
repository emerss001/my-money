import 'package:flutter/material.dart';
import 'package:my_money/components/transactions_list.dart';
import 'package:my_money/components/ui/nav_main.dart';
import 'package:my_money/components/summary_cards_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
    );
  }
}
