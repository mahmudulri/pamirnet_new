import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/utils/colors.dart';

import '../controllers/bundle_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/social_bundles.dart';
import '../widgets/ktext.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final serviceController = Get.find<ServiceController>();

  final bundleController = Get.find<BundleController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  final ScrollController scrollController = ScrollController();

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    serviceController.fetchservices();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Obx(() {
                if (serviceController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 1.0,
                    ),
                  );
                }

                final services =
                    serviceController.allserviceslist.value.data?.services ??
                    [];

                if (services.isEmpty) {
                  return Center(
                    child: Text(
                      'No services available',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 0.77,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final data = services[index];

                    return GestureDetector(
                      onTap: () {
                        box.write("company_id", data.companyId);
                        print(data.companyId.toString());
                        mypagecontroller.changePage(
                          SocialBundles(),
                          isMainPage: false,
                        );
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 4,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: data.company?.companyLogo ?? '',
                                placeholder: (context, url) {
                                  print('Loading image: $url');
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 2.0,
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  print(
                                    'Error loading image: $url, error: $error',
                                  );
                                  return Icon(
                                    Icons.error,
                                    size: 35,
                                    color: Colors.grey.shade400,
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: 8),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                data.company?.companyName ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
