import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfarmadmin/features/farms/application/create_farm.dart';
import 'package:myfarmadmin/features/farms/domain/entities/farm_entity.dart';
import 'package:myfarmadmin/features/users/application/get_users_list.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreatFarm extends ConsumerStatefulWidget {
  const CreatFarm({super.key});

  @override
  ConsumerState<CreatFarm> createState() => _CreatFarmState();
}

class _CreatFarmState extends ConsumerState<CreatFarm> {
  final form = FormGroup({
    'id': FormControl<int>(value: 4),
    'farm_name': FormControl<String>(validators: [Validators.required]),
    'farm_type': FormControl<String>(validators: [Validators.required]),
    'no_of_ambers': FormControl<int>(validators: [Validators.required]),
    'farm_start_date': FormControl<DateTime>(),
    'is_running': FormControl<bool>(value: true),
    'farm_supervisor': FormControl<String>(validators: [Validators.required]),
  });
  int currentStep = 0;
  late FarmEntity newFarm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        //scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stepper(
            steps: getSteps(currentStep, form, context),
            //type: StepperType.horizontal,
            currentStep: currentStep,
            controlsBuilder: (context, details) => Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //if it is the last step hide continue button
                if (currentStep ==
                    getSteps(currentStep, form, context).length - 1)
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ReactiveForm(
                      formGroup: form,
                      child: ReactiveFormConsumer(
                        builder: (context, form, child) => ElevatedButton(
                          onPressed: () => {
                            print(form.value),
                            newFarm = FarmEntity.fromJson(form.value),
                            ref.watch(CreateFarmProvider(newFarm: newFarm)),
                            print({newFarm}),
                          },
                          child: Text('حفظ'),
                        ),
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStep++;
                      });
                      details.onStepContinue;
                    },
                    child: Text('التالي'),
                  ),
                const SizedBox(
                  width: 20.0,
                ),
                // if this is the first step hide the back button
                if (currentStep == 0)
                  const SizedBox()
                else
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStep--;
                      });
                    },
                    child: Text('رجــــوع'),
                  ),
              ],
            ),
            onStepCancel: () => currentStep == 0
                ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('لا توجد خطوة قبل هذه'),
                  ))
                : setState(() {
                    currentStep--;
                  }),
            onStepContinue: () {
              bool isLastStep = (currentStep ==
                  getSteps(currentStep, form, context).length - 1);
              if (isLastStep) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('لقدوصلت للنهاية لا تنسى الحفظ'),
                  ),
                );
              } else {
                setState(() {
                  currentStep++;
                });
              }
            },
            onStepTapped: (step) => {
              if (currentStep != 0)
                setState(() {
                  currentStep = step;
                })
              else
                {}
            },
          ),
        ),
      ),
    );
  }
}

List<Step> getSteps(int currentStep, FormGroup form, BuildContext context) {
  return <Step>[
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text("اسم المزرعة"),
      content: Container(
        width: 150.0,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ReactiveForm(
          formGroup: form,
          child: ReactiveTextField(formControlName: 'farm_name'),
        ),
      ),
    ),
    Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text(
          "  حدد نوع المزرعة",
          // style: TextStyle(color: Colors.blue),
        ),
        content: ReactiveForm(
          formGroup: form,
          child: Container(
            width: 150.0,
            height: 50,
            decoration: BoxDecoration(
              border:
                  Border.all(width: 0.5, color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ReactiveDropdownField(
                formControlName: 'farm_type',
                elevation: 10,
                alignment: Alignment.bottomCenter,
                items: [
                  DropdownMenuItem<String>(
                    value: 'بياض',
                    child: Text('بياض'),
                  ),
                  DropdownMenuItem(
                    value: 'لاحم',
                    child: Text('لاحم'),
                  ),
                  const DropdownMenuItem(
                    value: 'امهات',
                    child: Text('امهات'),
                  )
                ].toList()),
          ),
        ),
        label: const Text(
          'نوع المزرعة',
        )),
    Step(
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 3,
      title: const Text(
        "عدد العنابر",
      ),
      content: Container(
        width: 150.0,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ReactiveForm(
          formGroup: form,
          child: ReactiveTextField(
            formControlName: 'no_of_ambers',
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    ),
    Step(
      state: currentStep > 4 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 4,
      title: const Text(
        "تعيين مشرف للمزرعة",
      ),
      content: ReactiveForm(
        formGroup: form,
        child: Consumer(
          builder: (_, WidgetRef ref, __) {
            final users = ref.watch(getUsersListProvider);

            return users.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Text('خطأ في استرجاع بيانات المشرفين: $err'),
              data: (data) => Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ReactiveDropdownField(
                  formControlName: 'farm_supervisor',
                  borderRadius: BorderRadius.circular(15),
                  elevation: 10,
                  alignment: AlignmentDirectional.bottomEnd,

                  //get the list of users and convert it into dropdown men item list
                  items: data.map<DropdownMenuItem<String>>((userData) {
                    return DropdownMenuItem<String>(
                      value: userData.id,
                      child: Text('${userData.email}'),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    ),
  ];
}
