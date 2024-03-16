import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/responses/item_detail_response.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_rating_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailWidget extends StatefulWidget {
  final ItemDetailResponse item;

  const ItemDetailWidget({required this.item, super.key});

  @override
  State<ItemDetailWidget> createState() => _ItemDetailWidgetState();
}

class _ItemDetailWidgetState extends State<ItemDetailWidget> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    widget.item.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileRatingWidget(
                user: widget.item.owner,
                showReviewsCount: true,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                    ),
                    Text(
                      "2,2 km od Vás",
                      style: Theme.of(context).textTheme.labelSmall!,
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
                  items: widget.item.images.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5),
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
                    children: widget.item.images.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(context.loc.price(widget.item.pricePerDay),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                )),
                        Text(
                          " ${context.loc.per_day}",
                          style: Theme.of(context).textTheme.labelMedium!,
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    widget.item.refundableDeposit == null
                        ? const Column(
                            children: [],
                          )
                        : Column(
                            children: [
                              Row(children: [
                                Text(
                                  "${context.loc.item_refundable_deposit} ",
                                  style:
                                      Theme.of(context).textTheme.labelMedium!,
                                ),
                                Text(
                                    context.loc
                                        .price(widget.item.refundableDeposit!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
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
                        context.loc.price(widget.item.pricePerDay))),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: widget.item.sellingPrice == null
                ? const Row()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_cart),
                          label: Text(
                              context.loc.item_buy_for_button(context.loc.price(
                            widget.item.sellingPrice!,
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
          Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(widget.item.description)),
          Divider(),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Text(
                  context.loc.about_item_owner,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  //backgroundImage: NetworkImage(widget.item.owner?.profileImage),
                  backgroundImage: AssetImage("images/user_placeholder.png"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.item.owner.firstName} ${widget.item.owner.lastName}",
                        style: Theme.of(context).textTheme.titleMedium!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                      ),
                      ProfileRatingWidget(
                        user: widget.item.owner,
                        showReviewsCount: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 2),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.supervised_user_circle),
                      label: Text(context.loc.show_user_profile_button),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.message),
                      label: Text(context.loc.contact_owner_short_button),
                    ),
                  ),
                ]),
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(
                  context.loc.where_can_you_find_it,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
              ],
            ),
          ),
          Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 5),
              // TODO: Improve location anonymization
              child: FlutterMap(
                options: MapOptions(
                  initialCenter:
                      LatLng(widget.item.latitude!, widget.item.longitude!),
                  initialZoom: 14.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                  CircleLayer(circles: [
                    CircleMarker(
                      point:
                          LatLng(widget.item.latitude!, widget.item.longitude!),
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      borderColor: Theme.of(context).primaryColor,
                      borderStrokeWidth: 2,
                      radius: 250,
                      useRadiusInMeter: true,
                    ),
                  ]),
                ],
              )),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  context.loc.owner_will_tell_you_exact_location,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
