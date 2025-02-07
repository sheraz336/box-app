// import 'package:flutter/material.dart';
//
// class BoxCard extends StatelessWidget {
//   final String title;
//   final int items;
//   final double value;
//   final bool isShared;
//   final String imagePath;
//
//   const BoxCard({
//     Key? key,
//     required this.title,
//     required this.items,
//     required this.value,
//     required this.isShared,
//     required this.imagePath,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.asset(
//             imagePath,
//             height: 200,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: Theme.of(context).textTheme.titleLarge),
//                 const SizedBox(height: 8),
//                 Text('Items: $items'),
//                 Text('Value: £$value'),
//                 Text('Shared: ${isShared ? "Yes" : "No"}'),
//               ],
//             ),
//           ),
//           ButtonBar(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// class CustomFAB extends StatelessWidget {
//   const CustomFAB({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       child: const Icon(Icons.add),
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           builder: (context) => Container(
//             height: 200,
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.location_on),
//                   title: const Text('Add Location'),
//                   onTap: () => Navigator.pop(context),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.inbox),
//                   title: const Text('Add Box'),
//                   onTap: () => Navigator.pop(context),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.widgets),
//                   title: const Text('Add Item'),
//                   onTap: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
