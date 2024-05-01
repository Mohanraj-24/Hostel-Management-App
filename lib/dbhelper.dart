import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/api_services/api_calls.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/services/auth_service.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';

import 'dart:io' show Platform;
import 'dart:async';
import 'dart:math';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostel_management/person.dart';
import 'package:hostel_management/personview.dart';
import 'package:hostel_management/facedetectionview.dart';

class DatabaseHelper {
  Future<Database> createDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'person.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE person(name text, faceJpg blob, templates blob)',
        );
      },
      version: 1,
    );

    return database;
  }

  Future<List<Person>> loadAllPersons() async {
    final db = await createDB();
    final List<Map<String, dynamic>> maps = await db.query('person');
    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<void> insertPerson(Person person, String rollNo) async {
    final db = await createDB();

    await db.insert(
      'person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // setState(() {
    //   widget.personList.add(person);
    // });
  }

  Future<void> deleteAllPerson() async {
    final db = await createDB();
    await db.delete('person');

    // setState(() {
    //   widget.personList.clear();
    // });

    Fluttertoast.showToast(
        msg: "All person deleted!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> deletePerson(index, String name) async {
    // ignore: invalid_use_of_protected_member

    final db = await createDB();
    await db.delete('person', where: 'name=?', whereArgs: [name]);

    // ignore: invalid_use_of_protected_member
    // setState(() {
    //   widget.personList.removeAt(index);
    // });

    Fluttertoast.showToast(
        msg: "Person removed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // Future enrollPerson() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;

  //     var rotatedImage =
  //         await FlutterExifRotation.rotateImage(path: image.path);

  //     final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);
  //     for (var face in faces) {
  //       num randomNumber =
  //           10000 + Random().nextInt(10000); // from 0 upto 99 included
  //       Person person = Person(
  //           name: 'Person' + randomNumber.toString(),
  //           faceJpg: face['faceJpg'],
  //           templates: face['templates']);
  //       print(face['faceJpg']);
  //       print(face['templates']);
  //       insertPerson(person);
  //     }

  //     if (faces.length == 0) {
  //       Fluttertoast.showToast(
  //           msg: "No face detected!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Person enrolled!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } catch (e) {}
  // }
}
