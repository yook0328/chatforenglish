package com.aram.chatproto.Events;

/**
 * Created by Aram on 2018. 3. 8..
 */

public class MsgDataEvent extends DataEvent {

    int index;

    public MsgDataEvent(Object source) {
        super(source);
    }

    public MsgDataEvent(Object src, int index){
        super(src);
        this.index = index;
    }

    public int getIndex() {
        return index;
    }
}
