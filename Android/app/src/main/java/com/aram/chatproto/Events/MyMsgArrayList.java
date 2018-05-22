package com.aram.chatproto.Events;

import java.util.ArrayList;

/**
 * Created by Aram on 2018. 3. 8..
 */

public class MyMsgArrayList<E> extends ArrayList<E> {
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
    public boolean add(E e) {
        boolean result = super.add(e);
        if(onValueEventListener.size() > 0){

            MsgDataEvent event = new MsgDataEvent(this, super.size() - 1);
            for(OnValueEventListener listener : onValueEventListener){
                listener.onDataAdded(event);
            }
        }
        return result;
    }

    @Override
    public E remove(int index) {
        E result = super.remove(index);

        if(onValueEventListener != null){
            DataEvent event = new DataEvent(this);
            for(OnValueEventListener listener : onValueEventListener){
                listener.onDataRemoved(event);
            }
        }

        return result;
    }

    @Override
    public boolean remove(Object o) {
        boolean result = super.remove(o);

        if(onValueEventListener != null){
            DataEvent event = new DataEvent(this);
            for(OnValueEventListener listener : onValueEventListener){
                listener.onDataRemoved(event);
            }
        }

        return result;
    }

//    @Override
//    public void clear() {
//        super.clear();
//    }
}
