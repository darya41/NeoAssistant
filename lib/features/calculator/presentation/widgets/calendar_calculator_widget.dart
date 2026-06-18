import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/calculator.dart';

class CalendarCalculatorWidget extends StatefulWidget {
  final Calculator calculator;

  const CalendarCalculatorWidget({super.key, required this.calculator});

  @override
  State<CalendarCalculatorWidget> createState() => _CalendarCalculatorWidgetState();
}

class _CalendarCalculatorWidgetState extends State<CalendarCalculatorWidget> {
  DateTime? _birthDate;
  String? _feedingType;
  Map<String, dynamic>? _result;
  bool _isCalculated = false;

  final List<String> _months = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
  ];

  Future<void> _selectDateWithCupertino(BuildContext context) async {
    DateTime tempDate = _birthDate ?? DateTime.now();

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Выберите дату рождения',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate,
                  minimumDate: DateTime(2020),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _birthDate = tempDate;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Выбрать',
                      style: TextStyle(color: AppColors.brand_40),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }



  void _calculate() {
    if (_birthDate == null || _feedingType == null) return;

    final schedule = widget.calculator.config['schedule'] ?? [];
    List<Map<String, dynamic>> resultSchedule = [];

    for (var item in schedule) {
      int ageMonths = item['age'];
      DateTime startDate = DateTime(
        _birthDate!.year,
        _birthDate!.month + ageMonths,
        _birthDate!.day,
      );

      String formattedDate = '${startDate.day} ${_months[startDate.month - 1]} ${startDate.year}';

      resultSchedule.add({
        'age': ageMonths,
        'age_text': item['age_text'],
        'start_date': formattedDate,
        'products': item['products'],
      });
    }

    setState(() {
      _result = {
        'start_date': resultSchedule.isNotEmpty ? resultSchedule.first['start_date'] : null,
        'schedule': resultSchedule,
      };
      _isCalculated = true;
    });
  }

  void _reset() {
    setState(() {
      _birthDate = null;
      _feedingType = null;
      _result = null;
      _isCalculated = false;
    });
  }

  String _getFeedingTypeText() {
    if (_feedingType == 'breast') return 'Грудное вскармливание';
    if (_feedingType == 'artificial') return 'Искусственное вскармливание';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final rules = widget.calculator.config['rules'] ?? {};
    final note = rules['note'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.calculator.description.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.neutral_5,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.calculator.description,
                style: const TextStyle(fontSize: 14, color: AppColors.neutral_60),
              ),
            ),

          if (note.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note,
                      style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Введите данные',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => _selectDateWithCupertino(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral_25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.neutral_50, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _birthDate != null
                                  ? _formatDate(_birthDate!)
                                  : 'Выберите дату рождения',
                              style: TextStyle(
                                color: _birthDate != null ? AppColors.neutral_90 : AppColors.neutral_50,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppColors.neutral_50),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Тип вскармливания',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeedingOption(
                              value: 'breast',
                              label: 'Грудное',
                              icon: Icons.favorite,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFeedingOption(
                              value: 'artificial',
                              label: 'Искусственное',
                              icon: Icons.auto_awesome,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (_birthDate != null && _feedingType != null)
                              ? _calculate
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.brand_40,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Сформировать календарь',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (_isCalculated)
                        const SizedBox(width: 12),
                      if (_isCalculated)
                        OutlinedButton(
                          onPressed: _reset,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Сбросить'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_isCalculated && _result != null)
            _buildResultWidget(),
        ],
      ),
    );
  }

  Widget _buildFeedingOption({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _feedingType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _feedingType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand_40.withValues(alpha: 0.1): AppColors.neutral_5,
          border: Border.all(
            color: isSelected ? AppColors.brand_40 : AppColors.neutral_25,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.brand_40 : AppColors.neutral_50,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: isSelected ? AppColors.brand_40 : AppColors.neutral_50,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.cake, size: 20, color: Colors.green[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Дата рождения: ${_formatDate(_birthDate!)} • ${_getFeedingTypeText()}',
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...(_result!['schedule'] as List).map((item) => _buildScheduleCard(item)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> item) {
    final products = item['products'] as List;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.brand_40,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['age_text'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.neutral_0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neutral_0.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'с ${item['start_date']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.neutral_0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ...products.map((product) => _buildProductCard(product)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isNew = product['is_new'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNew ? Colors.blue[50] : AppColors.neutral_5,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNew ? Colors.blue[200]! : AppColors.neutral_5,
          width: isNew ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.brand_40,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  product['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isNew ? FontWeight.bold : FontWeight.w500,
                    color: isNew ? Colors.blue[800] : AppColors.neutral_90,
                  ),
                ),
              ),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color:AppColors.neutral_0,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              product['amount'],
              style: TextStyle(
                fontSize: 13,
                color: AppColors.neutral_50,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }
}