import 'package:final_project/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/http.dart';

class Weather extends StatelessWidget {
  Weather({Key? key}) : super(key: key);

  var weatherinfo = Http().getWeatherByLocation();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: weatherinfo,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return SizedBox(
            height: height,
            width: width,
            child: Center(
            // child: Text(snapshot.data.toString()),
             child: Card(
               color: Theme.of(context).cardTheme.color,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Expanded(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Text(snapshot.data.locationName, style: Theme.of(context).textTheme.headline3),
                       Icon(Http().getWeatherIcon(snapshot.data.weatherID),size: 50,color: Theme.of(context).appBarTheme.iconTheme!.color),
                       SizedBox(height: 5),
                       Text(snapshot.data.temperature.toString()+"°",style: Theme.of(context).textTheme.headline3),
                       SizedBox(height: 5),
                       Text("Feels Like: "+snapshot.data.feelsLike.toString()+"°",style: Theme.of(context).textTheme.headline1),
                       SizedBox(height: 5),
                     ],
                   ),
                 ),
                   Expanded(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Column(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             Row(
                                 children: [
                                   Text("Min ", style: Theme.of(context).textTheme.headline2),
                                   Icon(FontAwesomeIcons.temperatureLow,color: Colors.blue),
                                 ]
                             ),
                             Text(snapshot.data.lowTemp.toString()+"°", style: Theme.of(context).textTheme.headline1),
                             Row(
                                 children:[
                                   Text("Wind Speed ",style: Theme.of(context).textTheme.headline1),
                                   Icon(FontAwesomeIcons.wind,color: Theme.of(context).appBarTheme.iconTheme!.color)
                                 ]
                             ),
                             Text(snapshot.data.windSpeed.toString(), style: Theme.of(context).textTheme.headline2),
                             Row(
                               children: [
                                 Text("Visibility ",style: Theme.of(context).textTheme.headline1),
                                 Icon(FontAwesomeIcons.eye,color: Theme.of(context).appBarTheme.iconTheme!.color),
                               ],
                             ),
                             Text((snapshot.data.visibility/1000).toStringAsFixed(2)+"km",style: Theme.of(context).textTheme.headline1),
                           ]
                         ),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Row(
                                 children: [
                                   Text("Max ", style: Theme.of(context).textTheme.headline2),
                                   Icon(FontAwesomeIcons.temperatureHigh,color: rPrimaryRedColor)
                                 ]
                             ),
                             Text(snapshot.data.highTemp.toString()+"°", style: Theme.of(context).textTheme.headline1),
                             Row(
                                 children: [
                                   Text("Humidity ",style: Theme.of(context).textTheme.headline1),
                                   Icon(FontAwesomeIcons.tint,color: Colors.blue)
                                 ]
                             ),
                             Text(snapshot.data.humidity.toString()+"%", style: Theme.of(context).textTheme.headline2),
                             Row(
                               children: [
                                 Text("Pressure ",style: Theme.of(context).textTheme.headline1),
                                 Icon(FontAwesomeIcons.compressArrowsAlt,color: Theme.of(context).appBarTheme.iconTheme!.color)
                               ],
                             ),
                             Text(snapshot.data.pressure.toString(),style:Theme.of(context).textTheme.headline1),
                           ],
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: 15)
                 ],
               ),
             ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

