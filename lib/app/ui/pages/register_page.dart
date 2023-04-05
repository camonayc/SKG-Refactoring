import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/controllers/register_controller.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';
import 'package:skg_refactoring/app/widgets/custom_dropdown.dart';
import 'package:skg_refactoring/app/widgets/loading_screen..dart';

class RegisterPage extends StatelessWidget {
  final RegisterController _controller =
      RegisterController.initializeController();
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "Reporte de incidente",
          style: TextStyle(color: HexColor("#9FDF20")),
        ),
        centerTitle: true,
        backgroundColor: HexColor("#242C40"),
        elevation: 2,
        actions: [
          IconButton(
            splashRadius: 1,
            splashColor: HexColor("#242C40"),
            onPressed: () {
              Get.offAllNamed(AppRoutes.HOME);
              _controller.clear();
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Stack(
        children: [
          buildFormScreen(context),
          Obx(() => _controller.isLoading.value == true
              ? buildLoadingScreen()
              : Container())
        ],
      ),
    );
  }

  GestureDetector buildFormScreen(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
            child: Obx(
          () => _controller.thereIsPlace.value == false
              ? buildNoLocalBogota(context)
              : buildRegisterFormPage(context),
        )));
  }

  Container buildNoLocalBogota(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(left: size.height * 0.04, right: size.height * 0.04),
      color: HexColor("#1C2333"),
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: double.infinity,
        height: size.height * 0.2,
        decoration: BoxDecoration(
            boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.white)],
            color: HexColor("#242C40"),
            borderRadius: BorderRadius.circular(12)),
        child: Text(
          "No te encuentras en Bogota.\nPor el momento esta función solo es permitida para la ciudad de Bogota",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: HexColor("#E6EFFD"),
            fontSize: size.height * 0.03,
          ),
        ),
      ),
    );
  }

  Container buildRegisterFormPage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: HexColor("#1C2333"),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardUbication(userPlace: _controller.address.value),
            CardIncidentDate(
                dateIncident:
                    "${DateTime.now().day < 9 ? "0${DateTime.now().day}" : "${DateTime.now().day}"}-${DateTime.now().month < 9 ? "0${DateTime.now().month}" : "${DateTime.now().month}"}-${DateTime.now().year}"),
            CardDropDown(
              titleCard: "Localidad",
              lable: "Seleccione localidad",
              value: "--empty--",
              childrens: _controller.elementLocalidad,
              onChangedF: (v) {
                log("$v");

                if (v != "--empty--") {
                  _controller.location.value = v.toString();
                } else {
                  _controller.location.value = "";
                }
              },
            ),
            CardDropDown(
              titleCard: "Clase",
              lable: "Seleccione clase",
              value: "--empty--",
              childrens: _controller.elementClases,
              onChangedF: (v) {
                log("$v");
                if (v != "--empty--") {
                  _controller.propertiesClass.value = v;
                } else {
                  _controller.propertiesClass.value = 0;
                }
              },
            ),
            CardDropDown(
              titleCard: "Orientación",
              lable: "Seleccione orientación",
              value: "--empty--",
              childrens: _controller.elementOrientacion,
              onChangedF: (v) {
                log("$v");

                if (v != "--empty--") {
                  _controller.orient.value = v;
                } else {
                  _controller.orient.value = 0;
                }
              },
            ),
            DescriptionBox(controller: _controller),
            PhotoBox(
              size: size,
              controller: _controller,
            ),
            Obx(() {
              if (_controller.address.value != "" &&
                  _controller.orient.value != 0 &&
                  _controller.propertiesClass.value != 0 &&
                  _controller.descriptionData.value != "") {
                return ReportButton(
                  onPressed: () async {
                    _controller.isLoading.value = true;
                    await _controller.createNewIndicent();
                    log("${_controller.photosInciden.length}");
                  },
                );
              } else {
                return Container(
                  height: 50,
                );
              }
            })
          ],
        ),
      ),
    );
  }
}

