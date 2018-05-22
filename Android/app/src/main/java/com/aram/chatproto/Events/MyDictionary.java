package com.aram.chatproto.Events;

import java.util.ArrayList;
import java.util.LinkedHashMap;

/**
 * Created by Aram on 2018. 3. 5..
 */

public class MyDictionary<K,V> extends LinkedHashMap<K,V> {

    ArrayList<OnValueEventListener> onValueEventListener = new ArrayList<>();

    public void addValueEventListener(OnValueEventListener listener){
        onValueEventListener.add(listener);
    }
    public void removeAllValueEventListener(){
        onValueEventListener.clear();
    }
    public void removeValueEventListener(int index){
        onValueEventListener.remove(index);
    }
    public void removeValueEventListener(Object object){
        onValueEventListener.remove(object);
    }

    @Override
    public V put(K key, V value) {
        boolean isContain = this.containsKey(key);
        V o = super.put(key, value);

        if(onValueEventListener.size() > 0){
            ChatRoomDataEvent event = new ChatRoomDataEvent(this, key);

            if(isContain){

                for(OnValueEventListener listener : onValueEventListener){
                    listener.onDataChanged(event);
                }

            }else{
                for(OnValueEventListener listener : onValueEventListener){
                    listener.onDataAdded(event);
                }
            }

        }

        return o;
    }

    @Override
    public V remove(Object key) {
        V o = super.remove(key);

        if(onValueEventListener != null){
            DataEvent event = new DataEvent(this);
            for(OnValueEventListener listener : onValueEventListener){
                listener.onDataRemoved(event);
            }
        }

        return o;
    }
}
