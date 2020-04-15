import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suraksha/library/curved_navigation_bar.dart' as prefix0;

class Sample extends StatefulWidget {

  final ValueChanged<int> index;


  Sample({this.index});

  @override
  _SampleState createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: prefix0.CurvedNavigationBar(
          height: 50,
          animationDuration: Duration(milliseconds: 300),
          animationCurve: Curves.bounceInOut,
          items: <Widget>[

            Container(
              child: SvgPicture.asset(
                'assets/svg/utilities/branchLocator.svg',fit: BoxFit.contain,
              ),
            ),
            Container(
              child: SvgPicture.asset(
                'assets/svg/utilities/appointment.svg',fit: BoxFit.fill,
              ),
            ),
            SvgPicture.asset(
              'assets/svg/utilities/home.svg',fit: BoxFit.fill,
            ),
            SvgPicture.asset(
              'assets/svg/utilities/wallet.svg',fit: BoxFit.fill,
            ),
            SvgPicture.asset(
              'assets/svg/utilities/report.svg',fit: BoxFit.fill,
            )

          ],
          onTap: (index){
            widget.index(index);
          },
        )
      ),
    );
  }
}
