import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../main/components/side_menu.dart';

class addnewbatchadvisor extends StatefulWidget {
  @override
  _AddNewBatchAdvisorState createState() => _AddNewBatchAdvisorState();
}

class _AddNewBatchAdvisorState extends State<addnewbatchadvisor> {
  final TextEditingController batchAdvisorIdController = TextEditingController();
  final TextEditingController selectbatchController = TextEditingController();
  final TextEditingController departIdController = TextEditingController();
  final TextEditingController batchAdvisorNameController = TextEditingController();
  final TextEditingController batchAdvisorEmailController = TextEditingController();
  final TextEditingController batchAdvisorContactController = TextEditingController();
  final TextEditingController batchAdvisorPasswordController = TextEditingController();
  String? selectedDepartment;
  String? selectedBatch;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardScreen(parameter: "Add New Batch Advisor"),
                      SizedBox(height: 20),
                      _buildAddBatchAdvisorForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBatchAdvisorForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValidatedTextField(
            controller: batchAdvisorIdController,
            labelText: 'Batch Advisor ID',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Advisor ID';
              }
              return null;
            },
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildDropdownButton(
            label: 'Department ID',
            controller: departIdController,
            defaultValue: selectedDepartment ?? 'Select Department',
            prefixIcon: Icons.business,
            items: [
              DropdownMenuItem(
                value: '101',
                child: Row(
                  children: [
                    Icon(Icons.business, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Department 101', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: '102',
                child: Row(
                  children: [
                    Icon(Icons.business, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Department 102', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedDepartment = value;
                departIdController.text = value ?? '';
              });
            },
          ),
          SizedBox(height: 16),
          _buildDropdownButton(
            label: 'Batch ',
            controller: selectbatchController,
            defaultValue:  'Select Batch ',
            prefixIcon: Icons.group,
            items: [
              DropdownMenuItem(
                value: '2023',
                child: Row(
                  children: [
                    Icon(Icons.group, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Batch 2023', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: '2024',
                child: Row(
                  children: [
                    Icon(Icons.group, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Batch 2024', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedBatch = value;
                selectbatchController.text = value ?? '';
              });
            },
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: batchAdvisorNameController,
            labelText: 'Batch Advisor Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Advisor Name';
              }
              return null;
            },
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: batchAdvisorEmailController,
            labelText: 'Batch Advisor Email',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Advisor Email';
              } else if (!RegExp(
                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            prefixIcon: Icons.email,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: batchAdvisorContactController,
            labelText: 'Batch Advisor Contact',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Advisor Contact';
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            prefixIcon: Icons.phone,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: batchAdvisorPasswordController,
            labelText: 'Batch Advisor Password',
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Advisor Password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
            prefixIcon: Icons.lock,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                sendDataToServer();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF334155)),

              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Square-shaped button
                ),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({
    required String label,
    required TextEditingController controller,
    String defaultValue = '',
    IconData? prefixIcon,
    List<DropdownMenuItem<String>> items = const [],
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (prefixIcon != null)
              Icon(prefixIcon, color: Colors.black),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
        DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty ? controller.text : null,
          onChanged: onChanged,
          items: items,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: defaultValue,
            hintStyle: TextStyle(color: Colors.black),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value == 'Select Department' || value == 'Select Batch') {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ],
    );
  }


  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon:
        prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
        suffixIcon: _buildValidationIcon(controller.text, validator),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: (value) {
        setState(() {});
      },
      validator: validator,
    );
  }

  Widget _buildValidationIcon(String text, String? Function(String?)? validator) {
    if (text.isEmpty) {
      return SizedBox.shrink();
    }
    return Icon(
      validator?.call(text) == null ? Icons.check : Icons.clear,
      color: validator?.call(text) == null ? Colors.green : Colors.red,
    );
  }

  Future<void> sendDataToServer() async {
    final url = 'http://localhost:5000/managebatch_advisor/add_new_batch_advisor';
    print( departIdController.text);
    final data = {
      'AdvisorID': batchAdvisorIdController.text,
      'depart_id': departIdController.text,
      'batch_id':selectbatchController.text,
      'advisor_name': batchAdvisorNameController.text,
      'advisor_contact': batchAdvisorContactController.text,
      'advisor_email': batchAdvisorEmailController.text,
      'advisor_password': batchAdvisorPasswordController.text,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // Successful response from the server

        showLoginSuccessToast('Batch Advisor added successfully');
        Navigator.pushNamed(context, '/add_new_batch_advisor');
        // Optionally, you can navigate to a new screen or show a success message
      } else {
        // Handle other response statuses
        showLoginFailedToast('Failed to add Batch Advisor. Status code: ${response.statusCode}');
        Navigator.pushNamed(context, '/add_new_batch_advisor');
      }
    } catch (error) {
      // Handle errors
      showLoginFailedToast('$error');
      Navigator.pushNamed(context, '/add_new_batch_advisor');
    }
  }
  void showLoginFailedToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red, // Red color for failure
      textColor: Colors.white,
      timeInSecForIosWeb: 3,
    );
  }

  void showLoginSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green, // Green color for success
      textColor: Colors.white,
      timeInSecForIosWeb: 3,
    );
  }

}
