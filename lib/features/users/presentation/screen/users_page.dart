import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfarmadmin/features/users/application/get_users_list.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
        ),
        title: const Text('قائمة المشرفين'),
      ),
      bottomSheet: BottomSheet(
        builder: (context) {
          return Row(children: [
            ElevatedButton(
              child: Text(' اضافة مشرف '),
              onPressed: () {
                context.go('/users');
              },
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
                final users = ref.watch(getUsersListProvider);

                return users.when(
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
                          onTap: () => {print(item.email)},
                          child: ListTile(
                            selected: false,
                            selectedColor: Theme.of(context).primaryColor,
                            // tileColor: Colors.blue[100],
                            shape: Border.all(
                                color: Theme.of(context).primaryColor,
                                style: BorderStyle.solid,
                                width: 2),
                            title: Text(
                              ' المشرف:     \t ${item.email.toString()}',
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
                                    'المزرعة:${item.userMetadata?['farm_id'].toString()}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
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
              onPressed: () => context.go('/'),
              child: const Text('اضافة مشرف جديد'),
            ),
          ],
        ),
      ),
    );
  }
}
