class Userupdateinfo {
  late final String userId;
  late final String? interestedIn;
  late final String? experience;
  late final String? language;
  late final String? ide;
  late final String? os;
  late final String? goal;

  Userupdateinfo({
    required this.userId,
    this.interestedIn,
    this.experience,
    this.language,
    this.ide,
    this.os,
    this.goal,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_id'] = userId;
    if (interestedIn != null) data['interestedIn'] = interestedIn;
    if (experience != null) data['experience'] = experience;
    if (language != null) data['language'] = language;
    if (ide != null) data['ide'] = ide;
    if (os != null) data['os'] = os;
    if (goal != null) data['goal'] = goal;
    return data;
  }
}
