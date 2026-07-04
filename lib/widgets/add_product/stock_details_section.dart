import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';
import 'add_product_form_widgets.dart';

class StockDetailsSection extends StatelessWidget {
  const StockDetailsSection({
    required this.quantityController,
    required this.selectedUnit,
    required this.onUnitChanged,
    super.key,
  });

  static const units = ['units', 'pcs', 'kg', 'g', 'L', 'ml', 'box', 'pack'];

  final TextEditingController quantityController;
  final String selectedUnit;
  final ValueChanged<String> onUnitChanged;

  @override
  Widget build(BuildContext context) {
    return AddProductSectionCard(
      title: 'STOCK DETAILS',
      children: [
        const AddProductFieldLabel('Quantity *'),
        TextFormField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const AddProductInputDecoration(hintText: '0'),
          validator: (value) {
            final quantity = int.tryParse(value?.trim() ?? '');

            if (quantity == null || quantity < 0) {
              return 'Enter a valid quantity';
            }

            return null;
          },
        ),
        const SizedBox(height: 14),
        StockStatusRow(isInStock: int.tryParse(quantityController.text) != 0),
        const SizedBox(height: 14),
        const AddProductFieldLabel('Unit'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: units
              .map(
                (unit) => UnitChip(
                  label: unit,
                  isSelected: selectedUnit == unit,
                  onTap: () => onUnitChanged(unit),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class StockStatusRow extends StatelessWidget {
  const StockStatusRow({required this.isInStock, super.key});

  final bool isInStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text(
            'In Stock',
            style: TextStyle(
              color: Color(0xFF667096),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Icon(
            isInStock ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isInStock ? StockColors.green : StockColors.red,
            size: 15,
          ),
          const SizedBox(width: 4),
          Text(
            isInStock ? 'Yes' : 'No',
            style: TextStyle(
              color: isInStock ? StockColors.green : StockColors.red,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class UnitChip extends StatelessWidget {
  const UnitChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: StockColors.primary,
      backgroundColor: const Color(0xFFF0F2F8),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF667096),
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
