
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderExample extends StatelessWidget {
  const CarouselSliderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      ListView(
          children: [
            CarouselSlider(
              items: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage("https://d1sag4ddilekf6.azureedge.net/compressed_webp/items/THITE2021040710553467885/detail/menueditor_item_f9774db3234a41919ccc9bc94e2fc2c9_1617792919551179805.webp"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage("https://d1sag4ddilekf6.azureedge.net/compressed_webp/items/THITE2021040710553467885/detail/menueditor_item_f9774db3234a41919ccc9bc94e2fc2c9_1617792919551179805.webp"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
                      image: NetworkImage("https://d1sag4ddilekf6.azureedge.net/compressed_webp/items/THITE2021040710553467885/detail/menueditor_item_f9774db3234a41919ccc9bc94e2fc2c9_1617792919551179805.webp"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 150.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
          ]),
    );
  }
}