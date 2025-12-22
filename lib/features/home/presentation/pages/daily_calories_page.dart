import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/widgets/padding_wg.dart';
import 'package:numi/features/home/domain/entities/user_body_info.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_bloc.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_event.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_state.dart';

class DailyCaloriesPage extends StatefulWidget {
  const DailyCaloriesPage({super.key});

  @override
  State<DailyCaloriesPage> createState() => _DailyCaloriesPageState();
}

class _DailyCaloriesPageState extends State<DailyCaloriesPage> {
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();

  Gender _gender = Gender.Male;
  ActivityLevel _activityLevel = ActivityLevel.Moderate;

  @override
  void initState() {
    super.initState();
    context.read<UserBodyInfoBloc>().add(LoadUserBodyInfoEvent());
  }

  void _save() {
    final weight = double.tryParse(_weightCtrl.text);
    final height = double.tryParse(_heightCtrl.text);
    final age = int.tryParse(_ageCtrl.text);

    if (weight == null || height == null || age == null) return;

    final bodyInfo = UserBodyInfo(
      weightKg: weight,
      heightCm: height,
      age: age,
      gender: _gender,
      activityLevel: _activityLevel,
    );

    context.read<UserBodyInfoBloc>().add(
      SaveUserBodyInfoEvent(userBodyInfo: bodyInfo),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Daily Calories",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<UserBodyInfoBloc, UserBodyInfoState>(
        listener: (context, state) {
          if (state is UserBodyInfoLoaded) {
            _weightCtrl.text = state.userBodyInfo.weightKg.toString();
            _heightCtrl.text = state.userBodyInfo.heightCm.toString();
            _ageCtrl.text = state.userBodyInfo.age.toString();

            setState(() {
              _gender = state.userBodyInfo.gender;
              _activityLevel = state.userBodyInfo.activityLevel;
            });
          }
        },
        child: PaddingWg(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Your body"),
              _card(
                child: Column(
                  children: [
                    _inputField(_weightCtrl, "Weight (kg)"),
                    _inputField(_heightCtrl, "Height (cm)"),
                    _inputField(_ageCtrl, "Age"),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              _sectionTitle("Gender"),
              _card(
                child: Row(
                  children: Gender.values.map((g) {
                    return Expanded(
                      child: RadioListTile<Gender>(
                        value: g,
                        groupValue: _gender,
                        title: Text(
                          g.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        onChanged: (v) => setState(() => _gender = v!),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.h),

              _sectionTitle("Activity level"),
              _card(
                child: DropdownButtonFormField<ActivityLevel>(
                  value: _activityLevel,
                  dropdownColor: Theme.of(context).cardColor,
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: ActivityLevel.values.map((a) {
                    return DropdownMenuItem(value: a, child: Text(a.name));
                  }).toList(),
                  onChanged: (v) => setState(() => _activityLevel = v!),
                ),
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    "Save & Calculate",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- UI helpers ----------

  Widget _card({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }

  Widget _inputField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
