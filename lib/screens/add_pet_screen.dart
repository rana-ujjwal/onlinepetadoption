// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:petadoptionapp/provider/storage_service.dart';
import 'package:petadoptionapp/screens/navigation_drawer.dart';
import 'dart:async';
import '../provider/storage_service.dart';

// ignore: must_be_immutable
class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _breedNameController = TextEditingController();
  final _descController = TextEditingController();
  final Storage storage = Storage();
  String? image;

  @override
  void dispose() {
    _petNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _breedNameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  List<String> items = <String>[
    'Dog',
    'Cat',
    'Bird',
    'Fish',
  ];

  List<String> genderItems = <String>[
    'Male',
    'Female',
  ];

  String? dropdownValue;
  String? genderDropDownValue;
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  final DateTime petAddedDate = DateTime.now();

  void uploadFile() async {
    final results = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (results != null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Photo uploaded'),
            );
          });
    }
    if (results == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No file selected"),
        ),
      );
    }
    final path = results!.files.single.path!;
    final fileName = results.files.single.name;

    try {
      String imageUpload = await storage.uploadFile(path, fileName);
      image = await FirebaseStorage.instance.ref(imageUpload).getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Future addPet() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload image"),
        ),
      );
      return;
    }

    addPetDetails(
      _petNameController.text.trim(),
      int.parse(_ageController.text.toString()),
      dropdownValue.toString(),
      genderDropDownValue.toString(),
      _breedNameController.text.toString(),
      _descController.text.toString(),
      image!,
    );

    await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('New Pet Added'),
          );
        });

    setState(() {
      _petNameController.text = '';
      _ageController.text = '';
      _breedNameController.text = '';
      _descController.text = '';
      dropdownValue = null;
      genderDropDownValue = null;
      fileName = '';
    });
  }

  Future addPetDetails(String petname, int age, String type, String gender,
      String breed, String desc, String image) async {
    await FirebaseFirestore.instance.collection('pets').add({
      'petname': petname,
      'age': age,
      'gender': gender,
      'type': type,
      'breed': breed,
      'desc': desc,
      'image': image,
      'owner_name': FirebaseAuth.instance.currentUser!.displayName,
      'owner_id': FirebaseAuth.instance.currentUser!.uid,
      'pet_added_date': petAddedDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add Pet'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(children: <Widget>[
            const SizedBox(
              height: 20,
            ),

            //name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _petNameController,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                    return "Enter first name";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Pet Name',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //age
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || value == '') {
                    return "Enter age";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Age',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //type
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint: const Text('Type'),
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  isExpanded: true,
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //Gender
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint: const Text('Gender'),
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                  value: genderDropDownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  isExpanded: true,
                  items:
                      genderItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      genderDropDownValue = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //Breed
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _breedNameController,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                    return "Enter first name";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Breed',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _descController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter description";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText:
                      'Description here. If any allergies please specify.',
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintMaxLines: 2,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //image picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: uploadFile,
                            child: const Text('Upload Photo')),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //add button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: addPet,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                      child: Text(
                    'Add Pet',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
