import 'package:flutter/material.dart';

/// i want to add functionality ti this class such that the houses can be fitered based on certain parameters and diplayed as results
/// this should be handled by 10th may

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
        ],
      ),
    );
  }
}
