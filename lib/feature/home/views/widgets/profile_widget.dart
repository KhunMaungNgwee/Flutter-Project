import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/auth/models/user_response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/feature/home/view_models/home_viewmodel.dart';

class ProfileWidget extends StatefulWidget {
  final UserResponse? userData;
  final String? profilePic;
  const ProfileWidget({super.key, this.userData, this.profilePic});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();

  void showDeleteConfirmationDialog(BuildContext context,
      {required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Delete canceled');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
                print('Delete confirmed');
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileWidgetState extends State<ProfileWidget> {
  // Declare the _cachedImage variable to hold the selected or taken image
  File? _cachedImage;
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  int userID = 1129;
  ProfilePic? _profilePic;

  List<String> dropDownItem = ['Mr.', 'Mrs.', 'Ms.', 'Miss.'];
  String selectValue = '';
  String? selectItem = '';
  String? imageString;
  String? fileName;
  String? prefix;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      fileName = pickedFile.path;
      imageString = imageToBase64(pickedFile.path);

      setState(() {
        _cachedImage = File(pickedFile.path);
        _profilePic = ProfilePic(fileName: imageString); // Update profilePic
      });
    }
  }

  Future<void> _takePictureWithCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      fileName = pickedFile.path;
      imageString = imageToBase64(pickedFile.path);

      setState(() {
        _cachedImage = File(pickedFile.path);
        _profilePic = ProfilePic(fileName: imageString); // Update profilePic
      });
    }
  }

  String imageToBase64(String imagePath) {
    final bytes = File(imagePath).readAsBytesSync();
    return base64Encode(bytes);
  }

  Future<void> _submitProfileUpdate() async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updating profile...')),
      );

      final fullName =
          '${_firstNameController.text} ${_lastNameController.text}';

      final updatedProfilePic = ProfilePic(
        base64: imageString, // ✅ Ensure base64 string is passed
        fileName: fileName, // ✅ Ensure fileName is included
        url: null, // Clear URL to avoid conflicts
      );

      final userData = ProfileResponse(
        id: widget.userData?.id ?? 1129,
        fullName: fullName,
        email: _emailController.text,
        firstName: _firstNameController.text,
        gender: selectValue,
        lastName: _lastNameController.text,
        profilePic: updatedProfilePic, // ✅ Assign the updated profilePic
        prefix: selectItem!,
      );

      debugPrint("Sending profile update: ${userData.toJson()}"); // ✅ Debug log

      await homeViewModel.updateProfile(userData, context);

      // ✅ Update UI state
      setState(() {
        _profilePic = updatedProfilePic;
      });

      Navigator.pop(context, _profilePic);
    } catch (e) {
      debugPrint("Profile update failed: $e");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updating Success...')),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _pickImageFromGallery();
                },
                icon: const Icon(Icons.folder_open),
                label: const Text('Browse'),
              ),
              TextButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _takePictureWithCamera();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Camera'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _userIdController.text = widget.userData?.id.toString() ?? '1129';
    _firstNameController.text = widget.userData?.firstName ?? 'Khun Maung';
    _lastNameController.text = widget.userData?.lastName ?? 'Ngwe';
    _emailController.text =
        widget.userData?.email ?? 'khunmaung11234@gmail.com';

    selectValue = widget.userData?.gender ?? 'male';
    selectItem = widget.userData?.prefix ?? 'Mr.';

    // ✅ Check if profilePic exists before assigning a new one
    if (widget.userData?.profilePic.base64 != null) {
      imageString = widget.userData!.profilePic.base64;
      fileName = widget.userData!.profilePic.fileName;
    }

    _profilePic = ProfilePic(
      base64: imageString,
      fileName: fileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 332,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF1C4C95), // Dark green
                  Color.fromARGB(255, 29, 100, 28),
                ]),
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).go("/home");
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 10, top: 20),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 80, 107, 155),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 30,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Edit Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 350, right: 10, top: 20),
              child: GestureDetector(
                onTap: () {
                  widget.showDeleteConfirmationDialog(
                    context,
                    onConfirm: () {
                      print('Item deleted');
                    },
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 88, 90, 88),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        Positioned(
          top: 200,
          left: 25,
          right: 25,
          height: 790,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color

                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withValues(
                //         alpha:
                //             1), //                    spreadRadius: 5, // How far the shadow spreads
                //     blurRadius: 10, // How blurry the shadow is
                //     offset: Offset(5, 5), // Shadow position (x, y)
                //   ),
                // ],
              ),
              width: double.infinity,
              height: double.infinity,
              // color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 20,
                      right: 20,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 600,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "User ID",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormField(
                                            controller: _userIdController,
                                            decoration: InputDecoration(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Prefix",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.5),
                                              ),
                                            ),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              value: selectItem,
                                              hint: Text("Mr."),
                                              onChanged: (String? newVal) {
                                                setState(() {
                                                  selectItem = newVal;
                                                });
                                              },
                                              items: dropDownItem.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value));
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "First Name",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormField(
                                            controller: _firstNameController,
                                            decoration: InputDecoration(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Last Name",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormField(
                                            controller: _lastNameController,
                                            decoration: InputDecoration(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Gender",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: RadioListTile(
                                              contentPadding: EdgeInsets.zero,
                                              activeColor: Colors.green,
                                              value: "male",
                                              groupValue: selectValue,
                                              title: Text("Male"),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectValue = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile(
                                              contentPadding: EdgeInsets.zero,
                                              activeColor: Colors.green,
                                              value: "female",
                                              groupValue: selectValue,
                                              title: Text("Female"),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectValue = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.only(left: 40, right: 40)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color.fromARGB(255, 89, 228, 96)),
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                    textStyle: WidgetStatePropertyAll(
                                        TextStyle(fontSize: 18.0)),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _submitProfileUpdate();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Please fill all fields')),
                                      );
                                    }
                                  },
                                  child: Text('Update'),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 25,
          right: 25,
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _cachedImage != null
                      ? FileImage(_cachedImage!) // ✅ Use new image if available
                      : (widget.profilePic != null &&
                              widget.profilePic!.isNotEmpty
                          ? MemoryImage(base64Decode(widget.profilePic!))
                              as ImageProvider
                          : NetworkImage(
                              'https://c02.purpledshub.com/uploads/sites/40/2023/08/JI230816Cosmos220-6d9254f-edited-scaled.jpg?w=1455&webp=1',
                            )), // ✅ Default image if null
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 10.0,
                ),
              ),
            ),
          ),
        ),
        Stack(
          children: [
            // Display the cached image if available
            // Center(
            //   child: _cachedImage != null
            //       ? Image.file(_cachedImage!) // Display the image
            //       : const Text(
            //           'No Image Selected'), // Placeholder if no image is selected
            // ),

            // Positioned Edit Button
            Positioned(
              top: 160,
              left: 200,
              right: 30,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 72, 244, 90),
                ),
                child: IconButton(
                  onPressed: () {
                    _showImagePickerDialog(context); // Show image picker dialog
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
