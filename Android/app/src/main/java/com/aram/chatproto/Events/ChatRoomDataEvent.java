package com.aram.chatproto.Events;

/**
 * Created by Aram on 2018. 3. 8..
 */

public class ChatRoomDataEvent extends DataEvent {

    Object key;

    public Object getKey() {
        return key;
    }

    public ChatRoomDataEvent(Object source, Object key) {
        super(source);
        this.key = key;
    }
}
