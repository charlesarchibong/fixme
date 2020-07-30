class ReviewModel {
  final String text;
  final String imgUrl;
  final DateTime date;

  ReviewModel({this.date, this.imgUrl, this.text});

  // Map<String, dynamic>  (){
  //   return{

  //   }
  // }

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return ReviewModel(
      text: data['review'],
    );
  }
}
