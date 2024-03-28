import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/core/widgets/loading_indicator.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_list_tile_widget.dart';
import 'package:pujcovadlo_client/features/loan/bloc/create_loan/form/create_loan_bloc.dart';
import 'package:pujcovadlo_client/features/loan/models/loan_tenant_note.dart';
import 'package:pujcovadlo_client/features/loan/views/create_loan/create_loan_submit_view.dart';

class CreateLoanView extends StatefulWidget {
  final int? itemId;
  final ItemResponse? item;
  final String? restorationId;

  const CreateLoanView({this.itemId, this.item, this.restorationId, super.key})
      : assert(itemId != null || item != null);

  @override
  State<CreateLoanView> createState() => _CreateLoanViewState();
}

class _CreateLoanViewState extends State<CreateLoanView> with RestorationMixin {
  late final CreateLoanFormBloc _bloc;
  late final TextEditingController _controllerDescription;

  // No default values are provided for the restoration properties.
  final RestorableDateTimeN _startDate = RestorableDateTimeN(null);
  final RestorableDateTimeN _endDate = RestorableDateTimeN(null);

  late final RestorableRouteFuture<DateTimeRange?>
      _restorableDateRangePickerRouteFuture =
      RestorableRouteFuture<DateTimeRange?>(
    onComplete: _selectDateRange,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator
          .restorablePush(_dateRangePickerRoute, arguments: <String, dynamic>{
        'initialStartDate': _startDate.value?.millisecondsSinceEpoch,
        'initialEndDate': _endDate.value?.millisecondsSinceEpoch,
      });
    },
  );

  @override
  void initState() {
    super.initState();
    _bloc = CreateLoanFormBloc(item: widget.item, itemId: widget.itemId)
      ..add(const InitialEvent());
    _controllerDescription = TextEditingController();
  }

  @override
  void dispose() {
    _controllerDescription.dispose();
    super.dispose();
  }

  /// Callback for the [RestorableRouteFuture.onComplete] property.
  void _selectDateRange(DateTimeRange? newSelectedDate) {
    // If the date range is selected
    if (newSelectedDate != null) {
      setState(() {
        _startDate.value = newSelectedDate.start;
        _endDate.value = newSelectedDate.end;
      });

      //  Trigger bloc event
      _bloc.add(UpdatedDatesEvent(
        startDate: newSelectedDate.start,
        endDate: newSelectedDate.end,
      ));
    } /*else {
      //  Trigger bloc event with empty data
      _bloc.add(const UpdatedDatesEvent());
    }*/
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'start_date');
    registerForRestoration(_endDate, 'end_date');
    registerForRestoration(
        _restorableDateRangePickerRouteFuture, 'date_picker_route_future');
  }

  @pragma('vm:entry-point')
  static Route<DateTimeRange?> _dateRangePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDateRange:
              _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          currentDate: DateUtils.dateOnly(DateTime.now()),
          firstDate: DateUtils.dateOnly(DateTime.now()),
          lastDate: DateUtils.dateOnly(
              DateTime.now().add(const Duration(days: 365 * 5))),
        );
      },
    );
  }

  static DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }

    return null;
  }

  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: LoaderOverlay(
        child: Scaffold(
            appBar: AppBar(
              title: Text(context.loc.loan_create_page_title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: RefreshIndicator(
                onRefresh: () async {}, // todo - send form again
                /*          onRefresh: () => Future.sync(
                  () => _bloc.add(RefreshBorrowedLoanDetailEvent())),*/
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child:
                          BlocConsumer<CreateLoanFormBloc, CreateLoanFormState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          // Loan detail is loaded
                          if (state.status == CreateLoanFormStateEnum.loaded) {
                            return _buildForm(context, state);
                          }

                          // something failed
                          if (state.status == CreateLoanFormStateEnum.error) {
                            return OperationError(
                              minHeight: viewportConstraints.maxHeight,
                              /*onRetry: () =>
                                  BlocProvider.of<CreateLoanFormBloc>(context)
                                      .add(RefreshBorrowedLoanDetailEvent())*/
                            );
                          }

                          return LoadingIndicator(
                            minHeight: viewportConstraints.maxHeight,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: [
                  const Spacer(),
                  BlocBuilder<CreateLoanFormBloc, CreateLoanFormState>(
                    builder: (context, state) {
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: Text(context.loc.loan_sent_button),
                        // Allow to go to the next step only if the form is valid
                        onPressed: state.isValid
                            ? () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreateLoanSubmitView(
                                    loan: _bloc.request,
                                  ),
                                ))
                            : null,
                      );
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildForm(BuildContext context, CreateLoanFormState state) {
    final item = state.item!;

    return Column(
      children: [
        Row(
          children: [
            Text(
              context.loc.loan_create_loan_title,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ItemListTileWidget(item: item),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 6,
                child: Text(
                  context.loc.loan_reservation_date_title,
                  style: Theme.of(context).textTheme.titleMedium!,
                )),
            Flexible(
              flex: 6,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.watch_later),
                label: Text(context.loc.loan_reservation_date_button),
                onPressed: () =>
                    _restorableDateRangePickerRouteFuture.present(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
/*            Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
            const SizedBox(width: 5),*/
            Text(
              state.dates.isValid
                  ? context.loc.loan_reservation_date_preview(
                      state.dates.value!.start!,
                      state.dates.value!.end!,
                      state.days!)
                  : context.loc.loan_reservation_date_placeholder,
              style: Theme.of(context).textTheme.labelSmall!,
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              context.loc.loan_expected_price_title,
              style: Theme.of(context).textTheme.titleMedium!,
            )
          ],
        ),
        const SizedBox(height: 5),
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FixedColumnWidth(100),
            2: FixedColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Text(
                  context.loc.loan_price_per_day,
                  style: Theme.of(context).textTheme.labelSmall!,
                ),
                Text(
                  context.loc.price(item.pricePerDay),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                ),
                const SizedBox(height: 20),
              ],
            ),
            if (state.expectedPrice != null)
              TableRow(
                children: <Widget>[
                  Text(context.loc.loan_total_expected_price,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  Text(
                    context.loc.price(state.expectedPrice!),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            if (state.item!.refundableDeposit != null)
              TableRow(
                children: <Widget>[
                  Text(
                    context.loc.loan_refundable_deposit,
                    style: Theme.of(context).textTheme.labelSmall!,
                  ),
                  Text(
                    context.loc.price(item.refundableDeposit!),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              context.loc.loan_tenant_note_title,
              style: Theme.of(context).textTheme.titleMedium!,
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                // initialValue: state.description.value,
                controller: _controllerDescription,
                onChanged: (String value) {
                  BlocProvider.of<CreateLoanFormBloc>(context)
                      .add(TenantNoteChangedEvent(note: value));
                },
                maxLength: 500,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(Regex.multilineTextRegex),
                ],
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.multiline,
                minLines: 4,
                // Set this
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: context.loc.loan_tenant_note_title,
                  hintText: context.loc.loan_tenant_note_hint_text,
                  helperText: context.loc.loan_tenant_note_helper_text,
                  helperMaxLines: 3,
                  errorText:
                      _localizeTenantLoanError(context, state.tenantNote),
                  border: OutlineInputBorder(),
                  //border: InputBorder.none
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? _localizeTenantLoanError(BuildContext context, LoanTenantNote value) {
    if (value.isPure || value.isValid) {
      return null;
    }

    switch (value.error) {
      case LoanTenantNoteValidationError.invalid:
        return context.loc.verror_input_invalid;
      case LoanTenantNoteValidationError.tooLong:
        return context.loc.verror_input_too_long;
      case null:
        return null;
    }
  }
}