class PhotoBox extends StatelessWidget {
  final RegisterController controller;
  const PhotoBox({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ObxValue(
        (p0) => Container(
              padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.03,
                  right: size.width * 0.03,
                  bottom: size.height * 0.01),
              width: double.infinity,
              height: controller.photoTake1.value || controller.photoTake2.value
                  ? size.height * 0.39
                  : size.height * 0.31,
              margin: EdgeInsets.only(
                  top: size.height * 0.05,
                  left: size.height * 0.045,
                  right: size.height * 0.045),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(blurRadius: 1, color: Colors.white)
                  ],
                  color: HexColor("#242C40"),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Registro fotográfico",
                    style: TextStyle(
                        color: HexColor("#E6EFFD"),
                        fontSize: size.height * 0.022),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                width: size.width * 0.35,
                                height: size.height * 0.23,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 0.5, color: Colors.black)),
                                child: Obx(
                                    () => controller.photoTake1.value == true
                                        ? Image.file(
                                            File(controller.photo1.value.path),
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Text(
                                            "Foto 1",
                                            style: TextStyle(
                                                color: HexColor("#E6EFFD"),
                                                fontSize: size.height * 0.022),
                                          ))),
                              ),
                              onTap: () {
                                Get.defaultDialog(
                                    title: "Agregar foto",
                                    middleText:
                                        "De donde quieres tomar la foto?",
                                    titleStyle:
                                        const TextStyle(color: Colors.white),
                                    middleTextStyle:
                                        const TextStyle(color: Colors.white),
                                    backgroundColor: HexColor("#242C40"),
                                    confirm: TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          var data =
                                              await _openGallery(context);
                                          if (data != null) {
                                            controller.photo1.value = data;
                                            controller.photoTake1.value = true;
                                          } else {
                                            controller.photoTake1.value = false;
                                          }
                                          if (controller.photo1.value.path !=
                                              "") {
                                            controller.photoTake1.value = true;
                                          }
                                        },
                                        child: Text(
                                          "Galeria",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: HexColor("#9FDF20")),
                                        )),
                                    cancel: TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          var data = await _openCamera(context);
                                          if (data != null) {
                                            controller.photo1.value = data;
                                            controller.photoTake1.value = true;
                                          } else {
                                            controller.photoTake1.value = false;
                                          }
                                          if (controller.photo1.value.path !=
                                              "") {
                                            controller.photoTake1.value = true;
                                          }
                                        },
                                        child: Text(
                                          "Camara",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: HexColor("#9FDF20")),
                                        )));
                              },
                            ),
                            Obx(() => controller.photoTake2.value
                                ? controller.photoTake1.value
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: size.height * 0.01),
                                        child: TextButton(
                                            onPressed: () {
                                              controller.photoTake1.value =
                                                  false;
                                              controller.photo1.value =
                                                  XFile("");
                                              log("${controller.photosInciden.length}");
                                              log("path 1${controller.photo1.value.path}");
                                              log("path2${controller.photo2.value.path}");
                                            },
                                            child: const Text("Eliminar foto")),
                                      )
                                    : Container(
                                        height: size.height * 0.08,
                                      )
                                : controller.photoTake1.value
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: size.height * 0.01),
                                        child: TextButton(
                                            onPressed: () {
                                              controller.photoTake1.value =
                                                  false;
                                              controller.photo1.value =
                                                  XFile("");
                                              log("${controller.photosInciden.length}");
                                              log("path 1${controller.photo1.value.path}");
                                              log("path2${controller.photo2.value.path}");
                                            },
                                            child: const Text("Eliminar foto")),
                                      )
                                    : Container())
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                width: size.width * 0.35,
                                height: size.height * 0.23,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 0.5, color: Colors.black)),
                                child: Obx(() =>
                                    controller.photoTake2.value == true
                                        ? Image.file(
                                            File(controller.photo2.value.path),
                                            fit: BoxFit.cover)
                                        : Center(
                                            child: Text(
                                            "Foto 2",
                                            style: TextStyle(
                                                color: HexColor("#E6EFFD"),
                                                fontSize: size.height * 0.022),
                                          ))),
                              ),
                              onTap: () {
                                Get.defaultDialog(
                                    title: "Agregar foto",
                                    middleText:
                                        "De donde quieres tomar la foto?",
                                    titleStyle:
                                        const TextStyle(color: Colors.white),
                                    middleTextStyle:
                                        const TextStyle(color: Colors.white),
                                    backgroundColor: HexColor("#242C40"),
                                    confirm: TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          var data =
                                              await _openGallery(context);
                                          if (data != null) {
                                            controller.photo2.value = data;
                                            controller.photoTake2.value = true;
                                          } else {
                                            controller.photoTake2.value = false;
                                          }
                                          if (controller.photo2.value.path !=
                                              "") {
                                            controller.photoTake2.value = true;
                                          }
                                        },
                                        child: Text(
                                          "Galeria",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: HexColor("#9FDF20")),
                                        )),
                                    cancel: TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          var data = await _openCamera(context);
                                          if (data != null) {
                                            controller.photo2.value = data;
                                            controller.photoTake2.value = true;
                                          } else {
                                            controller.photoTake2.value = false;
                                          }
                                          if (controller.photo2.value.path !=
                                              "") {
                                            controller.photoTake2.value = true;
                                          }
                                        },
                                        child: Text(
                                          "Camara",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: HexColor("#9FDF20")),
                                        )));
                              },
                            ),
                            Obx(() => controller.photoTake1.value
                                ? controller.photoTake2.value
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: size.height * 0.01),
                                        child: TextButton(
                                            onPressed: () {
                                              controller.photoTake2.value =
                                                  false;
                                              controller.photo2.value =
                                                  XFile("");
                                              log("${controller.photosInciden.length}");
                                              log("path 1${controller.photo1.value.path}");
                                              log("path2${controller.photo2.value.path}");
                                            },
                                            child: const Text("Eliminar foto")))
                                    : Container(
                                        height: size.height * 0.08,
                                      )
                                : controller.photoTake2.value
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: size.height * 0.01),
                                        child: TextButton(
                                            onPressed: () {
                                              controller.photoTake2.value =
                                                  false;
                                              controller.photo2.value =
                                                  XFile("");
                                              log("${controller.photosInciden.length}");
                                              log("path 1${controller.photo1.value.path}");
                                              log("path2${controller.photo2.value.path}");
                                            },
                                            child: const Text("Eliminar foto")))
                                    : Container())
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        controller.photoTake1);
  }
}

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({
    super.key,
    required RegisterController controller,
  }) : _controller = controller;

  final RegisterController _controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          top: size.height * 0.02,
          left: size.height * 0.02,
          right: size.height * 0.02,
          bottom: size.height * 0.02),
      width: double.infinity,
      height: size.height * 0.3,
      margin: EdgeInsets.only(
          top: size.height * 0.05,
          left: size.height * 0.045,
          right: size.height * 0.045),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.white)],
          color: HexColor("#242C40"),
          borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Descripción",
          style: TextStyle(
              color: HexColor("#E6EFFD"), fontSize: size.height * 0.022),
        ),
        Container(
          margin: EdgeInsets.only(top: size.height * 0.015),
          child: TextFormField(
              style: TextStyle(
                  color: HexColor("#E6EFFD"), fontSize: size.height * 0.022),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.multiline,
              minLines: 6,
              maxLines: 12,
              decoration: InputDecoration(
                  hintText: "Breve descripción del incidente",
                  hintStyle: TextStyle(
                      color: HexColor("#E6EFFD"),
                      fontSize: size.height * 0.022),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#E6EFFD"))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#E6EFFD"))),
                  border: InputBorder.none),
              onChanged: (v) {
                _controller.descriptionData.value = v;
                log(_controller.descriptionData.value);
                if (v == "") {
                  _controller.descriptionData.value = "";
                  log("Sin valor la descripción");
                }
              }),
        ),
      ]),
    );
  }
}

