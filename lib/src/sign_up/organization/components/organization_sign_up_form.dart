import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/provider/session.dart';
import 'package:flutter/material.dart';

import 'package:firulapp/components/custom_surfix_icon.dart';
import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/user.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firulapp/provider/city.dart';
import '../../../../size_config.dart';

class OrganizationSignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<OrganizationSignUpForm>
    with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Body(),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  String _username;
  String _name;
  String _surname;
  String _documentType;
  String _document;
  int _city;
  String _birthDate;
  final df = new DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  Future _citiesFuture;

  Future _obtainCitiesFuture() {
    return Provider.of<City>(context, listen: false).fetchCities();
  }

  @override
  void initState() {
    _citiesFuture = _obtainCitiesFuture();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        _birthDate = currentDate.toIso8601String();
      });
  }

  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    final _user = Provider.of<User>(context, listen: false);
    return _isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _formKey,
            child: Column(children: [
              buildEmailFormField(),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
              buildPasswordFormField(),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
              buildConformPassFormField(),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
              buildUsernameFormField(
                "Usuario",
                "Ingrese un nombre de usuario",
                TextInputType.name,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              buildNameFormField(
                "Nombre",
                "Ingrese su primer nombre",
                TextInputType.name,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              buildSurnameFormField(
                "Apellido",
                "Ingrese su apellido",
                TextInputType.name,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              buildDropdown(
                _user.getDocumentTypeOptions(),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),
              buildDocumentFormField(
                "Documento de identidad",
                "Ingrese su documento",
                TextInputType.number,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              FutureBuilder(
                future: _citiesFuture,
                builder: (_, dataSnapshot) {
                  return Consumer<City>(
                    builder: (ctx, cityData, child) => DropdownButtonFormField(
                      items: cityData.cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city.id,
                              child: Text(city.name),
                            ),
                          )
                          .toList(),
                      value: _city,
                      onChanged: (newValue) => _city = newValue,
                      hint: const Text("Ciudad"),
                    ),
                  );
                },
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),
              GestureDetector(
                child: Column(
                  children: [
                    const Text(
                      'Fecha de Nacimiento',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Constants.kSecondaryColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.calendar_today_outlined),
                          onPressed: () => _selectDate(context),
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
                  ],
                ),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),
              DefaultButton(
                text: "Registrar",
                color: Constants.kPrimaryColor,
                press: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  if (_birthDate == null) {
                    Dialogs.info(
                      context,
                      title: "ERROR",
                      content: "Debe seleccionar la fecha de nacimiento",
                    );
                    return;
                  }
                  final isOK = _formKey.currentState.validate();
                  if (isOK) {
                    try {
                      _user.addUser(
                        UserData(
                          id: null,
                          userId: null,
                          mail: _email,
                          encryptedPassword: _password,
                          confirmPassword: _confirmPassword,
                          userName: _username,
                          birthDate: _birthDate,
                          city: _city,
                          documentType: _documentType,
                          document: _document,
                          name: _name,
                          surname: _surname,
                          notifications: true,
                          profilePicture: null,
                          userType: 'ORGANIZATION',
                        ),
                      );
                      await Provider.of<Session>(context, listen: false)
                          .register(userData: _user.userData);
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, SignInScreen.routeName, (_) => false);
                    } catch (error) {
                      Dialogs.info(
                        context,
                        title: "ERROR",
                        content: error.response.data["message"],
                      );
                    }
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
            ]),
          );
  }

  Widget buildConformPassFormField() {
    return InputText(
        label: "Confirmar Contraseña",
        hintText: "Re-ingrese su contraseña",
        obscureText: true,
        onSaved: (newValue) => _confirmPassword = newValue,
        onChanged: (value) {
          if (value.isNotEmpty && _password == _confirmPassword) {
            return Constants.kMatchPassError;
          }
          _confirmPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return Constants.kPassNullError;
          } else if ((_password != value)) {
            return Constants.kMatchPassError;
          }
          return null;
        },
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"));
  }

  Widget buildPasswordFormField() {
    return InputText(
      label: "Contraseña",
      hintText: "Ingresa tu contraseña",
      obscureText: true,
      onChanged: (value) => _password = value,
      validator: validatePassword,
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
    );
  }

  Widget buildEmailFormField() {
    return InputText(
      label: "Correo",
      hintText: "Ingrese su correo",
      keyboardType: TextInputType.emailAddress,
      onChanged: (newValue) => _email = newValue,
      validator: validateEmail,
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    );
  }

  Widget buildUsernameFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _username = newValue,
    );
  }

  Widget buildCityFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _city = int.parse(newValue),
    );
  }

  Widget buildDocumentFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _document = newValue,
    );
  }

  Widget buildNameFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _name = newValue,
    );
  }

  Widget buildSurnameFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _surname = newValue,
    );
  }

  Widget buildBirthdateFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _birthDate = newValue,
    );
  }

  DropdownButtonFormField buildDropdown(List<String> documentType) {
    List<DropdownMenuItem> _typeOptions = [];
    documentType.forEach((type) {
      _typeOptions.add(
        DropdownMenuItem(
          child: Text(type),
          value: type,
        ),
      );
    });
    return DropdownButtonFormField(
      items: _typeOptions,
      value: 'RUC',
      onChanged: (newValue) => _documentType = newValue,
      hint: const Text("Tipo de documento"),
    );
  }
}
