//Generated by wsdl2apex

public class AsyncDoctorExternalBaseService {
    public class getDoctorsResponse_elementFuture extends System.WebServiceCalloutFuture {
        public DoctorExternalBaseWrapper.DB_DoctorResponseWrapper[] getValue() {
            DoctorExternalBaseService.getDoctorsResponse_element response = (DoctorExternalBaseService.getDoctorsResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class deleteDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public DoctorExternalBaseWrapper.DB_DoctorResponseWrapper getValue() {
            DoctorExternalBaseService.deleteDoctorResponse_element response = (DoctorExternalBaseService.deleteDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class addDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public DoctorExternalBaseWrapper.DB_DoctorResponseWrapper getValue() {
            DoctorExternalBaseService.addDoctorResponse_element response = (DoctorExternalBaseService.addDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class updateDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public DoctorExternalBaseWrapper.DB_DoctorResponseWrapper getValue() {
            DoctorExternalBaseService.updateDoctorResponse_element response = (DoctorExternalBaseService.updateDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class AsyncDB_DoctorExternalSearchWebService {
        public String endpoint_x = 'https://eu40.salesforce.com/services/Soap/class/DB_DoctorExternalSearchWebService';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public DoctorExternalBaseService.DebuggingInfo_element DebuggingInfo;
        public DoctorExternalBaseService.DebuggingHeader_element DebuggingHeader;
        public DoctorExternalBaseService.SessionHeader_element SessionHeader;
        public DoctorExternalBaseService.CallOptions_element CallOptions;
        public DoctorExternalBaseService.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/DB_DoctorResponseWrapper', 'DoctorExternalBaseWrapper', 'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService', 'DoctorExternalBaseService'};
        public AsyncDoctorExternalBaseService.getDoctorsResponse_elementFuture beginGetDoctors(System.Continuation continuation,String firstName,String lastName,String email,String country) {
            DoctorExternalBaseService.getDoctors_element request_x = new DoctorExternalBaseService.getDoctors_element();
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.email = email;
            request_x.country = country;
            return (AsyncDoctorExternalBaseService.getDoctorsResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncDoctorExternalBaseService.getDoctorsResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'getDoctors',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'getDoctorsResponse',
              'DoctorExternalBaseService.getDoctorsResponse_element'}
            );
        }
        public AsyncDoctorExternalBaseService.deleteDoctorResponse_elementFuture beginDeleteDoctor(System.Continuation continuation,String id) {
            DoctorExternalBaseService.deleteDoctor_element request_x = new DoctorExternalBaseService.deleteDoctor_element();
            request_x.id = id;
            return (AsyncDoctorExternalBaseService.deleteDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncDoctorExternalBaseService.deleteDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'deleteDoctor',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'deleteDoctorResponse',
              'DoctorExternalBaseService.deleteDoctorResponse_element'}
            );
        }
        public AsyncDoctorExternalBaseService.addDoctorResponse_elementFuture beginAddDoctor(System.Continuation continuation,String firstName,String lastName,String email,String country) {
            DoctorExternalBaseService.addDoctor_element request_x = new DoctorExternalBaseService.addDoctor_element();
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.email = email;
            request_x.country = country;
            return (AsyncDoctorExternalBaseService.addDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncDoctorExternalBaseService.addDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'addDoctor',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'addDoctorResponse',
              'DoctorExternalBaseService.addDoctorResponse_element'}
            );
        }
        public AsyncDoctorExternalBaseService.updateDoctorResponse_elementFuture beginUpdateDoctor(System.Continuation continuation,String id,String firstName,String lastName,String email,String country) {
            DoctorExternalBaseService.updateDoctor_element request_x = new DoctorExternalBaseService.updateDoctor_element();
            request_x.id = id;
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.email = email;
            request_x.country = country;
            return (AsyncDoctorExternalBaseService.updateDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncDoctorExternalBaseService.updateDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'updateDoctor',
              'http://soap.sforce.com/schemas/class/DB_DoctorExternalSearchWebService',
              'updateDoctorResponse',
              'DoctorExternalBaseService.updateDoctorResponse_element'}
            );
        }
    }
}