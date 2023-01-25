//   class dataModel{
//   final String content;
//   final String authorSlug;
//   const dataModel({
//     required this.content,
//     required this.authorSlug
//   });
//   factory dataModel.fromJson(Map<String, dynamic> json) {
//     return dataModel(
//       content: json['content'],
//       authorSlug: json['authorSlug']
//     );
//   }
// }


class dataModel{
  final String title;
  final int Id;
  const dataModel({
    required this.title,
    required this.Id
  });
  factory dataModel.fromJson(Map<String,dynamic> json){
    return dataModel(title: json['title'], Id: json['id']);
  }
}