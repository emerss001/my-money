import 'package:flutter/material.dart';
import 'package:my_money/components/ui/summary_card.dart';
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

  String _formatCurrency(num value) {
    bool isNegative = value < 0;
    String strVal = value.abs().toStringAsFixed(2);
    List<String> parts = strVal.split('.');
    String natural = parts[0];
    String decimal = parts[1];

    String result = "";
    int count = 0;
    for (int i = natural.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result = ".$result";
      }
      result = natural[i] + result;
      count++;
    }
    return "${isNegative ? '-' : ''}R\$ $result,$decimal";
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final date = DateTime.parse(isoDate).toLocal();
    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    return "${date.day} de ${months[date.month - 1]}";
  }

  String _formatTotalDate(String? first, String? last) {
    if (first == null || last == null) return 'Não há movimentações';
    final d1 = DateTime.parse(first).toLocal();
    final d2 = DateTime.parse(last).toLocal();
    String pad(int n) => n.toString().padLeft(2, '0');
    return 'De ${pad(d1.day)}/${pad(d1.month)}/${d1.year.toString().substring(2)} até ${pad(d2.day)}/${pad(d2.month)}/${d2.year.toString().substring(2)}';
  }

  Future<void> _loadMetrics() async {
    try {
      final data = await _repository.obterMetricasGlobais();
      if (mounted) {
        setState(() {
          double eTotal = (data['entradas']?['total'] ?? 0).toDouble();
          String? eLast = data['entradas']?['lastDate'];
          entradasTotal = _formatCurrency(eTotal);
          entradasSub = eLast != null
              ? 'Última entrada em ${_formatDate(eLast)}'
              : 'Não há movimentações';

          double sTotal = (data['saidas']?['total'] ?? 0).toDouble();
          String? sLast = data['saidas']?['lastDate'];
          saidasTotal = _formatCurrency(sTotal);
          saidasSub = sLast != null
              ? 'Última saída em ${_formatDate(sLast)}'
              : 'Não há movimentações';

          totalBalance = (data['total']?['balance'] ?? 0).toDouble();
          totalBalanceText = _formatCurrency(totalBalance);
          String? tFirst = data['total']?['firstDate'];
          String? tLast = data['total']?['lastDate'];
          totalSub = _formatTotalDate(tFirst, tLast);

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
