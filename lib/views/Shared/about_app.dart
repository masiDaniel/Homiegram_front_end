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
          "Landlords \n HomieGram revolutionizes the way landlords manage their rental properties, offering a comprehensive platform that streamlines every aspect of property management.\n With HomieGram, landlords can efficiently communicate with tenants, manage rental agreements,\n and handle maintenance requests all in one place.\n The app's intuitive interface and powerful features make it easier than ever to keep track of property details,\n tenant information, and upcoming maintenance schedules. By leveraging HomieGram, landlords can significantly reduce the time\n and effort required to manage their rental properties, allowing them to focus more on their business or personal endeavors. HomieGram's commitment to enhancing\n the rental experience for both landlords and tenants makes it an indispensable tool for property management.",
    ),
    Node(
      title:
          "Students \n HomieGram is designed to simplify the rental search process for students, providing a user-friendly platform that connects them with suitable rental properties. The app offers a wide range of filters and search options, allowing students to find properties that match their budget, preferences, and location. With HomieGram, students can easily apply to properties, view property listings, and even read reviews from other students who have lived in the same area. The app's personalized recommendations feature further enhances the search experience, suggesting properties based on the student's preferences and past searches. HomieGram's focus on making the rental process more efficient and enjoyable for students is evident in its design and functionality. By using HomieGram, students can save time and effort in their search for a new rental property, ensuring a smoother transition into their new living situation.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF126E06),
        title: const Text(
          "What is HomiGram?",
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
