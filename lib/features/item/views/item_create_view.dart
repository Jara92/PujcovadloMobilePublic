import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step1.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step2.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step3.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step4.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step5.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step6.dart';

class ItemCreateView extends StatelessWidget {
  final int? itemId;

  const ItemCreateView({this.itemId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateItemBloc()..add(InitialEvent(itemId: itemId)),
      child: BlocBuilder<CreateItemBloc, CreateItemState>(
        builder: (context, state) {
          if (state.status == CreateItemStateEnum.error) {
            return _buildPageBuilder(
                child: OperationError(
              onRetry: () => context
                  .read<CreateItemBloc>()
                  .add(InitialEvent(itemId: itemId)),
            ));
          }

          if (state.status == CreateItemStateEnum.loaded) {
            // The stack must be rendered only when the state is loaded because the steps are dependent on the data
            return IndexedStack(
                index: state.activeStepperIndex, children: steps());
          }

          // Show loading by default - should happen when the state = loading
          return _buildPageBuilder(
              child: const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  Widget _buildPageBuilder({required Widget child}) {
    return Scaffold(
      appBar: AppBar(),
      body: child,
    );
  }

  List<Widget> steps() => <Widget>[
        const Step1(),
        const Step2(),
        const Step3(),
        const Step4(),
        const Step5(),
        const Step6()
      ];
}
