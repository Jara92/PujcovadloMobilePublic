part of 'create_item_bloc.dart';

@immutable
class CreateItemState {
/*  final ItemName name;
  final ItemDescription description;*/

  //final ItemRequest? item;
  final int step;
  final bool isValid;

  const CreateItemState({
/*    this.name = const ItemName.pure(),
    this.description = const ItemDescription.pure(),*/
    this.step = 0,
    this.isValid = true,
  });

/*  CreateItemState copyWith({
    ItemName? name,
    ItemDescription? description,
    int? step,
    bool? isValid,
  }) {
    return CreateItemState(
*/ /*      name: name ?? this.name,
      description: description ?? this.description,*/ /*
      step: step ?? this.step,
      isValid: isValid ?? this.isValid,
    );
  }*/
}

class InitialState extends CreateItemState {
  InitialState({ItemRequest? item}) : super(step: 0, isValid: true);
}

class Step1_NameAndDescription extends CreateItemState {
  final ItemName name;
  final ItemDescription description;

  Step1_NameAndDescription({
    required this.name,
    required this.description,
    super.isValid,
  }) : super(step: 1);

  Step1_NameAndDescription copyWith({
    ItemName? name,
    ItemDescription? description,
    bool? isValid,
  }) {
    return Step1_NameAndDescription(
      name: name ?? this.name,
      description: description ?? this.description,
      isValid: isValid ?? this.isValid,
    );
  }
}
