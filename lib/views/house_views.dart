import 'package:flutter/material.dart';
import 'package:homi_2/services/get_house_service.dart';

class HousesView extends StatelessWidget {
  const HousesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          // const SizedBox(
          //   width: 25.0,
          // ),
          // InkWell(
          //   onTap: () async {
          //     final house = await fetchHouses();

          //     print(house);
          //     if (house != null) {
          //       Navigator.pushNamed(context, '/specific', arguments: house);
          //     } else {
          //       print("first house not accessed");
          //     }
          //   },
          //   child: Container(
          //     height: 240,
          //     width: 380,
          //     decoration: const BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(24)),
          //         image: DecorationImage(
          //           image: AssetImage('assets/images/1_1.jpeg'),
          //           fit: BoxFit.fill,
          //         )),
          //   ),
          // ),
          const SizedBox(
            width: 25.0,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/allHouses');
            },
            child: Container(
              height: 240,
              width: 380,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/1_2.jpeg'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/trialAllHouses');
            },
            child: Container(
              height: 240,
              width: 380,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/1_3.jpeg'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
          // InkWell(
          //   onTap: () {
          //     print("fourth house");
          //   },
          //   child: Container(
          //     height: 240,
          //     width: 380,
          //     decoration: const BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(24)),
          //         image: DecorationImage(
          //           image: AssetImage('assets/images/1_4.jpeg'),
          //           fit: BoxFit.fill,
          //         )),
          //   ),
          // ),
          // const SizedBox(
          //   width: 25.0,
          // ),
        ],
      ),
    );
  }
}
