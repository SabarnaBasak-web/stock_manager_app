import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import 'add_product_form_widgets.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    required this.nameController,
    required this.categoriesStream,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    super.key,
  });

  final TextEditingController nameController;
  final Stream<List<Category>> categoriesStream;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return AddProductSectionCard(
      title: 'PRODUCT INFO',
      children: [
        const AddProductFieldLabel('Product Name *'),
        TextFormField(
          controller: nameController,
          textInputAction: TextInputAction.next,
          decoration: const AddProductInputDecoration(
            hintText: 'e.g. Cherry Tomatoes',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
            }

            return null;
          },
        ),
        const SizedBox(height: 14),
        const AddProductFieldLabel('Category *'),
        StreamBuilder<List<Category>>(
          stream: categoriesStream,
          builder: (context, snapshot) {
            final categories = snapshot.data ?? const [];

            return DropdownButtonFormField<int>(
              value: selectedCategoryId,
              isExpanded: true,
              decoration: const AddProductInputDecoration(
                hintText: 'Select category...',
              ),
              items: categories
                  .map(
                    (category) => DropdownMenuItem<int>(
                      value: category.id,
                      child: Text('${category.icon}  ${category.name}'),
                    ),
                  )
                  .toList(),
              onChanged: categories.isEmpty ? null : onCategoryChanged,
              validator: (value) {
                if (value == null) {
                  return 'Category is required';
                }

                return null;
              },
            );
          },
        ),
      ],
    );
  }
}
