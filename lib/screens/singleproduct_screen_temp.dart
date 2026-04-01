import 'package:flutter/material.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/core/storage/token_storage.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class SingleproductScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const SingleproductScreen({super.key, required this.item});

  @override
  State<SingleproductScreen> createState() => _SingleproductScreenState();
}

class _SingleproductScreenState extends State<SingleproductScreen> {
  bool isInteracting = false;
  bool isZoomedState = false;
  int _pointerCount = 0;

  final TransformationController _transformationController =
      TransformationController();
  bool isAddingToCart = false;
  bool isAddingToWishlist = false;
  bool isUserLoggedIn() {
    return tokenStorage.getToken() != null && tokenStorage.isTokenValid();
  }

  final TokenStorage tokenStorage = TokenStorage();
  late PageController _pageController;
  int currentIndex = 0;

  List<String> _getImages(dynamic images) {
    if (images == null) return [];

    if (images is List) {
      return images.map((e) => e.toString()).toList();
    }

    return [images.toString()];
  }

  int quantity = 1;

  String? _asString(dynamic value) => value == null ? null : value.toString();

  String _nonNull(dynamic value, [String fallback = "N/A"]) =>
      _asString(value) ?? fallback;

  String _getImageUrl(String? imageName) {
    const String baseUrl = "https://www.dizaartdemo.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (imageName == null || imageName.trim().isEmpty) return defaultImage;

    final imageFile = imageName.split('/').last;
    if (imageFile.isEmpty) return defaultImage;

    return "${baseUrl}demo/shopnest/assets/images/products/$imageFile";
  }

