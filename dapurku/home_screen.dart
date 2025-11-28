import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, size: 28, color: Colors.orange),
                  const Text(
                    "DapurKu",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const Icon(Icons.notifications_none,
                      size: 28, color: Colors.orange),
                ],
              ),

              const SizedBox(height: 20),

              // SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search recipes",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // CATEGORY TITLE
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 15),

              // CATEGORY ITEMS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _categoryItem("noodles.png", "Noodles"),
                  _categoryItem("chicken.png", "Chicken"),
                  _categoryItem("vegetarian.png", "Vegetarian"),
                ],
              ),

              const SizedBox(height: 30),

              // POPULAR TITLE
              const Text(
                "Popular Recipes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 15),

              // POPULAR ITEMS GRID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _popularItem("spaghetti.png", "Spaghetti Bolognese", "30 Mins"),
                  _popularItem("grilled_chicken.png", "Grilled Chicken", "45 Mins"),
                ],
              ),
            ],
          ),
        ),
      ),

      // NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  // CATEGORY CARD
  Widget _categoryItem(String img, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffFFE8D0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(
            "assets/images/$img",
            width: 45,
            height: 45,
          ),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }

  // POPULAR RECIPE CARD
  Widget _popularItem(String img, String title, String time) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFFE8D0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.asset("assets/images/$img", height: 80),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.orange),
              const SizedBox(width: 5),
              Text(time, style: const TextStyle(fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}
