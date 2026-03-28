import 'package:my_money/repository/transactions_repository.dart';

class TransactionsController {
  final TransactionsRepository _transactionsRepository =
      TransactionsRepository();

  Future<void> criarTransacao({
    required String title,
    required double amount,
    required String type,
    required String categoryId,
  }) async {
    try {
      await _transactionsRepository.criarTransacao(
        title: title,
        amount: amount,
        type: type,
        categoryId: categoryId,
      );
    } catch (e) {
      print('Erro ao criar transação: $e');
      throw "Falha ao criar transação. Tente novamente mais tarde.";
    }
  }
}
