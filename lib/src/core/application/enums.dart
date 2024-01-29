enum PostType { image, text, link }

enum Karma {
  comment(1),
  textPost(2),
  linkPost(3),
  imagePost(3),
  awardPost(5),
  deletePost(-1);

  final int point;
  const Karma(this.point);
}
