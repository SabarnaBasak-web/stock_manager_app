import 'package:flutter/material.dart';

import '../core/stock_colors.dart';
import '../database/app_database.dart';
import '../widgets/add_product/add_product_form_widgets.dart';
import '../widgets/add_product/add_product_header.dart';
import '../widgets/add_product/expiry_date_section.dart';
import '../widgets/add_product/product_info_section.dart';
import '../widgets/add_product/stock_details_section.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({required this.database, super.key});

  final AppDatabase database;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '0');

  int? _selectedCategoryId;
  String _selectedUnit = 'units';
  DateTime? _expiryDate;
  bool _hasNoExpiryDate = false;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_refreshStockStatus);
  }

  @override
  void dispose() {
    _quantityController.removeListener(_refreshStockStatus);
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _refreshStockStatus() {
    setState(() {});
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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_expiryDate == null && !_hasNoExpiryDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date.')),
      );
      return;
    }

    await widget.database.addProduct(
      ProductsCompanion.insert(
        name: _nameController.text.trim(),
        categoryId: _selectedCategoryId!,
        quantity: int.parse(_quantityController.text.trim()),
        expiryDate: _expiryDate ?? DateTime(9999, 12, 31),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added to inventory.')),
    );

    _resetForm();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _quantityController.text = '0';
    setState(() {
      _selectedCategoryId = null;
      _selectedUnit = 'units';
      _expiryDate = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StockColors.scaffold,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AddProductHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
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
                    StockDetailsSection(
                      quantityController: _quantityController,
                      selectedUnit: _selectedUnit,
                      onUnitChanged: (unit) {
                        setState(() => _selectedUnit = unit);
                      },
                    ),
                    const SizedBox(height: 16),
                    ExpiryDateSection(
                      hasNoExpiryDate: _hasNoExpiryDate,
                      expiryDate: _expiryDate,
                      onNoExpiryChanged: _toggleNoExpiryDate,
                      onPickExpiryDate: _pickExpiryDate,
                    ),
                    const SizedBox(height: 18),
                    AddProductSubmitButton(onPressed: _saveProduct),
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
