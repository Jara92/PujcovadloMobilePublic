import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step1.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/step2.dart';

class ItemCreateView extends StatelessWidget {
  const ItemCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = CreateItemBloc();
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
  Scaffold(appBar: AppBar(), body: Text("Step3")),
];
