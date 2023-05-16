import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/screens/history/info_page.dart';
import 'package:worktracker/screens/home_screen_form/admin_form.dart';
import '../../services/blocs/login/login_bloc.dart';
import '../../widget/users_card_form.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';
import '../Login/login_screen.dart';
class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _sessionDataProvider = SessionDataProvider();

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(child:
    Scaffold(
      backgroundColor:Colors.grey.shade100,
        appBar: AppBar(title: const Text('Users'),
            automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          leading: null,
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => const [
                PopupMenuItem<int>(value: 0, child:  Text('Add User')),
                PopupMenuItem<int>(value: 1, child:  Text('History')),
                PopupMenuItem<int>(value: 2, child:  Text('Logout')),
              ],
            ),
          ],
        ),


        body:const DashboardData(),


    ) ,);
  }
  void handleClick(int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const AdminScreen()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=> MyPage(),));
        break;
      case 2:
        _sessionDataProvider.deleteAllToken();
        context.read<LoginCubit>().logOut();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        const LoginScreen()), (Route<dynamic> route) => false);
        break;
    }
  }
}

