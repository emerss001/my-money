import 'package:flutter/material.dart';
import 'package:my_money/components/ui/summary_card.dart';

class SummaryCardsList extends StatelessWidget {
  const SummaryCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: const [
          SummaryCard(
            title: 'Entradas',
            amount: 'R\$ 17.400,00',
            subtitle: 'Última entrada em 13 de abril',
            icon: Icons.arrow_circle_up_outlined,
            iconColor: Color(0xFF00B37E),
          ),
          SizedBox(width: 16),
          SummaryCard(
            title: 'Saídas',
            amount: 'R\$ 1.259,00',
            subtitle: 'Última saída em 10 de abril',
            icon: Icons.arrow_circle_down_outlined,
            iconColor: Color(0xFFF75A68),
          ),
          SizedBox(width: 16),
          SummaryCard(
            title: 'Total',
            amount: 'R\$ 16.141,00',
            subtitle: 'De 15/03/22 até 13/04/22',
            icon: Icons.attach_money,
            iconColor: Colors.white,
            isTotalCard: true, // Muda o fundo para verde
          ),
        ],
      ),
    );
  }
}
