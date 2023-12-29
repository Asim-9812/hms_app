


class Api{

   static const bearerToken = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiZjZhNTdmNC1iN2JmLTQzYmItODgzNy0yY2NiZDE4NDM5ODIiLCJ2YWxpZCI6IjEiLCJ1c2VyaWQiOiJET0MwMDAxIiwiZXhwIjoxNzIxMjc3NDc0LCJpc3MiOiJsb2NhbGhvc3QiLCJhdWQiOiJXZWxjb21lIn0.o7_teFlpwxmG7EOBO9eL46bfOwLySS6Qyc1Yj8ZgcyI';

   // static const baseUrl = 'http://192.168.1.110:404';
   // static const baseUrl = 'http://202.51.74.138:4010';
   static const baseUrl = 'https://api.meroupachar.com';


   ///Activities list api...
   static const baseActivitiesUrl = 'https://api.api-ninjas.com/v1/caloriesburnedactivities';
   static const caloriesBurnInfo = 'https://api.api-ninjas.com/v1/caloriesburned?';


   ///register type accounts ...
   static const registerPatient = '$baseUrl/api/Member/Insert';
   static const registerOrganization = '$baseUrl/api/Organization/Register';
   static const registerDoctor = '$baseUrl/api/DoctorRegistration/DoctorRegister';
   static const checkEmailOrCode = '$baseUrl/api/DoctorRegistration/CheckCodeEmail';
   static const natureType = '$baseUrl/api/NatureType/GetType3';

   /// User...
   static const userRegister = '$baseUrl/api/Users/UserRegister';
   static const getUsers = '$baseUrl/api/Users/GetUser';
   static const getUserById = '$baseUrl/api/Users/GetUserById/';
   static const userUpdate = '$baseUrl/api/Users/UpdateUser/profileImageUrl/signaturImageUrl';
   static const changePwdUser = '$baseUrl/api/Users/ChangePwd';



   ///scheme - subscription plan...
   static const schemePlan = '$baseUrl/api/SchemePlans/GetList';
   static const subscriptionPlan = '$baseUrl/api/SchemeSubscription/Insert';
   static const paymentSuccessUrl = '$baseUrl/api/PaymentSuccess/InsertPaymentSuccess';

   ///user Login...
   static const userLogin = '$baseUrl/api/Users/UserLogin';
   static const patientLogin = '$baseUrl/api/Member/MemberLogin';


   /// Patient registration...
   static const postPatientRegistration = '$baseUrl/api/patient/Insert/aa';
   static const getRegisteredPatients = '$baseUrl/api/Patient/Getlist';
   static const getCostCategory = '$baseUrl/api/CostCategory/Getlist';

   /// Patient report...

   static const getPatientInfo = '$baseUrl/api/Patient/SearchById/';
   static const getPatientReport = '$baseUrl/api/Report/GetList';
   static const getDoctorsList = '$baseUrl/api/Patient/GetdoctorByCode/';
   static const getPatientGroupList = '$baseUrl/api/PatientGroup/GetList';
   static const getConsultantList = '$baseUrl/api/Patient/GetdoctorsConsultant/';


   /// Country details...
   static const getCountry = '$baseUrl/api/Country/GetList';
   static const getProvince = '$baseUrl/api/Province/GetListProvinceByCountryId/';
   static const getAllProvince = '$baseUrl/api/Province/GetList';
   static const getDistrict = '$baseUrl/api/District/GetListDistrictByProvinceId/';
   static const getAllDistrict = '$baseUrl/api/District/GetList';
   static const getMunicipality = '$baseUrl/api/Municipality/GetListMunicipalityByDistrictId/';
   static const getAllMunicipality = '$baseUrl/api/Municipality/GetList';

   /// Department & doctors...
   static const getDepartmentList = '$baseUrl/api/Department/GetList';
   static const getDoctorDepartment = '$baseUrl/api/DoctorDepartment/GetDepartment';
   static const getDoctorList = '$baseUrl/api/DoctorRegistration/Getlist';


   /// Doctor Documents...
   static const getDocumentType = '$baseUrl/api/DocumentType/GetList';
   static const getFolders = '$baseUrl/api/DoctorDocument/FolderList/';
   static const getDocuments = '$baseUrl/api/DoctorDocument/GetDocuList/';
   static const addDocuments = '$baseUrl/api/DoctorDocument/InsertDocument';
   static const delDocuments = '$baseUrl/api/DoctorDocument/DeleteDocument/';


   /// Patient Documents...
   static const getPatientFolders = '$baseUrl/api/PatientDocument/FolderList/';
   static const getPatientDocuments = '$baseUrl/api/PatientDocument/GetDocuList/';
   static const addPatientDocuments = '$baseUrl/api/PatientDocument/InsertDocument/documentUrl';
   static const delPatientDocuments = '$baseUrl/api/PatientDocument/DeleteDocument/';



   /// Notices & health tips & sliders...
   static const getNoticeList = '$baseUrl/api/Notice/GetList';
   static const getHealthTipsList = '$baseUrl/api/HealthTips/GetList';
   static const getSliderList = '$baseUrl/api/Sliders/GetList';

}


