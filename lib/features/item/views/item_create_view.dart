import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step1.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step2.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step3.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step4.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step5.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step6.dart';

class ItemCreateView extends StatelessWidget {
  final ItemRequest? item;

  const ItemCreateView({this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = CreateItemBloc(item);
        bloc.add(const InitialEvent());
        return bloc;
      },
      child: BlocBuilder<CreateItemBloc, CreateItemState>(
        builder: (context, state) {
          return IndexedStack(index: state.activeStepperIndex, children: steps);
        },
      ),
    );
  }
}

List<Widget> steps = <Widget>[
  Step1(),
  Step2(),
  Step3(),
  Step4(),
  Step5(),
  Step6()
];
