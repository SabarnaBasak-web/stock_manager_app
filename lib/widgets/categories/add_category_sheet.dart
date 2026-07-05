import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';

class AddCategoryResult {
  const AddCategoryResult({
    required this.name,
    required this.icon,
    required this.colorHex,
  });

  final String name;
  final String icon;
  final String colorHex;
}

class CategoryIconFamily {
  const CategoryIconFamily({
    required this.label,
    required this.icons,
  });

  final String label;
  final List<String> icons;
}

const categoryIconFamilies = <CategoryIconFamily>[
  CategoryIconFamily(
    label: 'Food & Kitchen',
    icons: [
      '🥦',
      '🥕',
      '🍅',
      '🧅',
      '🧄',
      '🌽',
      '🥬',
      '🍇',
      '🍎',
      '🍋',
      '🥑',
      '🥝',
      '🛒',
      '🧃',
      '🥛',
      '🍳',
      '🫙',
      '🍞',
      '🧂',
      '☕',
    ],
  ),
  CategoryIconFamily(
    label: 'Beauty & Care',
    icons: [
      '💄',
      '💅',
      '🪥',
      '🧴',
      '🧼',
      '🪞',
      '💆',
      '🛁',
      '💊',
      '🩺',
      '🧻',
      '🪒',
      '💋',
      '👄',
      '🌸',
      '🧖',
      '💈',
      '🪮',
      '🫧',
      '🧹',
    ],
  ),
  CategoryIconFamily(
    label: 'Home & Clothes',
    icons: [
      '🏠',
      '🪑',
      '🛋',
      '🛏',
      '🚿',
      '🧺',
      '🧹',
      '🪣',
      '💡',
      '🔌',
      '🪟',
      '🚪',
      '👗',
      '👕',
      '👖',
      '👟',
      '👠',
      '🧥',
      '🧤',
      '🎒',
    ],
  ),
  CategoryIconFamily(
    label: 'Tech & Tools',
    icons: [
      '📱',
      '💻',
      '🖥',
      '⌨️',
      '🖱',
      '📷',
      '🔧',
      '🔨',
      '🪛',
      '🔩',
      '⚙️',
      '🪜',
      '📦',
      '📫',
      '🗂',
      '📋',
      '📌',
      '🗃',
      '💾',
      '🖨',
    ],
  ),
  CategoryIconFamily(
    label: 'Misc',
    icons: [
      '⭐',
      '❤️',
      '🎯',
      '🎁',
      '🏷',
      '🔑',
      '💰',
      '🪙',
      '📊',
      '🌿',
      '🌱',
      '🌻',
      '🐾',
      '🎵',
      '🏋',
      '🎨',
      '📚',
      '✏️',
      '🧩',
      '🎀',
    ],
  ),
];

const categoryColorSwatches = <String>[
  '#2E7D32',
  '#1B5E20',
  '#F57F17',
  '#E65100',
  '#AD1457',
  '#880E4F',
  '#4527A0',
  '#1A237E',
  '#00695C',
  '#004D40',
  '#1565C0',
  '#0D47A1',
  '#607D8B',
  '#37474F',
  '#6A1B9A',
  '#4A148C',
  '#C62828',
  '#B71C1C',
  '#00838F',
  '#006064',
  '#558B2F',
  '#33691E',
  '#EF6C00',
  '#BF360C',
];

Future<AddCategoryResult?> showAddCategorySheet(BuildContext context) {
  return showModalBottomSheet<AddCategoryResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const FractionallySizedBox(
        heightFactor: 0.84,
        child: AddCategorySheet(),
      );
    },
  );
}

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _nameController = TextEditingController();
  final _firstFamily = categoryIconFamilies.first;

  late CategoryIconFamily _selectedFamily;
  late String _selectedIcon;
  String _selectedColorHex = categoryColorSwatches[12];

  @override
  void initState() {
    super.initState();
    _selectedFamily = _firstFamily;
    _selectedIcon = _firstFamily.icons.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name.')),
      );
      return;
    }

    Navigator.of(context).pop(
      AddCategoryResult(
        name: name,
        icon: _selectedIcon,
        colorHex: _selectedColorHex,
      ),
    );
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
                      'New Category',
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
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  18 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'e.g. Snacks & Sweets',
                        hintStyle: const TextStyle(color: Color(0xFFB4BCD1)),
                        filled: true,
                        fillColor: const Color(0xFFF2F4FA),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('Choose Icon'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryIconFamilies.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final family = categoryIconFamilies[index];
                          final isSelected = family == _selectedFamily;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFamily = family;
                                _selectedIcon = family.icons.first;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? StockColors.primary
                                    : const Color(0xFFF2F4FA),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                family.label,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF7682A4),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final icon in _selectedFamily.icons)
                          _IconOption(
                            icon: icon,
                            isSelected: icon == _selectedIcon,
                            onTap: () {
                              setState(() {
                                _selectedIcon = icon;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _SectionLabel('Choose Colour'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final colorHex in categoryColorSwatches)
                          _ColorOption(
                            color: StockColors.fromHex(colorHex),
                            isSelected: colorHex == _selectedColorHex,
                            onTap: () {
                              setState(() {
                                _selectedColorHex = colorHex;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        backgroundColor: const Color(0xFF86A1B0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_rounded, size: 18),
                          SizedBox(width: 10),
                          Text(
                            'Save Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF6F7B9E),
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FB),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? StockColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(icon, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF94A5B2) : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF94A5B2).withValues(alpha: 0.3),
                blurRadius: 0,
                spreadRadius: 2,
              ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
            : null,
      ),
    );
  }
}
