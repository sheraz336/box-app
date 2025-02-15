import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:box_delivery_app/views/subscription_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_image_controller.dart';
import '../widgets/profile_image.dart';
import '../widgets/profile_text_field.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void onSignout(ProfileController controller) async {
    await FirebaseAuth.instance.signOut();
    await controller.logOut();
    Navigator.of(context).pushNamedAndRemoveUntil("/splash", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final currentSub =
        context.read<SubscriptionRepository>().currentSubscription;
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        if (controller.profile == null) return Scaffold();
        final user = controller.profile!;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xffe25e00),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'My Profile',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileImageWidget(
                  image: CircleAvatar(
                      backgroundImage: AssetImage('assets/profile_image.png')),
                  onMoreTap: () => _showImageOptions(context, controller),
                  icon: Icon(
                    Icons.more_horiz,
                    color: Color(0xffFFFFFF),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ProfileTextField(
                  label: 'Your Email',
                  value: user.email,
                ),
                SizedBox(height: 20),
                ProfileTextField(
                  label: 'Phone Number',
                  value: user.phoneNumber,
                ),
                SizedBox(height: 20),
                ProfileTextField(
                  label: 'Password',
                  value: user.password,
                  isPassword: true,
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: ProfileTextField(
                      label: 'Subscription',
                      value: currentSub.name,
                      isPassword: false,
                    )),
                    IconButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (c) => SubscriptionScreen())),
                        icon: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Icon(Icons.navigate_next,color: Colors.white,),
                        ))
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => onSignout(controller),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: Color(0xFFE25E00),
                                width: 1), // Orange border
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 56,
                    //     child: ElevatedButton(
                    //       onPressed: controller.deleteAccount,
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Color(0xFFE25E00),
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(8)),
                    //       ),
                    //       child: Text(
                    //         'Delete Account',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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

  void _showImageSourceDialog(
      BuildContext context, ProfileController controller) {
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
