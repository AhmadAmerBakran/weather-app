import 'package:flutter/material.dart';


class WeatherSliverAppBar extends StatelessWidget {
  const WeatherSliverAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      onStretchTrigger: () async {
        print('Load new data!');
        // await Server.requestNewData();
      },
      backgroundColor: Colors.teal[800],
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
        title: const Text('EASV Weather app'),
        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: <Color>[Colors.teal[800]!, Colors.transparent],
            ),
          ),
          child: Image.asset(
            'assets/images/header.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}