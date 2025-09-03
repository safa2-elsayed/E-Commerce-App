import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddReviewScreen extends StatefulWidget {
  final String productId;
  const AddReviewScreen({super.key, required this.productId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  double _rating = 3.0;

  void _submitReview() {
    if (_nameController.text.trim().isEmpty || _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productId)
        .collection("reviews")
        .add({
      "name": _nameController.text.trim(),
      "comment": _commentController.text.trim(),
      "rating": _rating,
      "date": DateTime.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Review"),
        centerTitle: true,
        backgroundColor:  const Color(0xFF9775FA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Share your experience",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: "How was your experience?",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.comment),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                Text("Rating: ${_rating.toStringAsFixed(1)} ⭐",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Slider(
                  value: _rating,
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _rating.toString(),
                  activeColor:  const Color(0xFF9775FA),
                  onChanged: (val) => setState(() => _rating = val),
                ),
              ],
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9775FA),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitReview,
                child: const Text(
                  "Submit Review",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
