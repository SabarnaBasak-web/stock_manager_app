import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import '../../models/product_item.dart';
import '../add_product/add_product_form_widgets.dart';
import '../add_product/expiry_date_section.dart';
import '../add_product/product_info_section.dart';

Future<bool?> showEditProductSheet({
  required BuildContext context,
  required AppDatabase database,
  required ProductItem product,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.88,
        child: EditProductSheet(
          database: database,
          product: product,
        ),
      );
    },
  );
}

class EditProductSheet extends StatefulWidget {
  const EditProductSheet({
    required this.database,
    required this.product,
    super.key,
  });

  final AppDatabase database;
  final ProductItem product;

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<EditProductSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late int? _selectedCategoryId;
  late DateTime? _expiryDate;
  late bool _hasNoExpiryDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    _selectedCategoryId = widget.product.categoryId;
    _hasNoExpiryDate = widget.product.hasNoExpiryDate;
    _expiryDate = _hasNoExpiryDate ? null : widget.product.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 20),
    );

    if (pickedDate == null) return;

    setState(() {
      _expiryDate = pickedDate;
      _hasNoExpiryDate = false;
    });
  }

  void _toggleNoExpiryDate(bool value) {
    setState(() {
      _hasNoExpiryDate = value;

      if (value) {
        _expiryDate = null;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_expiryDate == null && !_hasNoExpiryDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date.')),
      );
      return;
    }

    await widget.database.updateProduct(
      productId: widget.product.id,
      name: _nameController.text.trim(),
      categoryId: _selectedCategoryId!,
      quantity: int.parse(_quantityController.text.trim()),
      expiryDate: _expiryDate ?? DateTime(9999, 12, 31),
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 5,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E6F0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Edit Product',
                      style: TextStyle(
                        color: Color(0xFF111B43),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F3FA),
                    ),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    6,
                    16,
                    22 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  children: [
                    ProductInfoSection(
                      nameController: _nameController,
                      categoriesStream: widget.database.watchCategories(),
                      selectedCategoryId: _selectedCategoryId,
                      onCategoryChanged: (value) {
                        setState(() => _selectedCategoryId = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _EditQuantitySection(
                      quantityController: _quantityController,
                    ),
                    const SizedBox(height: 16),
                    ExpiryDateSection(
                      hasNoExpiryDate: _hasNoExpiryDate,
                      expiryDate: _expiryDate,
                      onNoExpiryChanged: _toggleNoExpiryDate,
                      onPickExpiryDate: _pickExpiryDate,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Save Changes'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3E63B9),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditQuantitySection extends StatelessWidget {
  const _EditQuantitySection({required this.quantityController});

  final TextEditingController quantityController;

  @override
  Widget build(BuildContext context) {
    return AddProductSectionCard(
      title: 'STOCK DETAILS',
      children: [
        const AddProductFieldLabel('Quantity *'),
        TextFormField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: AddProductFormColors.inputText,
            fontWeight: FontWeight.w700,
          ),
          decoration: const AddProductInputDecoration(hintText: '0'),
          validator: (value) {
            final quantity = int.tryParse(value?.trim() ?? '');

            if (quantity == null || quantity < 0) {
              return 'Enter a valid quantity';
            }

            return null;
          },
        ),
      ],
    );
  }
}
