import 'package:flutter/material.dart';
import 'package:provider_app/screens/active_order_tab.dart';
import 'package:provider_app/screens/history_order_tab.dart';
import 'package:provider_app/widgets/order_card_widget.dart';

class BookingFragment extends StatefulWidget {
  const BookingFragment({Key? key}) : super(key: key);

  @override
  State<BookingFragment> createState() => _BookingFragmentState();
}

class _BookingFragmentState extends State<BookingFragment> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Booking', style: TextStyle(color: Colors.white),),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(size: 30),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Active',),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ActiveOrderTab(),
          HistoryOrderTab(),
        ],
      ),
    );
  }
}