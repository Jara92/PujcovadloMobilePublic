import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/common/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/common/widgets/not_found_widget.dart';
import 'package:pujcovadlo_client/item/bloc/item_detail/item_detail_bloc.dart';

import '../../common/custom_colors.dart';

class ItemDetailView extends StatefulWidget {
  final int itemId;

  const ItemDetailView({super.key, required this.itemId});

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocProvider(
          create: (context) {
            var bloc = ItemDetailBloc();
            bloc.add(LoadItemDetail(itemId: widget.itemId));
            return bloc;
          },
          child: BlocConsumer<ItemDetailBloc, ItemDetailState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is ItemDetailFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              }
            },
            builder: (context, state) {
              // Display item not found message
              if (state is ItemDetailNotFound) {
                return const NotFoundWidget();
              }

              // Display item detail
              if (state is ItemDetailLoaded) {
                var item = state.item;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: CustomColors.gold,
                                    size: 20,
                                  ),
                                  Text(
                                    "4.4 (12 recenzí)",
                                    style:
                                        Theme.of(context).textTheme.labelSmall!,
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 20,
                                  ),
                                  Text(
                                    "2,2 km od Vás",
                                    style:
                                        Theme.of(context).textTheme.labelSmall!,
                                  ),
                                ])
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          //color: Colors.red,
                          child: Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 300,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                                carouselController: _controller,
                                items: item.images.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        /*decoration: BoxDecoration(
                                          color: Colors.amber,
                                        ),*/
                                        child: FittedBox(
                                          child: Image.network(i.url),
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              Wrap(
                                  children:
                                      item.images.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                (Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                      ),
                                    );
                                  }).toList()),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(context.loc.price(item.pricePerDay),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                              )),
                                      Text(
                                        " ${context.loc.per_day}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!,
                                      )
                                    ],
                                  ),
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
                                                "${context.loc.item_refundable_deposit} ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!,
                                              ),
                                              Text(
                                                  context.loc.price(
                                                      item.refundableDeposit!),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                            ]),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit_calendar),
                                  label: Text(context.loc.item_rent_for_button(
                                      context.loc.price(item.pricePerDay))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: item.sellingPrice == null
                              ? const Row()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.shopping_cart),
                                        label: Text(context.loc
                                            .item_buy_for_button(
                                                context.loc.price(
                                          item.sellingPrice!,
                                        ))),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Text(
                                context.loc.item_description_short,
                                style: Theme.of(context).textTheme.titleMedium!,
                              ),
                            ],
                          ),
                        ),
                        Text(state.item.description),
                      ],
                    ),
                  ),
                );
              }

              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return const Text("Empty");
            },
          ),
        ),
      ),
      //bottomNavigationBar: MainBottomNavigationBar(),
    );
  }
}
