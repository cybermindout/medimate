import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';

class SearchFilter {
  List<HospitalModel> hospitalList;
  List<DoctorModel> doctorList;

  SearchFilter({required this.hospitalList, required this.doctorList});

  List<HospitalModel> filterByLocation(String location) {
    return hospitalList.where((hospital) => hospital.loc == location).toList();
  }

  List<DoctorModel> filterByHospital(String hospital) {
    return doctorList.where((doctor) => doctor.hospital == hospital).toList();
  }
}
