// Flutter imports:
import 'package:firulapp/components/extras.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/dialogs.dart';
import '../../../provider/species.dart';
import '../../../src/pets/components/pets-image.dart';
import '../../../size_config.dart';
import '../../../constants/constants.dart';

class AddPets extends StatefulWidget {
  static const routeName = "/pets/add";
  const AddPets({Key key}) : super(key: key);

  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<AddPets>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  @override
  void initState() => super.initState();
  final df = new DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();

  // valores dinamicos del formulario, se utilizaran para enviar el objeto al back
  String _name;
  String _speciesName;
  int _speciesId;
  String _race;
  int _raceID;
  DateTime _birthDate;
  int _age;
  String _primaryColor;
  String _petDescription;
  String _secondaryColor;
  bool _petStatus;

  List<Map> _itemsRace = [
    {"value": 11, "text": 'Chiguagua'},
    {"value": 27, "text": 'Putbull'},
    {"value": 31, "text": 'Pastor Aleman'},
    {"value": 32, "text": 'Mestizo'},
  ];

  @override
  Widget build(BuildContext context) {
    Provider.of<Species>(context).getSpecie(context);
    final params = Provider.of<Species>(context);
    final listSpecies = params.items;
    final SizeConfig sizeConfig = SizeConfig();
    return new Scaffold(
        appBar: AppBar(
          title: Text("Agregar Mascota"),
        ),
        body: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: sizeConfig.hp(20),
                  child: PetImage(
                    onPressed: _pickImage,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text(
                                      'Datos de mascota',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: _name,
                            decoration: InputDecoration(
                              hintText: "Ingresa su nombre",
                              labelText: "Nombre",
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Especie',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  DropdownButton(
                                    hint: _speciesName == null
                                        ? Text('Eliga una especie')
                                        : null,
                                    disabledHint: _speciesName != null
                                        ? Text(listSpecies
                                            .firstWhere((item) =>
                                                item.name == _speciesName)
                                            .name)
                                        : null,
                                    items: listSpecies
                                        .map((e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.name),
                                            ))
                                        .toList(),
                                    onChanged: !_status
                                        ? (v) => setState(() {
                                              _speciesId = v;
                                            })
                                        : null,
                                    value: _speciesId,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Raza',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  DropdownButton(
                                    hint: _race == null
                                        ? Text('Eliga una raza')
                                        : null,
                                    disabledHint: _race != null
                                        ? Text(_itemsRace.firstWhere((item) =>
                                            item["value"] == _race)["text"])
                                        : null,
                                    items: _itemsRace
                                        .map((item) => DropdownMenuItem(
                                              value: item["value"],
                                              child: Text(item["text"]),
                                            ))
                                        .toList(),
                                    onChanged: !_status
                                        ? (v) => setState(() {
                                              _raceID = v;
                                            })
                                        : null,
                                    value: _raceID,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () => _selectDate(context),
                                    child: Text('Fecha de Nacimiento'),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    df.format(currentDate),
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Edad',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    (calculateAge(currentDate).toString() +
                                        " Años"),
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: _primaryColor,
                            decoration: InputDecoration(
                              hintText: "Ingrese un color",
                              labelText: "Color Primario",
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: _secondaryColor,
                            decoration: InputDecoration(
                              hintText: "Ingrese un color",
                              labelText: "Color secundario",
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: _petDescription,
                            decoration: InputDecoration(
                              hintText: "Ingrese una description",
                              labelText: "Descripción",
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        _status ? _getDeletePetButton() : Container(),
                        !_status ? _getActionButtons() : Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  TextStyle defaultTextStyle() {
    return TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  }

  Widget _getDeletePetButton() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Borrar Mascota"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  SelectDialog().alertDialog(context,
                      title: 'AVISO',
                      content:
                          'Está seguro que desa borrar el perfil de la mascota?');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Guardar"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                    //aqui deberia agregar la nueva mascota y mostrar popup de confirmacion
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancelar"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: kPrimaryColor,
        radius: 20.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  //Calculate age for the backend
  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    _age = age; // aqui deberia actualizar el objeto de la mascotas
    return age;
  }

  _pickImage() async {
    final PickedFile file = await Extra.pickImage(false);
    if (file != null) {
      //guardar en providercorrespondiente
      print("path ${file.path}");
    }
  }
}
