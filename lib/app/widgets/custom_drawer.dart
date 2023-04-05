import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/controllers/filter_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/get_data_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/google_map_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/home_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/register_controller.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';
import 'package:skg_refactoring/app/widgets/custom_dropdown.dart';

class CustomDrawer extends StatelessWidget {
  final FilterController _filterController =
      FilterController.initializeController();
  final GetDataController _dataController =
      GetDataController.initializeController();
  final RegisterController _registerController =
      RegisterController.initializeController();
  final MapGoogleController _mapController =
      MapGoogleController.initializeController();
  final HomeController _controller = HomeController.initializeController();

  List<DropdownMenuItem<dynamic>> elementLocalidad = [];
  List<DropdownMenuItem<dynamic>> elementClases = [];
  List<DropdownMenuItem<dynamic>> elementOrientacion = [];

  CustomDrawer({super.key}) {
    elementLocalidad =
        _registerController.elementsLocalidad(_filterController.localidades);

    elementClases =
        _registerController.elementsClases(_filterController.clases);

    elementOrientacion =
        _registerController.elementsOrientacion(_filterController.orientacion);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _filterController.showFilter.value = false;
    _registerController.getListData();
    return SafeArea(
        child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: HexColor("#242C40"),
              border: const Border(
                  right: BorderSide(color: Colors.black, width: 1),
                  top: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1))),
          width: size.width * 0.7,
          child: buildDrawer(size),
        ),
        Obx(() => _filterController.showFilter.value
            ? Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: size.height * 0.06),
                      margin: EdgeInsets.only(
                          left: size.height * 0.03, right: size.height * 0.03),
                      width: double.infinity,
                      height: size.height * 0.5,
                      decoration: BoxDecoration(
                          color: HexColor("#242C40"),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          border: Border.all(color: Colors.white, width: 0.5)),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          children: [
                            FilterDropDownButton(
                              size: size,
                              childrens: elementLocalidad,
                              lable: "Selecciona localidad",
                              titleCard: "Localidad",
                              onChangedF: (v) {
                                log("$v");

                                if (v != "--empty--") {
                                  _filterController.location.value =
                                      v.toString();
                                }
                              },
                              value: "--empty--",
                            ),
                            FilterDropDownButton(
                              size: size,
                              childrens: elementClases,
                              lable: "Selecciona clase",
                              titleCard: "Clase",
                              onChangedF: (v) {
                                log("$v");
                                if (v != "--empty--") {
                                  _filterController.propertiesClass.value = v;
                                }
                              },
                              value: "--empty--",
                            ),
                            FilterDropDownButton(
                              size: size,
                              childrens: elementOrientacion,
                              lable: "Selecciona otientación",
                              titleCard: "Orientación",
                              onChangedF: (v) {
                                log("$v");

                                if (v != "--empty--") {
                                  _filterController.orient.value = v;
                                }
                              },
                              value: "--empty--",
                            ),
                            FilterDateButton(
                                size: size,
                                filterController: _filterController),
                            FilterButton(onPressed: () {
                              _filterController.getIncidentsFilter();
                            })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            height: size.height * 0.07,
                            width: size.height * 0.07,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 0.5),
                                color: HexColor("#242C40"),
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  _filterController.showFilter.value = false;
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: size.height * 0.04,
                                  color: Colors.white,
                                ))),
                      ],
                    ),
                  ],
                ),
              ])
            : Container())
      ],
    ));
  }

  Widget buildDrawer(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Text(
            _registerController.placeMarker.value.administrativeArea == "Bogotá"
                ? "Bogotá"
                : _registerController.placeMarker.value.administrativeArea ==
                        "Cundinamarca"
                    ? "Bogotá"
                    : _registerController
                            .placeMarker.value.administrativeArea ??
                        "Sin Ciudad",
            style: TextStyle(color: HexColor("#9FDF20")),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Icon(Icons.access_time_outlined,
                    size: size.width * 0.05, color: Colors.white),
              ),
              Text(
                "${DateTime.now().toUtc().toLocal().hour}:${DateTime.now().toUtc().toLocal().minute < 9 ? "0${DateTime.now().toUtc().toLocal().minute}" : DateTime.now().toUtc().toLocal().minute} pm",
                style: TextStyle(color: HexColor("#9FDF20")),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 30),
                child: Icon(Icons.calendar_today_outlined,
                    size: size.width * 0.05, color: Colors.white),
              ),
              Text(
                "${DateTime.now().toUtc().toLocal().day < 9 ? "0${DateTime.now().toUtc().toLocal().day}" : "${DateTime.now().toUtc().toLocal().day}"}-${DateTime.now().toUtc().toLocal().month < 9 ? "0${DateTime.now().toUtc().toLocal().month}" : DateTime.now().toUtc().toLocal().month}-${DateTime.now().toUtc().toLocal().year}",
                style: TextStyle(color: HexColor("#9FDF20")),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, top: 50),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/usuario-blanco.svg',
                alignment: Alignment.center,
                width: size.width * 0.13,
                height: size.width * 0.13,
                color: Colors.white,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  "Usuario General",
                  style: TextStyle(color: HexColor("#9FDF20"), fontSize: 20),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: Divider(
            color: HexColor("#9FDF20"),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith(
                (states) => Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.transparent),
            fixedSize: MaterialStateProperty.resolveWith(
                (states) => const Size(280, 50)),
          ),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: SvgPicture.asset(
                    "assets/icons/buscador-verde.svg",
                    width: 20,
                    height: 20,
                    color: HexColor("#9FDF20"),
                    fit: BoxFit.cover,
                  )),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Filtros",
                  style: TextStyle(fontSize: 15, color: HexColor("#9FDF20")),
                ),
              )
            ],
          ),
          onPressed: () async {
            _filterController.showFilter.value =
                !_filterController.showFilter.value;
            log("${_filterController.showFilter.value}");
          },
        ),
        Divider(
          color: HexColor("#9FDF20"),
        ),
        TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent),
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(280, 50)),
            ),
            onPressed: () async {
              _registerController.isLoading.value = false;
              await _dataController.checkPlace();
              await _registerController.getListData();
              Get.toNamed(AppRoutes.REGISTER);
              _registerController.isLoading.value = false;
            },
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: SvgPicture.asset(
                      "assets/icons/untitled.svg",
                      width: 20,
                      height: 20,
                      color: HexColor("#9FDF20"),
                      fit: BoxFit.cover,
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Reporte de incidentes",
                    style: TextStyle(fontSize: 15, color: HexColor("#9FDF20")),
                  ),
                )
              ],
            )),
        Divider(
          color: HexColor("#9FDF20"),
        )
      ],
    );
  }
}

