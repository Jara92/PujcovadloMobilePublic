import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step5_prices/step5_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/form_container.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/item_form_heading.dart';

class Step5 extends StatefulWidget {
  const Step5({super.key});

  @override
  State<Step5> createState() => _Step5State();
}

class _Step5State extends State<Step5> {
  late final TextEditingController _controllerPricePerDay;
  late final TextEditingController _controllerRefundableDeposit;
  late final TextEditingController _controllerSellingPrice;

  @override
  void initState() {
    super.initState();
    _controllerPricePerDay = TextEditingController();
    _controllerRefundableDeposit = TextEditingController();
    _controllerSellingPrice = TextEditingController();
  }

  @override
  void dispose() {
    _controllerPricePerDay.dispose();
    _controllerRefundableDeposit.dispose();
    _controllerSellingPrice.dispose();
    super.dispose();
  }

  String? _localizePricePerDayError(
      BuildContext context, ItemPricePerDay field) {
    if (field.isPure || field.isValid) {
      return null;
    }

    switch (field.error) {
      case ItemPricePerDayValidationError.required:
        return context.loc.item_price_per_day_verror_required;
      case ItemPricePerDayValidationError.tooSmall:
        return context.loc.item_price_per_day_verror_too_small;
      case ItemPricePerDayValidationError.tooLarge:
        return context.loc.item_price_per_day_verror_too_large;
      case null:
        return null;
    }
  }

  String? _localizeRefundableDepositError(
      BuildContext context, ItemRefundableDeposit field) {
    if (field.isPure || field.isValid) {
      return null;
    }

    switch (field.error) {
      case ItemRefundableDepositValidationError.tooSmall:
        return context.loc.item_refundable_deposit_verror_too_small;
      case ItemRefundableDepositValidationError.tooLarge:
        return context.loc.item_refundable_deposit_verror_too_large;
      case null:
        return null;
    }
  }

  String? _localizeSellingPriceError(
      BuildContext context, ItemSellingPrice field) {
    if (field.isPure || field.isValid) {
      return null;
    }

    switch (field.error) {
      case ItemSellingPriceValidationError.tooSmall:
        return context.loc.item_selling_price_verror_too_small;
      case ItemSellingPriceValidationError.tooLarge:
        return context.loc.item_selling_price_verror_too_large;
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Step5Bloc(context.read<CreateItemBloc>())
        ..add(const Step5InitialEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.title_create_new_item),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            // Todo: ask confirmation if there are unsaved changes
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<Step5Bloc, Step5State>(
          listener: (context, state) {
            // Update text fields and round the values so the decimal part is hidden
            _controllerPricePerDay.text =
                state.pricePerDay.value?.round().toString() ?? "";
            _controllerRefundableDeposit.text =
                state.refundableDeposit.value?.round().toString() ?? "";
            _controllerSellingPrice.text =
                state.sellingPrice.value?.round().toString() ?? "";
          },
          builder: (context, state) {
            return FormContainer(
              child: Column(
                children: [
                  ItemFormHeading(
                    title: context.loc.item_prices_page_title,
                    description: context.loc.item_prices_page_description,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controllerPricePerDay,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            //FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]")), //
                          ],
                          // Only numbers can be entered
                          onChanged: (String value) {
                            BlocProvider.of<Step5Bloc>(context).add(
                                PricePerDayChanged(double.tryParse(value)));
                          },
                          decoration: InputDecoration(
                            labelText: context.loc.item_price_per_day_title,
                            hintText: context.loc.item_price_per_day_hint_text,
                            helperText:
                                context.loc.item_price_per_day_helper_text,
                            errorText: _localizePricePerDayError(
                                context, state.pricePerDay),
                            errorMaxLines: 2,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controllerRefundableDeposit,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            //FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]")), //
                          ],
                          // Only numbers can be entered
                          onChanged: (String value) {
                            BlocProvider.of<Step5Bloc>(context).add(
                                RefundableDepositChanged(
                                    double.tryParse(value)));
                          },
                          decoration: InputDecoration(
                            labelText:
                                context.loc.item_refundable_deposit_title,
                            hintText:
                                context.loc.item_refundable_deposit_hint_text,
                            helperText:
                                context.loc.item_refundable_deposit_helper_text,
                            helperMaxLines: 3,
                            errorText: _localizeRefundableDepositError(
                                context, state.refundableDeposit),
                            errorMaxLines: 2,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controllerSellingPrice,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            //FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]")), //
                          ],
                          // Only numbers can be entered
                          onChanged: (String value) {
                            BlocProvider.of<Step5Bloc>(context).add(
                                SellingPriceChanged(double.tryParse(value)));
                          },
                          decoration: InputDecoration(
                            labelText: context.loc.item_selling_price_title,
                            hintText: context.loc.item_selling_price_hint_text,
                            helperText:
                                context.loc.item_selling_price_helper_text,
                            helperMaxLines: 3,
                            errorText: _localizeSellingPriceError(
                                context, state.sellingPrice),
                            errorMaxLines: 2,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: BlocBuilder<Step5Bloc, Step5State>(
            builder: (context, state) {
              return Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: Text(context.loc.back),
                    onPressed: () => context
                        .read<Step5Bloc>()
                        .add(const PreviousStepEvent()),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(context.loc.next),
                    onPressed: state.isValid
                        ? () =>
                            context.read<Step5Bloc>().add(const NextStepEvent())
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
