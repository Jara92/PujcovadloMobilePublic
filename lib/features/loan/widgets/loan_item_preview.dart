import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_main_image.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';

class LoanItemPreview extends StatelessWidget {
  final LoanResponse loan;
  final Widget? statusBadge;

  const LoanItemPreview({required this.loan, this.statusBadge, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color.fromARGB(255, 250, 249, 248),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.only(right: 0),
                child: Stack(children: [
                  Positioned.fill(
                      child: ItemMainImage(
                    image: loan.itemImage,
                  )),
                  if (statusBadge != null)
                    Align(alignment: Alignment.bottomCenter, child: statusBadge)
                ]),
              )),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(7),
              //height: double.infinity,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          loan.itemName,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 14,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                            child: Text(
                          "${context.loc.date(loan.from)} - ${context.loc.date(loan.to)}",
                          style: Theme.of(context).textTheme.labelSmall!,
                        )),
                      ]),
                      Row(children: [
                        Text(
                          " ${context.loc.item_price_per_day}",
                          style: Theme.of(context).textTheme.labelSmall!,
                        ),
                        const SizedBox(width: 5),
                        //Icon(Icons.attach_money),
                        Text(context.loc.price(loan.pricePerDay),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                )),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(children: [
                                Text(
                                  " ${context.loc.loan_expected_price_short}",
                                  style:
                                      Theme.of(context).textTheme.labelSmall!,
                                ),
                                const SizedBox(width: 5),
                                Text(context.loc.price(loan.expectedPrice),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        )),
                              ]),
                            ],
                          ),
                          Column(
                            children: [
                              loan.refundableDeposit == null
                                  ? const Column(
                                      children: [],
                                    )
                                  : Column(
                                      children: [
                                        Row(children: [
                                          Text(
                                            "${context.loc.item_refundable_deposit_short} ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!,
                                          ),
                                          //Icon(Icons.attach_money),
                                          Text(
                                              context.loc.price(
                                                  loan.refundableDeposit!),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    // fontWeight: FontWeight.bold,
                                                  )),
                                        ]),
                                      ],
                                    ),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