class ReportButton extends StatelessWidget {
  final Function()? onPressed;
  const ReportButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding:
          EdgeInsets.only(top: size.height * 0.05, bottom: size.height * 0.05),
      child: TextButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => Size(size.width * 0.6, size.height * 0.07)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#9FDF20")),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#9FDF20"))),
          onPressed: onPressed,
          child: Text(
            "Reportar",
            style: TextStyle(
                fontSize: size.height * 0.03,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}

class CardDropDown extends StatelessWidget {
  final String titleCard;
  final String lable;
  final dynamic value;
  final Function(dynamic v)? onChangedF;
  final List<DropdownMenuItem> childrens;
  const CardDropDown({
    super.key,
    required this.lable,
    this.value,
    this.onChangedF,
    required this.childrens,
    required this.titleCard,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          top: size.height * 0.02,
          left: size.width * 0.04,
          right: size.width * 0.04,
          bottom: size.height * 0.02),
      width: double.infinity,
      height: size.height * 0.16,
      margin: EdgeInsets.only(
          top: size.height * 0.05,
          left: size.height * 0.045,
          right: size.height * 0.045),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.white)],
          color: HexColor("#242C40"),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleCard,
            style: TextStyle(
                color: HexColor("#E6EFFD"), fontSize: size.height * 0.022),
          ),
          CustomDropDown(
            childrens: childrens,
            label: lable,
            onChangedF: onChangedF,
            value: value ?? "--empty--",
          )
        ],
      ),
    );
  }
}

