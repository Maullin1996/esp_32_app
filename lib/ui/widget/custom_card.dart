import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final BuildContext ctx;
  final String title;
  final Widget page;
  final IconData icon;
  const CustomCard({
    super.key,
    required this.ctx,
    required this.title,
    required this.page,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (_) => page,
            maintainState: false, // 🔥 clave para mañana
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 30),
                  overflow: TextOverflow
                      .ellipsis, // o .fade, .visible según prefieras
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
