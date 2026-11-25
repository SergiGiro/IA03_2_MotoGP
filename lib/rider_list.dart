import 'package:flutter/material.dart';
import 'rider_card.dart';
import 'rider_model.dart';

class RiderList extends StatelessWidget {
  final List<Rider> riders;
  const RiderList(this.riders, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: riders.length,
      itemBuilder: (context, index) {
        return RiderCard(riders[index]);
      },
    );
  }
}
