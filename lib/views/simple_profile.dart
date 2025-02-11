import 'package:box_delivery_app/controllers/profile_image_controller.dart';
import 'package:box_delivery_app/views/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_image.dart';
import '../widgets/profile_text_field.dart';


class SimpleProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xffE25E00),
            title: Text(
              'My Profile',
              style: TextStyle(color: Color(0xffFFFFFF,),fontSize: 16,fontWeight: FontWeight.w600),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileImageWidget(
                  image: CircleAvatar(backgroundImage: AssetImage('assets/profile_image.png')),
                  onMoreTap: () => (){}, icon: Icon(Icons.edit,size :20,color:Color(0xffFFFFFF) ,),
                ),
                SizedBox(height: 20),
                Text(
                  controller.user.name ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                ProfileTextField(
                  label: 'Your Email',
                  value: controller.user.email,
                ),
                SizedBox(height: 20),
                ProfileTextField(
                  label: 'Phone Number',
                  value: controller.user.phoneNumber,
                ),
                SizedBox(height: 20),
                ProfileTextField(
                  label: 'Password',
                  value: controller.user.password,
                  isPassword: true,
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                  child: ProfileCustomButton(text: 'log out', onPressed: (){

                  }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
