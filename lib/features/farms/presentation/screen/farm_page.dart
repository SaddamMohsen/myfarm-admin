import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfarmadmin/features/farms/application/get_farm_list.dart';
import 'package:myfarmadmin/features/farms/domain/entities/farm_entity.dart';

class FarmPage extends ConsumerStatefulWidget {
  const FarmPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmPageState();
}

class _FarmPageState extends ConsumerState<FarmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
        ),
        title: const Text('قائمة المزارع'),
      ),
      bottomSheet: BottomSheet(
        builder: (context) {
          return Row(children: [
            ElevatedButton(
              child: Text(' اضافة مزرعة '),
              onPressed: () {
                context.go('/addNewFarm');
              },
            ),
            ElevatedButton(
              onPressed: () => {},
              child: Text('تعديل مزرعة'),
            ),
          ]);
        },
        onClosing: () => print("closing"),
      ),
      body: Center(
        child: Column(
          children: [
            // ElevatedButton(
            //   onPressed: () => context.go('/home'),
            //   child: Text('الرجوع للصفحة السابقه'),
            // ),
            Consumer(
              builder: (_, WidgetRef ref, __) {
                print('in farm consumer');
                final farms = ref.watch(getFarmsListProvider);

                return farms.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('خطأ: $err'),
                  data: (data) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = data[index];
                      return Card(
                        child: InkWell(
                          onTap: () => {print(item.farm_name)},
                          child: ListTile(
                            selected: false,
                            selectedColor: Theme.of(context).primaryColor,
                            // tileColor: Colors.blue[100],
                            shape: Border.all(
                                color: Theme.of(context).primaryColor,
                                style: BorderStyle.solid,
                                width: 2),
                            title: Text(
                              ' المزرعة:     \t ${item.farm_name.toString()}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                              textDirection: TextDirection.rtl,
                            ),
                            subtitle: Wrap(
                              textDirection: TextDirection.rtl,
                              spacing: 10,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                InputChip(
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  label: Text(
                                    'عدد العنابر:${item.no_of_ambers.toString()}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                InputChip(
                                  // disabledColor:
                                  //     Color.fromARGB(255, 196, 220, 243),
                                  // backgroundColor: Color(0xFFD4E6F7),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  label: Text(
                                    item.farm_type.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                InputChip(
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  label: Text(
                                    'الحاله:${item.is_running ? 'شغاله' : 'متوقفه'}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                InputChip(
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  label: Text(
                                      'تاريخ البدايه:${item.farm_start_date.toString()}'),
                                ),
                              ],
                            ),
                            leadingAndTrailingTextStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color.fromARGB(255, 16, 8, 22),
                                ),
                            //selectedTileColor: Colors.black12,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              // Text('صفحة المزارع'),
              ,
            ),
            ElevatedButton(
              onPressed: () => context.go('/addNewFarm'),
              child: const Text('انشاء مزرعة جديدة'),
            ),
          ],
        ),
      ),
    );
  }
}
