import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:worktracker/screens/users/users.dart';
import 'package:worktracker/services/blocs/login/login_bloc.dart';
import 'package:worktracker/services/blocs/login/login_state.dart';

import '../home_screen_form/user_form.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});


    @override
    Widget build(BuildContext context) {
      var screenSize = MediaQuery
          .of(context)
          .size;

      return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess && state.isUser!=null) {
            Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) =>  state.isUser == true? const UserScreen():const UsersScreen()),(Route<dynamic> route) => false);

          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Login Failure'),
                ),
              );
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height / 6),
                  const _LoginIput(),
                  SizedBox(height: screenSize.height / 19),
                  const PasswordInput(),
                  SizedBox(height: screenSize.height / 15),
                 const LoginButton(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
class _LoginIput extends StatelessWidget {
  const _LoginIput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
            errorText: state.userName.invalid ? 'Invalid data' : null,
          ),
          onChanged: (email) =>
              context.read<LoginCubit>().emailChanged(email),
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
    return BlocBuilder<LoginCubit, LoginState>(
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
              errorText: state.password.invalid ? 'Invalid data' : null,
            ),
            obscureText: isHiddenPassword,
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
          );
        });
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return SizedBox(
          child:TextButton(
            onPressed: () async {
              if (state.status.isValidated) {
                context.read<LoginCubit>().loginWithCredentials();
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 500),
                    content: Text(
                      'Login failure։',
                    )));
              }

            },
            style: TextButton.styleFrom(
              backgroundColor:  Colors.grey.shade500,

            ), child: const Text('LogIn',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          )
      );
    });
  }



}
