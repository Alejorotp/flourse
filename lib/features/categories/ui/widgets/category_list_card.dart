import 'package:flutter/material.dart';
import '../../domain/models/category.dart';

class CategoryListCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final int activitiesCount;
  final int groupsCount;
  const CategoryListCard({
    super.key,
    required this.category,
    this.onTap,
    this.activitiesCount = 0, //MODIFICAR
    this.groupsCount = 0, //MODIFICAR
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 205, 237, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.category, color: Color.fromRGBO(43, 213, 243, 1), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.groupingMethod,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.list_alt, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('$activitiesCount actividades', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 12),
                        Icon(Icons.groups, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${category.groupIDs.length} grupos', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}
