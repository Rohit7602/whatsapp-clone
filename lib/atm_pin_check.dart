import 'package:flutter/material.dart';
import 'package:whatsapp_clone/function/custom_appbar.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';

class AtmPinChecker extends StatefulWidget {
  const AtmPinChecker({super.key});

  @override
  State<AtmPinChecker> createState() => _AtmPinCheckerState();
}

class _AtmPinCheckerState extends State<AtmPinChecker> {
  final pinController = TextEditingController();

  String empty = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: const Text("Check Your Pin")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Pin is : 2202",
              style: TextStyle(fontSize: 20),
            ),
            AppServices.addHeight(40),
            TextFormField(
              controller: pinController,
              onChanged: (v) {
                if (pinController.text.length == 4) {
                  AppServices.keyboardUnfocus(context);
                }
              },
              decoration: const InputDecoration(hintText: "Enter Your Pin"),
            ),
            AppServices.addHeight(50),
            ElevatedButton(
                onPressed: () {
                  if (pinController.text == "2202") {
                    setState(() {
                      empty = "Congratulation! Your Pin Is Match";
                    });
                  } else {
                    setState(() {
                      empty = "You are Type Wrong Pin";
                    });
                  }
                },
                child: const Text("Check")),
            AppServices.addHeight(20),
          ],
        ),
      )),
    );
  }
}
