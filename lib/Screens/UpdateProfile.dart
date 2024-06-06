import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:she_connect/API/RegisterUser_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

class UpdateProfile extends StatefulWidget {
  final name;
  final mob;
  final email;
  final Function refresh;
  const UpdateProfile(
      {Key? key, required this.refresh, this.name, this.email, this.mob})
      : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  void initState() {
    super.initState();

    setState(() {
      _phoneController.text = widget.mob.toString();
      _nameController.text = widget.name.toString();
      _emailController.text = widget.email.toString();
    });
  }

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        title: const Text(
          "Update Profile",
          style: appBarTxtStyl,
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: _buttons(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    nameFiled(),
                    phoneField(),
                    emailField(),
                  ],
                ),
              ),
            ),
            // h(10),
            // Container(
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Gender",
            //           style: size14_400Grey,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             radioType("Male"),
            //             radioType("Female"),
            //             radioType("Other")
            //           ],
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             _pickDateDialog();
            //             // _selectDate(context);
            //           },
            //           child: Container(
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 color: textFieldGrey),
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 17, vertical: 20),
            //               child: Row(
            //                 children: [
            //                   Icon(
            //                     Icons.calendar_today,
            //                     size: 20,
            //                     color: Colors.blueGrey,
            //                   ),
            //                   w(10),
            //                   Text(
            //                     _selectedDate ==
            //                             null //ternary expression to check if date is null
            //                         ? 'Date of Birth'
            //                         : '${DateFormat.yMMMd().format(_selectedDate!)}',
            //                     style: size14_400Grey,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         )
            //         // RaisedButton(
            //         //   onPressed: () => _selectDate(context),
            //         //   child: Text('Select date'),
            //         // ),
            //       ],
            //     ),
            //   ),
            //   color: Colors.white,
            // ),
            // h(20),
            // _buttons(),
          ],
        ),
      ),
    );
  }

  _buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Expanded(
        child: GestureDetector(
          onTap: () async {
            if (_nameController.text.isNotEmpty &&
                _emailController.text.isNotEmpty &&
                _phoneController.text.isNotEmpty) {
              var rsp = await updateProfile(
                  _nameController.text.toString(),
                  _emailController.text.toString(),
                  _phoneController.text.toString());
              print(rsp);
              if (rsp["status"].toString() == "success") {
                showToastSuccess("Profile updated!");
                widget.refresh();
                Navigator.pop(context);
              } else {
                showToastSuccess("Something went wrong!");
              }
            } else {
              showToastError("Please fill the required fields!");
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              child: const Text(
                "Save",
                style: size16_600W,
              ),
            ),
            decoration: BoxDecoration(
                gradient: buttonGradient,
                border: Border.all(color: darkPink),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  phoneField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: textFieldGrey),
      child: TextFormField(
        controller: _phoneController,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        keyboardType: TextInputType.number,
        enabled: false,
        decoration: InputDecoration(
          labelText: "Mobile Number",
          contentPadding: EdgeInsets.only(left: 20),
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: const TextStyle(
              color: Colors.black26, fontSize: 14, fontWeight: FontWeight.w400),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }

  nameFiled() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: textFieldGrey),
      child: TextFormField(
        controller: _nameController,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Name",
          contentPadding: EdgeInsets.only(left: 20),
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: const TextStyle(
              color: Colors.black26, fontSize: 14, fontWeight: FontWeight.w400),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }

  emailField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: textFieldGrey),
      child: TextFormField(
        controller: _emailController,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email Address",
          contentPadding: EdgeInsets.only(left: 20),
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: const TextStyle(
              color: Colors.black26, fontSize: 14, fontWeight: FontWeight.w400),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }
}
