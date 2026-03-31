import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../cubits/auth/cart_cubit.dart';
import '../cubits/auth/product_cubit.dart';
import 'login.dart';
import 'product_details.dart';
import 'profile.dart';
import 'wishlist.dart';
import 'cart_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  String selectedBrand = "All";
  bool isDarkMode = false;

  final productService = ProductService();
  final List<String> brands = ["All", "Nike", "Adidas", "zara", "breshka", "cizaro"];

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const CartScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF9775FA),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String searchQuery = "";
  String selectedBrand = "All";
  bool isDarkMode = false;

  final productService = ProductService();
  final List<String> brands = ["All", "Nike", "Adidas", "zara", "breshka", "cizaro"];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    String getUserInitial() {
      if (user?.displayName != null && user!.displayName!.isNotEmpty) {
        return user.displayName!.substring(0, 1);
      } else if (user?.email != null && user!.email!.isNotEmpty) {
        return user.email!.substring(0, 1);
      } else {
        return 'G';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello in Laza " , style: TextStyle(fontStyle: FontStyle.italic),),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: user?.photoURL != null
                    ? ClipOval(
                  child: Image.network(
                    user!.photoURL!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
                    : Text(getUserInitial(), style: const TextStyle(fontSize: 20)),
              ),
              accountName: Text(user?.displayName ?? ""),
              accountEmail: Text(user?.email ?? "guest@gmail.com"),
              decoration: const BoxDecoration(color: Color(0xFF9775FA)),
            ),


            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (val) {
                setState(() => isDarkMode = val);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Account Information"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),


            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Password"),
              onTap: () {
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Orders"),
              onTap: () {
              },
            ),

            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("My Cards"),
              onTap: () {
              },
            ),

            // 5- Wishlist
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text("Wishlist"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                );
              },
            ),


            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
              },
            ),

            const Divider(),


            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9775FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(icon: const Icon(Icons.mic, color: Colors.white), onPressed: () {}),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                final isSelected = brand == selectedBrand;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(brand),
                    selected: isSelected,
                    selectedColor: const Color(0xFF9775FA),
                    onSelected: (_) => setState(() => selectedBrand = brand),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: productService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products found", style: TextStyle(fontSize: 16)));
                }

                final products = snapshot.data!.where((product) {
                  final matchesSearch = searchQuery.isEmpty || product.title.toLowerCase().contains(searchQuery.toLowerCase());
                  final matchesBrand = selectedBrand == "All" || product.category == selectedBrand;
                  return matchesSearch && matchesBrand;
                }).toList();

                if (products.isEmpty) return const Center(child: Text("No products found"));

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider<ProductDetailsCubit>(
                                  create: (_) => ProductDetailsCubit(product),
                                ),
                                BlocProvider.value(
                                  value: context.read<CartCubit>(),
                                ),
                              ],
                              child: const ProductDetailsScreen(),
                            ),
                          ),
                        );
                      },
                      child: ProductCard(product: product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 40)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Rate : ${product.rate}",
                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
