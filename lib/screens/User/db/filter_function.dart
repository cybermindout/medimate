import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';

class FilterFunctions {
  List<HospitalModel> filterHospitalsByLocation(
    List<HospitalModel> allHospitals,
    String selectedLocation,
  ) {
    return allHospitals
        .where((hospital) => hospital.loc == selectedLocation)
        .toList();
  }

  static List<DoctorModel> filterSpecializationsByHospital(
    List<DoctorModel> allSpecializations,
    String selectedHospital,
  ) {
    return allSpecializations
        .where((specialization) =>
            specialization.specialization == selectedHospital)
        .toList();
  }

  static List<DoctorModel> filterDoctorsByHospitalAndSpecialization(
    List<DoctorModel> allDoctors,
    String selectedHospital,
    String selectedSpecialization,
  ) {
    return allDoctors
        .where((doctor) =>
            doctor.hospital == selectedHospital &&
            doctor.specialization == selectedSpecialization)
        .toList();
  }
}
