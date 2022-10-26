import 'package:appiva/providers/auth_provider.dart';
import 'package:appiva/screens/logs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, provider, child) {
        return Center(
            child: provider.loadingState
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      provider.image == null
                          ? Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 50,
                              ),
                            )
                          : Image(
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                              image: FileImage(
                                provider.image!,
                              ),
                            ),
                      OutlinedButton(
                        onPressed: () {
                          if (!provider.isLoggingIn) {
                            provider.pickImage();
                          }
                        },
                        child: Text(
                          provider.image == null
                              ? "Select an Image"
                              : "Change Image",
                        ),
                      ),
                      if (provider.allowedGps) ...[
                        Text(
                            "longitude : ${provider.geoPosition?.longitude}\nlatitude : ${provider.geoPosition?.latitude}")
                      ] else ...[
                        OutlinedButton(
                          onPressed: () {
                            provider.getLocationPermission();
                          },
                          child: const Text(
                            "Please grant location Permission",
                          ),
                        )
                      ],
                      const SizedBox(
                        height: 20,
                      ),
                      if (provider.isLoggingIn) ...[
                        const CircularProgressIndicator(),
                        const Text("Please wait we're saving data"),
                      ] else ...[
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            if (provider.checkIfAllFieldsSet()) {
                              final succesfullyStoredData =
                                  await provider.performLogin();
                              // ignore: use_build_context_synchronously
                              if (succesfullyStoredData) {
                                Navigator.of(context).pushNamed(
                                  LogsScreen.route_name,
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Both Image and Location are required"),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          },
                          child: const Text(
                            "Login with google",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ));
      }),
    );
  }
}