  Future<void> addTowishlist() async {
    if (isAddingToWishlist) return; // 🚫 prevent spam

    if (!isUserLoggedIn()) {
      CustomSnackbar.showError("Please login to continue");
      Navigator.pushNamed(context, "/login");
      return;
    }

    final productId = _nonNull(widget.item["id"], "");
    if (productId.isEmpty) {
      CustomSnackbar.showError("Product ID missing");
      return;
    }

    setState(() => isAddingToWishlist = true);

    try {
      final response = await AuthRepository().addwishlistfun(id: productId);

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Added to wishlist");
        await Future.delayed(const Duration(seconds: 3));
      } else {
        CustomSnackbar.showError(response["message"] ?? "Failed");
      }
    } catch (e) {
      CustomSnackbar.showError("Error: $e");
    } finally {
      setState(() => isAddingToWishlist = false);
    }
  }

  Future<void> addToCart(int quantityToAdd) async {
    if (isAddingToCart) return; // 🚫 prevent spam click

    if (!isUserLoggedIn()) {
      CustomSnackbar.showError("Please login to continue");
      Navigator.pushNamed(context, "/login");
      return;
    }

    final productId = _nonNull(widget.item["id"], "");
    if (productId.isEmpty) {
      CustomSnackbar.showError("Product ID missing");
      return;
    }

    setState(() => isAddingToCart = true);

    try {
      final response = await AuthRepository().addcartfun(
        id: productId,
        quantity: quantityToAdd.toString(),
      );

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Added to cart");
        await Future.delayed(const Duration(seconds: 3));
      } else {
        CustomSnackbar.showError(response["message"] ?? "Failed");
        await Future.delayed(const Duration(seconds: 3));
      }
    } catch (e) {
      CustomSnackbar.showError("Error: $e");
    } finally {
      setState(() => isAddingToCart = false);
    }
  }

  @override
  void initState() {
    super.initState();

    // Start from a large number to allow both side scrolling
    _pageController = PageController(initialPage: 1000);
    currentIndex = 1000;
    _transformationController.addListener(() {
      final currentZoom =
          _transformationController.value.getMaxScaleOnAxis() > 1.01;
      if (currentZoom != isZoomedState) {
        setState(() {
          isZoomedState = currentZoom;
        });
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _openFullScreenGallery(BuildContext context, List<String> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenGallery(
          images: images,
          initialIndex: initialIndex,
          getImageUrl: _getImageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final imageUrl = _getImageUrl(_asString(item["images"] ?? item["image"]));
    final images = _getImages(item["images"] ?? item["image"]);
    print(item["images"]);
    final name = _nonNull(item["name"] ?? item["title"], "Unknown product");
    final size = _nonNull(item["size"]);
    final color = _nonNull(item["color"]);
    final rentalPrice = _nonNull(
      item["rental_price"] ?? item["rent"] ?? item["price"],
      "0",
    );
    final securityDeposit = _nonNull(item["security_deposit"] ?? "0", "0");
    final discount = _nonNull(
      item["discount_percent"] ?? item["discount"] ?? "0",
      "0",
    );
    final effectivePrice = _nonNull(
      item["effective_price"] ?? item["finalPrice"] ?? item["price"],
      "0",
    );
    final originalPrice = _nonNull(
      item["original_price"] ?? item["price"],
      "0",
    );
    final categoryName = _nonNull(
      item["category_name"] ?? item["category"],
      "Unknown category",
    );
    final stock = _nonNull(item["stock"] ?? "0", "0");

    return MainLayout(
      child: SingleChildScrollView(
        physics: (isZoomedState || isInteracting)
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PRODUCT IMAGE
            AspectRatio(
              aspectRatio: 1, // 🔥 makes it perfect square
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  children: [
                    /// 🔥 SLIDER
                    PageView.builder(
                      physics: (isZoomedState || isInteracting || _pointerCount >= 2)
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => currentIndex = index);
                        _transformationController.value = Matrix4.identity();
                      },
                      itemBuilder: (context, index) {
                        final realIndex = index % images.length;
                        final imageUrl = _getImageUrl(images[realIndex]);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.grey.shade100, // 👈 background
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    color: Colors.grey.shade100,
                                    child: GestureDetector(
                                      onDoubleTap: () {
                                        if (isZoomedState) {
                                          _transformationController.value =
                                              Matrix4.identity();
                                        } else {
                                          _transformationController.value =
                                              Matrix4.identity()..scale(2.0);
                                        }
                                      },
                                      onTap: () {
                                        if (isZoomedState) {
                                          _transformationController.value =
                                              Matrix4.identity();
                                        } else {
                                          _openFullScreenGallery(context, images, realIndex);
                                        }
                                      },
                                      child: Listener(
                                        onPointerDown: (_) {
                                          if (++_pointerCount == 2) setState(() {});
                                        },
                                        onPointerUp: (_) {
                                          if (--_pointerCount == 1) setState(() {});
                                        },
                                        onPointerCancel: (_) {
                                          if (--_pointerCount == 1) setState(() {});
                                        },
                                        child: InteractiveViewer(
                                          transformationController:
                                              _transformationController,
                                        onInteractionStart: (_) {
                                          setState(() {
                                            isInteracting = true;
                                          });
                                        },
                                        onInteractionEnd: (_) {
                                          setState(() {
                                            isInteracting = false;
                                          });
                                        },
                                        panEnabled: isZoomedState,
                                        scaleEnabled: true,
                                        minScale: 1,
                                        maxScale: 4,
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    /// ⬅️ LEFT ARROW
                    Positioned(
                      left: 5,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          color: Colors.black,
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),

                    /// ➡️ RIGHT ARROW
                    Positioned(
                      right: 5,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 20),
                          color: Colors.black,
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),

                    /// 🔵 DOT INDICATOR (FIXED)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          final realIndex =
                              currentIndex % images.length; // ✅ fix
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: realIndex == index ? 10 : 6,
                            height: realIndex == index ? 10 : 6,
                            decoration: BoxDecoration(
                              color: realIndex == index
                                  ? Colors.orange
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// PRODUCT DETAILS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// SIZE
                  Row(
                    children: [
                      const Icon(Icons.straighten, size: 18),
                      const SizedBox(width: 6),
                      Text("Size: $size"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// COLOR
                  Row(
                    children: [
                      const Icon(Icons.palette, size: 18),
                      const SizedBox(width: 6),
                      Text("Color: $color"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// RENTAL PRICE
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        const TextSpan(
                          text: "Rental: ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "₹$rentalPrice/day"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// SECURITY
                  Text(
                    "Security: ₹$securityDeposit",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// DISCOUNT
                  Text(
                    "Discount: $discount%",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// FINAL PRICE
                  Text(
                    "₹$effectivePrice/day",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Beautiful traditional red silk saree with zari work",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            "Available for Rent",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Only 2 left in stock"),
                  const SizedBox(height: 20),

                  /// QUANTITY SELECTOR
                  Row(
                    children: [
                      const Text("Quantity:", style: TextStyle(fontSize: 16)),

                      const SizedBox(width: 10),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),

                            Text(
                              quantity.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// ADD TO CART BUTTON
                  Row(
                    children: [
                      /// ADD TO CART
                      ElevatedButton.icon(
                        onPressed: isAddingToCart
                            ? null
                            : () => addToCart(quantity),

                        icon: const Icon(Icons.shopping_cart),

                        label: isAddingToCart
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Add to Cart"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      /// ADD TO WISHLIST
                      OutlinedButton.icon(
                        onPressed: isAddingToWishlist ? null : addTowishlist,

                        icon: const Icon(Icons.favorite, color: Colors.red),

                        label: isAddingToWishlist
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Add to Wishlist",
                                style: TextStyle(color: Colors.red),
                              ),

                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// DESCRIPTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title Row
                        Row(
                          children: const [
                            Icon(Icons.info_outline, size: 22),
                            SizedBox(width: 8),
                            Text(
                              "Rental Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// Bullet Points
                        buildBullet("Free delivery & pickup included"),
                        buildBullet(
                          "Professional dry cleaning after every use",
                        ),
                        buildBullet("Flexible rental periods (3–14 days)"),
                        buildBullet("Quality check & ironing before delivery"),
                        buildBullet("Easy cancellation policy"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const Text(
                  "Product Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                /// CARD 1
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      detailsRow("Category", categoryName),
                      const SizedBox(height: 12),

                      detailsRow("Size", size),
                      const SizedBox(height: 12),

                      detailsRow("Color", color),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// CARD 2
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      detailsRow("Product Price", "₹$originalPrice"),

                      const SizedBox(height: 12),

                      detailsRow("Rental Price", "₹$rentalPrice per day"),

                      const SizedBox(height: 12),

                      detailsRow(
                        "Security Deposit",
                        "₹$securityDeposit",
                        valueColor: Colors.red,
                      ),

                      const SizedBox(height: 12),

                      detailsRow(
                        "Availability",
                        stock,
                        valueColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ShopFooter(),
          ],
        ),
      ),
    );
  }
}

Widget detailsRow(String title, String value, {Color? valueColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),

      Text(
        value,
        style: TextStyle(fontSize: 16, color: valueColor ?? Colors.black87),
      ),
    ],
  );
}

Widget buildBullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("•", style: TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}

class FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String Function(String?) getImageUrl;

  const FullScreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.getImageUrl,
  });

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int currentIndex;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "${currentIndex + 1} / ${widget.images.length}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        physics: _isZoomed
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
            _isZoomed = false;
          });
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final imageUrl = widget.getImageUrl(widget.images[index]);
          return ZoomableImage(
            imageUrl: imageUrl,
            onZoomChanged: (isZoomed) {
              if (_isZoomed != isZoomed) {
                setState(() {
                  _isZoomed = isZoomed;
                });
              }
            },
          );
        },
      ),
    );
  }
}

class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final Function(bool isZoomed) onZoomChanged;

  const ZoomableImage({
    super.key,
    required this.imageUrl,
    required this.onZoomChanged,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;
  bool _isInteracting = false;
  int _pointerCount = 0;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onZoomChanged);
  }

  void _updateParentZoom() {
    widget.onZoomChanged(_isZoomed || _isInteracting || _pointerCount >= 2);
  }

  void _onZoomChanged() {
    final isCurrentlyZoomed =
        _transformationController.value.getMaxScaleOnAxis() > 1.05;
    if (isCurrentlyZoomed != _isZoomed) {
      _isZoomed = isCurrentlyZoomed;
      _updateParentZoom();
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        if (++_pointerCount == 2) _updateParentZoom();
      },
      onPointerUp: (_) {
        if (--_pointerCount == 1) _updateParentZoom();
      },
      onPointerCancel: (_) {
        if (--_pointerCount == 1) _updateParentZoom();
      },
      child: GestureDetector(
        onDoubleTap: () {
          if (_isZoomed) {
            _transformationController.value = Matrix4.identity();
          } else {
            _transformationController.value = Matrix4.identity()..scale(2.0);
          }
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          onInteractionStart: (_) {
            _isInteracting = true;
            _updateParentZoom();
          },
          onInteractionEnd: (_) {
            _isInteracting = false;
            _updateParentZoom();
          },
          minScale: 1,
          maxScale: 5,
          panEnabled: _isZoomed,
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
