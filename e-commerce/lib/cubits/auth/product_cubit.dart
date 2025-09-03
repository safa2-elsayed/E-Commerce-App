import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/product_model.dart';
import '/models/cartItem.dart';
import 'cart_cubit.dart';

class ProductDetailsCubit extends Cubit<Product> {
  ProductDetailsCubit(Product product) : super(product);

  void addToCart(CartCubit cartCubit) {
    final cartItem = CartItem(
      id: state.id.toString(),
      title: state.title,
      image: state.image,
      price: state.price,
      quantity: 1,
      description: state.description,
      category: state.category,
      rate: state.rate,
      count: state.count,
    );

    cartCubit.addToCart(cartItem);
  }
}
