
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderBanner extends StatelessWidget {
  const SliderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image:  DecorationImage(
              image: NetworkImage("https://assets.materialup.com/uploads/3d93aeff-2058-4e83-bb26-92a2fae5ba2d/preview.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage("https://img.lovepik.com/free-template/bg/20200922/bg/afe571a58445a_415745.png_list.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: NetworkImage("http://d3design.vn/uploads/Anh_Bia_Food_menu_web_banner_social_media_banner_template_Free_Psd.jpg"),
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
    );
  }
}