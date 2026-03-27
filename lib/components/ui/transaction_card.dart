import 'package:flutter/material.dart';
import 'package:my_money/helpers/formatters.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final double amount;
  final String category;
  final String date;
  final bool isExpense;

  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.isExpense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF29292E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFFC4C4CC), fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${isExpense || amount < 0 ? '- ' : ''}${formattedAmount(amount)}',
            style: TextStyle(
              color: isExpense || amount < 0
                  ? const Color(0xFFF75A68)
                  : const Color(0xFF00B37E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.sell_outlined,
                    color: Color(0xFF7C7C8A),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFF7C7C8A),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF7C7C8A),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate(date),
                    style: const TextStyle(
                      color: Color(0xFF7C7C8A),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
