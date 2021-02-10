public class StringArrayTest {
    public static List<String> generateStringArray(Integer recivedNumber){
        
        List<String> texts = new List<String>();
        for(Integer i = 0; i<recivedNumber;i++){
            
            texts.add('Test ' + i);
        }
         return texts;
    }
   
}