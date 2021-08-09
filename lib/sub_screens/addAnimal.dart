import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_lover/custom_classes/DatabaseManager.dart';
import 'package:pet_lover/custom_classes/TextFieldValidation.dart';
import 'package:pet_lover/custom_classes/progress_dialog.dart';
import 'package:pet_lover/model/animal.dart';
import 'package:pet_lover/provider/animalProvider.dart';
import 'package:pet_lover/video_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddAnimal extends StatefulWidget {
  String petId;
  AddAnimal({Key? key, required this.petId}) : super(key: key);
  @override
  _AddAnimalState createState() => _AddAnimalState(petId);
}

class _AddAnimalState extends State<AddAnimal> {
  String petId;
  _AddAnimalState(this.petId);
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _genusController = TextEditingController();
  // TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  File? fileMedia;
  File? _image;

  String? animalsImageLink;
  String? animalsVideoLink;
  String? imageLink;
  String? _currentMobileNo;
  String? _username;
  String? _userProfileImage;
  String dateData = '';
  String? petNameErrorText;
  String? colorErrorText;
  String? genusErrorText;
  String? genderErrorText;
  String? ageErrorText;

  bool profileImageUploadVisibility = false;
  VideoPlayerController? controller;

  String _choosenValue = 'Male';
  List<String> _groupGender = ['Male', 'Female'];
  Animal _animal = Animal();
  int _count = 0;

