import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greendit/core/common/error_text.dart';
import 'package:greendit/core/common/loader.dart';
import 'package:greendit/features/objectDetected/controller/object_detected_controller.dart';
import 'package:routemaster/routemaster.dart';

class ObjectView extends ConsumerWidget {
  const ObjectView({super.key});

  void navigateToAddObject(BuildContext context) {
    Routemaster.of(context).push('/add-object/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add electronics'),
            leading: const Icon(Icons.add),
            onTap: () => navigateToAddObject(context),
          ),
          ref.watch(userObjectDetectedProvider).when(
                data: (objectDetecteds) =>
                    Expanded(child: ListView.builder(
                      itemCount: objectDetecteds.length,
                      itemBuilder: (BuildContext context, int index){
                        final objectDetected = objectDetecteds[index];
                        return ListTile(
                          title: Text(objectDetected.object),
                        );
                      },
                    )),
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
