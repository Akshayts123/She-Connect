final baseUrl = "https://api.she-connect.in/";
// final baseUrl = "https://api.she-connect.eximuz.com/";
final razorPayKey ="rzp_test_1DP5mmOlF5G5ag";
//-------------------------------------------
final getOTP = "auth/generate-otp";
final verifyOtp = "auth/verify-otp";
final register = "customers/";
final updateUser = "customers/view-customer/";
final FirebaseNotification = "customers/upsert-device";
final categoriesCatalogue = "catalogue/categories?children=true";
final productsCatalogue = "catalogue/products?condition[isActive]=true";
final productDetails = "catalogue/product/";
final addToCart = "order/add-to-cart";
final listCart = "order/carts";
final UpdateCart = "order/cart/";
final deleteCart = "order/cart/remove";
final addAddress = "customers/add-address";
final editAddress = "customers/address/";
final notification = "notification";
final home = "app/home-view?type=";
final listFavourites = "catalogue/favorite?condition[user]=";
final listAddress = "customers/address";
final ordersList = "order/orders?sort=-createdAt";
final cancelOrder = "order/cancel-order";
final addFav = "catalogue/add-favorite";
final deleteAddress = "customers/address";
final placeOrder = "order/create";
final couponList = "coupons/coupons?appUser=";
final orderDetails = "order/orders?condition[user]=";

final addSocialMediaPost = "socialMedia/add-post";
final addSocialMediaComment = "socialMedia/add-comment";
final ViewSingleSocialMediaPostComment =
    "socialMedia/comments?condition[post]=";
final showPosts = "socialMedia/posts?appUser=";

final showBlog = "blog";
final readBlog = "blog/view/";

final catalogue = "catalogue/";

final listVendors = "vendors/vendors";
final singleVendorDetail = "vendors/vendor/";

final viewAllReviews = "catalogue/productReviews?condition[product]=";

final subCatsUnderCategory = "catalogue/category/";
final subCatsToProductsList = "catalogue/products?category=";

final productCategoryImageURL = "https://api.she-connect.in/catalogue/";

final vendorBaseUrl = "http://api.she-connect.in/vendor/";
final singleVendorProductDetails = "catalogue/products?condition[vendor]=";
final singleVendorOffers =
    "coupons/offers?sort=-createdAt&condition[vendorId]=";
final productImage = "http://api.she-connect.in/catalogue/";

final relatedProducts = "catalogue/related-products?product=";

final singleOrderDetail = "order/order/";

final viewAddress = "customers/address?condition[_id]=";

final uploadProfilePic = "customer-media/image/update";

// ----------------------------------

final sortLowToHigh = "catalogue/products?sort=";

final search = "catalogue/search/products?condition[isActive]=true&search=";

final homeBannerTop = "catalogue/promotion/banners?condition[position]=Top";
final homeBannerBottom =
    "catalogue/promotion/banners?condition[position]=Bottom";

final fullProducts = "catalogue/products?category=";
final activeCondition = "&condition[isActive]=true";
final relatedVendors = "vendors/productRelatedVendors?category=";

final addProductReview = "catalogue/add-productReview";

final checkFavUser = "catalogue/favorite?condition[user]=";
final checkFavProduct = "&condition[product]=";
final listCatForFilter = "catalogue/categories?children=true";

// ----------------------------------------------------
final filterPort = "catalogue/products?";
final ratingFilter = "rating=";
final maxAmtFilter = "maximumAmount=";
final minAmtFilter = "minimumAmount=";
final categoryFilter = "category=";

// -----------------------------------------------------

final blogComments = "blog/comments?condition[blog]=";
final blogAddComment = "blog/comment/create";
final followVendor = "vendors/follow";

final addVendorReview = "vendors/review/add";
final viewVendorReviews = "vendors/review/find-all?condition[vendor]=";

final topRatedVendors = "vendors/vendors?sort=-averageRating";
final nearestVendorsLat = "vendors/vendors?latitude=";
final nearestVendorsLong = "8&longitude=";

final viewSingleVendorPosting = "socialMedia/posts?condition[vendor]=";
final vendorSocialMediaPostImgBaseURL =
    "http://api.she-connect.in/social-media/";

final likePost = "socialMedia/add-like";

final getCartID = "order/carts?condition[user]=";

final checkCoupon = "coupon/apply-coupon";

final chkCoupon1 = "order/carts?appUser=";
final chkCoupon2 = "&condition[user]=";

final wallet = "customers/Wallets?sort=-createdAt&condition[user]=";

final singlePost = "socialMedia/post/";

final deliveryCharge = "order/find/deliveryCharge?pincode=";
final deliveryCharge2 = "&vendor=";

final orderTracking1 = "order/order-history?condition[user]=";
final orderTracking2 = "&condition[order]=";

// ----------------------------------------------------------
final getChats = "vendors/chats/messages?condition[chat]=";
final chatImageBaseUrl = "https://api.she-connect.in/vendor/";
final newMessage = "vendors/chatMessage";
final listAllChats = "vendors/chats?condition[customer]=";
const chatImageBaseUrlUser = "https://api.she-connect.in/users/";

const closeChat = "vendors/chat/";
