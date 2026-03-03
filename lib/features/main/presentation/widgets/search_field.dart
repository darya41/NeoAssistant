import 'package:flutter/material.dart';
import '../../../../core/utils/icon_widgets.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF44E4BF),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconWidgets.micIcon(
              onTap: () {
                // действие после нажатия на микрофон
              },
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(

                children: [
                  IconWidgets.searchIcon(
                  onTap: () {
                    // действия после нажатия на поиск
                         },
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Введите номер карты',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onChanged: (value) {
                              // Обработка ввода текста
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconWidgets.filterIcon(
                            onTap: () {
                              // Обработка нажатия фильтра
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          Container(
            width: 38,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconWidgets.addIcon(
              onTap: () {
                // Обработка нажатия кнопки добавления
              },
            ),
          ),
        ],
      ),
    );
  }
}
