class ApiConstants {
  static const baseUrl =
      "https://www.dizaartdemo.com/demo/shopnest/php-api-server/api";

  static const login = "/auth/login";
  static const register = "/auth/register";

  // public api
  static const products = "/products";
  static const categories = "/categories";

  static const cart = "/cart";
  static const addcart = "/cart/add";

  static const deletecart = "/cart/remove";

  static const trending = "/products/trending";

  static const getprofile = "/user/profile";
  static const updatePassowrd = "/user/change-password";

  static const chekout = "/orders/checkout";
  static const verify = "/orders/verify-payment";

  static const useridverfiy = "/user/verify-id";

  static const getaddress = "/user/addresses";
  static const setdefaultaddress = "/user/addresses/set-default";
  static const deleteaddress = "/user/addresses/delete";
  static const addaddress = "/user/addresses/add";
  static const updateaddress = "/user/addresses/update/";

  static const addwishlist = "/wishlist/add";
  static const getwishlist = "/wishlist";
  static const deltewishlist = "/wishlist/remove";

  static const rentalstatus = "/rentals/my";
}
