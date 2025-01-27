import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kandostum2/app/modules/profile/controllers/profile_controller.dart';
import 'package:kandostum2/app/modules/profile/pages/profile_historic_page.dart';
import 'package:kandostum2/app/modules/profile/pages/profile_settings_page.dart';
import 'package:kandostum2/app/modules/profile/widgets/profile_header.dart';
import 'package:kandostum2/app/shared/helpers/image_helper.dart';
import 'package:kandostum2/app/shared/helpers/snackbar_helper.dart';
import 'package:kandostum2/app/shared/widgets/forms/blood_type_input_field.dart';
import 'package:kandostum2/app/shared/widgets/forms/button_input_field.dart';
import 'package:kandostum2/app/shared/widgets/forms/custom_input_field.dart';
import 'package:kandostum2/app/shared/widgets/forms/gender_type_input_field.dart';
import 'package:kandostum2/app/shared/widgets/forms/date_input_field.dart';
import 'package:provider/provider.dart';
import 'package:kandostum2/app/shared/widgets/forms/list_tile_header.dart';
import 'package:search_cep/search_cep.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kandostum2/app/shared/masks.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = new GlobalKey<FormState>();

  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = MaskedTextController(mask: Mask.cepMask);
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementoController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  ProfileController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= Provider.of<ProfileController>(context);
    _controller.getCurrentUser().then((user) {
      _birthDateController.text = user.birthDate;
      _genderController.text = user.gender;
      _bloodTypeController.text = user.bloodType;
      _phoneController.text = user.phone;
      _cepController.text = user.cep;
      _addressController.text = user.address;
      _numberController.text = user.number;
      _complementoController.text = user.complemento;
      _neighborhoodController.text = user.neighborhood;
      _stateController.text = user.state;
      _cityController.text = user.city;
    });
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _genderController.dispose();
    _bloodTypeController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  _save() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      _controller.save();
    }
  }

  _onSearchCep(text) async {
    final infoCepJSON = await ViaCepSearchCep.searchInfoByCep(cep: text);
    if (infoCepJSON.searchCepError == null) {
      _addressController.text = infoCepJSON.logradouro;
      _neighborhoodController.text = infoCepJSON.bairro;
      _stateController.text = infoCepJSON.uf;
      _cityController.text = infoCepJSON.localidade;
    } else {
      SnackBarHelper.showFailureMessage(
        context,
        title: 'Error',
        message: infoCepJSON.searchCepError.errorMessage ?? '',
      );
    }
  }

  Future _changeImage(bool camera) async {
    File image = await ImageHelper.getImage(context, camera);
    if (image != null) {
      ImageHelper.uploadImage(
        image: image,
        onSuccess: (pictureUrl) {
          SnackBarHelper.showSuccessMessage(
            context,
            title: 'Success',
            message: 'Image upload is complete.',
          );

          _controller.setPicture(pictureUrl);
          setState(() {
            _controller.user.picture = pictureUrl;
          });
        },
      );
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.camera_alt),
                title: new Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _changeImage(true);
                },
              ),
              new ListTile(
                leading: new Icon(Icons.image),
                title: new Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _changeImage(false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _buildFloatingActionButton() {
    return Observer(
      builder: (_) {
        if (_controller.editable) {
          return FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: _save,
          );
        } else {
          return SpeedDial(
            child: Icon(Icons.add, color: Colors.white),
            labelsStyle: TextStyle(color: Colors.black),
            speedDialChildren: <SpeedDialChild>[
              SpeedDialChild(
                child: Icon(Icons.settings, color: Colors.white),
                foregroundColor: Theme.of(context).canvasColor,
                backgroundColor: Theme.of(context).accentColor,
                label: 'Settings',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSettingsPage(),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.history, color: Colors.white),
                foregroundColor: Theme.of(context).canvasColor,
                backgroundColor: Theme.of(context).accentColor,
                label: 'History',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileHistoricPage(),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                foregroundColor: Theme.of(context).canvasColor,
                backgroundColor: Theme.of(context).accentColor,
                label: 'Edit',
                onPressed: () {
                  _controller.editable = true;
                },
              ),
            ],
            closedBackgroundColor: Theme.of(context).accentColor,
            closedForegroundColor: Theme.of(context).canvasColor,
            openBackgroundColor: Theme.of(context).accentColor,
            openForegroundColor: Theme.of(context).accentColor,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Profile'),
        elevation: 0,
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Observer(builder: (_) {
                return ProfileHeader(
                  name: _controller.user.name,
                  email: _controller.user.email,
                  pictureUrl: _controller.user.picture,
                  lastDate: _controller.user.lastDonationDate ?? '--',
                  nextDate: _controller.user.dateToNextDonation(),
                  editable: _controller.editable,
                  onTapImage: () {
                    _settingModalBottomSheet(context);
                  },
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return BloodTypeInputField(
                    busy: !_controller.editable,
                    controller: _bloodTypeController,
                    label: 'Blood Type',
                    onSaved: (value) {
                      _controller.user.bloodType = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return DateInputField(
                    busy: !_controller.editable,
                    controller: _birthDateController,
                    textInputType: TextInputType.datetime,
                    label: 'Date of Birth',
                    onSaved: (value) {
                      _controller.user.birthDate = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return GenderInputField(
                    busy: !_controller.editable,
                    controller: _genderController,
                    label: 'Gender',
                    onSaved: (value) {
                      _controller.user.gender = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return CustomInputField(
                    busy: !_controller.editable,
                    controller: _phoneController,
                    textInputType: TextInputType.phone,
                    label: 'Phone Number',
                    onSaved: (value) {
                      _controller.user.phone = value;
                    },
                  );
                }),
              ),
              ListTileHeader('Address Info'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return ButtonInputField(
                    busy: !_controller.editable,
                    controller: _cepController,
                    label: 'Postcode',
                    textInputType: TextInputType.number,
                    onSaved: (value) {
                      _controller.user.cep = value;
                    },
                    onPressed: _onSearchCep,
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return CustomInputField(
                    busy: !_controller.editable,
                    controller: _addressController,
                    textInputType: TextInputType.text,
                    label: 'Address',
                    onSaved: (value) {
                      _controller.user.address = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return CustomInputField(
                    busy: !_controller.editable,
                    controller: _numberController,
                    textInputType: TextInputType.number,
                    label: 'Number',
                    onSaved: (value) {
                      _controller.user.number = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return CustomInputField(
                    busy: !_controller.editable,
                    controller: _complementoController,
                    textInputType: TextInputType.text,
                    label: 'Avenue / Street',
                    onSaved: (value) {
                      _controller.user.complemento = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return CustomInputField(
                    busy: !_controller.editable,
                    controller: _neighborhoodController,
                    textInputType: TextInputType.text,
                    label: 'District',
                    onSaved: (value) {
                      _controller.user.neighborhood = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return CustomInputField(
                    busy: !_controller.editable,
                    controller: _stateController,
                    textInputType: TextInputType.text,
                    label: 'Region',
                    onSaved: (value) {
                      _controller.user.state = value;
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Observer(builder: (_) {
                  return CustomInputField(
                    busy: !_controller.editable,
                    controller: _cityController,
                    label: 'Province',
                    textInputType: TextInputType.text,
                    onSaved: (value) {
                      _controller.user.city = value;
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
