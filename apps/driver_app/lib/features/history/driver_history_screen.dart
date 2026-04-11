import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DriverHistoryScreen extends StatelessWidget {
  const DriverHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Completed Rides'),
      ),
      body: FutureBuilder<List<RideModel>>(
        future: BookingApiService().getRides(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: LoadingShimmer(count: 4, height: 120));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) => RideCard(ride: snapshot.data![i], onTap: () {}),
          );
        },
      ),
    );
  }
}
