package com.aram.chatproto.Events;

import java.util.EventListener;

/**
 * Created by Aram on 2018. 3. 5..
 */

public interface OnValueEventListener extends EventListener {
    void onDataAdded(DataEvent event);
    void onDataChanged(DataEvent event);
    void onDataRemoved(DataEvent event);

}
