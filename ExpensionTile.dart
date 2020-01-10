import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:joyspet/Cite/model/cite.dart';
import 'package:joyspet/User/bloc/userbloc.dart';
import 'package:joyspet/User/ui/widgets/send_info_cite.dart';

class DatePickerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DatePickerScreen();
  }
}

class _DatePickerScreen extends State<DatePickerScreen> {
  DateTime _selectedDate = DateTime.now();
  String _typeofcite;
  // inicializo el index a 0 ya que traigo una List de documentos desde firebase
  int _selectedCiteIndex = 0;
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return StreamBuilder(
      stream: userBloc.getCitesTypeStream,
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;

          case ConnectionState.none:
            return CircularProgressIndicator();
            break;

          case ConnectionState.done:
            return showDataPickerInfo(snapshot);
            break;

          case ConnectionState.active:
            return showDataPickerInfo(snapshot);
            break;
          default:
        }
      },
    );
  }

  Widget showDataPickerInfo(snapshot) {

    //en realidad esto tiene que ir en tu archivo BLoC
  /*
   pero yo traigo las citas de mi app y las meto en el expasion tile para que sea mas efectivo  y pueda agregar mas opciones a la aplicacion
   desde la bd y asi no renderizar la app para poder agregar otra opcion 
   */
    final citesDb = snapshot.data.documents;
    List typeCites = [];
    for (var rest in citesDb) {
      final restName = rest.data['cites'];
      typeCites = restName;
    }
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Container(
            // margin: EdgeInsets.all(MediaQuery.of(context).size.width),
            child: Text("Seleccione un tipo de servicio:",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
          ),
          children: new List<RadioListTile<int>>.generate(
            typeCites.length,
              (int index) {
            return new RadioListTile<int>(
              value: index,
              groupValue: _selectedCiteIndex,
              title: new Text(typeCites[index]),
              onChanged: (int value) {
                setState(() {
                  _selectedCiteIndex = value;
                });
              },
            );
          }),
        ),
        //este solo es un button la verdad lo podes ignorar
        SendInfoCite( kind_of_appointment:typeCites[_selectedCiteIndex],  state: "P")
      ],
    );
  }
}
