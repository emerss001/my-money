import 'package:flutter/material.dart';
import 'package:my_money/components/ui/summary_card.dart';
import 'package:my_money/helpers/formatters.dart';
import 'package:my_money/repository/transactions_repository.dart';

class SummaryCardsList extends StatefulWidget {
  const SummaryCardsList({super.key});

  @override
  State<SummaryCardsList> createState() => _SummaryCardsListState();
}

class _SummaryCardsListState extends State<SummaryCardsList> {
  final TransactionsRepository _repository = TransactionsRepository();
  bool _isLoading = true;

  String entradasTotal = 'R\$ 0,00';
  String entradasSub = 'Não há movimentações';

  String saidasTotal = 'R\$ 0,00';
  String saidasSub = 'Não há movimentações';

  String totalBalanceText = 'R\$ 0,00';
  String totalSub = 'Não há movimentações';
  double totalBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    try {
      final data = await _repository.obterMetricasGlobais();
      if (mounted) {
        setState(() {
          double eTotal = (data['entradas']?['total'] ?? 0).toDouble();
          String? eLast = data['entradas']?['lastDate'];
          entradasTotal = '${eTotal < 0 ? '- ' : ''}${formattedAmount(eTotal)}';
          entradasSub = eLast != null
              ? 'Última entrada em ${formattedDateComplete(eLast)}'
              : 'Não há movimentações';

          double sTotal = (data['saidas']?['total'] ?? 0).toDouble();
          String? sLast = data['saidas']?['lastDate'];
          saidasTotal = '${sTotal < 0 ? '- ' : ''}${formattedAmount(sTotal)}';
          saidasSub = sLast != null
              ? 'Última saída em ${formattedDateComplete(sLast)}'
              : 'Não há movimentações';

          totalBalance = (data['total']?['balance'] ?? 0).toDouble();
          totalBalanceText =
              '${totalBalance < 0 ? '- ' : ''}${formattedAmount(totalBalance)}';
          String? tFirst = data['total']?['firstDate'];
          String? tLast = data['total']?['lastDate'];
          totalSub = formattedTotalDate(tFirst, tLast);

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _getTotalCardColor() {
    if (totalBalance > 0) return const Color(0xFF00875F); // Verde (Positivo)
    if (totalBalance < 0) return const Color(0xFFF75A68); // Vermelho (Negativo)
    return const Color(0xFF323238); // Neutro para 0
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF00875F)),
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SummaryCard(
            title: 'Entradas',
            amount: entradasTotal,
            subtitle: entradasSub,
            icon: Icons.arrow_circle_up_outlined,
            iconColor: const Color(0xFF00B37E),
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Saídas',
            amount: saidasTotal,
            subtitle: saidasSub,
            icon: Icons.arrow_circle_down_outlined,
            iconColor: const Color(0xFFF75A68),
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Total',
            amount: totalBalanceText,
            subtitle: totalSub,
            icon: Icons.attach_money,
            iconColor: Colors.white,
            isTotalCard: true,
            customBackgroundColor: _getTotalCardColor(),
          ),
        ],
      ),
    );
  }
}
