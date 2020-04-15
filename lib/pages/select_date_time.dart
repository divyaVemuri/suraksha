import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:suraksha/constants/asset_constants.dart';
import 'package:suraksha/pages/my_date_picker.dart';
import 'package:suraksha/pages/cart.dart';
import 'package:suraksha/values/gradients.dart';

class SelectDateTime extends StatefulWidget {
  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  DateTime dateTime;
  int slotSelected;
  bool showCartPressed;

  String timeSlotSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCartPressed=false;
    dateTime=DateTime.now();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom),
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/profile/background.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _getAppBar(),
                  _getBody()
                ],
              ),
            ),
         showCartPressed?

    Cart(type:2,buttonPressed: (res){
      setState(() {
        showCartPressed=res;
      });
    },)
        :Container()

          ],
        ),
      ),
    );
  }

  _getAppBar() {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(right: 15, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Row(
              children: <Widget>[
                InkResponse(
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: SvgPicture.asset(
                              'assets/svg/utilities/cart.svg'))),
                  onTap: (){
                    setState(() {
                      showCartPressed=true;

                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                InkResponse(
                  child: SvgPicture.asset('assets/svg/utilities/bell.svg'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _getBody(){
    return Expanded(
      flex: 10,
      child: Container(

        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white),
        child: Column(
          children: <Widget>[
            _getDate(),
            _getTimeSlot(),
            _getSlots(),

            _getNextButton(),

          ],
        ),
      ),
    );
  }


  _getDate() {
    DateTime currentTime = DateTime.now();
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 18,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                  ),
                  onPressed: () {
                    setState(() {
                      if (dateTime.year>=currentTime.year && dateTime.month>currentTime.month) {

                        dateTime = DateTime(
                            dateTime.year, dateTime.month - 1, dateTime.day);
                      }
                      if(dateTime.year==currentTime.year && dateTime.month==currentTime.month){
                        dateTime=DateTime(
                            dateTime.year, dateTime.month , dateTime.day
                        );
                      }

                      print("PRESSED PREV: "+dateTime.toString());
                    });
                  },
                ),
                Text(
                  new DateFormat("MMMM").format(dateTime),
                  style: TextStyle(
                      fontWeight: FontWeight.w600
                  ),// Month
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      dateTime = DateTime(
                          dateTime.year, dateTime.month + 1, 1);
                    });
                    print("PRESSED AFTER: "+dateTime.toString());

                  },
                )
              ],
            ),
          ),
          MyDatePicker(dateTime: dateTime,)
//          DatePickerTimeline(dateTime,dateTime),
        ],
      ),
    );
  }

  _getTimeSlot() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Select Time Slot',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 18,
              ),
            ),
          ),
          Container(
//            height: 40,
            padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
//                    height:40,
//                    width: 100,
                    child: GestureDetector(
                      child: (slotSelected != null && slotSelected == 1)
                          ? SvgPicture.asset(AssetConstants.slot_morning_selected,)
                          : SvgPicture.asset(AssetConstants.slot_morning,),
                      onTap: () {
                        setState(() {
                          slotSelected = 1;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    child: (slotSelected != null && slotSelected == 2)
                        ? SvgPicture.asset(
                        AssetConstants.slot_afternoon_selected)
                        : SvgPicture.asset(AssetConstants.slot_afternoon),
                    onTap: () {
                      setState(() {
                        slotSelected = 2;
                      });
                    },
                  ),
                  GestureDetector(
                    child: (slotSelected != null && slotSelected == 3)
                        ? SvgPicture.asset(AssetConstants.slot_evening_selected)
                        : SvgPicture.asset(AssetConstants.slot_evening),
                    onTap: () {
                      setState(() {
                        slotSelected = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getSlot(String slot){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),

        decoration: BoxDecoration(

          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(35)),
          gradient: timeSlotSelected!=null && timeSlotSelected==slot? Gradients.redGradient: null

        ),
        child: Text(
          slot,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: timeSlotSelected!=null && timeSlotSelected==slot?Colors.white:Colors.grey,
            fontFamily: "Avenir Next",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          timeSlotSelected=slot;
        });
      },
    );
  }

  _getSlots(){
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20,top: 10, bottom: 20),
      color: Colors.white,
      child: StaggeredGridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        shrinkWrap: true,
        staggeredTiles: [
          StaggeredTile.fit( 1),
          StaggeredTile.fit( 1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),

//          StaggeredTile.count(2, 1),
//          StaggeredTile.count(2, 1),
//          StaggeredTile.count(2, 1),
        ],
        children: <Widget>[
          _getSlot('12:00 - 12:30'),
          _getSlot('12:30 - 01:00'),
          _getSlot('01:00 - 01:30'),
          _getSlot('01:30 - 02:00'),
          _getSlot('02:00 - 02:30'),
          _getSlot('02:30 - 03:00'),

        ],
      ),
    );
  }

  _getNextButton() {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
//          borderRadius: BorderRadius.circular(10),
//          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: Offset(0, 1),
                spreadRadius: 0,
                blurRadius: 5),
//            BoxShadow(
//                color: Colors.grey[900],
//                offset: Offset(0, 10),
//                spreadRadius: 0,
//                blurRadius: 5)
          ],
        ),
        padding: EdgeInsets.only(bottom: 20,top: 20),
        child: CircleAvatar(
          //R:191, G:0, B:36
          backgroundColor: Color.fromRGBO(191, 0, 36, 1),
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ));
  }
}
