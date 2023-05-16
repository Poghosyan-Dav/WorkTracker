
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:worktracker/services/models/user.dart';


// widgets

class SheetContainerBody extends StatefulWidget {
  final User? user;
  final Function? pushEditedFirstName;
  final Function? pushEditedLastName;
  final Function? pushEditedJobTitle;
  final Function? pushEditedRole;
  final Function? pushEditedPassword;
  final bool? isInfo;
  final Function()? saveChanges;
  const SheetContainerBody({
    Key? key,
    this.isInfo,
    this.saveChanges,
    required this.user,
    this.pushEditedPassword,
    this.pushEditedRole,
     this.pushEditedFirstName,
     this.pushEditedLastName,
     this.pushEditedJobTitle,
  }) : super(key: key);

  @override
  SheetContainerBodyState createState() => SheetContainerBodyState();
}

class SheetContainerBodyState extends State<SheetContainerBody> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late  FocusNode _userNameFocusNode =FocusNode();
  late  FocusNode _lastNameFocusNode =FocusNode();
  late  FocusNode _firstNameFocusNode =FocusNode();
  late  FocusNode _passwordFocuseNode =FocusNode();

  final Completer<GoogleMapController> _controller = Completer();
  //final Location _location = Location();
  bool _firstNameFocused = false;
  bool _lastNameFocused = false;
  bool _userNameFocused = false;
  bool _passwordFocused = false;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.4018, 44.6434),
    zoom: 15,
  );

  String dropdownvalue = 'User';

  var items = [
    'User',
    'Admin',
  ];


 Widget roleDropDownMenu(){
  return DropdownButton(
     value: dropdownvalue,
     icon: const Icon(Icons.keyboard_arrow_down),
     items: items.map((String items) {
       return DropdownMenuItem(
         value: items,
         child: Text(items),
       );
     }).toList(),
     onChanged: (String? newValue) {
      dropdownvalue  = newValue!;
       setState(() {
        _userRoleChange(newValue.toLowerCase());
       });
     },
   );
 }

  @override
  void initState() {
    super.initState();
  if(widget.user?.role == 'admin')dropdownvalue = 'Admin';
    _userNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _firstNameFocusNode = FocusNode();
    _passwordFocuseNode = FocusNode();
    _userNameFocusNode.addListener(_onNameFocusChange);
    _lastNameFocusNode.addListener(_onLastNameFocusChange);
    _firstNameFocusNode.addListener(_onJobTitleFocusChange);
   _passwordController.addListener(_onPasswordFocuseChange);
    _firstNameController.text = widget.user?.firstName as String;
    _lastNameController.text = widget.user?.lastName as String;
    _userNameController.text = widget.user?.username as String;
  }

  void _onNameFocusChange() {
    setState(() {
      _firstNameFocused = _firstNameFocusNode.hasFocus ? true : false;
    });
  }

  void _onLastNameFocusChange() {
    setState(() {
      _lastNameFocused = _lastNameFocusNode.hasFocus ? true : false;
    });
  }

  void _onJobTitleFocusChange() {
    setState(() {
      _userNameFocused = _userNameFocusNode.hasFocus ? true : false;
    });
  }
  void _onPasswordFocuseChange() {
    setState(() {
      _passwordFocused = _passwordFocuseNode.hasFocus ? true : false;
    });
  }
  void _onFirstNameTextChange(name) {
    if (_firstNameController.text != '') {
      widget.pushEditedFirstName!(name);
    }
  }

  void _onLastNameTextChange(lastName) {
    if (_lastNameController.text != '') {
      widget.pushEditedLastName!(lastName);
    }
  }

  void _userNameTextChange(jobTitle) {
    if (_userNameController.text != '') {
      widget.pushEditedJobTitle!(jobTitle);
    }
  }void _userRoleChange(role) {
    if (role != '') {
      widget.pushEditedRole!(role);
    }
  }
  void _onPasswordChange(password) {
      widget.pushEditedPassword!(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        child:
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   Align(
                      alignment: Alignment.topLeft,
                      child:roleDropDownMenu()),
              const Text('First name',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  letterSpacing: 0.014,
                  color: Color(0xFF212121),
                ),
              ),
              Container(
                height: 56.0,
                margin: const EdgeInsets.only(top: 9.0),
                padding: const EdgeInsets.only(top: 12.0,left: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _firstNameFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _firstNameController..value = _firstNameController.value,
                  focusNode: _firstNameFocusNode,
                  onChanged: (name) => _onFirstNameTextChange(name),
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your first name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                  ),
                ),
              ),

              // last name input
              Container(
                margin: const EdgeInsets.only(top: 27.0),
                child: const Text('Last name',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    letterSpacing: 0.014,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
              Container(
                height: 56.0,
                margin: const EdgeInsets.only(top: 9.0, bottom: 20.0),
                padding: const EdgeInsets.only(top: 12.0,left: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _lastNameFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _lastNameController..value = _lastNameController.value,
                  focusNode: _lastNameFocusNode,
                  onChanged: (lastName) => _onLastNameTextChange(lastName),
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your last name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              // user name input
              const Text(
                'User Name',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  letterSpacing: 0.014,
                  color: Color(0xFF212121),
                ),
              ),
              Container(
                height: 56.0,
                margin: const EdgeInsets.only(top: 9.0),
                padding: const EdgeInsets.only(top: 12.0,left: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _userNameFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _userNameController..value = _userNameController.value,
                  focusNode: _userNameFocusNode,
                  onChanged: (userName) => _userNameTextChange(userName),
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your user name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
              Container(
                margin:const  EdgeInsets.only(top: 20),
                child: const Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    letterSpacing: 0.014,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
              Container(
                height: 56.0,
                margin: const EdgeInsets.only(top: 9.0),
                padding: const EdgeInsets.only(top: 12.0,left: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _passwordFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _passwordController..value = _passwordController.value,
                  focusNode: _passwordFocuseNode,
                  onChanged: (password) => _onPasswordChange(password),
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Edit your password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
                 const  SizedBox(height: 10,),
                  widget.isInfo == false ? const SizedBox(): SizedBox(
                    width: 56.0,
                    height: 56.0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:  widget.saveChanges,
                        borderRadius: const BorderRadius.all(Radius.circular(28.0)),
                        child:const Center(
                          child: Text('Save',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              letterSpacing: 0.2,
                              color: Color(0xFF569AFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],),
            ),
            // first name input
      ),
    );
  }
}