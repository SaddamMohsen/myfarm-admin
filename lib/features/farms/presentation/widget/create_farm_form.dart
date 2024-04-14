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
      // appBar: AppBar(
      //   title: const Text('اضافة بيانات مزرعة جديد'),
      // ),
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
                  const SizedBox()
                else
                  ElevatedButton(
                    onPressed: () {
                      print('pressed cont');
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
              print('onstep continue');
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
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 3,
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
              data: (data) => ReactiveDropdownField(
                formControlName: 'farmSupervisor',
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
            );
          },
        ),
      ),
    ),
    Step(
      state: currentStep > 4 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 4,
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
