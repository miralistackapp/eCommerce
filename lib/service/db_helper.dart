// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:learning/model/cart_model.dart';
import 'package:learning/model/orders_model.dart';
import 'package:learning/model/product_model.dart';
import 'package:learning/model/users_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:learning/main.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._instance();
  static Database? _db;

  DBHelper._instance();

  static const String dbName = 'InterViewDB';

  //     ======================= Add Product Table =======================     //
  static const String productTable  = 'productTable';
  static const String productId = 'productId';
  static const String productName = 'productName';
  static const String productCategory = 'productCategory';
  static const String productPrice = 'productPrice';
  static const String productQuantity = 'productQuantity';
  static const String productImage = 'productImage';
  static const String productDesc = 'productDesc';
  static const String productMfgDate = 'productMfgDate';

  //     ======================= Cart Table =======================     //
  static const String cartTable  = 'cartTable';
  static const String cartProductId = 'cartProductId';
  static const String cartProductPrice = 'cartProductPrice';
  static const String cartProductQuantity = 'cartProductQuantity';
  static const String cartProductTotal = 'cartProductTotal';

  //     ======================= Orders Table =======================     //
  static const String orderTable  = 'orderTable';
  static const String orderId = 'orderId';
  static const String orderPrice = 'orderPrice';
  static const String orderQuantity = 'orderQuantity';

  //     ======================= Users Table =======================     //
  static const String userTable  = 'userTable';
  static const String userId = 'userId';
  static const String userEmail = 'userEmail';
  static const String userName = 'userName';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    } else {
      logs('Database Name : $_db');
      logs('Database Check : ${_db!.isOpen}');
    }
    return _db;
  }

  _initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dbName);
    final db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $productTable ($productId integer primary key autoincrement, $productName TEXT, $productCategory TEXT, $productPrice TEXT, $productQuantity TEXT, $productImage TEXT, $productDesc TEXT, $productMfgDate TEXT)');
    await db.execute('CREATE TABLE $cartTable ($cartProductId integer, $cartProductPrice integer, $cartProductQuantity integer, $cartProductTotal integer)');
    await db.execute('CREATE TABLE $orderTable ($orderId integer, $orderPrice integer, $orderQuantity integer)');
    await db.execute('CREATE TABLE $userTable ($userId TEXT, $userEmail TEXT, $userName TEXT)');
  }

  //     ======================= Add Product =======================     //
  Future<int> addProduct(ProductModel productModel) async {
    Database? dbClient = await db;
    final int result = await dbClient!.insert(productTable, productModel.toJson());
    logs('Add product result : $result');
    return result;
  }

  //     ======================= get Product =======================     //
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.query(productTable);
    logs('Get products result : $result');
    return result;
  }

  //     ======================= Get Product by id =======================     //
  Future<ProductModel> getProductById(num id) async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('SELECT * FROM $productTable WHERE $productId = $id');
    ProductModel productModel = ProductModel.fromJson(result.first);
    logs('Get product result : $result');
    return productModel;
  }

  //     ======================= Update Product =======================     //
  Future updateProduct(ProductModel productModel) async {
    Database? dbClient = await db;
    final int result = await dbClient!.update(productTable, productModel.toJson(), where: '$productId = ?', whereArgs: [productModel.productId]);
    logs('Update product result : $result');
    return result;
  }

  //     ======================= Update Product =======================     //
  Future updateProductById(num id, String productKey, String productValue) async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('UPDATE $productTable SET $productKey = ? WHERE $productId = ?', [productValue, id]);
    logs('Update product result : $result');
    return result;
  }

  //     ======================= Add Product =======================     //
  Future<int> addCartProduct(CartModel cartModel) async {
    Database? dbClient = await db;
    final int result = await dbClient!.insert(cartTable, cartModel.toJson());
    logs('Add cart result : $result');
    return result;
  }

  //     ======================= Get Cart =======================     //
  Future<List<CartModel>> getMyCartMap() async {
    Database? dbClient = await db;
    List<CartModel> catModelList = <CartModel>[];
    final List<Map<String, dynamic>> result = await dbClient!.query(cartTable);
    for (Map<String, dynamic> element in result) {
      CartModel cartModel = CartModel.fromJson(element);
      catModelList.add(cartModel);
    }
    logs('Get my cart map result : $result');
    return catModelList;
  }

  //     ======================= Count Cart =======================     //
  Future<int> countMyCartMap() async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.query(cartTable);
    logs('Count my cart map result : $result');
    return result.length;
  }

  //     ======================= Update Cart =======================     //
  Future updateCartById(num id, String cartKey, dynamic cartValue) async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('UPDATE $cartTable SET $cartKey = ? WHERE $cartProductId = ?', [cartValue, id]);
    logs('Update product result : $result');
    return result;
  }

  //     ======================= Delete Cart =======================     //
  Future<int> deleteCartProduct(num id) async {
    Database? dbClient = await db;
    final int result = await dbClient!.delete(cartTable, where: '$cartProductId = ?', whereArgs: [id]);
    logs('Delete cart product result : $result');
    return result;
  }

  //     ======================= Calculate Cart =======================     //
  Future<int> calculateMyCart() async {
    Database? dbClient = await db;
    int cartAmount = 0;
    final List<Map<String, dynamic>> result = await dbClient!.query(cartTable);
    for (Map<String, dynamic> element in result) {
      CartModel cartModel = CartModel.fromJson(element);
      num productTotal = cartModel.cartProductQuantity * cartModel.cartProductPrice;
      cartAmount += productTotal.toInt();
    }
    logs('Calculate my cart map result : $cartAmount');
    return cartAmount;
  }

  //     ======================= Add user =======================     //
  Future<int> addUser(UserModel userModel) async {
    Database? dbClient = await db;
    final int result = await dbClient!.insert(userTable, userModel.toJson());
    logs('Add user result : $result');
    return result;
  }

  //     ======================= get users =======================     //
  Future<List<UserModel>> getAllUsers() async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.query(userTable);
    List<UserModel> usersList = <UserModel>[];
    for (Map<String, dynamic> element in result) {
      UserModel userModel = UserModel.fromJson(element);
      usersList.add(userModel);
    }
    logs('Users --> $usersList');
    return usersList;
  }

  //     ======================= Add Order =======================     //
  Future<int> addOrder(OrdersModel ordersModel) async {
    Database? dbClient = await db;
    final int result = await dbClient!.insert(orderTable, ordersModel.toJson());
    logs('Add order result : $result');
    return result;
  }

  //     ======================= get Product =======================     //
  Future<List<OrdersModel>> getAllOrders() async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.query(orderTable);
    List<OrdersModel> ordersModelList = <OrdersModel>[];
    for (Map<String, dynamic> element in result) {
      OrdersModel ordersModel = OrdersModel.fromJson(element);
      ordersModelList.add(ordersModel);
    }
    logs('Orders --> $ordersModelList');
    return ordersModelList;
  }

  //     ======================= Delete Database =======================     //
  Future<void> deleteDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dbName);
    return databaseFactory.deleteDatabase(path);
  }
}
