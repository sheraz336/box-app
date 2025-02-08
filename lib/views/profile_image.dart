import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controllers/profile_image_controller.dart';
import '../widgets/profile_image.dart';
import '../widgets/profile_text_field.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xffe25e00),
            title: Text(
              'My Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileImageWidget(
                  image: CircleAvatar(backgroundImage: AssetImage('assets/profile_image.png')),
                  onMoreTap: () => _showImageOptions(context, controller), icon: Icon(Icons.more_horiz,color:Color(0xffFFFFFF) ,),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed:  ()async{
                            await FirebaseAuth.instance.signOut();
                            controller.logOut();
                            Navigator.of(context).pushNamedAndRemoveUntil("/splash", (route)=>false);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFFE25E00), width: 1), // Orange border
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Color(0xFFE25E00), // Orange text color
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.deleteAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE25E00),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  void _showImageOptions(BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Photo'),
              onTap: () {
                Navigator.pop(context);
                _showImageSourceDialog(context, controller);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Photo'),
              onTap: () {
                controller.deleteProfileImage();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}