class FilterDateButton extends StatelessWidget {
  const FilterDateButton({
    super.key,
    required this.size,
    required FilterController filterController,
  }) : _filterController = filterController;

  final Size size;
  final FilterController _filterController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: size.height * 0.01, bottom: size.height * 0.01),
          padding: EdgeInsets.only(
              left: size.height * 0.01,
              right: size.height * 0.01,
              top: size.height * 0.01),
          width: size.width * 0.7,
          color: HexColor("#242C40"),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Fecha",
              style: TextStyle(
                  color: HexColor("#E6EFFD"), fontSize: size.height * 0.022),
            ),
            Container(
                width: size.width * 0.6,
                margin: EdgeInsets.only(
                    top: size.height * 0.01, bottom: size.height * 0.04),
                padding: EdgeInsets.only(
                    left: size.height * 0.01,
                    right: size.height * 0.01,
                    top: size.height * 0.01,
                    bottom: size.height * 0.01),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1))),
                child: ObxValue((p0) {
                  print(p0);
                  return Text(
                    _filterController.showDate.value != "" ? _filterController.showDate.value: "Selecciona Fecha",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HexColor("#9FDF20"),
                        fontSize: size.height * 0.029),
                  );
                }, _filterController.showDate))
          ])),
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1999),
          lastDate: DateTime(2150),
        );
        if (date != null) {
          _filterController.day.value = date.day.toString();
          _filterController.mounth.value = date.month.toString();
          _filterController.year.value = date.year.toString();
          _filterController.showDate.value =
              "${date.day < 9 ? "0${date.day}" : "${date.day}"}-${date.month < 9 ? "0${date.month}" : "${date.month}"}-${date.year}";
        }
        log("$date");
        log("value null");
      },
    );
  }
}

class FilterDropDownButton extends StatelessWidget {
  final String titleCard;
  final String lable;
  final dynamic value;
  final Function(dynamic v)? onChangedF;
  final List<DropdownMenuItem> childrens;
  const FilterDropDownButton({
    super.key,
    required this.size,
    required this.titleCard,
    required this.lable,
    this.value,
    this.onChangedF,
    required this.childrens,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin:
          EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.04),
      padding: EdgeInsets.only(
          left: size.height * 0.01,
          right: size.height * 0.01,
          top: size.height * 0.01),
      width: size.width * 0.7,
      color: HexColor("#242C40"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleCard,
            style: TextStyle(
                color: HexColor("#E6EFFD"), fontSize: size.height * 0.022),
          ),
          Column(
            children: [
              Container(
                width: size.width * 0.6,
                decoration: BoxDecoration(color: HexColor("#242C40")),
                child: CustomDropDown(
                  childrens: childrens,
                  onChangedF: onChangedF,
                  value: value ?? "--empty--",
                  label: lable,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final Function()? onPressed;
  const FilterButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding:
          EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.05),
      child: TextButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => Size(size.height * 0.3, size.height * 0.07)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#9FDF20")),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#9FDF20"))),
          onPressed: onPressed,
          child: Text(
            "Filtrar",
            style: TextStyle(
                fontSize: size.height * 0.03,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
