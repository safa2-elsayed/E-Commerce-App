import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/cartItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  final user = FirebaseAuth.instance.currentUser;

  void addToCart(CartItem item) {
    final index = state.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      final updatedItem = CartItem(
        id: item.id,
        title: item.title,
        image: item.image,
        price: item.price,
        quantity: state[index].quantity + 1,
        description: item.description,
        category: item.category,
        rate: item.rate,
        count: item.count,
      );
      final newState = List<CartItem>.from(state);
      newState[index] = updatedItem;
      emit(newState);
    } else {
      emit([...state, item]);
    }
    saveCartToFirestore();
  }

  void clearCart() {
    emit([]);
  }

  void removeFromCart(String id) {
    emit(state.where((item) => item.id != id).toList());
    saveCartToFirestore();
  }

  double totalPrice() {
    return state.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  Future<void> saveCartToFirestore() async {
    if (user == null) return;
    final cartData = state.map((item) => item.toMap()).toList();
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(user!.uid)
        .set({'items': cartData});
  }

  Future<void> loadCartFromFirestore() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('carts')
        .doc(user!.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!['items'] as List<dynamic>;
      emit(data.map((e) => CartItem.fromMap(e)).toList());
    }
  }
}
