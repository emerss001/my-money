import 'package:flutter/material.dart';
import 'package:my_money/repository/transactions_repository.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/models/categoria.dart';
import 'package:my_money/components/build_category_dropdown.dart';

class NewTransactionForm extends StatefulWidget {
  final VoidCallback onClosePressed;
  // Agora o terceiro parâmetro (String) representará o ID da categoria selecionada
  final Function(String, double, String, String) onRegisterPressed;

  const NewTransactionForm({
    super.key,
    required this.onClosePressed,
    required this.onRegisterPressed,
  });

  @override
  State<NewTransactionForm> createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final TransactionsRepository _transactionsRepository =
      TransactionsRepository();
  // Estado para o tipo de transação ('entrada' ou 'saida')
  String _selectedType = 'entrada';
  String? _selectedCategoryId;

  // Controladores de texto para os outros campos
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // 2. Lista de categorias vinda da API
  List<Categoria> _categorias = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFieldChanged);
    _priceController.addListener(_onFieldChanged);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final data = await _transactionsRepository.obterCategorias();

      setState(() {
        _categorias = data.map((item) {
          return Categoria(id: item['id'].toString(), nome: item['name']);
        }).toList();

        _isLoadingCategories = false;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e');
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _priceController.removeListener(_onFieldChanged);
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _buildFilledInputField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CoresGlobal().inputBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: CoresGlobal().textColor, fontSize: 16),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: CoresGlobal().hintColor, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required IconData icon,
    required String text,
    required Color color,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: CoresGlobal().inputBackgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? CoresGlobal().textColor : color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid =
        _titleController.text.isNotEmpty &&
        double.tryParse(_priceController.text) != null &&
        _selectedCategoryId != null;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: CoresGlobal().backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nova transação',
                style: TextStyle(
                  color: CoresGlobal().textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: CoresGlobal().hintColor),
                onPressed: widget.onClosePressed,
              ),
            ],
          ),

          const SizedBox(height: 32),

          _buildFilledInputField(
            hint: 'Descrição',
            controller: _titleController,
          ),

          _buildFilledInputField(
            hint: 'Preço',
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),

          // Campo Select da Categoria
          CategoryDropdown(
            selectedCategoryId: _selectedCategoryId,
            isLoadingCategories: _isLoadingCategories,
            categorias: _categorias,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategoryId = newValue;
              });
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _buildTypeButton(
                icon: Icons.arrow_circle_up_outlined,
                text: 'Entrada',
                color: CoresGlobal().incomeColor,
                isSelected: _selectedType == 'entrada',
                onPressed: () {
                  setState(() {
                    _selectedType = 'entrada';
                  });
                },
              ),
              const SizedBox(width: 16),
              _buildTypeButton(
                icon: Icons.arrow_circle_down_outlined,
                text: 'Saída',
                color: CoresGlobal().outcomeColor,
                isSelected: _selectedType == 'saida',
                onPressed: () {
                  setState(() {
                    _selectedType = 'saida';
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isFormValid
                  ? () {
                      widget.onRegisterPressed(
                        _titleController.text,
                        double.parse(_priceController.text),
                        _selectedCategoryId!,
                        _selectedType,
                      );

                      _titleController.clear();
                      _priceController.clear();
                      setState(() {
                        _selectedCategoryId = null; // Reseta o select
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresGlobal().primaryColor,
                disabledBackgroundColor: CoresGlobal().primaryColor.withValues(
                  alpha: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Cadastrar',
                style: TextStyle(
                  color: isFormValid
                      ? CoresGlobal().textColor
                      : CoresGlobal().textColor.withValues(alpha: 0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
