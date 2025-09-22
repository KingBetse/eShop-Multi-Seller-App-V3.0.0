import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/addPickUpLocationProvider.dart';
import 'package:sellermultivendor/Screen/AddPickUpLocation/Widget/getCommanInputTextFieldWidget.dart';
import 'package:sellermultivendor/Widget/ButtonDesing.dart';

import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/snackbar.dart';

class AddPickUpLocation extends StatefulWidget {
  const AddPickUpLocation({super.key});

  @override
  State<AddPickUpLocation> createState() => _AddPickUpLocationState();
}

AddPickUpLocationProvider? addPickUpLocationProvider;

class _AddPickUpLocationState extends State<AddPickUpLocation>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    addPickUpLocationProvider =
        Provider.of<AddPickUpLocationProvider>(context, listen: false);
    addPickUpLocationProvider!.freshInitializationOfAddPickUpLocation();
    addPickUpLocationProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    addPickUpLocationProvider!.buttonSqueezeanimation = Tween(
      begin: width,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: addPickUpLocationProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    super.initState();
  }

  Widget addAllData() {
    return SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 20,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getPrimaryCommanText(
                          "PickUp Location".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "Add PickUp Location".translate(context: context),
                        1,
                        0.06,
                        1,
                        1,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Name".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "Shipper's Name".translate(context: context),
                        2,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Email".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "Shipper's Email Address".translate(context: context),
                        3,
                        0.06,
                        1,
                        5,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Phone".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "Shipper's Phone Number".translate(context: context),
                        4,
                        0.06,
                        1,
                        4,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "City".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "PickUp Location City Name".translate(context: context),
                        5,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "State".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "PickUp Location State Name"
                            .translate(context: context),
                        6,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Country".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "PickUp Location Country Name"
                            .translate(context: context),
                        7,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Pincode".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "PickUp Location Pincode".translate(context: context),
                        8,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Address".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "Shipper's Primary Address Max 80 Characters"
                            .translate(context: context),
                        9,
                        0.11,
                        1,
                        1,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Additional Address".translate(context: context),
                          false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "Additional Address Details"
                            .translate(context: context),
                        10,
                        0.11,
                        1,
                        1,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Latitude".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "PickUp Location Latitude".translate(context: context),
                        11,
                        0.06,
                        1,
                        3,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          "Longitude".translate(context: context), false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        "PickUp Location Longitude".translate(context: context),
                        12,
                        0.06,
                        1,
                        3,
                        context,
                      ),
                    ]))));
  }

  Widget getBottomBarButton() {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(vertical: 8, horizontal: 10),
      child: AppBtn(
        onBtnSelected: () async {
          validateAndSubmit();
        },
        height: 45,
        title: "Add PickUp Location".translate(context: context),
        btnAnim: addPickUpLocationProvider!.buttonSqueezeanimation,
        btnCntrl: addPickUpLocationProvider!.buttonController,
        paddingRequired: false,
      ),
    );
  }

  update() {
    setState(
      () {},
    );
  }

  Future<void> _playAnimation() async {
    try {
      await addPickUpLocationProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      addPickUpLocationProvider!.addPickUpLocationAPI(context, update);
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      if (addPickUpLocationProvider!.pickUpLocation == null ||
          addPickUpLocationProvider!.pickUpLocation!.isEmpty) {
        setSnackbar(
          "Please Add PickUp Location".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.name == null ||
          addPickUpLocationProvider!.name!.isEmpty) {
        setSnackbar(
          "Please Add Shipper's Name".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.email == null ||
          addPickUpLocationProvider!.email!.isEmpty) {
        setSnackbar(
          "Please Add Shipper's Email Address".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.phone == null ||
          addPickUpLocationProvider!.phone!.isEmpty) {
        setSnackbar(
          "Please Add Shipper's Phone".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.city == null ||
          addPickUpLocationProvider!.city!.isEmpty) {
        setSnackbar(
          "Please Add PickUp Location City Name".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.state == null ||
          addPickUpLocationProvider!.state!.isEmpty) {
        setSnackbar(
          "Please Add PickUp Location State Name".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.country == null ||
          addPickUpLocationProvider!.country!.isEmpty) {
        setSnackbar(
          "Please Add PickUp Location Country Name".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.pinCode == null ||
          addPickUpLocationProvider!.pinCode!.isEmpty) {
        setSnackbar(
          "Please Add PickUp Location Pincode".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.address == null ||
          addPickUpLocationProvider!.address!.isEmpty) {
        setSnackbar(
          "Please Add Shipper's Primary Address".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.address2 == null ||
          addPickUpLocationProvider!.address2!.isEmpty) {
        setSnackbar(
          "Please Add Address Additional Details".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.longitude == null ||
          addPickUpLocationProvider!.longitude!.isEmpty) {
        setSnackbar(
          "Please Add PickUp Location Latitude".translate(context: context),
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.latitude == null ||
          addPickUpLocationProvider!.latitude!.isEmpty) {
        setSnackbar(
          "Please Add PickUp Location Longitude".translate(context: context),
          context,
        );
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      bottomNavigationBar: getBottomBarButton(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [grad1Color, grad2Color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(circularBorderRadius10),
              bottomRight: Radius.circular(circularBorderRadius10),
            ),
          ),
        ),
        toolbarHeight: 50,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return Container(
              color: Colors.transparent,
              margin: const EdgeInsets.all(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(circularBorderRadius5),
                onTap: () => Navigator.of(context).pop(),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: white,
                    size: 25,
                  ),
                ),
              ),
            );
          },
        ),
        title: Text(
          "Add PickUp Location".translate(context: context),
          style: const TextStyle(
            color: white,
            fontSize: textFontSize16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: addAllData(),
    );
  }
}
