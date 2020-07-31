class ReviewModel {
  final String text;
  final String imgUrl;
  final DateTime date;
  final String name;

  ReviewModel({
    this.date,
    this.imgUrl,
    this.text,
    this.name,
  });

  // Map<String, dynamic>  (){
  //   return{

  //   }
  // }

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return ReviewModel(
      text: data['review'],
      name:
          "${data['reviewer']['user_first_name']} ${data['reviewer']['user_last_name']}",
      imgUrl: data['reviewer']['profile_pic_file_name'],
      date: data['dateAdded'],
    );
  }
}

class ReviewList {
  final List<ReviewModel> reviewList;
  ReviewList({this.reviewList});
  factory ReviewList.fromData(data) {
    var list = data;
    List<ReviewModel> newList = list.map((i) => ReviewModel.fromMap(i));
    return ReviewList(reviewList: newList);
  }
}
