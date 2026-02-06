import 'package:flutter/material.dart';
import '../../components/button/continue_button.dart';

class RegistrationStep2 extends StatefulWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final VoidCallback onNextStep;
  final bool isStepValid;

  const RegistrationStep2({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    required this.middleNameController,
    required this.onNextStep,
    required this.isStepValid,
  });

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  bool _agreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            const Text(
              'Шаг 1/3',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: widget.lastNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Фамилия',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),

                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.grey[300],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: widget.firstNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Имя',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),

                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.grey[300],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: widget.middleNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Отчество',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ContinueButton(
              onPressed: widget.onNextStep,
              isEnabled: widget.isStepValid && _agreementChecked,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: _agreementChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreementChecked = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF44E4BF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreementChecked = !_agreementChecked;
                      });
                    },
                    child: const Text(
                      'Согласие на обработку персональных данных',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}