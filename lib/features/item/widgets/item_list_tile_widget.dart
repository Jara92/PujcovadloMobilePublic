import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/item_placeholder_image.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemListTileWidget extends StatelessWidget {
  final ItemResponse item;

  const ItemListTileWidget({required this.item, super.key});

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
                padding: const EdgeInsets.only(right: 0),

                /// TODO: placeholder when cannot load the image
                child: item.mainImage?.url == null
                    ? const ItemPlaceholderImage()
                    : FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        // TODO: add url of placeholder image??
                        image: item.mainImage?.url ?? '',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            const ItemPlaceholderImage()),
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
                          item.name,
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
                              style: Theme.of(context).textTheme.labelSmall!,
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
                                Text(context.loc.price(item.pricePerDay),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        )),
                                Text(
                                  " ${context.loc.per_day}",
                                  style:
                                      Theme.of(context).textTheme.labelSmall!,
                                )
                              ]),
                            ],
                          ),
                          Column(
                            children: [
                              item.refundableDeposit == null
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
                                                  item.refundableDeposit!),
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
