import 'package:fortloom/domain/entities/PersonResource.dart';

class ReportResource{

final int id;

final String reportDescription;

final PersonResource userMain;

final PersonResource userReported;

ReportResource(this.id,this.reportDescription,this.userMain,this.userReported);


}