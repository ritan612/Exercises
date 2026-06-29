public with sharing class Exercise1 {
    public Static Map<String,Integer> exercise1(List<String> InputList) {
        Map<String, Integer> Newmap = new Map<String, Integer>();
        for(String i: InputList){
            if (Newmap.containsKey(i)) {
                Integer counter=Newmap.get(i);
                Integer newCount= counter + 1;
                Newmap.put(i, newCount);
            }
            else {
                Newmap.put(i, 1);
            }
        }
        return Newmap;
    }
}