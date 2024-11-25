import 'package:flutter/material.dart';

class VerticalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Node {
  final String title;
  final Color color;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;

  Node({
    required this.title,
    this.color = const Color.fromARGB(255, 119, 204, 98),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    List<BoxShadow>? boxShadow,
  }) : boxShadow = boxShadow ??
            [
              BoxShadow(
                color: const Color.fromARGB(255, 14, 13, 13).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ];
}

///how will i wdit the text in the nodes?
///
class AboutHomiegram extends StatelessWidget {
  final List<Node> nodes = [
    Node(
      title:
          "Landlords \n HomieGram provides landlords with a streamlined property management experience. Through a single platform, landlords can manage rental agreements, handle maintenance requests, and communicate with tenants efficiently. With HomieGram's intuitive tools, managing property details, tenant information, and maintenance schedules becomes effortless, reducing administrative time and enhancing focus on business growth.",
    ),
    Node(
      title:
          "Tenants \n Homiegram simplifies the rental search process for students, offering a user-friendly platform with filters for budget, location, and preferences. Students can browse listings, apply easily, and even read reviews. Personalized recommendations make it easier to find the perfect property, making the transition to a new living space smoother and more enjoyable.",
    ),
    Node(
      title:
          "Market \n Homigram extends its platform to businesses and individuals looking to sell items within the rental ecosystem. The Market node allows users to list and browse items relevant to student life and rental needs, from furniture to appliances, making it a one-stop shop for both property management and essential items. By integrating sales opportunities directly into the platform, Homiegram creates a seamless environment for students, landlords, and sellers alike, enhancing the overall rental experience.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF126E06),
        title: const Text(
          "What is Homigram?",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: CustomPaint(
        painter: VerticalLinePainter(),
        child: ListView.builder(
          itemCount: nodes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: NodeWidget(node: nodes[index]),
            );
          },
        ),
      ),
    );
  }
}

class NodeWidget extends StatelessWidget {
  final Node node;

  const NodeWidget({Key? key, required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: node.color,
        borderRadius: node.borderRadius,
        boxShadow: node.boxShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(node.title),
      ),
    );
  }
}
