import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:worktracker/services/blocs/register/register_bloc.dart';

import '../../services/blocs/register/register_state.dart';
import '../users/users.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                  const UsersScreen()),
                  (Route<dynamic> route) =>
              false);
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
             const  Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Center(child: Text('Add User',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22),),),
                  ),

                  SizedBox(height: screenSize.height / 13),
                 const Align(
                      alignment: Alignment.topLeft,
                      child:DropRolButton()),
                  const _FirstNameInput(),
                  SizedBox(height: screenSize.height / 19),
                  const _LastNameInput(),
                  SizedBox(height: screenSize.height / 19),
                  const _UserNameInput(),
                  SizedBox(height: screenSize.height / 19),
                  const PasswordInput(),
                  SizedBox(height: screenSize.height / 15),
                  const Align(
                      alignment: Alignment.centerLeft, child: _SignupButton()),

            ],
          ),
        ),
      ),
    );
  }
}

class _UserNameInput extends StatelessWidget {
  const _UserNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.userName != current.userName,
      builder: (context, state) {
        return TextFormField(
          cursorColor: Colors.black,
          style: const TextStyle(color:Colors.black),
          decoration: InputDecoration(
            focusedBorder:const  OutlineInputBorder(
              borderSide:
              BorderSide(width: 2,color: Colors.black),),
            enabledBorder:  OutlineInputBorder(

                borderSide:const
                BorderSide(width: 2,color: Colors.black),
                borderRadius: BorderRadius.circular(12)),
            labelText: 'User Name',
            labelStyle: const TextStyle(
              fontFamily: 'GHEAGrapalat',
              fontSize: 14,
              color: Colors.black,
            ),
            focusColor:Colors.black12,
            errorText: state.userName.invalid ? 'Մուտքագրված հասցեն սխալ է' : null,
          ),
          onChanged: (email) =>
              context.read<RegisterCubit>().emailChanged(email),
        );
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  const _FirstNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            focusedBorder:const  OutlineInputBorder(
              borderSide:
              BorderSide(width: 2,color: Colors.black),),
            enabledBorder:  OutlineInputBorder(

                borderSide:const
                BorderSide(width: 2,color: Colors.black),
                borderRadius: BorderRadius.circular(12)),
            labelText: 'First name',
            labelStyle: const TextStyle(
              fontFamily: 'GHEAGrapalat',
              fontSize: 14,
              color: Colors.black,
            ),
            focusColor: Colors.black12,
            errorText: state.firstName.invalid
                ? 'Invalid data '
                : null,
          ),
          onChanged: (fullName) =>
              context.read<RegisterCubit>().fullaNameChanged(fullName),
        );
      },
    );
  }
}
class _LastNameInput extends StatelessWidget {
  const _LastNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            focusedBorder:const  OutlineInputBorder(
              borderSide:
              BorderSide(width: 2,color: Colors.black),),
            enabledBorder:  OutlineInputBorder(

                borderSide:const
                BorderSide(width: 2,color: Colors.black),
                borderRadius: BorderRadius.circular(12)),
            labelText: 'Last Name',
            labelStyle: const TextStyle(
              fontFamily: 'GHEAGrapalat',
              fontSize: 14,
              color: Colors.black,
            ),
            focusColor: Colors.black12,
            errorText: state.firstName.invalid
                ? 'Invalid data'
                : null,
          ),
          onChanged: (fullName) =>
              context.read<RegisterCubit>().lastNameChange(fullName),
        );
      },
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isHiddenPassword = true;

  void _togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          cursorColor:Colors.black,
          style:const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            focusedBorder:const  OutlineInputBorder(
                borderSide:
                BorderSide(width: 2,color: Colors.black),),
            enabledBorder:  OutlineInputBorder(

                borderSide:const
                BorderSide(width: 2,color: Colors.black),
            borderRadius: BorderRadius.circular(12)),

            fillColor: Colors.white30,
            labelText: 'Password',
            labelStyle: const TextStyle(
                fontFamily: 'GHEAGrapalat',
                fontSize: 14,
                color: Colors.black),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: InkWell(
                onTap: _togglePassword,
                child: isHiddenPassword
                    ? const Icon(
                  Icons.visibility,
                  color: Colors.black,
                )
                    : const Icon(
                  Icons.visibility_off,
                  color:Colors.black
                ),
              ),
            ),
            errorText: state.password.invalid ? 'Գաղտնաբառը հուսալի չէ' : null,
          ),
          obscureText: isHiddenPassword,
          onChanged: (password) =>
              context.read<RegisterCubit>().passwordChanged(password),
        );
      },
    );
  }
}

class _SignupButton extends StatefulWidget {
  const _SignupButton({Key? key}) : super(key: key);

  @override
  State<_SignupButton> createState() => _SignupButtonState();
}

class _SignupButtonState extends State<_SignupButton> {
  bool _isActive = false;

  void isActive() {
    setState(() {
      _isActive = !_isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return SizedBox(

        child:TextButton(
          onPressed: () {
      print(state.status.isValidated);
            if (state.status.isValidated) {
              isActive();
              context.read<RegisterCubit>().signUpCredentials();
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade500,

          ), child: const Text('Add',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        )
      );
    });
  }
}

class DropRolButton extends StatefulWidget {
  const DropRolButton({Key? key}) : super(key: key);

  @override
  State<DropRolButton> createState() => _DropRolButtonState();
}

class _DropRolButtonState extends State<DropRolButton> {
  String dropdownvalue = 'User';

  var items = [
    'User',
    'Admin',
  ];

  @override
  Widget build(BuildContext context) {
    context.read<RegisterCubit>().roleChanged(dropdownvalue.toLowerCase());

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

        setState(() {
          dropdownvalue = newValue!;
          context.read<RegisterCubit>().roleChanged(dropdownvalue.toLowerCase());


        });
      },
    );
  }
}
