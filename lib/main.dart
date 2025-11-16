import 'package:flutter/material.dart';
import 'dart:math';

// ------------------------------------
// 1. Data Model
// ------------------------------------

/// Represents a single food item on the menu.
class MenuItem {
  final String name;
  final double price;
  final String imageUrl; // This holds the local asset path

  MenuItem(this.name, this.price, this.imageUrl);
}

// ------------------------------------
// 2. Main Application Setup
// ------------------------------------

void main() {
  runApp(const CanteenOrderingApp());
}

class CanteenOrderingApp extends StatelessWidget {
  const CanteenOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LBRCE Canteen Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Dark Theme: Deep Red (primary) and Black (background)
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red.shade700, // Deep Red primary color
          secondary: Colors.yellow.shade700, // Bright Yellow secondary/accent color
          background: Colors.black, // Global dark background
          brightness: Brightness.dark, // Use dark brightness scheme
        ),
        scaffoldBackgroundColor: Colors.black, // Explicitly set scaffold background
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Start with the SplashScreen
    );
  }
}

// ------------------------------------
// 3. SplashScreen Widget
// ------------------------------------

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade900, // Darker Red
              Colors.black, // Black bottom
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Prominent icon
              Icon(
                Icons.fastfood_rounded,
                size: 120,
                color: Theme.of(context).colorScheme.secondary, // Bright icon color (Yellow)
              ),
              const SizedBox(height: 30),
              Text(
                'LBRCE CANTEEN',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.8),
                      offset: const Offset(4.0, 4.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Fresh food, quick service!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 80),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CanteenOrderingScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                label: const Text(
                  'Start Ordering',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondary, // Bright accent (Yellow)
                  foregroundColor: Colors.black, // Dark text on bright button
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------
// 4. Main Ordering Screen
// ------------------------------------

class CanteenOrderingScreen extends StatefulWidget {
  const CanteenOrderingScreen({super.key});

  @override
  State<CanteenOrderingScreen> createState() => _CanteenOrderingScreenState();
}

class _CanteenOrderingScreenState extends State<CanteenOrderingScreen> {
  // 💥 UPDATED list of available menu items with UNIQUE Asset Paths 💥
  final List<MenuItem> _menuItems = [
    MenuItem('Spicy Chicken Biryani', 135.00, 'assets/images/biryani.png'),
    MenuItem('Schezwan Veg Noodles', 90.00, 'assets/images/noodles.png'),
    MenuItem('Crispy Samosa (4 pcs)', 35.00, 'assets/images/samosa.png'),
    MenuItem('Coffee', 60.00, 'assets/images/coffee.png'),
    MenuItem('Seasonal Fresh Juice', 50.00, 'assets/images/juice.png'),
    MenuItem('Tangy Pani Puri (7 pcs)', 70.00, 'assets/images/panipuri.png'),
    MenuItem('Decadent Chocolate Cake', 160.00, 'assets/images/cake.png'),
    MenuItem('Grilled Cheese Sandwich', 55.00, 'assets/images/sandwich.png'),
    MenuItem('Masala Dosa', 45.00, 'assets/images/dosa.png'),
    MenuItem('Idli Sambar', 40.00, 'assets/images/idli.png'),
    MenuItem('Ice Cream Sundae', 110.00, 'assets/images/icecream.png'),
    MenuItem('Veg Burger', 80.00, 'assets/images/burger.png'),
    MenuItem('Hot Tea', 20.00, 'assets/images/tea.png'),
    MenuItem('Mineral Water', 25.00, 'assets/images/water.png'),
    MenuItem('French Fries', 75.00, 'assets/images/fries.png'),
  ];

  // Map to store quantities (Item Name -> Quantity)
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    // Initialize all quantities to zero
    for (var item in _menuItems) {
      _quantities[item.name] = 0;
    }
  }

  // Calculate total dynamically
  double _calculateTotal() {
    double total = 0.0;
    for (var item in _menuItems) {
      final quantity = _quantities[item.name] ?? 0;
      total += item.price * quantity;
    }
    return total;
  }

  // Place Order (Now navigates to summary screen)
  void _placeOrder() {
    final total = _calculateTotal();
    final selectedItemsCount =
        _quantities.entries.where((entry) => entry.value > 0).length;

    if (selectedItemsCount == 0) {
      _showInfoDialog(
        title: 'Order Empty!',
        content: 'Please select some food items before placing an order.',
        icon: Icons.error_outline,
      );
      return;
    }

    // 1. Navigate to OrderSummaryScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryScreen(
          // Pass the current state data to the summary screen
          quantities: Map.from(_quantities), // Pass a copy of the map
          menuItems: _menuItems,
          totalAmount: total,
        ),
      ),
    ).then((_) {
      // 2. Reset cart when returning from OrderSummaryScreen
      setState(() {
        for (var key in _quantities.keys) {
          _quantities[key] = 0;
        }
      });
    });
  }

  // Custom Dialog to replace alert()
  void _showInfoDialog(
      {required String title,
      required String content,
      required IconData icon}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final primaryColor = Theme.of(context).colorScheme.primary;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.grey.shade900, // Dark dialog background
          title: Row(
            children: [
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColor),
              )),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(content, style: const TextStyle(color: Colors.white70)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('GOT IT', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Quantity Stepper logic
  void _updateQuantity(String itemName, int newQuantity) {
    setState(() {
      _quantities[itemName] = newQuantity.clamp(0, 99);
    });
  }

  // ------------------------------------
  // 5. Build Method (UI Layout for CanteenOrderingScreen)
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();
    final primaryColor = Theme.of(context).colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive crossAxisCount logic for smaller cards on desktop
    int crossAxisCount;
    if (screenWidth > 1200) {
      crossAxisCount = 5; // Large desktop
    } else if (screenWidth > 800) {
      crossAxisCount = 4; // Medium desktop/large tablet
    } else if (screenWidth > 600) {
      crossAxisCount = 3; // Tablet
    } else {
      crossAxisCount = 2; // Mobile
    }

    return Scaffold(
      backgroundColor: Colors.black, // Black background for the main screen
      appBar: AppBar(
        title: const Text('LBRCE Canteen Menu'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 8,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: GridView.builder(
  padding: const EdgeInsets.fromLTRB(12, 12, 12, 120), // Add extra bottom padding
  itemCount: _menuItems.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.85,
  ),
  itemBuilder: (context, index) {
    final item = _menuItems[index];
    final quantity = _quantities[item.name]!;

    return _MenuItemCard(
      item: item,
      quantity: quantity,
      onQuantityChanged: (newQuantity) {
        _updateQuantity(item.name, newQuantity);
      },
    );
  },
),

      bottomSheet: Container(
        padding: const EdgeInsets.all(19.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade900, // Dark bottom sheet
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YOUR TOTAL:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54)),
                  Text(
                    '₹${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: total > 0 ? _placeOrder : null,
                icon: const Icon(Icons.send_rounded, size: 28),
                label: Text(total > 0 ? 'Proceed to Pay' : 'Select Items',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      total > 0 ? primaryColor : Colors.grey.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------
// 6. Menu Item Card Widget (Handles Hover and Image Display)
// ------------------------------------

class _MenuItemCard extends StatefulWidget {
  final MenuItem item;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const _MenuItemCard({
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  State<_MenuItemCard> createState() => __MenuItemCardState();
}

class __MenuItemCardState extends State<_MenuItemCard> {
  bool _isHovering = false;

  void updateQuantity(int change) {
    final newQuantity = widget.quantity + change;
    if (newQuantity >= 0) {
      widget.onQuantityChanged(newQuantity.clamp(0, 99));
    }
  }

  // Quantity Stepper widget to manage item count
  Widget _buildQuantityStepper(
      Color primaryColor, Color secondaryColor, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withOpacity(0.3)
            : Colors.grey.shade900, // Dark stepper bg
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade700, width: 1.5),
        boxShadow: isSelected
            ? [
                BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            color: widget.quantity > 0 ? secondaryColor : Colors.grey.shade700,
            onPressed:
                widget.quantity > 0 ? () => updateQuantity(-1) : null,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 25,
            child: Text(
              widget.quantity.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : Colors.grey.shade500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            color: secondaryColor,
            onPressed: () => updateQuantity(1),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  // Widget to display the LOCAL asset image (uses Image.asset)
  Widget _buildFoodImage(BuildContext context, String assetPath, Color primaryColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25, // Dynamic height for image area
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
        ),
        child: Image.asset( // Image.asset is used here
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback content in case image fails to load (e.g., asset not found)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_rounded,
                    size: 40,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 4),
                  const Text('Asset Missing!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.quantity > 0;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // Calculate background color based on hover and selection state
    final Color cardBackgroundColor;
    if (_isHovering) {
      // Implement the 'hover:bg-red' effect using the primary color
      cardBackgroundColor = primaryColor.withOpacity(0.2);
    } else {
      cardBackgroundColor = Colors.grey.shade900;
    }

    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: isSelected ? primaryColor.withOpacity(0.8) : Colors.grey.shade800,
                width: isSelected ? 3 : 1)),
        color: cardBackgroundColor, // Dynamic color based on hover
        child: InkWell( // Use InkWell for better touch/click feedback
          onTap: () => updateQuantity(1), // Tap to add one
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image area - uses Image.asset
                _buildFoodImage(context, widget.item.imageUrl, primaryColor),

                const SizedBox(height: 8),
                // Item Name
                Expanded(
                  child: Text(
                    widget.item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14, // Reduced font size
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Item Price
                Text('₹${widget.item.price.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.w900,
                        color: secondaryColor)), // Yellow
                const SizedBox(height: 8),
                // Quantity Stepper
                Center(
                    child: _buildQuantityStepper(
                        primaryColor, secondaryColor, isSelected)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------
// 7. Order Summary Screen
// ------------------------------------

class OrderSummaryScreen extends StatelessWidget {
  final Map<String, int> quantities;
  final List<MenuItem> menuItems;
  final double totalAmount;

  const OrderSummaryScreen({
    super.key,
    required this.quantities,
    required this.menuItems,
    required this.totalAmount,
  });

  // Helper method to look up a MenuItem by name
  MenuItem _getItemByName(String name) {
    return menuItems.firstWhere((item) => item.name == name);
  }

  // Helper widget to build payment row details
  Widget _buildPaymentRow(BuildContext context, IconData icon, String title,
      String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final orderedItems = quantities.entries
        .where((entry) => entry.value > 0)
        .toList(); // List of entries with quantity > 0

    // Generate a random order ID for realism
    final orderId = 'LBRCE-${Random().nextInt(9999).toString().padLeft(4, '0')}';

    return Scaffold(
      backgroundColor: Colors.black, // Black background for summary
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header and Status
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.only(bottom: 20),
              color: Colors.grey.shade900, // Dark card
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Confirmed!',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text('Order ID: $orderId',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            color: Colors.green.shade500, size: 24),
                        const SizedBox(width: 8),
                        Text('Status: Processing (Ready in 5 mins)',
                            style: TextStyle(
                                fontSize: 16, color: Colors.green.shade500)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Itemized Bill
            const Text('Itemized Bill',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const Divider(height: 20, thickness: 2, color: Colors.grey),
            ...orderedItems.map((entry) {
              final item = _getItemByName(entry.key);
              final quantity = entry.value;
              final itemTotal = item.price * quantity;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Item Name and Quantity
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70)),
                          Text(
                            '${quantity} x ₹${item.price.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    // Item Total
                    Text('₹${itemTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
            const Divider(height: 20, thickness: 2, color: Colors.grey),

            // Total Amount
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL PAYABLE',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.red.shade900),
                  ),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Payment Methods Section ---
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Options Available',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Divider(height: 15, thickness: 1, color: Colors.grey),
                    _buildPaymentRow(context, Icons.payment, 'UPI / Wallet Payments',
                        'Google Pay, Paytm, PhonePe accepted', secondaryColor),
                    _buildPaymentRow(context, Icons.credit_card_rounded,
                        'Debit/Credit Card', 'Visa, Mastercard accepted at the counter',
                        secondaryColor),
                    _buildPaymentRow(context, Icons.money_rounded,
                        'Cash on Collection', 'Pay exact amount upon pickup',
                        secondaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Payment Message (Updated)
            Center(
              child: Text(
                'Payment must be completed at the counter using your preferred method (UPI/Card/Cash). Show Order ID ($orderId) for transaction and collection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary), // Yellow for emphasis
              ),
            ),
            const SizedBox(height: 20),

            // Back to Menu Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Pop back to the main ordering screen
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('Back to Menu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ), // Closing style: ElevatedButton.styleFrom(...)
              ), // Closing child: ElevatedButton.icon(...)
            ), // Closing Center
            const SizedBox(height: 50),
          ], // Closing children: [...]
        ), // Closing child: Column(...)
      ), // Closing body: SingleChildScrollView(...)
    ); // Closing return Scaffold(...)
  } // Closing build method
} // Closing OrderSummaryScreen class