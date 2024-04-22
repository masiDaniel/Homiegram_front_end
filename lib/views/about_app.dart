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

class Node extends StatelessWidget {
  final String title;
  const Node({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(80),
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]),
      child: Text(title),
    );
  }
}

class AboutHomiegram extends StatelessWidget {
  const AboutHomiegram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What HomieGram has to offers"),
      ),
      body: CustomPaint(
        painter: VerticalLinePainter(),
        child: ListView(
          children: const <Widget>[
            Node(
                title:
                    "Landlords \n HomieGram revolutionizes the way landlords manage their rental properties, offering a comprehensive platform that streamlines every aspect of property management. With HomieGram, landlords can efficiently communicate with tenants, manage rental agreements, and handle maintenance requests all in one place. The app's intuitive interface and powerful features make it easier than ever to keep track of property details, tenant information, and upcoming maintenance schedules. By leveraging HomieGram, landlords can significantly reduce the time and effort required to manage their rental properties, allowing them to focus more on their business or personal endeavors. HomieGram's commitment to enhancing the rental experience for both landlords and tenants makes it an indispensable tool for property management."),
            SizedBox(
              height: 20,
            ),
            Node(
                title:
                    "Students \n HomieGram is designed to simplify the rental search process for students, providing a user-friendly platform that connects them with suitable rental properties. The app offers a wide range of filters and search options, allowing students to find properties that match their budget, preferences, and location. With HomieGram, students can easily apply to properties, view property listings, and even read reviews from other students who have lived in the same area. The app's personalized recommendations feature further enhances the search experience, suggesting properties based on the student's preferences and past searches. HomieGram's focus on making the rental process more efficient and enjoyable for students is evident in its design and functionality. By using HomieGram, students can save time and effort in their search for a new rental property, ensuring a smoother transition into their new living situation."),
          ],
        ),
      ),
    );
  }
}
