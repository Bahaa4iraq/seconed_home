import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../api_connection/student/api_general_data.dart';
import '../../../static_files/my_color.dart';
import 'join_us_page.dart';

class JoinSchool extends StatefulWidget {
  const JoinSchool({super.key});

  @override
  State<JoinSchool> createState() => _JoinSchoolState();
}

class _JoinSchoolState extends State<JoinSchool> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController name = TextEditingController();
  final TextEditingController birthDay = TextEditingController();
  final TextEditingController brotherNumbers = TextEditingController();

  ///التحصيل الدراسي للاب
  final TextEditingController fathersStudy = TextEditingController();
  final TextEditingController fathersJob = TextEditingController();

  ///التحصيل الدراسي للام
  final TextEditingController mothersStudy = TextEditingController();
  final TextEditingController mothersJob = TextEditingController();
  final TextEditingController previouslyKindergartenName =
      TextEditingController();
  final TextEditingController currentSchoolName = TextEditingController();
  final TextEditingController reasonSchoolName = TextEditingController();
  final TextEditingController reason = TextEditingController();
  final TextEditingController locality = TextEditingController();
  final TextEditingController alley = TextEditingController();
  final TextEditingController house = TextEditingController();
  final TextEditingController nearestPoint = TextEditingController();
  final TextEditingController fatherPhone = TextEditingController();
  final TextEditingController motherPhone = TextEditingController();
  final TextEditingController address = TextEditingController();
  bool liveWithParents = true;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeN = FocusNode();
  final _formValidate = GlobalKey<FormState>();
  String sequence = '';
  List<S2Choice<String>> sequenceList = [
    S2Choice<String>(value: "الوحيد", title: "الوحيد"),
    S2Choice<String>(value: "الاول", title: "الاول"),
    S2Choice<String>(value: "الوسط", title: "الوسط"),
    S2Choice<String>(value: "الاخير", title: "الاخير"),
  ];
  String currentStage = '';
  List<S2Choice<String>> currentStageList = [
    S2Choice<String>(value: "الاول الابتدائي", title: "الاول الابتدائي"),
    S2Choice<String>(value: "الثاني الابتدائي", title: "الثاني الابتدائي"),
    S2Choice<String>(value: "الثالث الابتدائي", title: "الثالث الابتدائي"),
    S2Choice<String>(value: "الرابع الابتدائي", title: "الرابع الابتدائي"),
    S2Choice<String>(value: "الخامس الابتدائي", title: "الخامس الابتدائي"),
    S2Choice<String>(value: "السادس الابتدائي", title: "السادس الابتدائي"),
  ];
  String? image;

  _send() {
    if (_formValidate.currentState!.validate()) {
      if (sequence == "") {
        _btnController.error();
        EasyLoading.showInfo("اختر تسلسل الطالب");
        _btnController.reset();
        return;
      }
      Map data = {
        "student_name": name.text,
        "student_birthday": birthDay.text,
        "student_class": currentStage,
        "student_brother_number": brotherNumbers.text,
        "mother_degree": mothersStudy.text,
        "father_degree": fathersStudy.text,
        "father_jop": fathersJob.text,
        "mother_jop": mothersJob.text,
        "past_kindergarten": previouslyKindergartenName.text,
        "school_name": currentSchoolName.text,
        "past_school_reason": reasonSchoolName.text,
        "student_stying_with": reason.text,
        "address_m": locality.text,
        "address_z": alley.text,
        "address_d": house.text,
        "nearest_landmark": nearestPoint.text,
        "father_phone": fatherPhone.text,
        "mother_phone": motherPhone.text,
        "is_staying_with_his_fathers": liveWithParents,
        "student_brother_rank": sequence,
        "student_image": image,
        "address": address.text,
      };
      GeneralData().joinUsSchool(data).then((res) {
        if (res['error'] == false) {
          _btnController.success();
        } else {
          _btnController.error();
        }
      });
    } else {
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formValidate,
      child: Container(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: MyColor.grayDark,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        pickImageSingleGallery().then((String value) {
                          setState(() {
                            image = value;
                          });
                        });
                      },
                      child: image != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(
                                base64Decode(image!.split(',')[1]),
                              ),
                            )
                          : const Icon(
                              Icons.add_a_photo,
                              color: MyColor.grayDark,
                              size: 50,
                            ),
                    ),
                  ),
                ],
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: name,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("اسم التلميذ الرباعي"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 5) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: birthDay,
                  focusNode: _focusNode,
                  onTap: () {
                    _focusNode.unfocus();
                    selectDate(context);
                  },
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("مواليد التلميذ"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 5) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                    minWidth: 200, maxWidth: 350, maxHeight: 73),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 0, left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: MyColor.turquoise2,
                  ),
                  color: MyColor.white1,
                ),
                //_schoolType
                child: SmartSelect<String>.single(
                  title: "المرحلة الدراسية حالياَ",
                  selectedValue: currentStage,
                  placeholder: "اختر",
                  choiceItems: currentStageList,
                  onChange: (selected) => setState(() {
                    currentStage = selected.value;
                  }),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: brotherNumbers,
                  focusNode: _focusNodeN,
                  onTap: () {
                    _focusNodeN.unfocus();
                    showPicker();
                  },
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("عدد الاخوة"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.isEmpty) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                    minWidth: 200, maxWidth: 350, maxHeight: 73),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 0, left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: MyColor.turquoise2,
                  ),
                  color: MyColor.white1,
                ),
                //_schoolType
                child: SmartSelect<String>.single(
                  title: "تسلسل التلميذ بين أخوته",
                  selectedValue: sequence,
                  placeholder: "اختر",
                  choiceItems: sequenceList,
                  onChange: (selected) => setState(() {
                    sequence = selected.value;
                  }),
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                    minWidth: 200, maxWidth: 350, maxHeight: 73),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 0, left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: MyColor.turquoise2,
                  ),
                  color: MyColor.white1,
                ),
                //_schoolType
                child: CheckboxListTile(
                    title: const Text("يقيم التلميذ مع الأبوين"),
                    value: liveWithParents,
                    activeColor: MyColor.green,
                    onChanged: (value) {
                      setState(() {
                        liveWithParents = value!;
                      });
                    }),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: reason,
                  enabled: !liveWithParents,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("اذكر مع من يقيم"),
                  // validator: (value) {
                  //   assert(value != null);
                  //   if (value!.length < 5) {
                  //     return "الرجاء ملئ البيانات";
                  //   }
                  //   return null;
                  // },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: fathersStudy,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("التحصيل الدراسي للأب"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 3) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: fathersJob,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("مهنة الأب ومكان عمله"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 3) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: mothersStudy,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("التحصيل الدراسي للأم"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 3) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: mothersJob,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("مهنة الأم ومكان عمله"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 3) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: previouslyKindergartenName,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("اسم الروضة سابقاً"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 3) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: currentSchoolName,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("اسم المدرسة الحالي"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 3) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: reasonSchoolName,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: inputDecoration("سبب النقل من المدرسة الحالية"),
                  validator: (value) {
                    assert(value != null);
                    if (value!.length < 3) {
                      return "الرجاء ملئ البيانات";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: MyColor.white1.withOpacity(.3),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: const Text(
                    "نرتأي لمصلحة التلميذ بقائه في مدرسته الحالية إذا لم يكن هناك سبب مقنع للنقل",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MyColor.black),
                    textAlign: TextAlign.justify),
              ),
              const Divider(),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: MyColor.turquoise2.withOpacity(.5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("العنوان",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 200, maxWidth: 350),
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: address,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          color: MyColor.grayDark,
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: inputDecoration("المنطقة"),
                        validator: (value) {
                          assert(value != null);
                          if (value!.length < 3) {
                            return "الرجاء ملئ البيانات";
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              controller: locality,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: MyColor.grayDark,
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: inputDecoration("محلة"),
                              validator: (value) {
                                assert(value != null);
                                if (value!.isEmpty) {
                                  return "الرجاء ملئ البيانات";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              controller: alley,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: MyColor.grayDark,
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: inputDecoration("زقاق"),
                              validator: (value) {
                                assert(value != null);
                                if (value!.isEmpty) {
                                  return "الرجاء ملئ البيانات";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              controller: house,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: MyColor.grayDark,
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: inputDecoration("دار"),
                              validator: (value) {
                                assert(value != null);
                                if (value!.isEmpty) {
                                  return "الرجاء ملئ البيانات";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 200, maxWidth: 350),
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: nearestPoint,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          color: MyColor.grayDark,
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: inputDecoration("اقرب نقطة دالة"),
                        validator: (value) {
                          assert(value != null);
                          if (value!.length < 3) {
                            return "الرجاء ملئ البيانات";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: fatherPhone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      contentPadding: const EdgeInsets.all(12.0),
                      hintText: "هاتف الأب",
                      isDense: true,
                      errorStyle: const TextStyle(color: MyColor.red),
                      fillColor: MyColor.white1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.red,
                        ),
                      ),
                      filled: true
                      //fillColor: Colors.green
                      ),
                  validator: (value) =>
                      _phoneValidator(value, motherPhone.text),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: motherPhone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      contentPadding: const EdgeInsets.all(12.0),
                      hintText: "هاتف الأم",
                      isDense: true,
                      errorStyle: const TextStyle(color: MyColor.red),
                      fillColor: MyColor.white1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.red,
                        ),
                      ),
                      filled: true
                      //fillColor: Colors.green
                      ),
                  validator: (value) =>
                      _phoneValidator(value, fatherPhone.text),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: RoundedLoadingButton(
                  color: MyColor.yellow,
                  valueColor: MyColor.yellow,
                  successColor: MyColor.turquoise2,
                  controller: _btnController,
                  onPressed: _send,
                  resetAfterDuration: true,
                  resetDuration: const Duration(seconds: 10),
                  borderRadius: 10,
                  child: const Text("ارسال",
                      style: TextStyle(
                          color: MyColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _phoneValidator(String? text, String anotherPhone) {
    RegExp regExp = RegExp(
      r"^0{1}7{1}[8,9,6,7,5,4]{1}[\d]{8}",
      caseSensitive: false,
      multiLine: false,
    );
    RegExp regExpFirstNumber = RegExp(
      r"0{1}7{1}",
      caseSensitive: false,
      multiLine: false,
    );
    RegExp regExpThirdNumber = RegExp(
      r"0{1}7{1}[7,6,5,8,9]{1}",
      caseSensitive: false,
      multiLine: false,
    );
    if (text != null) {
      if (regExpFirstNumber.hasMatch(text)) {
        if (regExpThirdNumber.hasMatch(text)) {
          if (text.length == 11) {
            if (regExp.hasMatch(text)) {
              if (text != anotherPhone) {
                return null;
              } else {
                return "يرجى ادخال ارقام مختلفة";
              }
            } else {
              return "يجب ان يكون الرقم بالصيغة 07XXXXXXXXX";
            }
          } else {
            return "يجب ان يكون 11 رقم";
          }
        } else {
          return "يجب ان يكون الرقم بالصيغة الصحيحة";
        }
      } else {
        return "يجب ان يبدأ الرقم ب 07";
      }
    } else {
      return "هذا الحقل مطلوب";
    }
  }

  int _selectedValue = 0;
  void selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 1460)),
        firstDate: DateTime.now().subtract(const Duration(days: 5475)),
        lastDate: DateTime.now().subtract(const Duration(days: 1460)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: MyColor.turquoise2, // <-- SEE HERE
                onPrimary: MyColor.yellow, // <-- SEE HERE
                onSurface: MyColor.turquoise2, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: MyColor.turquoise2, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      String year = picked.year.toString();
      String month = picked.month.toString();
      String day = picked.day.toString();
      String date = "$year-$month-$day";
      birthDay.text = date;
    }
  }

  void showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200.0,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                const Text('عدد الاخوة'),
                const SizedBox(height: 20.0),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: _selectedValue),
                    itemExtent: 40.0,
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedValue = index;
                      });
                    },
                    children: List<Widget>.generate(11, (int index) {
                      return Center(
                        child: Text('$index'),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    brotherNumbers.text = _selectedValue.toString();
                    Get.back();
                  },
                  child: const Text('Select'),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          );
        }).then((value) {
      if (value != null) {
        setState(() {
          // _selectedValue = value;
        });
      }
    });
  }
}

InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
      //contentPadding: EdgeInsets.symmetric(vertical: 12.0),
      contentPadding: const EdgeInsets.all(12.0),
      hintText: hintText,
      isDense: true,
      errorStyle: const TextStyle(color: MyColor.red),
      fillColor: MyColor.white1,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(
          color: MyColor.white1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: MyColor.white1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(
          color: MyColor.white1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(
          color: MyColor.red,
        ),
      ),
      filled: true
      //fillColor: Colors.green
      );
}
