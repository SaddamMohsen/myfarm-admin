import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfarmadmin/features/users/application/get_users_list.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:myfarmadmin/util/constant.dart';

class CreatFarm extends StatefulWidget {
  const CreatFarm({super.key});

  @override
  State<CreatFarm> createState() => _CreatFarmState();
}

class _CreatFarmState extends State<CreatFarm> {
  final form = FormGroup({
    'farmName': FormControl<String>(validators: [Validators.required]),
    'farmType': FormControl<FarmType>(validators: [Validators.required]),
    'noOfAmbers': FormControl<int>(validators: [Validators.required]),
    'farmStartDate': FormControl<DateTime>(),
    'isRunning': FormControl<bool>(),
    'farmSupervisor': FormControl<String>(validators: [Validators.required])
  });
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('اضافة بيانات مزرعة جديد'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stepper(
            steps: getSteps(currentStep, form, context),
            type: StepperType.horizontal,
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
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ReactiveForm(
          formGroup: form,
          child: ReactiveTextField(formControlName: 'farmName'),
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
          child:
              ReactiveDropdownField(formControlName: 'farmType', items: const [
            DropdownMenuItem(
              value: FarmType.Laying,
              child: Text('بياض'),
            ),
            DropdownMenuItem(
              value: FarmType.Broiler,
              child: Text('لاحم'),
            ),
            DropdownMenuItem(
              value: FarmType.Brood,
              child: Text('امهات'),
            )
          ]),
        ),
        label: const Text(
          'نوع المزرعة',
        )),
    //step 3 to insert production of eggs and out eggs and save
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
              error: (err, stack) => Text('خطأ: $err'),
              data: (data) => ReactiveDropdownField(
                formControlName: 'farmSuperVisor',
                //dropdownColor: const Color.fromARGB(255, 235, 237, 240),
                borderRadius: BorderRadius.circular(15),
                elevation: 10,
                // decoration:
                //     customeInputDecoration(context, 'حدد رقم العنبر'),
                alignment: AlignmentDirectional.bottomEnd,

                //get the list of ambers and convert it into dropdown men item list
                items: data.map<DropdownMenuItem<String>>((userData) {
                  return DropdownMenuItem<String>(
                    value: userData.id,
                    child: Text('${userData.email}'),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    ),
    Step(
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 3,
      title: const Text(
        "عدد العنابر",
      ),
      content: ReactiveForm(
        formGroup: form,
        child: ReactiveTextField(formControlName: 'noOfAmbers'),
      ),
    ),
  ];
}
