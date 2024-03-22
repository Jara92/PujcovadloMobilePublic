part of 'step1_bloc.dart';

@immutable
class Step1State {
  final ItemName name;
  final ItemDescription description;

  bool get isValid => name.isValid && description.isValid;

  const Step1State({
    this.name = const ItemName.pure(),
    this.description = const ItemDescription.pure(),
  });

  Step1State copyWith({
    ItemName? name,
    ItemDescription? description,
  }) {
    return Step1State(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

class InitialState extends Step1State {
  const InitialState({
    super.name,
    super.description,
  });
}