class CardIncidentDate extends StatelessWidget {
  final String dateIncident;
  const CardIncidentDate({
    super.key,
    required this.dateIncident,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          top: size.height * 0.02,
          left: size.width * 0.04,
          right: size.width * 0.04,
          bottom: size.height * 0.01),
      width: double.infinity,
      height: size.height * 0.145,
      margin: EdgeInsets.only(
          top: size.height * 0.05,
          left: size.height * 0.045,
          right: size.height * 0.045),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.white)],
          color: HexColor("#242C40"),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fecha de incidente",
            style: TextStyle(
                color: HexColor("#E6EFFD"), fontSize: size.height * 0.022),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // width: size.width * 0.6,
                margin: const EdgeInsets.all(10),
                child: Text(
                  dateIncident,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HexColor("#9FDF20"), fontSize: size.height * 0.05),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardUbication extends StatelessWidget {
  final String? userPlace;
  const CardUbication({
    super.key,
    required this.userPlace,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          top: size.height * 0.02,
          left: size.width * 0.04,
          right: size.width * 0.04,
          bottom: size.height * 0.02),
      width: double.infinity,
      height: size.height * 0.272,
      margin: EdgeInsets.only(
          top: size.height * 0.05,
          left: size.height * 0.045,
          right: size.height * 0.045),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.white)],
          color: HexColor("#242C40"),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ubicacion/Dirección",
            style: TextStyle(
                color: HexColor("#E6EFFD"), fontSize: size.height * 0.022),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //*
              Container(
                  alignment: Alignment.center,
                  width: size.width * 0.7,
                  color: HexColor("#242C40"),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: size.width * 0.6,
                            padding: EdgeInsets.only(
                                left: size.width * 0.01,
                                right: size.width * 0.01,
                                top: size.height * 0.01,
                                bottom: size.height * 0.01),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.white, width: 1))),
                            child: Text(
                              getPlace(userPlace ?? ""),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: HexColor("#9FDF20"),
                                  fontSize: size.height * 0.029),
                            ))
                      ])),
              //*
              // SizedBox(
              //   height: size.height * 0.07,
              //   width: size.width * 0.7,
              //   child: TextFormField(
              //       readOnly: true,
              //       initialValue: userPlace ?? "No se encontro la dirección",
              //       style: TextStyle(
              //           color: HexColor("#9FDF20"),
              //           fontSize: size.height * 0.029),
              //       textAlign: TextAlign.start,
              //       keyboardType: TextInputType.visiblePassword,
              //       decoration: InputDecoration(
              //           focusedBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(color: HexColor("#E6EFFD"))),
              //           enabledBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(color: HexColor("#E6EFFD"))),
              //           border: InputBorder.none),
              //       onFieldSubmitted: (v) {
              //         log("value : $v");
              //       }),
              // ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: size.height * 0.01,
            ),
            child: Text(
              "La ubicación se toma de tu GPS. Recuerda tenerlo activo. Para mayor precision escribe la dirección.",
              // softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HexColor("#E6EFFD"),
                fontSize: size.height * 0.02,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<XFile?> _openGallery(BuildContext context) async {
  final ImagePicker imagePicker = ImagePicker();
  var picture = await imagePicker.pickImage(source: ImageSource.gallery);
  log("${picture?.path}");
  return picture;
}

Future<XFile?> _openCamera(BuildContext context) async {
  final ImagePicker imagePicker = ImagePicker();
  var picture = await imagePicker.pickImage(source: ImageSource.camera);
  log("${picture?.path}");
  return picture;
}

String getPlace(String userPlace) {
  var data = userPlace.split(",");
  log("${data.length}");
  return "${data[0]}\n${data[1]}\n${data[2]}";
}
