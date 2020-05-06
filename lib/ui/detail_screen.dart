import 'package:flutter/material.dart';

import 'package:foursquare/model/argument.dart';
import 'package:foursquare/model/venue.dart';
import 'package:foursquare/bloc/request_bloc.dart';
import 'package:foursquare/constants.dart';

class DetailScreen extends StatefulWidget {
  static const String id = "detail_screen";

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _requestBloc = RequestBloc();
  bool favourite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArgument args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _requestBloc.venue,
          builder: (context, AsyncSnapshot<Venue> venueSnapshot) {
            _requestBloc.fetchVenue(args.venueId);
            if (venueSnapshot.hasData) {
              return Column(
                children: <Widget>[
                  headerSection(venueSnapshot.data),
                  infoSection(venueSnapshot.data),
                ],
              );
            } else if (venueSnapshot.hasError) {
              return Text(Strings.kError);
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget headerSection(Venue venueSnapshot) {
    return Column(
      children: <Widget>[
        Positioned(
          child: appBar(venueSnapshot.name),
          top: 0,
        ),
        Stack(
          children: <Widget>[
            Image.asset(
              "assets/images/temp_image.jpg",
            ),
            Positioned(
              child: FloatingActionButton(
                  elevation: 10,
                  splashColor: Colors.grey,
                  mini: true,
                  child: Image.asset(
                    favourite
                        ? "assets/images/heart_icon.png"
                        : "assets/images/heart_icon_disabled.png",
                    width: 20,
                    height: 20,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      favourite = !favourite;
                    });
                  }),
              bottom: 10,
              right: 15,
            ),
          ],
        ),
      ],
    );
  }

  Widget appBar(String name) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset("assets/images/back_button.png")),
          ),
          SizedBox(width: 14.0),
          Expanded(
            flex: 8,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(Strings.kAppbarText, style: kAppbarTS),
                  SizedBox(height: 8.0),
                  Text(name, style: kAppbarTitleTS),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoSection(Venue venueSnapshot) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Strings.kName, style: kInfoTS),
                Text('${venueSnapshot.name}\n', style: kInfoDataTS),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Strings.kCategory, style: kInfoTS),
                Flexible(
                    child: Text('${venueSnapshot.category}\n',
                        style: kInfoDataTS)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Strings.kDescription, style: kInfoTS),
              ],
            ),
            Text(Strings.kDescriptionText, style: kDescriptionTS),
          ],
        ),
      ),
    );
  }
}
