import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/cart_card.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';
import 'package:shopnest/screens/addAddress_screen.dart';

//2667.24
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final home = Get.find<AuthRepository>();

  List<Map<String, dynamic>> productlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartAndAddress();
  }

  int delivery = 99;
  String currentAddress = "Loading addresses...";
  bool isLocationLoading = true;

  List<Map<String, dynamic>> userAddresses = [];
  Map<String, dynamic>? selectedAddress;

  static const double warehouseLat = 28.6139;
  static const double warehouseLng = 77.3910;
  static const String googleMapsApiKey =
      "AIzaSyA6QGBhKVtToksi-gydARasyxhcpJoiKbw";

  double applyGST(double amount) {
    double gst = amount * 0.18;
    return double.parse(gst.toStringAsFixed(2));
  }

  double finalprice = 0;
  double totalamt = 0;
  double gst = 0;

  void _calculateTotals() {
    gst = applyGST(totalamt);
    finalprice = double.parse((totalamt + gst + delivery).toStringAsFixed(2));
  }

  Future<void> fetchCartAndAddress() async {
    await fetchCart();
    await _getUserAddresses();
  }

  Future<void> _getUserAddresses() async {
    try {
      final res = await home.getaddressfun();
      final List data = res["data"] ?? [];

      if (data.isNotEmpty) {
        setState(() {
          userAddresses = List<Map<String, dynamic>>.from(data);
          selectedAddress = userAddresses.firstWhere(
            (addr) => addr['is_default'] == true || addr['is_default'] == 1,
            orElse: () => userAddresses.first,
          );
        });

        await _calculateDeliveryForSelectedAddress();
      } else {
        setState(() {
          userAddresses = [];
          selectedAddress = null;
          isLocationLoading = false;
        });
      }
    } catch (e) {
      print("Address error: $e");
      setState(() {
        isLocationLoading = false;
      });
    }
  }

  Future<List<double>?> _getLatLngFromAddress(String addressText) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(addressText)}&key=$googleMapsApiKey";
      final response = await Dio().get(url);
      final data = response.data;
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return [location['lat'], location['lng']];
      }
    } catch (e) {
      print("Geocoding API error: $e");
    }
    return null;
  }

  Future<void> _calculateDeliveryForSelectedAddress() async {
    if (selectedAddress == null) return;

    setState(() {
      isLocationLoading = true;
    });

    try {
      final String fullAddress =
          "${selectedAddress!['address']}, ${selectedAddress!['city']}, ${selectedAddress!['state']} ${selectedAddress!['pincode']}";

      final latLng = await _getLatLngFromAddress(fullAddress);

      if (latLng != null) {
        double distanceKm = await _getDistanceKm(
          warehouseLat,
          warehouseLng,
          latLng[0],
          latLng[1],
        );
        print(distanceKm);
        setState(() {
          currentAddress = fullAddress;
          delivery = _calculateDeliveryCharge(distanceKm);
          _calculateTotals();
          isLocationLoading = false;
        });
      } else {
        setState(() {
          currentAddress = "Failed to locate map address";
          isLocationLoading = false;
        });
      }
    } catch (e) {
      print("Map Geocoding error: $e");
      setState(() {
        currentAddress = "Map Geocoding failed";
        isLocationLoading = false;
      });
    }
  }

  Future<void> fetchCart() async {
    try {
      final user = home.storage.getUser();
      final id = user?["id"].toString();

      final response = await home.getusercarts(id: id ?? "");
      print(response);
      if (response["success"] == true) {
        setState(() {
          productlist = List<Map<String, dynamic>>.from(
            response["data"]["items"],
          );
          totalamt = (response["data"]["subtotal"] as num).toDouble();
          print(totalamt);

          _calculateTotals();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Cart error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddressSelectionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Delivery Address",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: userAddresses.length,
                  itemBuilder: (context, index) {
                    final addr = userAddresses[index];
                    final full =
                        "${addr['address']}, ${addr['city']}, ${addr['state']} ${addr['pincode']}";
                    final isSelected =
                        selectedAddress != null &&
                        selectedAddress!['id'] == addr['id'];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? const Color(0xff6a7bd1)
                            : Colors.grey,
                      ),
                      title: Text(
                        addr['full_name'] ?? 'Address',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(full),
                      onTap: () {
                        setState(() {
                          selectedAddress = addr;
                        });
                        Get.back();
                        _calculateDeliveryForSelectedAddress();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Get.back();
                    final res = await Get.to(() => const AddAddressScreen());
                    if (res == true) {
                      _getUserAddresses();
                    }
                  },
                  icon: const Icon(Icons.add, color: Color(0xff6a7bd1)),
                  label: const Text(
                    "Add New Address",
                    style: TextStyle(color: Color(0xff6a7bd1)),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xff6a7bd1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<double> _getDistanceKm(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
  ) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$originLat,$originLng&destinations=$destLat,$destLng&key=$googleMapsApiKey";
      final response = await Dio().get(url);
      final data = response.data;

      if (data['status'] == 'OK' &&
          data['rows'][0]['elements'][0]['status'] == 'OK') {
        final distanceMeters =
            data['rows'][0]['elements'][0]['distance']['value'];
        return distanceMeters / 1000.0;
      }
    } catch (e) {
      print("Distance Matrix Error: $e");
    }
    return 0.0;
  }

  int _calculateDeliveryCharge(double distanceKm) {
    if (distanceKm <= 5)
      return 29;
    else if (distanceKm <= 10)
      return 49;
    else if (distanceKm <= 20)
      return 69;
    else if (distanceKm <= 30)
      return 89;
    else if (distanceKm <= 50)
      return 109;
    else if (distanceKm <= 75)
      return 139;
    else if (distanceKm <= 100)
      return 169;
    else if (distanceKm <= 150)
      return 209;
    else if (distanceKm <= 200)
      return 249;
    else if (distanceKm <= 300)
      return 349;
    else if (distanceKm <= 500)
      return 499;
    else if (distanceKm <= 800)
      return 699;
    else
      return 999; // ultra long distance
  }

  // final List<Map<String, dynamic>> productlist = [
  //   {
  //     "image": "https://images.unsplash.com/photo-1523381294911-8d3cead13475",
  //     "title": "Casual Hoodie",
  //     "size": "L",
  //     "color": "Green",
  //     "rent": 900,
  //     "discount": 8,
  //     "finalPrice": 828,
  //   },
  //   {
  //     "image": "https://images.unsplash.com/photo-1509631179647-0177331693ae",
  //     "title": "Formal Suit",
  //     "size": "XL",
  //     "color": "Navy Blue",
  //     "rent": 3200,
  //     "discount": 20,
  //     "finalPrice": 2560,
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.shopping_cart,
                        size: 36,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Your Rental Cart",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2c3e50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: productlist.map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CartCard(
                          item: product,
                          onDeleteSuccess: fetchCart,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// CONTINUE SHOPPING BUTTON
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.toNamed("/rentclothes");
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                        label: const Text(
                          "Continue Shopping",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      /// RENTAL SUMMARY CARD
                      ///
                      if (productlist.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: const LinearGradient(
                              colors: [Color(0xff6a7bd1), Color(0xff7a4fa3)],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TITLE
                              const Row(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Rental Summary",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (userAddresses.isEmpty &&
                                            !isLocationLoading)
                                          ElevatedButton(
                                            onPressed: () async {
                                              final res = await Get.to(
                                                () => const AddAddressScreen(),
                                              );
                                              if (res == true) {
                                                _getUserAddresses();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                            ),
                                            child: const Text(
                                              "Add Delivery Address",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        else
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isLocationLoading
                                                    ? "Calculating delivery route..."
                                                    : currentAddress,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap:
                                                    _showAddressSelectionModal,
                                                child: Text(
                                                  "Change Address",
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              /// PRICE ROWS
                              _priceRow("All Product Price :", "₹${totalamt}"),
                              const SizedBox(height: 12),
                              _priceRow("Tax (18% GST) :", "₹${gst}"),
                              const SizedBox(height: 5),
                              const Divider(color: Colors.white54),
                              const SizedBox(height: 5),
                              _priceRow(
                                "After add the gst :",
                                "₹${totalamt + gst}",
                              ),
                              const SizedBox(height: 5),
                              const Divider(color: Colors.white54),
                              const SizedBox(height: 5),

                              _priceRow(
                                "Delivery Charge no GST apply:",
                                "+ ₹$delivery",
                              ),
                              const SizedBox(height: 12),

                              const SizedBox(height: 20),

                              const Divider(color: Colors.white54),

                              const SizedBox(height: 15),

                              /// TOTAL
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Payable For 1 day :",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "₹$finalprice",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              /// CHECKOUT BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Get.toNamed(
                                      "/checkout",
                                      arguments: {
                                        "address": currentAddress,
                                        "subtotalWithGst": totalamt + gst,
                                        "delivery": delivery,
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.credit_card),
                                  label: const Text(
                                    "Proceed to Checkout",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 25),

                      /// RENTAL POLICIES CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.shield_outlined),
                                SizedBox(width: 10),
                                Text(
                                  "Rental Policies",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Free pickup after rental"),
                              ],
                            ),

                            SizedBox(height: 10),

                            Row(
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Professional cleaning included"),
                              ],
                            ),

                            SizedBox(height: 10),

                            Row(
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Easy cancellation"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ShopFooter(),
          ],
        ),
      ),
    );
  }
}

Widget _priceRow(String title, String price) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      Text(price, style: const TextStyle(color: Colors.white, fontSize: 18)),
    ],
  );
}
