public with sharing class StateUtility {
	public StateUtility() {
		
	}

    private static boolean run = true;
    
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
    }
    }

}