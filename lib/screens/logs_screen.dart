import 'package:appiva/models/log_model.dart';
import 'package:appiva/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/logs_provider.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  static String route_name = 'LogsScreenRoute';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log History"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.read<AuthProvider>().performLogout();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => LogsProvider()..init(),
        child: Consumer<LogsProvider>(
          builder: (context, provider, child) {
            return Center(
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.logs!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) =>
                          _LogListCard(log: provider.logs![i])),
            );
          },
        ),
      ),
    );
  }
}

class _LogListCard extends StatelessWidget {
  final LogModel log;
  const _LogListCard({required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Image(
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, imagechunk) => Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              image: NetworkImage(
                log.userImgUrl,
              ),
            ),
            const VerticalDivider(
              color: Colors.black,
              thickness: 0.7,
              width: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Longitude : ${log.geoLocation['longitude']}",
                  ),
                  Text(
                    "Latitude    : ${log.geoLocation['latitude']}",
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Added At"),
                  Text(log.addedAt.toLocal().toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
