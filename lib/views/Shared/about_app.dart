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
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  Node({
    required this.title,
    required this.description,
    this.icon = Icons.info,
    this.gradientColors = const [Colors.greenAccent, Colors.green],
  });
}

class AboutHomiegram extends StatelessWidget {
  final List<Node> nodes = [
    Node(
      title: "Landlords",
      description:
          "HomieGram provides landlords with a streamlined property management experience. Through a single platform, landlords can manage rental agreements, handle maintenance requests, and communicate with tenants efficiently. With HomieGram's intuitive tools, managing property details, tenant information, and maintenance schedules becomes effortless, reducing administrative time and enhancing focus on business growth.",
    ),
    Node(
      title: "Tenants",
      description:
          "HomieGram simplifies the rental search process for students, offering a user-friendly platform with filters for budget, location, and preferences. Students can browse listings, apply easily, and even read reviews. Personalized recommendations make it easier to find the perfect property, making the transition to a new living space smoother and more enjoyable.",
    ),
    Node(
      title: "Market",
      description:
          "HomieGram extends its platform to businesses and individuals looking to sell items within the rental ecosystem. The Market node allows users to list and browse items relevant to student life and rental needs, from furniture to appliances, making it a one-stop shop for both property management and essential items. By integrating sales opportunities directly into the platform, HomieGram creates a seamless environment for students, landlords, and sellers alike, enhancing the overall rental experience.",
    ),
  ];

  AboutHomiegram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF126E06),
        title: const Text(
          "What is HomieGram?",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
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
        gradient: LinearGradient(
          colors: node.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(node.icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  node.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              node.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
