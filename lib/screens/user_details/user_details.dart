import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_project_1/constants/colors.dart';
import 'package:test_project_1/constants/dimensions.dart';
import 'package:test_project_1/constants/images.dart';
import 'package:test_project_1/constants/styles.dart';
import 'package:test_project_1/controller/details.dart';
import 'package:test_project_1/screens/user_details/user_head.dart';
import 'package:test_project_1/widgets/name.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final UserDetailsController ctr = Get.put(UserDetailsController());

  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  Future<void> fetchUserDetails() async {
    await ctr.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final DateFormat formatter = DateFormat('yyyy-MM-dd');
            final today = DateTime.now();
            final date = formatter.format(ctr.userModel.data?.dob ?? today);

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserHead(image: user),
                    Padding(
                      padding: e2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Personal Information', style: s15),
                            ],
                          ),
                          name(ctr.userModel.data?.name ?? 'Name', 'Name'),
                          const SizedBox(height: 5),
                          name(ctr.userModel.data?.email ?? 'Email', 'Email'),
                          const SizedBox(height: 5),
                          name(
                              ctr.userModel.data?.gender ?? 'Gender', 'Gender'),
                          name(date, 'Date of Birth'),
                          const SizedBox(height: 5),
                          name(ctr.userModel.data?.phone ?? 'Contact Number',
                              'Contact Number'),
                          const SizedBox(height: 5),
                          name(ctr.userModel.data?.location ?? 'Location',
                              'Location'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
