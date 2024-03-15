import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pujcovadlo_client/common/custom_colors.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/item/responses/item_detail_response.dart';
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
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: CustomColors.gold,
                      size: 20,
                    ),
                    Text(
                      "4.4 (12 recenzí)",
                      style: Theme.of(context).textTheme.labelSmall!,
                    ),
                  ]),
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
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
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
                                  color:
                                      Theme.of(context).colorScheme.primary,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!,
                                ),
                                Text(
                                    context.loc.price(
                                        widget.item.refundableDeposit!),
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
            margin: const EdgeInsets.only(bottom: 5),
            child: widget.item.sellingPrice == null
                ? const Row()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_cart),
                          label: Text(context.loc
                              .item_buy_for_button(context.loc.price(
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
          Text(widget.item.description),
          Container(
            height: 200,
            child: FlutterMap(
              options: MapOptions(
                //initialCenter: LatLng(widget.item.longitude!, widget.item.latitude!),
                //initialCenter: LatLng(widget.item.latitude!, widget.item.longitude!),
                initialCenter: LatLng(widget.item.latitude!, widget.item.longitude!),
                //initialCenter: LatLng(51.509364, -0.128928),
                initialZoom: 15,
               // initialCameraFit: CameraFit.
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
                CircleLayer(circles: [
                  CircleMarker(
                    point: LatLng(widget.item.latitude!, widget.item.longitude!),
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderColor: Theme.of(context).primaryColor,
                    borderStrokeWidth: 2,
                    radius: 50,
                  ),
                ]),
              ],
            )
          )
        ],
      ),
    );
  }
}
