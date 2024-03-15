import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pujcovadlo_client/common/custom_colors.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/item/responses/item_response.dart';

class ItemListWidget extends StatelessWidget {
  final Iterable<ItemResponse> items;

  const ItemListWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items.elementAt(index);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(right: 0),
                  child: Image.network(
                    item.mainImage?.url ?? "https://via.placeholder.com/100",
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  //height: double.infinity,
                  color: const Color.fromARGB(255, 250, 249, 248),
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
                              item.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 2,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: CustomColors.gold,
                                  size: 20,
                                ),
                                Text(
                                  "4.4",
                                  style:
                                      Theme.of(context).textTheme.labelSmall!,
                                ),
                              ])
                        ],
                      ),
                      Column(
                        children: [
                          Row(children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                            ),
                            Text("1.2 km",
                                style: Theme.of(context).textTheme.labelSmall!),
                          ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(children: [
                                    //Icon(Icons.attach_money),
                                    Text(
                                        context.loc
                                            .price(item.pricePerDay),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              color:
                                                  Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            )),
                                    Text(
                                      " ${context.loc.per_day}",
                                      style: Theme.of(context).textTheme.labelSmall!,
                                    )
                                  ]),
                                ],
                              ),
                              Column(
                                children: [
                                  item.refundableDeposit == null ? const Column(children: [],) : Column(
                                    children: [
                                      Row(children: [
                                        Text(
                                          "${context.loc.item_refundable_deposit_short} ",
                                          style: Theme.of(context).textTheme.labelSmall!,
                                        ),
                                        //Icon(Icons.attach_money),
                                        Text(
                                            context.loc
                                                .price(item.refundableDeposit!),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                              color:
                                              Theme.of(context).colorScheme.secondary,
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
      },
    );
  }
}
