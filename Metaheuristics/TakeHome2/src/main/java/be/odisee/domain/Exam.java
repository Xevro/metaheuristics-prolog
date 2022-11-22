
package be.odisee.domain;

import java.io.Serializable;
import java.util.List;

public class Exam implements Serializable {

    private int ID;
    private List<Student> studentIDs; // Array van studenten die dit examen moeten doen
    private static int _ID = 1;
    private int internalID;

    public Exam(int ID) {
        this.internalID = _ID++;
        this.ID = ID;
    }

    public Exam() {
        this.internalID = _ID++;
        this.ID = internalID;
    }

    public Exam(int _ID, List<Student> studentIDs) {
        this.ID = _ID;
        this.studentIDs = studentIDs;
    }

    public Exam(List<Student> studentIDs) {
        this.internalID = _ID++;
        this.ID = internalID;
        this.studentIDs = studentIDs;
    }

    public int getID() {
        return ID;
    }

    public void setID(int id) {
        ID = id;
    }

    public List<Student> getStudentIds() {
        return studentIDs;
    }

    public void setStudentIDs(List<Student> stdIDs) {
        studentIDs = stdIDs;
    }

    public void addSID(Student StudentID) {
        studentIDs.add(StudentID);
    }
}
