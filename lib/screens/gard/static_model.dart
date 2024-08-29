class StaticModel {
  int? allStudents;
  int? allStudentsInOut;
  int? remainingStudentsThatNotRegister;
  int? allStudentsIn;
  int? allStudentsOut;

  StaticModel(
      {this.allStudents,
      this.allStudentsInOut,
      this.remainingStudentsThatNotRegister,
      this.allStudentsIn,
      this.allStudentsOut});

  StaticModel.fromJson(Map<String, dynamic> json) {
    allStudents = json['all_students'];
    allStudentsInOut = json['all_students_in_out'];
    remainingStudentsThatNotRegister =
        json['remaining_students_that_not_register'];
    allStudentsIn = json['all_students_in'];
    allStudentsOut = json['all_students_out'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all_students'] = allStudents;
    data['all_students_in_out'] = allStudentsInOut;
    data['remaining_students_that_not_register'] =
        remainingStudentsThatNotRegister;
    data['all_students_in'] = allStudentsIn;
    data['all_students_out'] = allStudentsOut;
    return data;
  }
}
