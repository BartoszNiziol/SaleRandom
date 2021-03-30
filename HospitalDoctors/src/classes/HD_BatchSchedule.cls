/**
 * Created by BRITENET on 29.03.2021.
 */

global class HD_BatchSchedule implements Schedulable{

    public static String scheduleCron = '0 11 * * * ?';

    public static String scheduleBatch(){
        HD_BatchSchedule schedule = new HD_BatchSchedule();
        return System.schedule('Hospital Doctor To DoctorBase Schedule' ,scheduleCron,schedule);
    }

    global void execute (SchedulableContext SC){
        HD_DoctorBatch batch = new HD_DoctorBatch();
        database.executeBatch(batch);
    }

}