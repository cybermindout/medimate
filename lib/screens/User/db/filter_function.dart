import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';

class FilterFunctions {
  List<HospitalModel> filterHospitalsByLocation(
    List<HospitalModel> allHospitals,
    String selectedLocation,
  ) {
    return allHospitals
        .where((hospital) => hospital.loc == selectedLocation)
        .toList();
  }

  List<HospitalModel> filterSpecializationsByHospital(
    List<HospitalModel> allSpecializations,
    String selectedSpecialization,
  ) {
    return allSpecializations
        .where((hospital) => hospital.specialization == selectedSpecialization)
        .toList();
  }

  List<DoctorModel> filterDoctorsByHospital(
    List<DoctorModel> allDoctors,
    String selectedHospital,
  ) {
    return allDoctors
        .where((doctor) => doctor.hospital == selectedHospital)
        .toList();
  }
}
