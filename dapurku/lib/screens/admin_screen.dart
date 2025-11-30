import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'admin_recipe_list_screen.dart';
import 'admin_user_list_screen.dart';
import 'login_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Stream<int> recipeCount() {
    return FirebaseFirestore.instance
        .collection("recipes")
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Stream<int> userCount() {
    return FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
      ),

      drawer: _buildDrawer(context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Statistics",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 15),

            // ======== STAT CARDS ========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _statCard("Recipes", recipeCount(), Icons.fastfood)),
                const SizedBox(width: 12),
                Expanded(child: _statCard("Users", userCount(), Icons.people)),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Overview Graph",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // ======== GRAPH ========
            StreamBuilder<int>(
              stream: recipeCount(),
              builder: (_, recipeSnap) {
                return StreamBuilder<int>(
                  stream: userCount(),
                  builder: (_, userSnap) {
                    final recipes = recipeSnap.data ?? 0;
                    final users = userSnap.data ?? 0;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: BarChart(
                        BarChartData(
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                    toY: recipes.toDouble(),
                                    width: 22,
                                    color: Colors.orange)
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                    toY: users.toDouble(),
                                    width: 22,
                                    color: Colors.blue)
                              ],
                            ),
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: true)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text("Recipes");
                                    case 1:
                                      return const Text("Users");
                                    default:
                                      return const Text("");
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===================== DRAWER =====================
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.orange),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.admin_panel_settings,
                    color: Colors.white, size: 60),
                SizedBox(height: 10),
                Text("Admin Panel",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text("Manage Recipes"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AdminRecipeListScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Manage Users"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminUserListScreen()));
            },
          ),
          const Divider(),

          // ================= LOGOUT FIXED =================
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ===================== STAT CARD =====================
  Widget _statCard(String title, Stream<int> stream, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 4),
            color: Colors.black12,
          ),
        ],
      ),
      child: StreamBuilder<int>(
        stream: stream,
        builder: (_, snap) {
          final value = snap.data ?? 0;

          return Row(
            children: [
              Icon(icon, size: 45, color: Colors.orange),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("$value",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