  Future<String?> getCurrentMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    _currentMobileNo = prefs.getString('mobileNo');
    print('Current Mobile no is $_currentMobileNo');
    return _currentMobileNo;
  }

  Future _customInit(AnimalProvider animalProvider) async {
    if (this.mounted) {
      setState(() {
        _count++;
      });
      _getPetInfo(animalProvider);
    }
  }

  _getPetInfo(AnimalProvider animalProvider) async {
    if (petId != '') {
      _animal = await animalProvider.getSpecificAnimal(petId);
      print('name = ${_animal.petName}, id = ${_animal.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Add Animal",
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * .05,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: bodyUI(context),
    );
  }

  //body demo design
  Widget bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AnimalProvider animalProvider = Provider.of<AnimalProvider>(context);
    if (_count == 0) _customInit(animalProvider);
    return Container(
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //container for image or video loading
              width: size.width,
              height: size.width * .7,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300)),
              child: Center(
                child: _image != null || fileMedia != null
                    ? Container(
                        width: size.width,
                        height: size.width * .7,
                        color: Colors.grey.shade300,
                        alignment: Alignment.topCenter,
                        child: _image != null
                            ? Image.file(_image!, fit: BoxFit.fill)
                            : VideoWidget(fileMedia!))
                    : Text(
                        'No image or video selected!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.width * .05,
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: size.width * .02,
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * .04),
              child: Row(
                children: [
                  ElevatedButton(
                      //video pick button
                      onPressed: () async {
                        setState(() {
                          String source = 'Video';

                          _cameraGalleryBottomSheet(context, source);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.video_camera_front,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: size.width * .03,
                          ),
                          Text(
                            'Video',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .038),
                          )
                        ],
                      )),
                  SizedBox(
                    width: size.width * .04,
                  ),
                  ElevatedButton(
                      //image pick button
                      onPressed: () async {
                        setState(() {
                          String source = 'Photo';
                          _cameraGalleryBottomSheet(context, source);
                        });

                        //   print(_file);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: size.width * .03,
                          ),
                          Text(
                            'Photo',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .038),
                          )
                        ],
                      ))
                ],
              ),
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.fromLTRB(size.width * .04, size.width * .06,
                  size.width * .04, size.width * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Animal Details',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * .05,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.width * .05),
                  Text(
                    'Pet name',
                    style: TextStyle(fontSize: size.width * .042),
                  ),
                  SizedBox(
                    height: size.width * .02,
                  ),
                  Container(
                    //textformfield for pet name input
                    width: size.width,
                    padding: EdgeInsets.only(
                        left: size.width * .04,
                        right: size.width * .04,
                        top: size.width * .02,
                        bottom: size.width * .02),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(size.width * .02),
                    ),
                    child: textFormFieldBuilder(TextInputType.text, 1,
                        _petNameController, petNameErrorText),
                  ),
                  SizedBox(
                    height: size.width * .04,
                  ),
                  Text(
                    'Color',
                    style: TextStyle(fontSize: size.width * .042),
                  ),
                  SizedBox(
                    height: size.width * .02,
                  ),
                  Container(
                    //textformfield for pet color input
                    width: size.width,
                    padding: EdgeInsets.only(
                        left: size.width * .04,
                        right: size.width * .04,
                        top: size.width * .02,
                        bottom: size.width * .02),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(size.width * .02),
                    ),
                    child: textFormFieldBuilder(TextInputType.text, 1,
                        _colorController, colorErrorText),
                  ),
                  SizedBox(
                    height: size.width * .04,
                  ),
                  Text(
                    'Genus',
                    style: TextStyle(fontSize: size.width * .042),
                  ),
                  SizedBox(
                    height: size.width * .02,
                  ),
                  Container(
                    //textformfield for genus input
                    width: size.width,
                    padding: EdgeInsets.only(
                        left: size.width * .04,
                        right: size.width * .04,
                        top: size.width * .02,
                        bottom: size.width * .02),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(size.width * .02),
                    ),
                    child: textFormFieldBuilder(TextInputType.text, 1,
                        _genusController, genusErrorText),
                  ),
                  SizedBox(
                    height: size.width * .04,
                  ),
                  Text(
                    'Gender',
                    style: TextStyle(fontSize: size.width * .042),
                  ),
                  SizedBox(
                    height: size.width * .02,
                  ),
                  Container(
                      width: size.width,
                      height: size.width * .095,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              BorderRadius.circular(size.width * .02)),
                      padding: EdgeInsets.only(
                          left: size.width * .04, right: size.width * .04),
                      child: Container(
                        child: DropdownButton<String>(
                          value: _choosenValue,
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (value) {
                            setState(() {
                              _choosenValue = value.toString();
                            });
                          },
                          items: _groupGender
                              .map((item) => DropdownMenuItem<String>(
                                    child: Text(item),
                                    value: item,
                                  ))
                              .toList(),
                        ),
                      )),
                  SizedBox(
                    height: size.width * .04,
                  ),
                  Text(
                    'Age',
                    style: TextStyle(fontSize: size.width * .042),
                  ),
                  SizedBox(
                    height: size.width * .02,
                  ),
                  Container(
                    //textformfield for pet age input
                    width: size.width,
                    padding: EdgeInsets.only(
                        left: size.width * .04,
                        right: size.width * .04,
                        top: size.width * .02,
                        bottom: size.width * .02),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(size.width * .02),
                    ),
                    child: textFormFieldBuilder(
                        TextInputType.text, 1, _ageController, ageErrorText),
                  ),
                  SizedBox(
                    height: size.width * .04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          //Cancel button
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .038),
                          )),
                      SizedBox(
                        width: size.width * .04,
                      ),
                      ElevatedButton(
                          //save button
                          onPressed: () {
                            setState(() {
                              if (!TextFieldValidation()
                                  .petNameValidation(_petNameController.text)) {
                                petNameErrorText = 'What is your pet name?';
                                return;
                              } else {
                                petNameErrorText = null;
                              }

                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return ProgressDialog(
                                        message:
                                            'Please wait...Uploading file and saving animal data.');
                                  });

                              _uploadData(animalProvider);
                            });
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .038),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _uploadData(AnimalProvider animalProvider) async {
    _currentMobileNo = await getCurrentMobileNo();
    String id = _petNameController.text + _currentMobileNo!;

    _username =
        await DatabaseManager().getUserInfo(_currentMobileNo!, 'username');

    _userProfileImage = await DatabaseManager()
        .getUserInfo(_currentMobileNo!, 'profileImageLink');
    await uploadData(
        id, _currentMobileNo!, _username!, _userProfileImage!, animalProvider);
  }

  Future<void> uploadData(String uuid, String _currentMobileNo, String username,
      String userProfileImage, AnimalProvider animalProvider) async {
    if (_image != null || fileMedia != null) {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('Animals')
          .child(uuid);

      if (_image != null) {
        firebase_storage.UploadTask storageUploadTask =
            storageReference.putFile(_image!);

        firebase_storage.TaskSnapshot taskSnapshot;
        storageUploadTask.then((value) {
          taskSnapshot = value;
          taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
            final downloadUrl = newImageDownloadUrl;
            setState(() {
              animalsImageLink = downloadUrl;
            });
            _submitData(uuid, _currentMobileNo, username, userProfileImage,
                animalProvider);
          });
        });
      } else {
        firebase_storage.UploadTask storageUploadTask =
            storageReference.putFile(fileMedia!);

        firebase_storage.TaskSnapshot taskSnapshot;
        storageUploadTask.then((value) {
          taskSnapshot = value;
          taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
            final downloadUrl = newImageDownloadUrl;
            setState(() {
              animalsVideoLink = downloadUrl;
            });
            _submitData(uuid, _currentMobileNo, username, userProfileImage,
                animalProvider);
          });
        });
      }
    } else {
      print('Please Select File');
    }
  }

  Future<void> _submitData(
      String uuid,
      String _currentMobileNo,
      String username,
      String userProfileImage,
      AnimalProvider animalProvider) async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, String> map = {
      'petName': _petNameController.text,
      'username': username,
      'userProfileImage': userProfileImage,
      'color': _colorController.text,
      'genus': _genusController.text,
      'gender': _choosenValue,
      'age': _ageController.text,
      'mobile': _currentMobileNo,
      'photo': _image != null ? animalsImageLink! : '',
      'video': fileMedia != null ? animalsVideoLink! : '',
      'date': date,
      'totalFollowings': '0',
      'totalComments': '0',
      'totalShares': '0',
      'id': uuid
    };
    await DatabaseManager()
        .addAnimalsData(map, _currentMobileNo)
        .then((value) async {
      if (value) {
        _emptyFildCreator();
        await animalProvider
            .getMyAnimalsNumber()
            .then((value) => Navigator.pop(context));
      } else {}
    });
  }

  _emptyFildCreator() {
    _image = null;
    _petNameController.clear();
    _colorController.clear();
    _genusController.clear();
    _ageController.clear();
  }

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    return File(result!.files.single.path.toString());
  }

  void _cameraGalleryBottomSheet(BuildContext context, String source) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.width * .3,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * .03),
                      topRight: Radius.circular(size.width * .03))),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(source == 'Photo'
                        ? FontAwesomeIcons.camera
                        : FontAwesomeIcons.video),
                    title: Text('Camera'),
                    onTap: () {
                      source == 'Photo' ? _getCameraImage() : _getCameraVideo();

                      Navigator.pop(context);
                      controller != null ? controller!.dispose() : true;
                    },
                  ),
                  ListTile(
                    leading: Icon(source == 'Photo'
                        ? FontAwesomeIcons.images
                        : FontAwesomeIcons.fileVideo),
                    title: Text('Gallery'),
                    onTap: () {
                      source == 'Photo'
                          ? _getGalleryImage()
                          : _getGalleryVideo();
                      Navigator.pop(context);
                      controller != null ? controller!.dispose() : true;
                    },
                  )
                ],
              ),
            ),
          );
        }).then((value) {
      profileImageUploadVisibility = true;
    });
  }

  Future _getGalleryImage() async {
    setState(() {
      this.fileMedia = null;

      this._image = null;
    });
    final _originalImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (_originalImage != null) {
      await ImageCropper.cropImage(
          sourcePath: _originalImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: .7),
          androidUiSettings: AndroidUiSettings(
            lockAspectRatio: false,
          )).then((value) {
        setState(() {
          _image = value;
        });
      });
    }
  }

  Future _getGalleryVideo() async {
    setState(() {
      this.fileMedia = null;
      //   controller!.dispose();
      _image = null;
    });
    final file = await pickVideoFile();
    controller = VideoPlayerController.file(file)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) {
        controller!.play();
        setState(() {
          fileMedia = file;
        });
      });
  }

  Future _getCameraImage() async {
    setState(() {
      //  controller!.dispose();
      this._image = null;
    });
    final _originalImage =
        await ImagePicker().getImage(source: ImageSource.camera);

    if (_originalImage != null) {
      await ImageCropper.cropImage(
          sourcePath: _originalImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: .7),
          androidUiSettings: AndroidUiSettings(
            lockAspectRatio: false,
          )).then((value) {
        setState(() {
          _image = value;
        });
      });
    }
  }

  Future _getCameraVideo() async {
    setState(() {
      this.fileMedia = null;
      //   controller!.dispose();
      _image = null;
    });
    final getMedia = ImagePicker().getVideo;
    final media = await getMedia(source: ImageSource.camera);
    final file = File(media!.path);
    if (file == null) {
      return;
    } else {
      setState(() {
        fileMedia = file;
      });
    }
  }

  //textformfile demo design
  Widget textFormFieldBuilder(TextInputType keyboardType, int maxLine,
      TextEditingController textEditingController, String? errorText) {
    return TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorText: errorText,
        ),
        keyboardType: keyboardType,
        cursorColor: Colors.black,
        maxLines: maxLine);
  }
}
