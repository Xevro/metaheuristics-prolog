package be.odisee.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Student implements Serializable {

    private int id;
    private List<Integer> examIds; // Examens lijst

    public Student(int id) {
        this.id = id;
        examIds = new ArrayList<Integer>();
    }

    public int getID() {
        return id;
    }

    public void setID(int id) {
        this.id = id;
    }

    public List<Integer> getExamIds() {
        return examIds;
    }

    public void setExamIds(List<Integer> eid) {
        this.examIds = eid;
    }
}
