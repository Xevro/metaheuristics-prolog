package be.odisee.domain;

import java.io.Serializable;

public class Timeslot implements Serializable {

    private int id; // 1-200

    public Timeslot(int id) {
        this.id = id;
    }

    public int getID() {
        return id;
    }

    public void setID(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return id + "";
    }
}
