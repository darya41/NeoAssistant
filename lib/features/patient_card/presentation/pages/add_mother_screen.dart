import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../view_models/add_mother_viewmodel.dart';
import '../widgets/mother_form.dart';

class AddMotherScreen extends StatefulWidget {
  const AddMotherScreen({super.key});

  @override
  State<AddMotherScreen> createState() => _AddMotherScreenState();
}

class _AddMotherScreenState extends State<AddMotherScreen> {
  late final AddMotherViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddMotherViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    _viewModel.onTriedToSubmit();

    if (!_viewModel.isFormValid) return;

    final createdMother = await _viewModel.saveMother(context);

    if (mounted && createdMother != null) {
      Navigator.pop(context, createdMother);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить мать'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.neutral_0,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: MotherFormWidget(
                      onMotherChanged: _viewModel.onMotherChanged,
                      onAddressChanged: _viewModel.onAddressChanged,
                      showValidationErrors: _viewModel.triedToSubmit,
                      lastNameError: _viewModel.lastNameError,
                      firstNameError: _viewModel.firstNameError,
                      dateError: _viewModel.dateError,
                      bloodGroupError: _viewModel.bloodGroupError,
                      rhFactorError: _viewModel.rhFactorError,
                    ),
                  ),
                ),
                if (_viewModel.isSaving)
                  const Center(child: CircularProgressIndicator())
                else
                  ContinueButton(
                    text: "Сохранить",
                    onPressed: _handleSave,
                    backgroundColor: _viewModel.isFormValid ? AppColors.brand_40 : AppColors.neutral_5,
                    borderColor: _viewModel.isFormValid ? AppColors.brand_40 : AppColors.neutral_25,
                    textColor: _viewModel.isFormValid ? AppColors.neutral_0 : AppColors.neutral_90,
                    isEnabled: _viewModel.isFormValid,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}