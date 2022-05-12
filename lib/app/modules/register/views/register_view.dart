import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),
            const Image(
              image: AssetImage("assets/images/logo.png"),
              width: 390,
              height: 350,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 1),
            const Text(
              "Register as a Rider",
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: controller.txtName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "john do.",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: controller.txtPhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "05xxxxxxxxx",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: controller.txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "someone@example.com",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: controller.txtPass,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "********",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    // color: Colors.yellow,
                    // textColor: Colors.white,
                    onPressed: () => controller.validation(context),
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(24),
                    // ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN);
              },
              child: const Text(
                'Already have an Account? Login here.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
