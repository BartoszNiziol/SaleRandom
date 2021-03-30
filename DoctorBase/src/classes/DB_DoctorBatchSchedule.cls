/**
 * Created by BRITENET on 30.03.2021.
 */

global class DB_DoctorBatchSchedule implements Schedulable{
    public static String scheduleCron = '0 11 * * * ?';

    public static String scheduleBatch(){
        DB_DoctorBatchSchedule schedule = new DB_DoctorBatchSchedule();
        return System.schedule('DoctorBase To Hospital Doctor Schedule' ,scheduleCron,schedule);
    }

    global void execute (SchedulableContext SC){
        DB_DoctorBatch batch = new DB_DoctorBatch();
        database.executeBatch(batch);
    }

}